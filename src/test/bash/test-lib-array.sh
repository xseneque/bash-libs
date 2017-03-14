#!/bin/bash

pushd ../../main/bash
. ./lib-array.sh
popd

test_array_create_no_params() {
  local retval
  retval=$(array_create 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

#
# somehow creating an array with no elements does not define the variable
#
#test_array_create_no_values() {
#  array_create myarray
#  assertEquals 0 $?
#  if declare -p myarray > /dev/null 2>&1 ; then
#    assertEquals 0 ${#myarray[*]}
#  else
#    fail "myarray was not created"
#  fi
#  unset myarray
#}

test_array_create_one_value() {
  array_create myarray abc
  assertEquals 0 $?
  if declare -p myarray > /dev/null 2>&1 ; then
    assertEquals 1 ${#myarray[*]}
    assertEquals "abc" "${myarray[0]}"
  else
    fail "myarray was not created"
  fi
  unset myarray
}


test_array_create_3_values() {
  array_create myarray abc 123 "with spaces"
  assertEquals 0 $?
  if declare -p myarray > /dev/null 2>&1 ; then
    assertEquals 3 ${#myarray[@]}
    assertEquals "abc" "${myarray[0]}"
    assertEquals "123" "${myarray[1]}"
    assertEquals "with spaces" "${myarray[2]}"
  else
    fail "myarray was not created"
  fi
  unset myarray
}



. ../lib/shunit2/source/2.1/src/shunit2


