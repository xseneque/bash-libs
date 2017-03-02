#!/bin/bash


# TODO: move to other file
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

# 
# Parameters:
# - $1: the string onto which to determine the empty status
#
# Returns:
# - true (0) if the parameter is empty or there are no parameters passed
# - false (1) if a non empty parameter is passed
#
# Output:
# - stderr: nil
# - stdout: nil
#
function string_is_empty() {
  if [ $# -ge 1 ] && [ ${#1} -gt 0 ] ; then
    false 
  else
    true
  fi
}

#
# Parameters:
# - $1 the string to retrieve the char from
# - $2 the index of the char to retrieve - 0 based
#
# Returns:
# - 1 if the wrong number of arguments is passed
# - 2 if the second argument is not valid integer
# - 3 if the index is outside of $1 bounds
# - 0 in other cases
#
# Output:
# - stderr: when returning > 0: error message
# - stdout: when returning   0: character at the specified index
#
function string_char_at() {
  if [ $# -ne 2 ] ; then
    echo "usage: string_char_at <string> <index_char_at>" 1>&2
    return 1
  fi
  if ! is_valid_integer "$2" ; then
    echo "usage: string_char_at <string> <index_char_at>" 1>&2
    echo "<index_char_at> must be an integer between 0 and up to the size of <string>" 1>&2
    return 2
  fi
  if [ $2 -lt 0 ] || [ $2 -ge ${#1} ] ; then
    echo "usage: string_char_at <string> <index_char_at>" 1>&2
    echo "<index_char_at> must be an integer between 0 and up to the size of <string>" 1>&2
    return 3
  fi
  echo "${1:$2:1}"
}

#
# Parameters
# - $1 the string whose length we want to know about
# 
# Returns:
# - 0 in all cases
#
# Output:
# - stdout: the size of the string in input; if no string is passed, 0 is printed
# - stderr: nil
#
function string_length() {
  if [ $# -eq 0 ] ; then
    echo 0
  else
    echo ${#1}
  fi
}

#
# Parameters:
# - $1 the string to check
# - $2 the string that might be a prefix of $1
#
# Returns:
# - true (0) if $1 starts with $2
# - false (1) in all other cases
# 
# Output:
# - stderr: nil
# - stdout: nil
#
function string_starts_with() {
  if [ $# -lt 2 ] ; then
    # we do not have 2 arguments... so $2 can't be a prefix
    false
  else
    if [ ${#1} -lt ${#2} ] ; then
      # $2 is longer than $1
      false
    else
      if [ "${1:0:${#2}}" = "$2" ] ; then
        true
      else
        false
      fi
    fi
  fi
}

#
# Parameters:
# - $1 the string to check
# - $2 the string that might be a suffix of $1
#
# Returns:
# - true (0) if $1 ends with $2
# - false (1) in all other cases
# 
# Output:
# - stderr: nil
# - stdout: nil
#
function string_ends_with() {
  if [ $# -lt 2 ] ; then
    # we do not have 2 arguments... so $2 can't be a suffix
    false
  else
    if [ ${#1} -lt ${#2} ] ; then
      # $2 is longer than $1
      false
    else
      local startidx=$(( ${#1} - ${#2} ))
      if [ "${1:${startidx}}" = "$2" ] ; then
        true
      else
        false
      fi
    fi
  fi
}

#
# Parameters:
# - $1 the string to take the substring from
# - $2 the idx to start from (0 based)
# - $3 [optional] the length of the substring; or until the end of $1 if not specified
#
# Returns:
# - 1 if the wrong less than 2 parameters are passed
# - 2 if $2 or $3 are not valid integers
# - 3 if $2 is greater than the length of $1
# - 4 if $2 is negative
# - 5 if $3 is negative
# - 0 in all other cases
#
# Output:
# - stderr: when returning > 0, adequate error message
# - stdout: when returning 0, the substring defined by the parameters.  
#
function string_substring() {
  local usage="usage: string_substring <string> <idxstart> [lengthsubstr]"
  if [ $# -lt 2 ] ; then
    echo "$usage" 1>&2
    return 1
  fi
  if ! is_valid_integer $2 $3 ; then
    echo "$usage" 1>&2
    return 2
  fi
  if [ $2 -ge ${#1} ] ; then
    echo "$usage" 1>&2
    echo "$2 can't be greater or equal to the length of [$1]" 1>&2
    return 3
  fi
  if [ $2 -lt 0 ] ; then
    echo "$usage" 1>&2
    echo "<idxstart> can't be negative" 1>&2
    return 4
  fi
  if [ $# -ge 3 ] ; then
    if [ $3 -lt 0 ] ; then
      echo "$usage" 1>&2
      echo "[lengthsubstr] can't be negative" 1>&2
      return 5
    fi
    echo ${1:$2:$3}  
  else
    echo ${1:$2}  
  fi
}
