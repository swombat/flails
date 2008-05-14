Flails - a ruby on rails + flex framework
==========================================

Authors: Daniel Tenner (daniel.flails at tenner dot org), Cliff Rowley (cliffrowley at gmail dot com)

Note: Flails is still in its infancy, badly documented, potentially broken, etc. Feel
free to download it and use it. It is still roughly in line with the RubyAMF conventions.
However, it may well be a waste of your time at this point in time.

Credits:
----------
Many thanks to Aaron Smith for releasing RubyAMF. Despite any flaws it may have, it has been
a tremendously useful library and if made many things possible.

Many thanks also to the PyAMF team, for writing the PyAMF serialisation code in such a clear 
manner. It is effectively our reference implementation in rewriting the RubyAMF serialiser 
and deserialiser. Particular thanks to Nick Joyce for being so helpful in explaining the
more obscure aspects of AMF encoding and decoding. There are probably less than a dozen
people in the whole world who know as much as him about implementing an AMF protocol, and
his help is *invaluable*.

Many thanks to Karl von Randow of XK72.com for generously contributing a licence for "Charles" 
to Flails. Charles is an HTTP proxy/monitor/reverse proxy, that we are using to debug AMF 
calls. Charles can be found at http://www.xk72.com/charles/

Many thanks to Woobius for allowing us to open this piece of code.

Finally, many thanks to anyone else who has supported or helped us in any way.

Overview:
==========

Flails Objectives / Target Feature Set:
-------------------
There are a certain number of features that we will definitely extract from Woobius into Flex.
Among those, in no particular order:

* Generation of Rails-side mappings from a simple YAML file to minimise manual configuration
* Generation of the Flex-side ValueObject classes from the same file
* API controller framework to provide useful functionality for any similar API
* Access control framework baked into the api controller
* Model updates/refreshing
* Specification of the depth of rendering for objects which contain other objects

Most of those features already exist within the Woobius codebase and will be extracted into
Flails as soon as possible.

Flails Principles:
-------------------

In order for this project to go somewhere, some principles need to be set down. Taking
some cue from Rails, we propose the following guiding principles.

**Flails is opinionated software.** It's extracted from our work on Woobius and functionality
will be driven by real needs of real applications, and thus will aim to do a few useful
things right rather than do everything.

**Flails aims to build a specific kind of Flex/Rails API.** We are not interested in the WebORB 
style of exposing Ruby objects to Flex. A good API should be openable, and to do so effectively,
it should not be entirely dependent on a proprietary technology like AMF. Flails allows
developers to develop an API that can then be exposed through various methods. Currently
supported are: XML, JSON, and, of course, AMF. This will drive some of the design decisions,
such as how to translate parameters from Flex to Rails.

**Flails will maintain a complete suite of specs.** We will use the RSpec framework for this purpose.
Once the initial RubyAMF import is specced, there will be no code added without a corresponding
specification.

History:
----------

Before Flails there was RubyAMF. Then, there were all sorts of add-ons to RubyAMF. 
Then there were many hacks in the RubyAMF code. As those hacks were written, there
was frustration at RubyAMF's rather loose interpretation of the AMF3 protocol.
From the frustration grew a desire to redo various bits of RubyAMF.

At the same time, there was an application, Woobius, which was using all this code
and doing some great things with it. There were many bits of functionality that
could really be reused by almost anyone trying to quickly build a Flex application
backed by Rails.

Then, in one day of in-depth hacking into RubyAMF, the decision was born to fork from
RubyAMF. This was made all the more worthwhile by the many add-ons that could, hopefully, 
now be built in once they were extracted from Woobius.

A quick search on the net revealed that the name Flails was not used by any OS project,
nor was flails.org registered.

And so Flails was born.

Daniel Tenner - 24 April 2008

How to contribute:
-------------------
We're still working out how to accept patches. Feel free to send them, though, and we'll do
our best to include them. You can find us on #flails on irc.freenode.net.