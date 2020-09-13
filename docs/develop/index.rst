MicroPython Internals
=====================

This chapter covers a tour of MicroPython from the perspective of a developer, contributing
to MicroPython. It acts as a comprehensive resource on the implementation details of MicroPython
for both novice and expert contributors.

Development around MicroPython usually involves modifying the core runtime, porting or 
maintaining a new library. This guide describes at great depth, the implementation
details of MicroPython including a getting started guide, compiler internals, porting
micropython to a new platform and implementing a new MicroPython library.

.. note::
   For a quick developer checklist on the basics of setting up and making a contribution,
   see the developer quick reference :ref:`developerreference`.

.. toctree::
   :maxdepth: 3

   gettingstarted.rst
   core.rst
   library.rst
   porting.rst

   extendingmicropython.rst
   devref.rst
