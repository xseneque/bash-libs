#!/bin/bash

pushd ../../main/bash
. ./lib-int.sh
popd

test_int_is_valid_no_params() {
  local retval
  retval=$(int_is_valid 2> /dev/null)
  assertEquals 255 $?
  assertEquals "" "$retval"
}

test_int_is_valid_one_valid_int() {
  local retval
  retval=$(int_is_valid 123 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_int_is_valid_one_valid_int_with_spaces() {
  local retval
  retval=$(int_is_valid " 123 " 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_int_is_valid_3_valid_int() {
  local retval
  retval=$(int_is_valid 123 -12 9999999999 2> /dev/null)
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_int_is_valid_one_invalid_param() {
  local retval
  retval=$(int_is_valid 123a 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_int_is_valid_one_invalid_param_out_of_3() {
  local retval
  retval=$(int_is_valid 123 123a -12 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_int_is_valid_two_invalid_param_out_of_3() {
  local retval
  retval=$(int_is_valid 123 " asd " " " 123a "-1NOTINT2" 2> /dev/null)
  assertEquals 4 $?
  assertEquals "" "$retval"
}

. ../lib/shunit2/source/2.1/src/shunit2


