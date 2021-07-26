#!/bin/bash

read -r -p "Hi,is this your first dockerfile? [y/N]" response

printf "\n"

if [[ "$response" = "Y" ]] || [[ "$response" = "y" ]]; then
  printf "\nCongrats :)\n"
  printf "\n"
  exit 1
elif [[ "$response" = "N" ]] || [[ "$response" = "n" ]]; then
  printf "\nYour already a pro then?\n"
  printf "\n"
  exit 1
else
  printf "\nPlease input a valid character [y/N]\n"
  printf "\n"
  exit 1
fi
