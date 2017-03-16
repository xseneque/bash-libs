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
# In some version of bash, creating an array with no value will be a no-op
# and thus will do nothing. This should not really impact the use of this
# function except in rare scenarios.
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
    eval "declare -ga ${array_name}"
  else
    eval "declare -ga ${array_name}=( \"\$@\" )"
  fi
}

# Parameters:
# - $1 the name of the array
# - $2 .. $N values to add to the array
#
# Returns
# - 1 if no array name is supplied
# - 2 if no element is supplied
# - 0 in all other cases
#
# Output:
# - stderr: when returning > 0, usage information
# - stdout: nil
#
function array_add_elements() {
  local usage="usage: array_add_elements <array_name> <value1> ... [valueN]"
  if [ $# -lt 1 ] ; then
    echo "$usage" 1>&2
    echo "array_name must be specified" 1>&2
    return 1
  fi
  if [ $# -lt 2 ] ; then
    echo "$usage" 1>&2
    echo "at least one element must be specified" 1>&2
    return 2
  fi
  local array_name=$1
  shift
  if declare -p "$array_name" > /dev/null 2>&1 ; then
    # the array exists, lets add the elements 
    eval "${array_name}+=( \"\$@\" )"
  else
    # the array doesn't exist, simply call array_create
    array_create "$array_name" "$@"
  fi
}

# Parameters
# - $1 the name of the array
#
# Returns
# - 1 if the array name is not supplied
# - 0 otherwise
#
# Output
# - stderr : when returning > 0, usage information
# - stdout : when returning   0, the indices (keys) uses in the specified array
#            if the array doesn't exist, nothing is printed
#
function array_print_indices() {
  local usage="usage: array_print_indices <array_name>"
  if [ $# -ne 1 ] ; then
    echo "$usage" 1>&2
    echo "array_name must be specified" 1>&2
    return 1
  fi
  if declare -p "$1" > /dev/null 2>&1 ; then
    eval "echo \${!$1[*]}"
  fi
}

BASH_LIBS_ARRAY=
unset BASH_LIBS_ARRAY
fi
