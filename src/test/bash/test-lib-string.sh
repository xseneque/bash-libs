#!/bin/bash

. ../../main/bash/lib-string.sh

test_string_is_empty() {
  if ! string_is_empty "" ; then
    fail
  fi 
  if ! string_is_empty ; then
    fail
  fi 
  if string_is_empty " " ; then
    fail
  fi
  if string_is_empty "x" ; then
    fail
  fi
}

test_string_char_at_one_param() {
  string_char_at "abc"
  assertEquals 1 $?
}

test_string_char_at_invalid_int() {
  string_char_at "abc" "abc"
  assertEquals 2 $?
}

test_string_char_at_negative_idx() {
  string_char_at "abc" -1
  assertEquals 3 $?
}

test_string_char_at_idx_same_as_length() {
  string_char_at "abc" 3
  assertEquals 3 $?
}

test_string_char_at_idx_greater_than_str_length() {
  string_char_at "abc" 4
  assertEquals 3 $?
}

test_string_char_at_ok() {
  local i=0
  local str="my string"
  while [ $i -lt ${#str} ] ; do
    assertEquals "${str:$i:1}" "$(string_char_at "$str" $i)"
    i=$((i+1))
  done
}

. ../lib/shunit2/source/2.1/src/shunit2
