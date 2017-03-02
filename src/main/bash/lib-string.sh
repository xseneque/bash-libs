#!/bin/bash


# TODO: move to other file
function is_valid_integer() {
  if [ $# -ne 1 ] ; then
    false
  else
    local val=$1
    if [ ${val:0:1} = "-" ] ; then
      val=${val:1}
    fi
    case $val in
      *[!0-9]*) false;;
      *) true ;;
    esac
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
