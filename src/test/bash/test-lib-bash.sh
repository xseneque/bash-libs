#!/bin/bash

pushd ../../main/bash
. ./lib-bash.sh
popd


test_bash_escape_substitution_pattern_no_params() {
  local retval
  retval=$(bash_escape_substitution_pattern 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_bash_escape_substitution_pattern_empty_param() {
  local retval
  retval=$(bash_escape_substitution_pattern "")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_bash_escape_substitution_pattern_nothing_to_escape() {
  local retval
  retval=$(bash_escape_substitution_pattern " ab cd ")
  assertEquals 0 $?
  assertEquals " ab cd " "$retval"
}

test_bash_escape_substitution_pattern_backslashes() {
  local retval
  retval=$(bash_escape_substitution_pattern 'a\i\b')
  assertEquals 0 $?
  assertEquals 'a\\i\\b' "$retval"
}

test_bash_escape_substitution_pattern_stars() {
  local retval
  retval=$(bash_escape_substitution_pattern 'a*i*b')
  assertEquals 0 $?
  assertEquals 'a\*i\*b' "$retval"
}

test_bash_escape_substitution_pattern_qmarks() {
  local retval
  retval=$(bash_escape_substitution_pattern 'a?i?b')
  assertEquals 0 $?
  assertEquals 'a\?i\?b' "$retval"
}

test_bash_escape_substitution_pattern_leading_pound() {
  local retval
  retval=$(bash_escape_substitution_pattern '#a#b#c')
  assertEquals 0 $?
  assertEquals '\#a#b#c' "$retval"
}

test_bash_escape_substitution_pattern_leading_slash() {
  local retval
  retval=$(bash_escape_substitution_pattern '/a/b/c')
  assertEquals 0 $?
  assertEquals '\/a/b/c' "$retval"
}

test_bash_escape_substitution_pattern_leading_pct() {
  local retval
  retval=$(bash_escape_substitution_pattern '%a%b%c')
  assertEquals 0 $?
  assertEquals '\%a%b%c' "$retval"
}

test_bash_escape_substitution_pattern_mixed() {
  local retval
  retval=$(bash_escape_substitution_pattern '% \*\? *? %#')
  assertEquals 0 $?
  assertEquals '\% \\\*\\\? \*\? %#' "$retval"
}

test_bash_escape_substitution_pattern_chars_not_to_escape() {
  local retval
  retval=$(bash_escape_substitution_pattern "|,.<>;:'@#~[]{}=+-_)(&^%$£\"!\`¬|")
  assertEquals 0 $?
  assertEquals "|,.<>;:'@#~[]{}=+-_)(&^%$£\"!\`¬|" "$retval"
}

. ../lib/shunit2/source/2.1/src/shunit2
