# Lu2CoO4 1 band FTPS example

simple one band example for the ForkTPS solver using solid_dmft. This example is for the AbInitioDMFT tutorial of triqs: https://github.com/TRIQS/tutorials/tree/3.2.x/AbinitioDMFT.

A reference output is given and the calculation takes ~1h for 8 DMFT iterations. There are 4 Green functions components to evolve in time, that each run on one mpi rank. For optimal performance set the bash env variable `OMP_NUM_THREADS` to ~12 and run with at least 4 mpi ranks. Beyond that not much speed up is to be expected. 

Currently the Fourier transformation to obtain Sigma in FTPS is not correctly treating the high-frequency tail. Calculations should converge but spurious diverge of Sigma at high omega is expected. 

To increase accuracy converge first the DMFT iterations using given parameters, then decrease `dt` and `eta`. All other parameters should be already at high accuracy.

Finally, the converged self-energy can be compared to the analytically continued one from the tutorial.
