.. _developerreference:

Developer Reference
===================

For a detailed getting started guide, see :ref:`gettingstarted`.
This a compressed quick developer checklist on the basics of setting up
and making a contribution.

#. Clone the source code:

.. code-block:: console

   $ git clone https://github.com/micropython/micropython.git 
   $ cd micropython

#. Build mpy-cross:

.. code-block:: console

   $ cd mpy-cross
   $ make

#. Build MicroPython for the unix port:

.. code-block:: console

   $ cd ports/unix
   $ make submodules
   $ make

#. Run MicroPython:

.. code-block:: console

   $ ./micropython

On windows use ``wine`` and replace ``./micropython`` with ``wineconsole --backend=curses ./micropython.exe``.

#. Run the testsuite:

.. code-block:: console

   $ make test

#. Build the Docs:

.. code-block:: console

   $ cd docs
   $ make html



