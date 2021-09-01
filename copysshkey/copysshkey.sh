#!/usr/bin/env bash
# copysshkey.sh
# khurram.subhani@td.com
# Copy new ssh key to the server
# Test new ssh key on the server
# If test is success, remove old key from server
# If test fails, revert old key back
#
# To use the script
# ./copysshkey [USERID] [/path/to/list/of/serverfile] [/path/to/old/public/sshkey] [/path/to/new/ssh/key]
# NOTE/WARNING: BE VERY CAREFULL OF HOW YOU PUT THE ARGUMENTS: THERE IS NO VALIDATION!

USERID="$1"
SERVERFILE="$2"
OSSHKEYFILE="$3"
NSSHKEYFILE="$4"

displaymsg() {
    server="$1"
    etype="$2"

    fmt1="%s\t--> copy success"
    fmt2="%s\t--> copy failed... revert success"
    fmt3="%s\t--> copy failed... revert failed"

    # cs = copy success; rs = revert success; rf == revert failed
    if [[ "${etype,,}" == "cs" ]]; then
      printf "$fmt1" "$server"
    fi

    if [[ "${etype,,}" == "rs" ]]; then
      printf "$fmt2" "$server"
    fi

    if [[ "${etype,,}" == "rf" ]]; then
      printf "$fmt2" "$server"
    fi
}

run() {
    for SERVER in $(cat $SERVERFILE); do
      # backup authorized_keys file
      ssh $SERVER "cp ~/.ssh/authorized_keys ~/.ssh/authorized_keys.bk"

      # ssh-copy-id new key
      ssh-copy-id -i $NSSHKEYFILE $USERID@$SERVER

      # test if the new key works
      check="$(ssh -i $NSSHKEYFILE $USERID@$SERVER "ls ~/" >/dev/null 2&>1; echo $?)"
      if [[ "$check" == 0 ]]; then
        displaymsg "$server" "cs"
        # remove old ssh key
        ssh -i $NSSHKEYFILE $SERVER "sed -i '/$OSSHKEYFILE/d' ~/.ssh/authorized_key'"
      else
        # if copy fails then revert the changes
        revert="$(ssh $SERVER "cat ~/.ssh/authorized_keys.bk > ~/.ssh/authorized_keys")"
        if [[ "$revert" == 0 ]]; then
          displaymsg "$server" "rs"
        else
          # can't revert the change! ops!
          displaymsg "$server" "rf"
        fi
      fi        
    done
}

main() { 
    run
}

main