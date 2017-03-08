#!/bin/bash

if [ -z "$BASH_LIBS_BASH" ] ; then
echo "Importing lib-bash"
BASH_LIBS_BASH=BASH_LIBS_BASH

# This method is purely aimed at escaping the pattern when using bash's
# ${parameter/pattern/string} for substitution. 
#
# Parameters:
# - $1 the pattern to escape
#
# Returns
# - 1 if no pattern is supplied
# - 0 in all other cases
#
# Output:
# - stderr: when returning > 0, usage information
# - stdout: when returning   0, the escaped substitution pattern
#
function bash_escape_substitution_pattern() {
  local usage="usage: bash_escape_substitution_pattern <pattern_to_escape>"
  if [ $# -lt 1 ] ; then
    echo
    return 1
  fi
  local pattern="${1}"
  # need to escape in pattern:
  # any '\'
  pattern="${pattern//\\/\\\\}"
  # leading '#' and '/' and '%'
  case "$pattern" in
    \#*) pattern="\\$pattern";;
    /*) pattern="\\$pattern";;
    %*) pattern="\\$pattern";;
  esac
  # any '*'
  pattern="${pattern//\*/\\*}"
  # any '?'
  pattern="${pattern//\?/\\?}"
  #pattern is now just a litteral string!
  echo "$pattern"
}

BASH_LIBS_BASH=
unset BASH_LIBS_BASH
fi
