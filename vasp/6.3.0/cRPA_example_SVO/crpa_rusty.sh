#!/bin/bash
#SBATCH --job-name="nno-cpra-1orb"
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=32
#SBATCH --ntasks-per-core=1
#SBATCH --partition=ccq
#SBATCH --constraint=rome
#SBATCH --output=out.%j
#SBATCH --error=err.%j

#======START=====

export OMP_NUM_THREADS=4
ulimit -s unlimited

module purge
module load slurm
module load vasp/6.3.0_gnu


VASP="mpirun --map-by socket:pe=$OMP_NUM_THREADS vasp_std" 

cp INCAR.DFT INCAR
$VASP
cat INCAR OUTCAR > OUTCAR.DFT

cp INCAR.EXACT INCAR
$VASP
cat INCAR OUTCAR > OUTCAR.EXACT

cp INCAR.CRPA INCAR
$VASP
cat INCAR OUTCAR > OUTCAR.CRPA

#=====END====
