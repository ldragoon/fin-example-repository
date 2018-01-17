#!/usr/bin/env bats


@test "Test JSONLD" {
	run jsonld frame --omit-default=true --frame=eastman_frame.json B-10004.json
}

@test "Missing Frame" {
	run jsonld frame --frame=foo.json B-10004.json
}
