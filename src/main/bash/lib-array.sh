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
  while [ $# -gt 0 ] ; do
    declare -i idx=0
    for idx in $(array_print_indices "$array_name") ; do
      local val=$(array_print_entry "$array_name" $idx)
      if [ "$1" = "$val" ] ; then
        shift
        continue 2
      fi
    done
    # we haven't found it in $array_name...
    return 1
  done
  return 0 
}

# Parameters
# - $1 the name of the array to look in
# - $2 ... $N values to look for in the array
#
# Returns
# - 0 if $1 contains at least one the values (if no values are passed, 1 rray to look in
# - $2 ... $N values to look for in the array
#
# Returns
# - 0 if $1 contains at least one the values (if no values are passed, 0 is returned)
# - 1 if none of the $2 ... $N parameters are in $1
# - 2 if $1 is missing
# - 3 if $1 is not declaris returned)
# - 1 if none of the $2 ... $N parameters are in $1
# - 2 if $1 is missing
# - 3 if $1 is not declared
#
# Output
# - stderr: when returning 1, usage information
#           else nil 
# - stdout: nil
#
function array_contains_one() {
  local usage="usage: array_contains_one <array_name> <searchVal1> [ ... <searchValN>]"
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
  declare -i searchArrayIdx=0
  declare -a searchVals=("$@")
  for searchArrayIdx in $(array_print_indices "$array_name") ; do
    local val=$(array_print_entry "$array_name" $searchArrayIdx)
    declare -i paramIdx=1
    while [ $paramIdx -le ${#searchVals[*]} ] ; do
      if [ "${searchVals[$paramIdx]}" = "$val" ] ; then
        return 0
      else
        paramIdx+=1
      fi
    done
  done
  return 1 
}

# Parameters
# - $1 the name of the array to sort
#
# Returns
# - 1 if $1 is missing
# - 2 if there is no declared array of name $1
# - 0 in all other cases
#
# Output
# - stderr: when returning > 1, usage information with optional error message
# - stdout: nil
#
# Note: 
# - sorting algorithm used is insertion sort
# - order is lexicographical order as defined by bash and the current local ( use of [[ a < b ]])
#
function array_sort() {
  local usage="usage: array_sort <array_name>"
  if [ $# -eq 0 ] ; then
    echo "$usage" 1>&2
    return 1
  fi
  if ! declare -p "$1" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "$1 is not declared" 1>&2
    return 2
  fi
  local array_name=$1
  declare -a arrayIndices=( $(array_print_indices "$array_name") )
  declare -i arrayLen=${#arrayIndices[*]}
  declare -i _i=1
  while [ $_i -lt $arrayLen ] ; do
    declare -i _j=$_i
    while [ $_j -gt 0 ] ; do
      declare -i _jn=$(($_j - 1))
      declare -i idxJ=${arrayIndices[$_j]}
      declare -i idxJn=${arrayIndices[$_jn]}
      local _valJ=$(eval "echo \${$array_name[$idxJ]}")
      local _valJn=$(eval "echo \${$array_name[$idxJn]}")
      if [[ "$_valJ" < "$_valJn" ]] ; then
        eval "${array_name}[${idxJ}]=\"${_valJn}\"" 
        eval "${array_name}[${idxJn}]=\"${_valJ}\"" 
        _j=$_jn
      else
        unset _jn idxJ idxJn _valJ _valJn
        break
      fi
      unset _jn idxJ idxJn _valJ _valJn
    done
    unset _j
    _i+=1
  done
  unset _i arrayLen arrayIndices array_name usage
}

# Parameters
# - $1 the name of the array to reverse sort
#
# Returns
# - 1 if $1 is missing
# - 2 if there is no declared array of name $1
# - 0 in all other cases
#
# Output
# - stderr: when returning > 1, usage information with optional error message
# - stdout: nil
#
# Note: 
# - sorting algorithm used is insertion sort
# - order is reversed lexicographical order as defined by bash and the current local ( use of [[ a > b ]])
#
function array_reverse_sort() {
  local usage="usage: array_reverse_sort <array_name>"
  if [ $# -eq 0 ] ; then
    echo "$usage" 1>&2
    return 1
  fi
  if ! declare -p "$1" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "$1 is not declared" 1>&2
    return 2
  fi
  local array_name=$1
  declare -a arrayIndices=( $(array_print_indices "$array_name") )
  declare -i arrayLen=${#arrayIndices[*]}
  declare -i _i=1
  while [ $_i -lt $arrayLen ] ; do
    declare -i _j=$_i
    while [ $_j -gt 0 ] ; do
      declare -i _jn=$(($_j - 1))
      declare -i idxJ=${arrayIndices[$_j]}
      declare -i idxJn=${arrayIndices[$_jn]}
      local _valJ=$(eval "echo \${$array_name[$idxJ]}")
      local _valJn=$(eval "echo \${$array_name[$idxJn]}")
      if [[ "$_valJ" > "$_valJn" ]] ; then
        eval "${array_name}[${idxJ}]=\"${_valJn}\"" 
        eval "${array_name}[${idxJn}]=\"${_valJ}\"" 
        _j=$_jn
      else
        unset _jn idxJ idxJn _valJ _valJn
        break
      fi
      unset _jn idxJ idxJn _valJ _valJn
    done
    unset _j
    _i+=1
  done
  unset _i arrayLen arrayIndices array_name usage
}


# Parameters
# - $1 the name of the array to sort
# - $2 the name of the sort function to use. This function should accept two parameters and return 0
#      when param1 < param2 and a value >= 1 otherwise. It is a "isLessThan" function.
#
# Returns
# - 1 if $1 or $2 are missing
# - 2 if there is no declared array of name $1
# - 3 if there is no declare function of name $2
# - 0 in all other cases
#
# Output
# - stderr: when returning > 1, usage information with optional error message
# - stdout: nil
#
# Note: 
# - all output from function $2 is redirected to /dev/null; only its return code is used
#
function array_sort_wfct() {
  local usage="usage: array_sort_wfct <array_name> <function_name>"
  if [ $# -lt 2 ] ; then
    echo "$usage" 1>&2
    return 1
  fi
  if ! declare -p "$1" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "array $1 is not declared" 1>&2
    return 2
  fi
  if ! declare -pF "$2" > /dev/null 2>&1 ; then
    echo "$usage" 1>&2
    echo "function $2 is not declared" 1>&2
    return 3
  fi
  local array_name=$1
  declare -a arrayIndices=( $(array_print_indices "$array_name") )
  declare -i arrayLen=${#arrayIndices[*]}
  declare -i _i=1
  while [ $_i -lt $arrayLen ] ; do
    declare -i _j=$_i
    while [ $_j -gt 0 ] ; do
      declare -i _jn=$(($_j - 1))
      declare -i idxJ=${arrayIndices[$_j]}
      declare -i idxJn=${arrayIndices[$_jn]}
      local _valJ=$(eval "echo \${$array_name[$idxJ]}")
      local _valJn=$(eval "echo \${$array_name[$idxJn]}")
      if eval "$2 \"$_valJ\" \"$_valJn\" > /dev/null 2>&1" ; then
        eval "${array_name}[${idxJ}]=\"${_valJn}\"" 
        eval "${array_name}[${idxJn}]=\"${_valJ}\"" 
        _j=$_jn
      else
        unset _jn idxJ idxJn _valJ _valJn
        break
      fi
      unset _jn idxJ idxJn _valJ _valJn
    done
    unset _j
    _i+=1
  done
  unset _i arrayLen arrayIndices array_name usage
}


BASH_LIBS_ARRAY=
unset BASH_LIBS_ARRAY
fi
