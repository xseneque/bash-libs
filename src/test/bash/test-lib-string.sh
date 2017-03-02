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
  local retval
  retval=$(string_char_at "abc" 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_char_at_invalid_int() {
  local retval
  retval=$(string_char_at "abc" "abc" 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
}

test_string_char_at_negative_idx() {
  local retval
  retval=$(string_char_at "abc" -1 2> /dev/null)
  assertEquals 3 $?
  assertEquals "" "$retval"
}

test_string_char_at_idx_same_as_length() {
  local retval
  retval=$(string_char_at "abc" 3 2> /dev/null)
  assertEquals 3 $?
  assertEquals "" "$retval"
}

test_string_char_at_idx_greater_than_str_length() {
  local retval
  retval=$(string_char_at "abc" 4 2> /dev/null)
  assertEquals 3 $?
  assertEquals "" "$retval"
}

test_string_char_at_ok() {
  local retval
  local -i i=0
  local str="my string"
  while [ $i -lt ${#str} ] ; do
    retval=$(string_char_at "$str" $i)
    assertEquals 0 $?
    assertEquals "${str:$i:1}" "$retval"
    ((i++))
  done
}

test_string_length() {
  local retval
  retval=$(string_length)
  assertEquals 0 $?
  assertEquals "0" "$retval" 
  retval=$(string_length a)
  assertEquals 0 $?
  assertEquals "1" "$retval" 
  retval=$(string_length abc)
  assertEquals 0 $?
  assertEquals "3" "$retval" 
}

. ../lib/shunit2/source/2.1/src/shunit2
