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

Backwards Compatibility
=======================

The stated goal of this module is to be a drop-in replacement for ``re``. 
My hope is that some will be able to go to the top of their module and put::

    try:
        import re2 as re
    except ImportError:
        import re

That being said, there are features of the ``re`` module that this module may
never have. For example, ``RE2`` does not handle lookahead assertions (``(?=...)``).
For this reason, the module will automatically fall back to the original ``re`` module
if there is a regex that it cannot handle.

However, there are times when you may want to be notified of a failover. For this reason,
I'm adding the single function ``set_fallback_notification`` to the module.
Thus, you can write::

    try:
        import re2 as re
    except ImportError:
        import re
    else:
	re.set_fallback_notification(re.FALLBACK_WARNING)

And in the above example, ``set_fallback_notification`` can handle 3 values:
``re.FALLBACK_QUIETLY`` (default), ``re.FALLBACK_WARNING`` (raises a warning), and
``re.FALLBACK_EXCEPTION`` (which raises an exception).


Performance
===========

More details to come. Performed well on shootout with all regex engines. I will have
a detailed analysis of features versus python's ``re`` soon.

If you do use this module, you *should* pre-compile your regex's. This module does
not contain a regex cache.


Current Status
==============

pyre2 has only received basic testing. Please use it
and let me know if you run into any issues!

Contact
=======

You can file bug reports on GitHub, or contact the author:
`Mike Axiak  contact page <http://mike.axiak.net/contact>`_.

Tests
=====

If you would like to help, one thing that would be very useful
is writing comprehensive tests for this. It's actually really easy:

* Come up with regular expression problems using the regular python 're' module.
* Write a session in python traceback format `Example <http://github.com/axiak/pyre2/blob/master/tests/search.txt>`_.
* Replace your ``import re`` with ``import re2 as re``.
* Save it as a .txt file in the tests directory. You can comment on it however you like and indent the code with 4 spaces.

Missing Features
================

Currently the features missing are:

* If you use substitution methods without a callback, a non 0/1 maxsplit argument is not supported.
* No compile cache.
  (If you care enough about performance to use RE2,
  you probably care enough to cache your own patterns.)


Credits
=======

Though I ripped out the code, I'd like to thank David Reiss
and Facebook for the initial inspiration. Plus, I got to
gut this readme file!

Moreover, this library would of course not be possible if not for
the immense work of the team at RE2 and the few people who work
on Cython.
