# Fin Example Repositories

This project contains a set of example repositories for the
[fin-server](https://github.com/UCDavisLibrary/fin-server), extended Fedora
Linked Data platform [Fedora-LDP](https://fedora.info/spec/).

Included are a number of different example repositories that illustrate various
aspects of the server, and it's associated services.  These include different
organizations of data, and methods for import.

Following the steps below, you should be able to get your own server, up and
running relatively quickly.  From there, you can investigate some of the example
repository data.

Currently, we assume some knowledge of what an LDP is, what linked data means,
and how linked metadata is created and maintained. We also assume you have some
familiarity with linked data turtle and json-ld formats.  We are looking to
expand the tutorial material in those areas.

# Installation

The first step is to get your example server up and running. This setup uses
docker and a suite of docker containers to run the system.  After installation
you will have an test server up and running, and ready to add collections.

## Prerequisites

First, we'll need to clone this repository. This is a good way to get your
example data downloaded, and it is also a good starting point to fork this
repository, later when you want to save site specific preferences. So, we'll
need have have `git` on your development machine. If you're new to git, you my
follow the installation instructions in this [GIT Book](https://git-scm.com/),
or perhaps try github's [desktop](https://desktop.github.com/) application if
you are using windows. The examples below, will use `git`'s command line
features.

The server is implemented as suite of docker containers, so in order to run this
example, you need to have `docker` and `docker-compose` installed on our system.
Follow the [installation notes](https://docs.docker.com/compose/install/) from
docker, if you are new to docker.  **Note**, if you are new to docker,
understand that you will need to learn about this system.  Some of the example
configuration below, will be unclear, and it will be difficult to modify the
examples below for your setup unless  you understand this environment.

## Configuration

The first step is to clone the repository, using:
```bash
git clone https://github.com/UCDavisLibrary/fin-example-repository.git
cd fin-example-repository          # change directory to your cloned location
```

This will create a local copy of some example data and configurations for
testing the server. Looking around these files, you'll see some configuration
files, some data and some metadata files mostly located within the collection
directory

The first thing we need to do is setup some environment variables for our first
setup. Look at the `fin-example.env` file. The file will look something like the file
below:

```bash
# server.env
FIN_URL=http://localhost:3000
FIN_ALLOW_ORIGINS=mylibrary.org,localhost
JWT_SECRET=lax
JWT_ISSUER=mylibrary.org
JWT_TTL=36000
JWT_VERBOSE=1
```

- `FIN_URL`  describes where the server will start.  By default we'll start it
   on a localhost with a development port.  If would like to see your server
   from other locations, modify this to a publicly accessible location.  See the
   section below for running on default ports.

- `FIN_ALLOW_ORIGINS` describes what domains can access your system.

- `JWT_SECRET` is a secret used between servers to verify authentication. The
  `JWT_SECRET` is used to sign jwt tokens. Computers with this secret can
  very easily create tokens that would be accepted by the system, so it's **very
  important** to protect this secret in production environments.

- `JWT_ISSUER` describes the service that issued the jwt token. While, it is checked by
  the servers, is not a source of security.

If you are happy with this configuration, let's go ahead and startup you system.
We are using docker-compose to startup the services described in our `fin.yml`
file.

``` bash
docker-compose up -f fin-example.yml -d
```

*Docker pros will notice we are avoiding using the standard location for the
`docker-compose.yml` file, and in addition we explicitly identify the
environment file in our setup. This is just to make it more clear what files are
being used.*

##

## Initialization

There is an initialization script `initialize`.  You probably just need to run `initialize` or maybe `initialize --fin='node /home/quinn/fin-cli/lib'` if you are not using an installed version of `fin`.
You can use `pod2text initialize` or read the script for more ways to run this command.

# Using the Web interface.

Once the Example is initialized, you need to [login via CAS](https://cas.ucdavis.edu/cas/login?service=http%3A%2F%2Fdams-sandbox.library.ucdavis.edu%2Ffcrepo%2Frest&renew=false)

# Advanced Configuration

## Running the server on default ports

If you want to run this on the default port, the user running this example will
need permission to connect to that protected port. In our setup, we often have
multiple domains running on the same machine, and we use apache to map to this
setup. This allows you to run the server as a normal user.  Additionally, our
service does not directly support SSL, so you will need to do something similar
to this setup when you move to a production setup.

``` xml
<VirtualHost *:80>
  ServerName dams.mylibrary.org
  ServerAdmin admin@mylibrary.org
  RewriteEngine on
  RewriteRule ^ https://%{SERVER_NAME}%{REQUEST_URI} [END,QSA,R=permanent]
</VirtualHost>

<IfModule mod_ssl.c>
 <VirtualHost *:443>
        ServerName dams.mylibrary.org
        SSLEngine on

        Header set Access-Control-Allow-Origin "*"
#        SSLCertificateFile      /etc/ssl/certs/__name__.cer
#       SSLCertificateKeyFile /etc/ssl/private/__name__.key

       # Required for RIIIF pathnames
       AllowEncodedSlashes On
       ProxyPreserveHost On
       ProxyPass / http://localhost:3000/ nocanon
       ProxyPassReverse / http://localhost:3000/ nocanon
</VirtualHost>
</IfModule>
```
