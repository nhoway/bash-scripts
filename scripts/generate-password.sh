#!/bin/bash

# GENERATE PASSWORD
########################################
generatePassword () {
  if [ -n "$1" ]; then
    echo "$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c $1)"
  else
    echo "$(cat /dev/urandom | tr -dc 'a-z0-9' | head -c 10)"
  fi
}
