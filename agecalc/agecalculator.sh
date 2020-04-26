#!/usr/bin/env bash
# Age Calculator
# version 1.0.10
# Bedouin Technologies (c) Copyright 2020 *GPL*
# 20200418

currentYear=$(date +%Y)

birth_month=""
birth_date=""
birth_year=""
currentAge=""

fname=""
lname=""
fullname=""

ask() {
  value1="$1"
  value2="$2"
  read -p "[E]nter your $value1 : " $value2
}

defaultvalue() {
  if [ "${!1}" == "" ]; then
    declare -g $1="$2"
  fi
}

askName() {
  ask "first name" fname
  ask "last name" lname

  defaultvalue "fname" "Arnold"
  defaultvalue "lname" "Schwarzenegger"

  fullname="${fname^} ${lname^}"
}

askDOB() {
  ask "birth month" birth_month
  ask "birth date" birth_date
  ask "birth year" birth_year

  defaultvalue "birth_month" "July"
  defaultvalue "birth_date" "30"
  defaultvalue "birth_year" "1947"
}

calculateAge() {
  currentAge=$(($currentYear-$birth_year))
}

displaymsg() {
  printf "Hi %s!\n" "${fname^}"
  printf "Your first and last name is \"%s\"\n" "$fullname"
  printf "Your were born in %s, %s %s\n" "${birth_month^}" "${birth_date}" "${birth_year}"
  printf "According to your date of birth, you are %s years of age.\n" "${currentAge}"
}

askQuestions() {
  askName
  askDOB
}

main() {
  askQuestions
  calculateAge
   clear
  displaymsg
}

main
