# DAMS Example

This is a startup set of commands to implement a simple DAMs example
for testing of the UC Davis Dams setup.  It includes a number of
features including:

- CAS Authentication
- User and Group based Authorizations
- Collection Examples

Make sure to check out the [FAQ](https://github.com/UCDavisLibrary/dams-example-repository/milestone/1), that documents some of the questions we've investigated about Fedora. Check both the open and closed issues there.

## Initialization

## inf4 based initialization

The old script for interacting with the fedora repository is a shell
script included in this directory called inf4.  This script requires
the [httpie](https://httpie.org/) package to fetch URLs.  In addition,
you need JWT tokens for both an administrator and a user.


```bash
export INF4=~/dams-example-repository/inf4
export FEDORA_BASE=http://dams-sandbox.library.ucdavis.edu/fcrepo/rest

export ADMIN_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InF1aW5uIiwiYWRtaW4iOnRydWUsImlhdCI6MTUwNzc2NzQwMywiZXhwIjoxNTA4MjY4OTEzLCJpc3MiOiJsaWJyYXJ5LnVjZGF2aXMuZWR1In0.4jAof7Rr2CWYovLT56ocER88blvZjrtd1j-MsRFjfX4

export QUINN_JWT=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InF1aW5uIiwiaWF0IjoxNTA3NzY3NDAzLCJleHAiOjE1MDgyNjg5MTMsImlzcyI6ImxpYnJhcnkudWNkYXZpcy5lZHUifQ.wfU1vL-MvXydnwTi0D9hiX5jAGnE05T4g2Se9_zuw-Q

initialize_via_inf4.sh
```

``` bash
# This sets up your environment
alias inf4-admin="${INF4} --session=dams-admin"
alias inf4="${INF4} --session=dams"
# This adds your bearer token to the httpie --session=dams-admin
http --session=dams-admin GET ${FEDORA_BASE} "Authorization:Bearer ${ADMIN_JWT}"
http --session=dams GET ${FEDORA_BASE} "Authorization:Bearer ${QUINN_JWT}"

```

## node-fedora-cli based initialization

The newer method for interacting with the fedora repository is a node
application, *node-fedora-cli*.

# Using the Web interface.

Once the Example is initialized, you need to [login via CAS](https://cas.ucdavis.edu/cas/login?service=http%3A%2F%2Fdams-sandbox.library.ucdavis.edu%2Ffcrepo%2Frest&renew=false)
