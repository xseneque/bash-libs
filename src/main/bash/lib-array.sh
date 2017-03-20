#!/bin/bash

if [ -z "$BASH_LIBS_ARRAY" ] ; then
echo "Importing lib-array"
BASH_LIBS_ARRAY=BASH_LIBS_ARRAY

. lib-int.sh

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
    eval "declare -ga ${array_name}=()"
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

# Parameters
# - $1 the name of the array 
#
# Returns
# - 1 if $1 is not passed
# - 2 if $1 is not declared
# - 0 in other cases
#
# Output
# - stderr: when returning > 0, usage + details of issue
# - stoudt: when returning   0, the size of $1
#
function array_print_size() {
  local usage="usage: array_print_size <array_name>"
  if [ $# -ne 1 ] ; then
    echo "$usage" 1>&2
    echo "array_name must be specified" 1>&2
    return 1
  fi
  if ! declare -p "$1" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "$1 is not declared" 1>&2
    return 2
  fi
  if declare -p "$1" > /dev/null 2>&1 ; then
   eval "echo \${#$1[*]}"
  fi
}

# Parameters
# - $1 array name
# - $2 index of the entry from $1 to print
#
# Returns
# - 1 if less than 2 parameters are passed
# - 2 if $1 is not declared
# - 3 if $2 is not a valid integer
# - 0 otherwise
#
# Output
# - stderr: when returning > 0, usage and error details
# - stdout: when returning 0, the value of the entry in $1 at index $2
#
function array_print_entry() {
  local usage="usage: array_print_entry <array_name> <idx>"
  if [ $# -lt 2 ] ; then
    echo "$usage" 1>&2
    return 1
  fi
  if ! declare -p "$1" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "$1 is not declared" 1>&2
    return 2
  fi
  if int_is_valid "$2" ; then
    eval "echo \${$1[$2]}"
  else
    echo "$usage" 1>&2
    echo "$2 is not a valid integer (array index)" 1>&2
    return 3
  fi 
}

# Parameters
# - $1 the name of the array to look in
# - $2 ... $N values to look for in the array
#
# Returns
# - 0 if $1 contains all the values (if no values are passed, 0 is returned)
# - 1 if any $2 ... $N parameters are not in $1
# - 2 if $1 is missing
# - 3 if $1 is not declared
#
# Output
# - stderr: when returning 1, usage information
#           else nil 
# - stdout: nil
#
function array_contains_all() {
  local usage="usage: array_contains_all <array_name> <searchVal1> [ ... <searchValN>]"
  if [ $# -eq 0 ] ; then
    echo "$usage" 1>&2
    return 2
  fi
  if ! declare -p "$1" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "$1 is not declared" 1>&2
    return 3
  fi
  local array_name=$1
  shift
  declare -i array_size=$(array_print_size "$array_name")
  while [ $# -gt 0 ] ; do
    declare -i idx=0
    while [ $idx -lt $array_size ] ; do
      local val=$(array_print_entry "$array_name" $idx)
      if [ "$1" = "$val" ] ; then
        shift
        continue 2
      fi
      idx+=1
    done
    # we haven't found it in array_name...
    return 1
  done
  return 0 
}

BASH_LIBS_ARRAY=
unset BASH_LIBS_ARRAY
fi
