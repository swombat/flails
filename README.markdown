Flails - a ruby on rails + flex framework
==========================================

Authors: Daniel Tenner (daniel.flails at tenner dot org), Cliff Rowley

Note: Flails is still in its infancy, badly documented, etc. Use at your own risk.

Flails is based on RubyAMF, by Aaron Smith (http://www.rubyamf.org).

Overview:
==========

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

How to contribute:
-------------------
We're still working out how to accept patches. Feel free to send them, though, and we'll do
our best to include them.

Credits:
----------
Many thanks to Aaron Smith for releasing RubyAMF. Despite any flaws it may have, it has been
a tremendously useful library and if made many things possible.

Many thanks also to the PyAMF team, particularly njoyce, for writing the PyAMF serialisation
code in such a clear manner. It is effectively our reference implementation in rewriting
the RubyAMF serialiser and deserialiser.

Many thanks to Woobius for allowing us to open this piece of code.

Finally, many thanks to anyone else who has supported or helped us in any way.