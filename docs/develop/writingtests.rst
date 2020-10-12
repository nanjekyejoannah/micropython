.. _writingtests:

Writing tests
=============

Tests in MicroPython are written in the path ``py/tests``:

.. code-block:: bash
   
   .
    ├── basics
    ├── cmdline
    ├── cpydiff
    ├── esp32
    ├── extmod
    ├── feature_check
    ├── float
    ├── import
    ├── inlineasm
    ├── internal_bench
    ├── io
    ├── jni
    ├── micropython
    ├── misc
    ├── multi_bluetooth
    ├── multi_net
    ├── net_hosted
    ├── net_inet
    ├── perf_bench
    ├── pyb
    ├── pybnative
    ├── qemu-arm
    ├── README
    ├── run-internalbench.py
    ├── run-multitests.py
    ├── run-natmodtests.py
    ├── run-perfbench.py
    ├── run-tests
    ├── run-tests-exp.py
    ├── run-tests-exp.sh
    ├── stress
    ├── thread
    ├── unicode
    ├── unix
    └── wipy

There are subfolders maintained to categorize most tests. Add a test by creating a new file in one of the
existing folders or in a new folder.

For example, add the following code in a file ``print.py`` in the unix subdirectory:

.. code-block:: python
   
   def print_one():
    print(1)
   
   print_one()

If you run your tests, this test should appear in the test output:

.. code-block:: bash
   
   $ cd ports/unix
   $ make tests
   skip  unix/extra_coverage.py
   pass  unix/ffi_callback.py
   pass  unix/ffi_float.py
   pass  unix/ffi_float2.py
   pass  unix/print.py
   pass  unix/time.py
   pass  unix/time2.py

If you create a test under a new subfolder, be sure to update the test script ``run-tests``.

Tests are run by comparing the output of a program by running it against the unix port and CPython.
So your "test" should use print statements to indicate test results.

For tests that can't be compared to CPython (i.e. micropython-specific functionality),
you can provide a ``.exp`` file.
