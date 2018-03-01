<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#sec-1">1. Example 1 - Pets</a></li>
</ul>
</div>
</div>

# Example 1 - Pets<a id="sec-1" name="sec-1"></a>

This example collection is something like the most basic type of collection that
can be added into the system.  This example contains a simple set of digital
images, with a small amount of data about the pets.  Our goal is to take these
data and add them into our DAMs.

Let&rsquo;s start with the collection description.  That&rsquo;s stored in the \`index.ttl\`
file.

    @prefix : <http://schema.org/> .
    @prefix rdf:  <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
    @prefix ldp:  <http://www.w3.org/ns/ldp#> .

    <>
      a ldp:BasicContainer, :Collection;
      :title "Collaborator Pets";
      :keywords "Pets", "Cats", "Dogs";
      :license <http://rightsstatements.org/vocab/InC-NC/1.0/>;
      :creator "Quinn Hart";
      :datePublished "2018" ;
      :description "This collection includes pictures of pets that are owned by our collaborators.  This is meant to be something of the most basic collection that can be added as a DAMs.".

    ls
