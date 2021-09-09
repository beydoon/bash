#!/usr/bin/env bash
# copysshkey.sh
# Copy new ssh key to the server
# Test new ssh key on the server
# If test is success, remove old key from server
# If test fails, revert old key back
#
# To use the script
#                                                     NEW KEY
# ./copysshkey [USERID] [/path/to/list/of/serverfile] [/path/to/new/ssh/pub/key/file]
# NOTE/WARNING: BE VERY CAREFULL OF HOW YOU PUT THE ARGUMENTS: THERE IS NO VALIDATION!

USERID="$1"
SERVERFILE="$2"
NSSHKEYFILE="$3"

OSSHKEY=""
AUTHKEYFILE="~/.ssh/authorized_keys"

displaymsg() {
    server="$1"
    etype="$2"

    fmt0="%s\t--> connection timed out..."
    fmt1="%s\t--> copy success"
    fmt2="%s\t--> copy failed... revert success"
    fmt3="%s\t--> copy failed... revert failed"
    fmt4="%s\t--> copied new sshkey but can\'t log in with it..."
    fmt5="%s\t--> connection test success"

    # etype :
    # ct  == connection timed-out
    # tct == test connection time out
    # cts == connection test success
    # cs  == copy success
    # rs  == revert success
    # rf  == revert failed

    case ${etype,,} in
      "ct"  ) shift; printf "$fmt0" "$server";;
      "tct" ) shift; printf "$fmt4" "$server";;
      "cs"  ) shift; printf "$fmt1" "$server";;
      "rs"  ) shift; printf "$fmt2" "$server";;
      "rf"  ) shift; printf "$fmt2" "$server";;
      "cts" ) shift; printf "$fmt5" "$server";;
           *) shift; echo "Error : ${etype,,} no such command..."; break;
    esac
}

checkAccessToServer() [
  status="$(ssh -o ConnectTimeout=10 $USER@$1 "echo" >/dev/null 2&>1; echo $?)"
  echo $status
}

backupRemoteAuthKeyFile() {
    ssh $USER@$1 "cp $AUTHKEYFILE $AUTHKEYFILE.bkp"
}

revertRemoteAuthKeyFile() {
    ssh $USER@$1 "mv $AUTHKEYFILE.bkp $AUTHKEYFILE"
}

copyNewSshKey() {
    ssh-copy-id -i "$NSSHPUBKEY" "$USER@$1"
}

run() {
    # LOOP THRU THE SERVER LIST
    for SERVER in $(cat $SERVERFILE); do
      # CHECK IF SERVER IS TIMING OUT OR NOT
      if [ "$(checkAccessToServer $SERVER)" == 0 ]; then
        
        # CHECK IF OLD SSHKEY IS THE SAME AS THE NEW SSH KEY
        if [[ "$OSSHKEY" != "$(cat $NSSHKEYFILE)" ]]; then
          # backup authorized_keys file
          backupRemoteAuthKeyFile $SERVER

          # ssh-copy-id new key **(MAKE SURE THAT OLD NOT EQUAL THE NEW)**
          copyNewSshKey $SERVER

          # test if the new key works
          check="$(ssh -i $NSSHKEYFILE $USER@$SERVER "echo" >/dev/null 2&>1; echo $?)"
          
          if [[ "$check" == 0 ]]; then
            displaymsg "$server" "cs"
            # remove old ssh key
            ssh -i $NSSHKEYFILE $SERVER "sed -i '/$OSSHKEY/d' ~/.ssh/authorized_key'" # DO ANOTHER TEST AFTER THIS IF WE CAN ACCESS
            # TEST NSSHKEY ACCESS
            status="$(ssh -i $NSSHKEYFILE -o ConnectTimeout=10 $USER@$1 "echo" >/dev/null 2&>1; echo $?)"
            if [[ "$status" != 0 ]]; then
              displaymsg "$SERVER" "tct"
            else
              displaymsg "$SERVER" "cts"
            fi
          else
            # if copy fails then revert the changes
            revert="$(ssh $SERVER 'cat ~/.ssh/authorized_keys.bk > ~/.ssh/authorized_keys')"
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
    done
}

main() { 
    run
}

main