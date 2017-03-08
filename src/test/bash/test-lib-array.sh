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

test_array_create_no_values() {
  local retval
#  set -xv
  retval=$(array_create myarray)
  assertEquals 0 $?
  assertEquals "" "$retval"
  if [ -z ${myarray+x} ] ; then
    fail "myarray was not created"
  else
    unset myarray
  fi
#  set +xv
}

. ../lib/shunit2/source/2.1/src/shunit2


