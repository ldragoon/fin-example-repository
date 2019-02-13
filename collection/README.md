# Example Collections

Our example collections are included to illustrate various aspects of how we
organize data in the DAMS and methods we use to add data into the DAMS.  Each
collection will include some information about what particular aspects of the
DAMS are being represented for that example.  In addition, each collection
includes sample data and an installation script.

Please note that every script will require the FIN Command Line Interface
[fin-cli]. Although lots of interaction with the [Fedora-LDP] can be performed
directly with a standard HTTP client, the [fin-cli] simplifies many components;
in particular authorization, access control, and some more complicated container
creation.  The [fin-cli] is a node-js component and can be installed on most
operating systems with the command: `npm install @ucd-lib/fin-cli` or `sudo npm
install -g @ucd-lib/fin-cli` to install system-wide.

In addition to the organization, we also use these examples to illustrate
various ervices that are available through our DAMS.

These collection describe the standards we use in how data should be added to
the system. Each individual collection has it's own README that documents some
of the features of our DAMS. There are a few examples that should probably be
done in order, [Pets] and [Photos]. After that, the examples can be looked at in
pretty much any order.


- [Pets] This is the first, most simple example of using the LDP. It introduces
  [schema.org](https://schema.org), and how we use that to define our
  collections and items. The items in our pets collection are born digital which
  simplifies some of organization of the data files. We also introduce a lot of
  the concepts that we use for all collections.

- [Photos] This collection shows how physical items should be documented. This
  shows the layout for adding associated Digital data (in this case images) for
  the physical items.



[Pets]:collection/example_1-pets
[Photos]:collection/example_2-photos
[fin-cli]:https://github.com/UCDavisLibrary/fin-cli
[Fedora-LDP](https://fedora.info/spec/).
