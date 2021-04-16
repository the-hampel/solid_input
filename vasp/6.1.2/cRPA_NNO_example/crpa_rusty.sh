#!/bin/bash
#SBATCH --job-name="vasp-crpa"
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=64
#SBATCH --ntasks-per-core=1
#SBATCH --partition=ccq
#SBATCH --constraint=rome
#SBATCH --output=out.%j
#SBATCH --error=err.%j

#======START=====

export OMP_NUM_THREADS=1
ulimit -s unlimited

module purge
module load slurm
module load vasp/6.1.2_gnu_ompi/module-rome


VASP="mpirun vasp_std" 

cp INCAR.DFT INCARV
$VASP
cat INCAR OUTCAR > OUTCAR.DFT

cp INCAR.EXACT INCAR
$VASP
cat INCAR OUTCAR > OUTCAR.EXACT

cp INCAR.CRPA INCAR
$VASP
cat INCAR OUTCAR > OUTCAR.CRPA_target.static

#=====END====
