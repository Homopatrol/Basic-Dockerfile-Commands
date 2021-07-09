#!/usr/bin/env bash

option="${OPTARG}"

printf "\nHi,is this your first dockerfile?(Y\n)\n"

if [ "$option" != "Y" ] |  [ "$option" != "y" ]; then
  printf "\nCongrats :)\n"
  exit 1
fi
