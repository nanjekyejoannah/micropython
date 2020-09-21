.. _gettingstarted:

Getting Started
===============

This guide covers a step by step process on setting up version control, obtaining and building
a copy of the source code for a port, building the Docs, running tests and a description of the 
directory structure of the MicroPython code base.

.. note::
   For a quick developer checklist on the basics of setting up and making a contribution,
   see the developer quick reference :ref:`developerreference`.

Source control with git
-----------------------

MicroPython is hosted on GitHub and uses ``git`` for source control. The workflow is such that
code is pulled and pushed to and from the main repository. Install the respective version of ``Git`` for 
your operating system to follow through the rest of the steps.

.. note::
   For a reference on the installation instructions, please refer to 
   the `Git installation instructions <https://git-scm.com/book/en/v2/Getting-Started-Installing-Git>`_.
   Learn about the basic git commands in this `Git Handbook <https://guides.github.com/introduction/git-handbook/>`_
   or any other sources on the internet.

Get the code
----------------

It is recommended that you maintain a fork of the MicroPython repository for your development purposes.
The process of obtaining the source code includes the following:

#. Fork the repository https://github.com/micropython/micropython.git
#. You will now have a fork at <https://github.com/<yourusername>/micropython.git>.
#. Clone the repository. You may clone either your fork or the main MicroPython repository.
   Use one of the commands below:

.. code-block:: console

   $ git clone https://github.com/micropython/micropython.git 
   $ git clone https://github.com/<yourusername>/micropython.git

Depending on what you cloned, do the necessary configuration.

Configure upstream if you cloned your fork.

.. code-block:: console

   $ cd micropython
   $ git remote add upstream https://github.com/micropython/micropython.git

It is common to configure ``upstream`` and ``origin`` on a forked repository to assist with sharing code changes. You can maintain your
own mapping but it is recommended that origin maps to your fork and upstream to the main
MicroPython repository:

.. code-block:: console

   $ cd micropython
   $ git remote add upstream https://github.com/micropython/micropython.git
   $ git remote set-url origin https://github.com/<yourusername>/micropython.git

After the above configuration, your setup should be similar to this:

.. code-block:: console

   origin	https://github.com/<yourusername>/micropython.git (fetch)
   origin	https://github.com/<yourusername>/micropython.git (push)
   upstream	https://github.com/micropython/micropython.git (fetch)
   upstream	https://github.com/micropython/micropython.git (push)

You should now have a copy of the source code. By default you are pointing
to the master branch. To get ready for further development, it is recommended
to work on a development branch.

.. code-block:: console

    $ git checkout -b dev-branch

You can give it any name. You will have to compile MicroPython whenever you change 
to a different branch.

Build the Code
--------------

For development, you should compile MicroPython for a specific platform which corresponds
to a port. Before any building for a port, first build the MicroPython cross-compiler.
Install the required dependencies for the port in order to sucessfully
compile and build.

Build the cross-compiler
~~~~~~~~~~~~~~~~~~~~~~~~

Almost all ports require building ``mpy-cross`` first to perform pre-compilation
of scripts that will be included in the port firmware:

.. code-block:: console

   $ cd mpy-cross
   $ make

If ``mpy-cross`` built successfully, you should see a message similar to this:

.. code-block:: console

   LINK mpy-cross
      text	   data	    bss	    dec	    hex	filename
    279328	    776	    880	 280984	  44998	mpy-cross

The unix port
~~~~~~~~~~~~~
To build for the unix port, make sure you have a working environment for ``gcc`` and ``GNU make``.
All Unixes come with ``gcc`` installed. Confirm if unsure:

.. code-block:: console

   $ gcc --version
   gcc (Ubuntu 5.4.0-6ubuntu1~16.04.12) 5.4.0 20160609
   Copyright (C) 2015 Free Software Foundation, Inc.
   This is free software; see the source for copying conditions.  There is NO
   warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Install the required dependencies:

.. code-block:: console

   $ sudo apt-get install build-essential libreadline-dev libffi-dev git \\
   pkg-config gcc-arm-none-eabi libnewlib-arm-none-eabi

Then build:

.. code-block:: console

   $ cd ports/unix
   $ make submodules
   $ make

If MicroPython built correctly, you should see the following:

.. code-block:: console

   LINK micropython
      text	   data	    bss	    dec	    hex	filename
    412033	   5680	   2496	 420209	  66971	micropython

Now run it:

.. code-block:: console

   $ ./micropython
   MicroPython v1.13-38-gc67012d-dirty on 2020-09-13; linux version
   Use Ctrl-D to exit, Ctrl-E for paste mode
   >>> print("hello world")
   hello world
   >>>

The stm32 port
~~~~~~~~~~~~~~

Like the unix port, you need to install some required dependencies.
The ARM compiler is required:

.. code-block:: console

   $ sudo apt-get install arm-none-eabi-gcc arm-none-eabi-binutils arm-none-eabi-newlib

Build:

.. code-block:: console

   $ cd ports/stm32
   $ make submodules
   $ make

Please refer to the `stm32 documentation <https://github.com/micropython/micropython/tree/master/ports/stm32>`_ 
for more details on flashing the firmare.

The windows port
~~~~~~~~~~~~~~~~

The windows port is experimental and based on the unix port. Build on 
debian/linux systems using the following commands:

.. code-block:: console

   $ cd ports/windows
   $ sudo apt-get install gcc-mingw-w64
   $ make CROSS_COMPILE=i686-w64-mingw32-

Then run easily with ``wine``:

.. code-block:: console

   $ wineconsole --backend=curses ./micropython.exe

Refer to the `windows port documentation <https://github.com/micropython/micropython/tree/master/ports/windows>`_
on more details on building using Cygwin and MS visual Studio 2013 or higher.

Build the Docs
--------------

MicroPython Documentation is created using ``Sphinx``. If you have already
installed Python, then install ``Sphinx`` using ``pip``:

.. code-block:: console

   $ pip install sphinx

Navigate to the docs directory:

.. code-block:: console

   $ cd docs

Buld the docs:

.. code-block:: console

   $ make html

Open ``docs/build/html/index.html`` in your browser to view the docs locally. Refer to the 
documentation on `importing your documentation to use Read the Docs
<https://docs.readthedocs.io/en/stable/intro/import-guide.html>`_.

Run the tests
-------------

To run all tests in the testsuite, use make:

.. code-block:: console

   $ make test

.. warning::
   Make sure you are in the port directory where MicroPython was built before running the tests. 
   Running outside your port will not work.

Folder structure
----------------

There are a couple of directories to take note of in terms of where certain implementation details
are. The following is a break down of the top-level folders in the source code.

``py``

Contains the the compiler, runtime and core library implementation.

``mpy-cross``

Has the MicroPython cross-compiler which pre-compiles the Python scripts to bytecode.

``ports``

Code for all the versions of MicroPython for the supported ports.

``lib``

Low-level C libraries used by any port.

``drivers``

Has drivers for specific hardware and intended to work across multiple ports.

``extmod``

Contains a C implementation of more non-core modules.

``docs``

Has the standard documentation found at https://docs.micropython.org/.

``tests``

An implementation of the test suite.

``tools``

Contains helper tools including the ``upip`` and the ``pyboard.py`` module.

``examples``

Example Python scripts.
