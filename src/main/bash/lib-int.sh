#!/bin/bash

if [ -z "$BASH_LIBS_INT" ] ; then
echo "Importing lib-int"
BASH_LIBS_INT=BASH_LIBS_INT

#
# Parameters:
# - one or more params to validate
#
# Returns:
# - > 0 if any param is not an int or if no parameters passed
#       the actual number of non ints is returned up to 254.
# - = 0 if all params are valid int
#
# Output
# - stderr: when not passing any parameter, an adequate message
# - stdout: nil
#
function int_is_valid() {
  local usage="usage: int_is_valid <param1> [param2 ... paramN]"
  if [ $# -lt 1 ] ; then
    echo "$usage" 1>&2
    echo "at least 1 <param> must be passed to int_is_valid" 1>&2
    return -1
  else
    local ret=0
    while [ $# -gt 0 ] ; do
      local val=$(echo $1)
      if [ ${#val} -ge 1 ] && [ "${val:0:1}" = "-" ] ; then
        val="${val:1}"
      fi
      case "$val" in
        *[!0-9]*)
          ret=$((ret + 1));;
        "")
          ret=$((ret + 1));;
        *) ;;
      esac
      shift
    done
    return $ret
  fi
}

BASH_LIBS_INT=
unset BASH_LIBS_INT
fi
