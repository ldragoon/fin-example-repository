#! /usr/bin/env bash
as() {
	if [[ "$1" = "admin" ]]; then
		fin_jwt --user=quinn --SECRET=$JWT_SECRET --admin --save
	else
		fin_jwt --user=$1 --SECRET=$JWT_SECRET --save
	fi;
}
