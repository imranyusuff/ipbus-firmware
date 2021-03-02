#!/usr/bin/python
from __future__ import print_function, absolute_import

import uhal
import time
import sys
import random

N = 1024

testdata = random.sample(xrange(0x100000000), N)

# uhal.setLogLevelTo(uhal.LogLevel.ERROR)
hw = uhal.getDevice("sim", "ipbusudp-2.0://127.0.0.1:50001", "file://ipbus_example.xml")

print ("Reading RAM")
v = hw.getNode("ram").readBlock(N)
hw.dispatch()

print ("Writing RAM")
hw.getNode("ram").writeBlock(testdata)
hw.dispatch()

print ("Reading RAM")
v = hw.getNode("ram").readBlock(N)
hw.dispatch()

gotErr = False

for i in xrange(N):
  if v[i] != testdata[i]:
    print ("!!! ERROR IN READBACK !!! i =", i, "  v =", v[i], "  testdata =", testdata[i])
    gotErr = True

if gotErr:
  print ("Done with error.")
  sys.exit(1)

print ("Done.")
