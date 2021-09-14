#!/usr/bin/env bash
set -x
# copysshkey.sh
# Copy new ssh key to the server
# Test new ssh key on the server
# If test is success, remove old key from server
# If test fails, revert old key back
#
# To use the script
#                                                      OLD KEY                        NEW KEY
# ./copysshkey [USERID] [/path/to/list/of/serverfile] [/path/to/old/ssh/pub/key/file][/path/to/new/ssh/pub/key/file]
# NOTE/WARNING: BE VERY CAREFULL OF HOW YOU PUT THE ARGUMENTS: THERE IS NO VALIDATION!
# 
# Please make sure you backup the existing ~/.ssh/id_rsa && ~/.ssh/id_rsa.pub 
# before generating new keys

USERID="$1"
SERVERFILE="$2"
OLDSSHKEYFILE="$3"
NEWSSHPRIVKEYFILE="$4"
NEWSSHPUBKEYFILE="$NEWSSHPRIVKEYFILE.pub"
NEWSSHPUBKEY="$(cat $NEWSSHPUBKEYFILE)"

OSSHKEY=""
AUTHKEYFILE="~/.ssh/authorized_keys"

displaymsg() {
  server="$1"
  mtype="$2"

  fmt0="%s\t--> connection timed out...\n"
  fmt1="%s\t--> copy success\n"
  fmt2="%s\t--> copy failed... revert success\n"
  fmt3="%s\t--> copy failed... revert failed\n"
  fmt4="%s\t--> copied new sshkey but can\'t log in with it...\n"
  fmt5="%s\t--> connection test success\n"

  # mtype : (message type)
  # ct  == connection timed-out
  # tct == test connection time out
  # cts == connection test success
  # cs  == copy success
  # rs  == revert success
  # rf  == revert failed

  case ${mtype,,} in
    "ct"  ) shift; printf "$fmt0" "$server";;
    "tct" ) shift; printf "$fmt4" "$server";;
    "cs"  ) shift; printf "$fmt1" "$server";;
    "rs"  ) shift; printf "$fmt2" "$server";;
    "rf"  ) shift; printf "$fmt2" "$server";;
    "cts" ) shift; printf "$fmt5" "$server";;
         *) shift; echo "Error : ${mtype,,} no such command..."; break;
  esac
}

checkAccessToServer() {
  server="$1"
  status="$(ssh -o ConnectTimeout=10 $USER@$server "echo" >/dev/null 2&>1; echo $?)"
  if [[ "$status" == "0" ]]; then
    OSSHKEY="$(ssh $USER@$server 'cat ~/.ssh/authorized_keys | tail -1' )"
  fi
  echo $status
}

backupRemoteAuthKeyFile() {
  server="$1"
  ssh $USER@$server "cp $AUTHKEYFILE $AUTHKEYFILE.bak"
}

revertRemoteAuthKeyFile() {
  server="$1"
  ssh "$USER@$server" "mv $AUTHKEYFILE.bkp $AUTHKEYFILE"
}

copyNewSshKey() {
  server="$1"
  #ssh-copy-id -i "$NSSHKEYFILE" "$USER@$server"
  ssh $USER@$server "echo $NEWSSHPUBKEY >> ~/.ssh/authorized_keys"
}

run() {
    # LOOP THRU THE SERVER LIST
    for SERVER in $(cat $SERVERFILE); do
      # CHECK IF SERVER IS TIMING OUT OR NOT
      check="$(checkAccessToServer $SERVER)"
      if [[ $check == 0 ]]; then
        # CHECK IF OLD SSHKEY IS THE SAME AS THE NEW SSH KEY
        if [[ "$OSSHKEY" != "$NEWSSHPUBKEY" ]]; then
          # backup authorized_keys file
          backupRemoteAuthKeyFile $SERVER

          # ssh-copy-id new key **(MAKE SURE THAT OLD NOT EQUAL THE NEW)**
          copyNewSshKey $SERVER

          # test if the new key works
          check="$(ssh -i $NEWSSHPRIVKEYFILE $USER@$SERVER "echo" >/dev/null 2&>1; echo $?)"
          
          if [[ "$check" == 0 ]]; then
            displaymsg "$server" "cs"

            # remove old ssh key
            cmd="sed -i '\|$OSSHKEY|d' ~/.ssh/authorized_keys"
            ssh -t -i $NEWSSHPRIVKEYFILE $USER@$SERVER "$cmd"
            #ssh -i $NEWSSHPRIVKEYFILE $USER@$SERVER "grep -v \"$OSSHKEY\" ~/.ssh/authorized_keys >~/.ssh/authorized_keys"

            # TEST NSSHKEY ACCESS
            status="$(ssh -i $NEWSSHPRIVKEYFILE -o ConnectTimeout=10 $USER@$SERVER "echo" >/dev/null 2&>1; echo $?)"

            if [[ "$status" != 0 ]]; then
              displaymsg "$SERVER" "tct"
            else
              displaymsg "$SERVER" "cts"
            fi
          else
            # if copy fails then revert the changes
            revert="$(ssh -i $OLDSSHKEYFILE $USER@$SERVER "cat ~/.ssh/authorized_keys.bak > ~/.ssh/authorized_keys" ; echo $?)"

            if [[ "$revert" == 0 ]]; then
              displaymsg "$server" "rs"
            else
              # can't revert the change! oops!
              displaymsg "$server" "rf"
            fi
          fi
        else
          displaymsg "$SERVER" "ct"
        fi 
      fi       
    done
}

main() {
  run
}

main