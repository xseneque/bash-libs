#!/bin/bash

# 
# Parameters:
# - $1: the string onto which to determine the empty status
#
# Returns:
# - false if the parameter is empty or there are no parameters passed
# - true if a non empty parameter is passed
#
# Usage example:
#  string_is_empty "$param" || echo "missing value" 
#
function string_is_empty() {
  if [ $# -ge 1 ] && [ ${#1} -gt 0 ] ; then
    true
  else
    false
  fi
}
