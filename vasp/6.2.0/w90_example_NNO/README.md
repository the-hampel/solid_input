# Vasp 6.2.0 example for w90

In Vasp 6.2.0 the wannier90 interface is completely revamped. This leads to some unexpected behavior. I found seg faults when trying to use the legacy interface with the traditional workflow from <6.2.0. Now all input goes into the INCAR file from Vasp. Importantly one has to set the number of Wannier functions in the INCAR separately as flag `NUM_WANN=X`, and not in the wannier90.win file section! The number of bands is automatically written by Vasp. Then everything works as expected, also with mpirun! 

Creation of UNK real space plotting files of Wannier functions seems to be broken in this version. 

