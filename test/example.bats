#!/usr/bin/env bats

load env
load shims/fin_jwt

fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin

@test "Tell Secret $JWT_SECRET" {
	fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin --save
	[ true ]
}
@test "addition using cd" {
  result="$(echo 2+2 | bc)"
  [ "$result" -eq 4 ]
}

@test "addition using dc" {
  result="$(echo 2 2+p | dc)"
  [ "$result" -eq 4 ]
}
