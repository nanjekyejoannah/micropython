.. _optimizations:

Optimizations
=============

MicroPython uses several optimizations to save RAM but also ensure the efficient
execution of programs. This chapter discusses some of these optimizations.

.. note::
   :ref:`qstr` and :ref:`maps` details other optimizations on strings and 
   dictionaries.


Frozen bytecode
----------------

When MicroPython loads Python code from the filesystem, it first has to parse the file into
a temporary in-memory representation, and then generate bytecode for execution, both of which
are stored in the heap (in RAM). This can lead to significant amounts of memory being used.
:ref:`The MicroPython cross compiler <glossary>` can be used to generate
a ``.mpy`` file, containing the pre-compiled bytecode for a Python module. This will still
be loaded into RAM, but it avoids the additional overhead of the parsing stage.

As a further optimisation, the pre-compiled bytecode from a ``.mpy`` file can be "frozen"
into the firmware image as part of the main firmware compilation process, which means that
the bytecode will be executed from ROM. This can lead to a significant memory saving, and
reduce heap fragmentation.

Variables
----------

MicroPython processes local and global variables differently. Global variables
are stored and looked up from a global dictionary that is allocated on the heap.
Local variables on the other hand are stored on the stack which makes their access
more efficient.

The length of global variable names also affects how much RAM is used as identifiers
are stored in RAM. The shorter the identifier, the less memory is used.

The other aspect is, ``const`` variables that start with an underscore are treated as
constants and are not allocated or added in a dictionary hence saving some memory. These
variables use ``const()`` from the MicroPython library. Therefore:

.. code-block:: python

    X = const(1)
    _Y  = const(2)
    foo(X, _Y)

Compiles to:

.. code-block:: python

    X = 1
    foo(1, 2)

Allocation of memory
--------------------

Most of the common MicroPython constructs are not allocated on in RAM/heap
however, the following are:

- Data structures like lists, mappings, etc
- Functions and classes
- imports and
- First-time assignment of global variables

For a detailed discussion on a more user-centric perspective on optimization,
see `Maximising MicroPython speed <https://docs.micropython.org/en/latest/reference/speed_python.html/>`_
