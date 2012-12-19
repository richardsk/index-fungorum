ABOUT THIS SOFTWARE
===================

TapirDotNET is a data provider software compatible with the 
TAPIR protocol (http://www.tdwg.org/subgroups/tapir). 

"TAPIR specifies a standardised, stateless, HTTP transmittable, 
request and response protocol for accessing structured data that 
may be stored on any number of distributed databases of varied 
physical and logical structure."

Data provider software is one of the key components of TAPIR 
networks. All participants of a TAPIR network, ie. people or 
institutions that want to share data through TAPIR, need to 
install a data provider software. TapirDotNET allows data providers 
to map their local databases against one or more conceptual 
schemas (used as a data abstraction layer). It translates TAPIR 
search requests to the local query language and local database 
structure to return an XML response based on the output model 
requested.

ACKNOWLEDGEMENTS
================ 

TapirDotNET has been generously funded by the Biodiversity 
Information Standards, TDWG, with resources from the Gordon and 
Betty Moore Foundation. 

This software was ported from the TapirLink PHP provider implementation
for TAPIR, which was originally developed by Renato De Giovanni from CRIA.


NOTES
=====

A single instance of TapirDotNET can provide access to multiple 
TAPIR resources, each one with its own address. After 
installing this software and adjusting your web server 
configuration, you may be tempted to guess that the access 
point of your service is something like:

http://example.net/tapirdotnet/tapir.aspx

However, this will only give you generic documentation about 
the service. Real interaction with the service can only be 
done through one of the resources' access points. After 
configuring TapirDotNET, you will notice that each resource has 
a local id (or code). The local id must be appended to the 
previous URI to give you the corresponding address of the 
service, like: 

http://example.net/tapirdotnet/tapir.aspx/myres/

TapirDotNET can map conceptual schemas that either follow the 
DarwinCore pattern or the CNS configuration file pattern. In the
DarwinCore pattern, concepts are defined as global elements 
of an XML Schema document having a "substitutionGroup" attribute 
referencing dwe:dwElement (where "dwe" is a prefix for the 
namespace "http://rs.tdwg.org/dwc/dwelement"). Please note that 
this is NOT the original format of DarwinCore. It comes from 
a more recent version of the schema. 

TapirDotNET allows each resource to map one or more conceptual 
schemas, but it will only be able to serve instances of a single 
"class" or "entity". In other words, when mapping multiple 
conceptual schemas, each mapped concept will actually refer to an 
"attribute" or "property" of the same underlying class. In search 
responses, instances of that class will be bound to instances of 
the "indexingElement" defined in the output model.

This means that TapirDotNET has limited use with response structures 
that relate instances of different classes, for example multiple 
specimens, each one with multiple identifications. However, in 
these cases sometimes it is possible to use fixed value mappings,
especially when response structures include metadata elements 
(for example "collection code") enclosing all instances of a class.

FEATURES
========

* All TAPIR operations (metadata, capabilities, inventory, search
  and ping). 
* Request encoding can be KVP or XML.
* Inventories on any mapped concepts.
* Searches with any output models involving concepts from mapped 
  schemas.
* Response structures with basicSchemaLanguage.
* Several types of relational databases supported 
* Complete filter parsing. "Equals" and "like" can be case sensitive 
  or not.
* Max element repetitions and max element levels settings.
* Multiple resources can be exposed from a single TapirDotNET instance.
* Each resource can map one or more conceptual schemas based on the 
  new DarwinCore pattern or the CNS configuration file format.
* A simple client for testing.
* OAI-PMH message handling.

LIMITATIONS
===========

* Any XML Schema used as a response structure should not include or 
  import other schemas that redeclare the same prefix and associate
  it with a different namespace.

INSTALLATION
============

Please read the INSTALL.txt file for installation instructions.

TROUBLESHOOTING
===============

Try running in your browser the script tapirdotnetadmin/check.aspx to see if 
there are any problems with your installation.

When you are having problems, it is also be a good idea to activate 
debugging. To do this, set the _DEBUG setting to true in the tapirdotnet/web.config file. 

Restart your web server to clear any cache and settings.

As a last resource, instead of using:

http://somehost/somepath/tapir.aspx/someresource

You can define your accesspoint as:

http://somehost/somepath/tapir.aspx?dsa=someresource

