#!/bin/bash

askconfig () {
  VFILE=$1;
  VNAME=$2;
  if [ ! -z "$3" ]; then  VHELP="($3) "; fi
  VVAR="$(getconfig $VFILE $VNAME)";
  if [ -z "$VVAR" ]; then
    read -p "Please enter $VNAME $VHELP: " VVAR;
    setconfig "$VFILE" "$VNAME" "$VVAR";
  fi
  echo $VVAR;
}

getconfig () {
  VFILE=$1;
  VNAME=$2;
  checkfile "$VFILE";
  grep -oP "(?<=$VNAME=')[^']*(?=')" $VFILE;
}

setconfig () {
  VFILE=$1;
  VNAME=$2;
  VVAR=$3;
  if [ -z "$VVAR" ]; then
    VVAR="$(askconfig $VFILE $VNAME)";
  else
    checkfile "$VFILE";
    sed -i -e "/^$VNAME=/d" $VFILE;
    echo "$VNAME='$VVAR'" >> $VFILE;
  fi
}

checkfile() {
  #if [ ! -f "$1" ]; then
  touch "$1";
  chmod o+x "$1";
}
