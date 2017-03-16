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

test_array_add_elements_no_params() {
  local retval
  retval=$(array_add_elements 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_array_add_elements_no_ele() {
  local retval
  retval=$(array_add_elements myarray 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
}


test_array_add_elements_non_existent_array() {
  array_add_elements myarray 123 "abc d"
  assertEquals 0 $?
  if declare -p myarray > /dev/null 2>&1 ; then
    assertEquals 2 ${#myarray[*]}
    assertEquals "123" "${myarray[0]}"
    assertEquals "abc d" "${myarray[1]}"
  else
    fail "myarray was not created"
  fi
  unset myarray
}

test_array_add_elements_existing_array() {
  array_create myarray "a b" "c d"
  array_add_elements myarray 123 "9 0"
  assertEquals 0 $?
  if declare -p myarray > /dev/null 2>&1 ; then
    assertEquals 4 ${#myarray[*]}
    assertEquals "a b" "${myarray[0]}"
    assertEquals "c d" "${myarray[1]}"
    assertEquals "123" "${myarray[2]}"
    assertEquals "9 0" "${myarray[3]}"
  else
    fail "myarray was not created"
  fi
  unset myarray
}

test_array_print_indices_no_array_name() {
  local retval
  retval=$(array_print_indices 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}


test_array_print_indices_non_existing_array() {
  local retval
  retval=$(array_print_indices somefantomarrayABC 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
}


test_array_print_indices_existing_array() {
  myarray[0]=abc
  myarray[3]=three
  myarray[42]=haha
  local retval
  retval=$(array_print_indices myarray 2> /dev/null)
  assertEquals 0 $?
  assertEquals "0 3 42" "$retval"
  unset myarray
}







. ../lib/shunit2/source/2.1/src/shunit2


