# DAMS Example

This is a startup set of commands to implement a simple DAMs example
for testing of the UC Davis Dams setup.  It includes a number of
features including:

- CAS Authentication
- User and Group based Authorizations
- Collection Examples

Make sure to check out the [FAQ](https://github.com/UCDavisLibrary/dams-example-repository/milestone/1), that documents some of the questions we've investigated about Fedora. Check both the open and closed issues there.

## Initialization

There is an initialization script `initialize`.  You probably just need to run `initialize` or maybe `initialize --fin='node /home/quinn/fin-cli/lib'` if you are not using an installed version of `fin`.
You can use `pod2text initialize` or read the script for more ways to run this command. 

# Using the Web interface.

Once the Example is initialized, you need to [login via CAS](https://cas.ucdavis.edu/cas/login?service=http%3A%2F%2Fdams-sandbox.library.ucdavis.edu%2Ffcrepo%2Frest&renew=false)
