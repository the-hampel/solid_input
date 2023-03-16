#!/usr/bin/python
from triqs_dft_tools.converters import *
from h5 import *
from triqs.utility.h5diff import h5diff
import triqs.utility.mpi as mpi
from triqs_dft_tools.converters.wannier90 import Wannier90Converter
import sys

# if the w90 output is seedname_hr.dat, the input file for the converter must be called seedname.inp
if len(sys.argv) < 2:
    print ("Usage: pytriqs w90_convert.py <seedname> [<rot_mat_typ>]")
    quit()
mpi.report('Seedname:', str(sys.argv[1]))
arg1 = str(sys.argv[1])

# create the converter object
if len(sys.argv) == 3:
    arg2 = int(sys.argv[2])
    mpi.report('--- Using rotation matrix construction method n. ', str(arg2))
    Converter = Wannier90Converter(seedname=arg1,rot_mat_typ=arg2)
else:
    Converter = Wannier90Converter(seedname=arg1, rot_mat_type='hloc_diag', bloch_basis=False, w90zero=1e-5)
## perform the conversion
Converter.convert_dft_input()

