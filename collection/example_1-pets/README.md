
# Table of Contents

1.  [Example 1 - Collaborator Pets](#org3b88d60)
    1.  [Administrative Privleges](#org60204d2)
    2.  [Make a new Collection](#org6d36858)
    3.  [Collection Access Control](#org408206d)
    4.  [Add Example Data](#org55dd180)
2.  [Graphs](#orged33566)
3.  [Amended metadata representation](#orgce071b5)

:header-args:    :exports both :eval no-export :cache yes


<a id="org3b88d60"></a>

# Example 1 - Collaborator Pets

Our collaborator pets collection is the most basic type of collection that can
be added into the DAMS. This example contains a simple set of digital images
with a small amount of data about the pets. Each pet, eg. [ashley.jpg](./ashley.jpg) is included
in their own image file, and each image file has some associated metadata in a
`.ttl` sidecar, eg. [ashley.jpeg.ttl](./ashley.jpeg.ttl). The metadata is in `text/turtle` format.
The [index.ttl](./index.ttl) file includes information about the collection as a whole.
Finally, we have an additional [graph.hdt](./graph.hdt) file is explained in more detail below.

This collection can all be created with the [import.sh](./import.sh) script, and we will be
going through that script line-by-line to describe the general steps for
creating new collections.


<a id="org60204d2"></a>

## Administrative Privleges

If you have gone through the installation steps, this is good place to come as
your next step.  The steps below assume that you are currently logged in to your
fin server, as an admin.  How to do this is explained in the installation
instructions.  You can verify this with the following command, which access the
root location, and verifies you can write to this location.

    fin http get -P b / | grep fedora:writable


<a id="org6d36858"></a>

## Make a new Collection

Let&rsquo;s start with the collection description.  That&rsquo;s stored in the \`index.ttl\`
file.  This file describes the collection. \`index.ttl\` is a pretty easy file to
understand, you&rsquo;ll see a title, and description and some keywords.  If you&rsquo;re
savy with your linked data, you will see that by default we like to use
schema.org for our descriptions.  This is not a requirement for the server, but
lots of the DAMS setup expects to use this schema when indexing collections and
data.

    @prefix schema: <http://schema.org/> .
    @prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix ldp:  <http://www.w3.org/ns/ldp#> .

    <>
      a ldp:BasicContainer, schema:Collection;
      schema:name "Collaborator Pets";
      schema:keywords "Pets", "Cats", "Dogs";
      schema:license <http://rightsstatements.org/vocab/InC-NC/1.0/>;
      schema:creator "Quinn Hart";
      schema:datePublished "2018"^^<http://www.w3.org/2001/XMLSchema#date>  ;
      schema:description "This collection includes pictures of pets that are owned by our collaborators.  This is meant to be something of the most basic collection that can be added as a DAMs." ;
      schema:identifier "ark:/pets/awesome".

fin has some special commands to create and administrate collections.  Let&rsquo;s
go ahead and create our new collection.

    fin collection create example_1-pets index.ttl

    New collection created at: /collection/example_1-pets

This command creates a new container in our system, for the new collection, but
it does more than that. It sets up some default access control conditions, and
organizes standard locations for things like groups for this collection. Also,
with the addition of the metadata in our index.ttl file, it also describes the
contents of this collection, which is then used in the default Interface for the
repository. After this step, you should be able to navigate to
<http://localhost:3000/fcrepo/rest/collection>, and see your newly created
example<sub>1</sub>-pets collection. You may need to login to your account via
<http://localhost:3000/auth/basic/login.html> to give your browser access.


<a id="org408206d"></a>

## Collection Access Control

By default new collections are not publicly available.  Let&rsquo;s make this
available for anyone.

    fin collection acl user add example_1-pets foaf:Agent r


<a id="org55dd180"></a>

## Add Example Data

Now we want to add some additional

![img](diagram.png)


<a id="orged33566"></a>

# Graphs

One problem that is currently not completely solved


<a id="orgce071b5"></a>

# Amended metadata representation
