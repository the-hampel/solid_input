#!/bin/bash
#SBATCH --job-name="vasp-SVO-cRPAR"
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --constraint=icelake
#SBATCH --partition=ccq
#SBATCH --output=log.%j

#======START=====

module purge
module load slurm vasp/6.4.1_nix2.1_ione

# set OMP_NUM_THREADS so that times ntasks-per-node is the total number of cores on each node
# Vasp is currently compiled without OpenMP support!
export OMP_NUM_THREADS=1
ulimit -s unlimited

# with map by socket a maximum of number of cores per physical cores are spawned! This is cores per node/2
# if more threads are needed switch socket -> node
VASP="mpirun --map-by socket:pe=$OMP_NUM_THREADS vasp_std"

date
cp INCAR.DFT INCAR
# run DFT step with dens kpoint mesh to converge charge density
cp KPOINTS.DFT KPOINTS
$VASP
cat INCAR OUTCAR > OUTCAR.DFT

cp INCAR.EXACT INCAR
cp KPOINTS.CRPA KPOINTS
$VASP
cat INCAR OUTCAR > OUTCAR.EXACT

cp INCAR.CRPA INCAR
$VASP
cat INCAR OUTCAR > OUTCAR.CRPA
date
#=====END====
