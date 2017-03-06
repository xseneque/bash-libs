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
  retval=$(string_length " abc ")
  assertEquals 0 $?
  assertEquals "5" "$retval" 
}

test_string_starts_with_one_param() {
  local retval
  retval=$(string_starts_with "abc")
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_starts_with_prefix_too_long() {
  local retval
  retval=$(string_starts_with "abc" "abcd")
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_starts_with_same_str() {
  local retval
  retval=$(string_starts_with "abc" "abc")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_starts_with_prefix() {
  local retval
  retval=$(string_starts_with "abc" "a")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_starts_with_spaceprefix() {
  local retval
  retval=$(string_starts_with " a bc" " a b")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_starts_with_emptystr() {
  local retval
  retval=$(string_starts_with "abc" "")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_starts_with_notprefix() {
  local retval
  retval=$(string_starts_with "abc" "bc")
  assertEquals 1 $?
  assertEquals "" "$retval"
}




test_string_ends_with_one_param() {
  local retval
  retval=$(string_ends_with "abc")
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_ends_with_prefix_too_long() {
  local retval
  retval=$(string_ends_with "abc" "abcd")
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_ends_with_same_str() {
  local retval
  retval=$(string_ends_with "abc" "abc")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_ends_with_suffix() {
  local retval
  retval=$(string_ends_with "abc" "c")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_ends_with_spacesuffix() {
  local retval
  retval=$(string_ends_with "ab c " "b c ")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_ends_with_emptystr() {
  local retval
  retval=$(string_ends_with "abc" "")
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_ends_with_notsuffix() {
  local retval
  retval=$(string_ends_with "abc" "ab")
  assertEquals 1 $?
  assertEquals "" "$retval"
}


#
# string_substring
#

test_string_substring_no_param() {
  local retval
  retval=$(string_substring 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_substring_one_param() {
  local retval
  retval=$(string_substring "abc" 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}


test_string_substring_invalid_int_idx_param() {
  local retval
  retval=$(string_substring "abc" "notAnInt" 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
}

test_string_substring_invalid_int_length_param() {
  local retval
  retval=$(string_substring "abc" 2 "notAnInt" 2> /dev/null)
  assertEquals 2 $?
  assertEquals "" "$retval"
}

test_string_substring_idx_too_big() {
  local retval
  retval=$(string_substring "abc" 3 2> /dev/null)
  assertEquals 3 $?
  assertEquals "" "$retval"
}

test_string_substring_idx_negative() {
  local retval
  retval=$(string_substring "abc" -1 2> /dev/null)
  assertEquals 4 $?
  assertEquals "" "$retval"
}

test_string_substring_length_negative() {
  local retval
  retval=$(string_substring "abc" 0 -1 2> /dev/null)
  assertEquals 5 $?
  assertEquals "" "$retval"
}

test_string_substring_length_negative() {
  local retval
  retval=$(string_substring "abc" 0 -1 2> /dev/null)
  assertEquals 5 $?
  assertEquals "" "$retval"
}

test_string_substring_2params() {
  local retval
  retval=$(string_substring "abc" 1 )
  assertEquals 0 $?
  assertEquals "bc" "$retval"
}

test_string_substring_2params_space() {
  local retval
  retval=$(string_substring "ab c " 1 )
  assertEquals 0 $?
  assertEquals "b c " "$retval"
}

test_string_substring_3params() {
  local retval
  retval=$(string_substring "abc" 1 1 )
  assertEquals 0 $?
  assertEquals "b" "$retval"
}

test_string_substring_3params_space() {
  local retval
  retval=$(string_substring "a bc" 1 1 )
  assertEquals 0 $?
  assertEquals " " "$retval"
}

test_string_substring_3params_0length() {
  local retval
  retval=$(string_substring "abc" 1 0 )
  assertEquals 0 $?
  assertEquals "" "$retval"
}

#
# string_rtrim
#

test_string_rtrim_0params() {
  local retval
  retval=$(string_rtrim 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_rtrim_2params_second_too_long() {
  local retval
  retval=$(string_rtrim "abc " "  " 2> /dev/null)
  assertEquals 2 $?
  assertEquals "abc " "$retval"
}

test_string_rtrim_1param() {
  local retval
  retval=$(string_rtrim "  abc   ")
  assertEquals 0 $?
  assertEquals "  abc" "$retval"
}

test_string_rtrim_1param_string_not_ending_with_space() {
  local retval
  retval=$(string_rtrim "  abc")
  assertEquals 0 $?
  assertEquals "  abc" "$retval"
}

test_string_rtrim_2params_space() {
  local retval
  retval=$(string_rtrim "   abc   " " ")
  assertEquals 0 $?
  assertEquals "   abc" "$retval"
}

test_string_rtrim_2params_notspace() {
  local retval
  retval=$(string_rtrim "abc   aaa" "a")
  assertEquals 0 $?
  assertEquals "abc   " "$retval"
}

test_string_rtrim_2params_notspace_notending() {
  local retval
  retval=$(string_rtrim "bb abc   aaa" "b")
  assertEquals 0 $?
  assertEquals "bb abc   aaa" "$retval"
}

test_string_rtrim_blank_str() {
  local retval
  retval=$(string_rtrim "" )
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_rtrim_spaces_str() {
  local retval
  retval=$(string_rtrim "   " )
  assertEquals 0 $?
  assertEquals "" "$retval"
}

#
# string_ltrim
#

test_string_ltrim_0params() {
  local retval
  retval=$(string_ltrim 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_ltrim_2params_second_too_long() {
  local retval
  retval=$(string_ltrim " abc " "  " 2> /dev/null)
  assertEquals 2 $?
  assertEquals " abc " "$retval"
}

test_string_ltrim_1param() {
  local retval
  retval=$(string_ltrim "   abc   ")
  assertEquals 0 $?
  assertEquals "abc   " "$retval"
}

test_string_ltrim_1param_string_not_starting_with_space() {
  local retval
  retval=$(string_ltrim "abc  ")
  assertEquals 0 $?
  assertEquals "abc  " "$retval"
}

test_string_ltrim_2params_space() {
  local retval
  retval=$(string_ltrim "   abc   " " ")
  assertEquals 0 $?
  assertEquals "abc   " "$retval"
}

test_string_ltrim_2params_notspace() {
  local retval
  retval=$(string_ltrim "aaa   abc   aaa" "a")
  assertEquals 0 $?
  assertEquals "   abc   aaa" "$retval"
}

test_string_ltrim_2params_notspace_notending() {
  local retval
  retval=$(string_ltrim "aaa abc  bbb" "b")
  assertEquals 0 $?
  assertEquals "aaa abc  bbb" "$retval"
}

test_string_ltrim_blank_str() {
  local retval
  retval=$(string_ltrim "" )
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_ltrim_spaces_str() {
  local retval
  retval=$(string_ltrim "   " )
  assertEquals 0 $?
  assertEquals "" "$retval"
}


#
# string_trim
#


test_string_trim_0params() {
  local retval
	  retval=$(string_trim 2> /dev/null)
  assertEquals 1 $?
  assertEquals "" "$retval"
}

test_string_trim_2params_second_too_long() {
  local retval
  retval=$(string_trim " abc " "  " 2> /dev/null)
  assertEquals 2 $?
  assertEquals " abc " "$retval"
}

test_string_trim_1param() {
  local retval
  retval=$(string_trim "   abc   ")
  assertEquals 0 $?
  assertEquals "abc" "$retval"
}

test_string_trim_1param_string_not_starting_with_space() {
  local retval
  retval=$(string_trim "abc   ")
  assertEquals 0 $?
  assertEquals "abc" "$retval"
}

test_string_trim_2params_space() {
  local retval
  retval=$(string_trim "   abc   " " ")
  assertEquals 0 $?
  assertEquals "abc" "$retval"
}

test_string_trim_2params_notspace() {
  local retval
  retval=$(string_trim "aaa   abc   aaa" "a")
  assertEquals 0 $?
  assertEquals "   abc   " "$retval"
}

test_string_trim_2params_notspace_notending() {
  local retval
  retval=$(string_trim "aaa abc  bbb" "b")
  assertEquals 0 $?
  assertEquals "aaa abc  " "$retval"
}

test_string_trim_blank_str() {
  local retval
  retval=$(string_trim "" )
  assertEquals 0 $?
  assertEquals "" "$retval"
}

test_string_trim_spaces_str() {
  local retval
  retval=$(string_trim "   " )
  assertEquals 0 $?
  assertEquals "" "$retval"
}



. ../lib/shunit2/source/2.1/src/shunit2
