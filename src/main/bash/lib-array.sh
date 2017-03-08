#!/bin/bash

if [ -z "$BASH_LIBS_ARRAY" ] ; then
echo "Importing lib-array"
BASH_LIBS_ARRAY=BASH_LIBS_ARRAY

# Parameters:
# - $1 the name of the array
# - $2 .. $N [optional] values to populate the array with
#
# Returns
# - 1 if no array name is supplied
# - 0 in all other cases
#
# Output:
# - stderr: when returning > 0, usage information
# - stdout: nil
#
function array_create() {
  local usage="usage: array_create <array_name> [value1] ... [valueN]"
  if [ $# -lt 1 ] ; then
    echo "$usage" 1>&2
    return 1
  fi
  local array_name=$1
  shift
  if [ $# -eq 0 ] ; then
    #declaring an array with =() is not really valid so doesn't declare anything
    eval "declare -xa ${array_name}"
  else
    eval "declare -xa ${array_name}=(""$@"")"
  fi
}

BASH_LIBS_ARRAY=
unset BASH_LIBS_ARRAY
fi
