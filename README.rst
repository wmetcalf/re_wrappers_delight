=====
pyre2
=====

.. contents::

Summary
=======

pyre2 is a Python extension that wraps
`Google's RE2 regular expression library
<http://code.google.com/p/re2/>`_.

This version of pyre2 is similar to the one you'd
find at `facebook's github repository <http://github.com/facebook/pyre2/>`_
except that the stated goal of this version is to be a *drop-in replacement* for
the ``re`` module.

Missing Features
================

Currently the features missing are:
* No substitution methods.
* No ``split``, ``findall``, or ``finditer``.
* No compile cache.
  (If you care enough about performance to use RE2,
  you probably care enough to cache your own patterns.)


Current Status
==============

pyre2 has only received basic testing. Please use it
and let me know if you run into any issues!

Contact
=======

You can file bug reports on GitHub, or email the author:
Mike Axiak <mike@axiak.net>

Tests
=====

If you would like to help, one thing that would be very useful
is writing comprehensive tests for this. It's actually really easy:
* Come up with regular expression problems using the regular python 're' module.
* Write a session in python traceback format `Example <http://github.com/axiak/pyre2/blob/master/tests/search.txt>`_.
* Replace your ``import re`` with ``import re2 as re``.
* Save it as a .txt file in the tests directory. You can comment on it however you like and indent the code with 4 spaces.

Contributions
=============

Though I ripped out the code, I'd like to thank David Reiss
and Facebook for the initial inspiration. Plus, I got to
gut this readme file!