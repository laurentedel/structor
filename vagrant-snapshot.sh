#!/bin/bash
if [ -z "$1" ]
  then
    echo "Please supply quoted name of the snapshot"
    exit 2
fi

for i in $(sed -n 's/.*"hostname": "\([^"]*\)".*/\1/p' current.profile);
do
  vagrant snapshot take $i "$1";
done
