#!/usr/bin/env bash

read -r -p "Hi,is this your first dockerfile? [y/N]" response

printf "\n"

if [ "$response" = "Y" ] | [ "$response" = "y" ]; then
  printf "\nCongrats :)\n"
  exit 1
elseif [ "$response" = "N" ] | [ "$response" = "n" ]; then
  printf "\nYour already a pro then?\n"
  exit 1
else
  printf "\nPlease input a valid character [y/N]\n"
  exit 1
fi
