#!/bin/bash

pushd ../../main/bash
. ./lib-array.sh
popd

setUp() {
  unset myarray 2> /dev/null
  return 0
}

#
# array_create
#

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

######################################
# array_add_elements
######################################

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

######################################
# array_print_indices
######################################

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

######################################
# array_print_size
######################################

test_array_print_size_no_params() {
  local retval
  retval=$(array_print_size 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_array_print_size_undeclared_array() {
  local retval
  retval=$(array_print_size myarray 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_print_size_empty_array() {
  local retval
  declare -ga myarray=()
  retval=$(array_print_size myarray 2> /dev/null)
  assertEquals 0 $?
  assertEquals "0" "$retval"
  unset myarray
}

test_array_print_size_array() {
  local retval
  declare -ga myarray=(a b c)
  retval=$(array_print_size myarray 2> /dev/null)
  assertEquals 0 $?
  assertEquals "3" "$retval"
  unset myarray
}

######################################
# array_print_entry
######################################

test_array_print_entry_no_params() {
  local retval
  retval=$(array_print_entry 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_array_print_entry_one_param() {
  local retval
  retval=$(array_print_entry myarray 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_array_print_entry_undeclared_array() {
  local retval
  retval=$(array_print_entry myarray 0 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
}

test_array_print_entry_invalid_idx() {
  declare -ga myarray=(a b c)
  local retval
  retval=$(array_print_entry myarray abc 2> /dev/null)
  assertEquals 3 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_print_entry_inexistant_entry() {
  declare -ga myarray=(a b c)
  local retval
  retval=$(array_print_entry myarray 5)
  assertEquals 0 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_print_entry_empty_entry() {
  declare -ga myarray=("" b c)
  local retval
  retval=$(array_print_entry myarray 0)
  assertEquals 0 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_print_entry_ok() {
  declare -ga myarray=("" "b c" def)
  local retval
  retval=$(array_print_entry myarray 1)
  assertEquals 0 $?
  assertEquals "b c" "$retval"
  unset myarray
}

#######################################
# array_contains_all
#######################################

test_array_contains_all_no_params() {
  local retval
  retval=$(array_contains_all 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
}

test_array_contains_all_undeclared_array() {
  local retval
  retval=$(array_contains_all myarray 2> /dev/null)
  assertEquals 3 $?
  assertEquals "" "$retval"
}

test_array_contains_all_array_no_searchval() {
  declare -ga myarray=(a b c)
  local retval
  retval=$(array_contains_all myarray 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_contains_all_array_01() {
  declare -ga myarray=(a c "c c")
  local retval
  retval=$(array_contains_all myarray c "c c" 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_contains_all_array_02() {
  declare -ga myarray=(a "a a a"  c)
  local retval
  retval=$(array_contains_all myarray "a a a" 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_contains_all_array_03() {
  declare -ga myarray=(a b c)
  local retval
  retval=$(array_contains_all myarray b d 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_contains_all_array_04() {
  declare -ga myarray=(a b c)
  local retval
  retval=$(array_contains_all myarray d 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
  unset myarray
}

test_array_contains_all_array_05() {
  declare -ga myarray=(a b c)
  myarray[10]=d
  local retval
  retval=$(array_contains_all myarray d 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
  unset myarray
}

. ../lib/shunit2/source/2.1/src/shunit2


