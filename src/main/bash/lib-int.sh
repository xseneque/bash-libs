#!/bin/bash

if [ -z "$BASH_LIBS_INT" ] ; then
echo "Importing lib-int"
BASH_LIBS_INT=BASH_LIBS_INT

function is_valid_integer() {
  if [ $# -lt 1 ] ; then
    false
  else
    while [ $# -gt 0 ] ; do
      local val=$1
      if [ ${val:0:1} = "-" ] ; then
        val=${val:1}
      fi
      case $val in
        *[!0-9]*)
          echo "[$1] is not a valid integer." 1>&2
          return 1;;
        *) ;;
      esac
      shift
    done
    true
  fi
}

BASH_LIBS_INT=
unset BASH_LIBS_INT
fi
