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

General Project Quick References
--------------------------------

Here are some links to references you will find useful.

+ `The MicroPython Repository <https://github.com/micropython/micropython>`_.
+ `Open Issues <https://github.com/micropython/micropython/issues>`_.
+ `Developer Forum <https://forum.micropython.org/>`_.
+ `The Wiki <https://github.com/micropython/micropython/wiki>`_.

Development Links
-----------------

The various delopment related links:

+ `MicroPython Internals <http://docs.micropython.org/en/latest/develop/index.html>`_.
+ `Code conventions <https://github.com/micropython/micropython/blob/master/CODECONVENTIONS.md>`_.
+ `Contributor guidelines <https://github.com/micropython/micropython/wiki/ContributorGuidelines>`_.
+ `Development Workflow <https://github.com/micropython/micropython/wiki/DevelWorkflow>`_.
+ `Code Stats <http://micropython.org/resources/code-dashboard/>`_.
+ `ARM Toolchain <https://github.com/micropython/micropython/wiki/Getting-Started-STM>`_.
+ More Architecture <https://github.com/micropython/micropython/wiki/CrossBranch>`_.
