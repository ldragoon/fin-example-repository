#!/usr/bin/env bash

secret='SOME SECRET'

json() {
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | jq -c .
}

base64_encode()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl enc -base64 -A
}

hmacsha256_sign()
{
	declare input=${1:-$(</dev/stdin)}
	printf '%s' "${input}" | openssl dgst -binary -sha256 -hmac "${secret}"
}

get_header() {
    # Static header fields.
    header='{
	"typ": "JWT",
	"alg": "HS256",
	"kid": "0001",
	"iss": "fin-cli shim"
}'
    
    # Use jq to set the dynamic `iat` and `exp`
    # fields on the header using the current time.
    # `iat` is set to now, and `exp` is now + 1 second.
    header=$(
	echo "${header}" | jq --arg time_str "$(date +%s)" \
			      '
	($time_str | tonumber) as $time_num
	| .iat=$time_num
	| .exp=($time_num + 1)
	'
	  )
    return $header;
}

payload='{
	"Id": 1,
	"Name": "Hello, world!"
}'


: <<=cut
=pod

=head1  NAME

  fin_login - Shim for the missing fin login parameters.  It can also be used to create local jwt tokens.

=head1 USAGE

fin_login --SECRET=<jwtsecrect> --user=username --admin --agent=agent

or

fin_jwt --SECRET=<jwtsecrect> --user=username --admin --agent=agent


=head1 OPTIONS

=over 4	

=item B<--SECRET=>I<serversecret>
 This is B<NOT> part of the real setup.  If passed, this will create a local jwt token with the passed parameters. 

=item B<--user=>I<username>
 This is the user logging logging into the server.  

=item B<--agent=>I<agent> default I<--user> value

This defines the agent to be used.  If the user logging in, has administrative privlidges, then they may specify a different agent to
be defined in the returning JWT token.

=item B<--admin>
If the user has admin privledges, they can specify a token with admin privledges as well. You cannot use the I<admin> and I<agent> tokens together.

=back
=cut

function fin_login() {
    OPTS=`getopt --long SECRET:,user:,agent:,admin -n 'login [options]' -- login "$@"` 
    if [ $? != 0 ] ; then echo "Bad login options." >&2 ; exit 1 ; fi
    eval set -- "$OPTS"
    local SECRET=
    local user="foaf:Agent"
    local agent=
    local admin=0

    while true; do
    	case $1 in
        --SECRET) SECRET=$2; shift 2;;
	--user) user=$2; shift 2;;
	--agent) agent=$2; shift 2;;
	--admin) admin=1; shift;
        *) break;;
    	esac
    done
    shift;

}

header_base64=$(get_header | json | base64_encode)
payload_base64=$(get_user | json | base64_encode)

header_payload=$(echo "${header_base64}.${payload_base64}")
signature=$(echo "${header_payload}" | hmacsha256_sign | base64_encode)

echo "${header_payload}.${signature}"
