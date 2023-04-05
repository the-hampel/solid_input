#!/bin/bash
#SBATCH --job-name="svo.respack.in"
#SBATCH --time=48:00:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --ntasks-per-core=1
#SBATCH --partition=ccq
#SBATCH --constraint=rome
#SBATCH --output=out.%j
#SBATCH --error=err.%j

#======START=====

module purge
module load slurm
module load quantum_espresso/7.1_nix2_gnu_ompi_respack

seedname=svo

export OMP_NUM_THREADS=16
export OMP_STACKSIZE=512
ulimit -s unlimited

echo "QE scf step"
mpirun --map-by socket:pe=$OMP_NUM_THREADS pw.x -pd .true. < ${seedname}.scf.in > ${seedname}.scf.out

echo "QE nscf step"
mpirun --map-by socket:pe=$OMP_NUM_THREADS pw.x -pd .true. < ${seedname}.nscf.in > ${seedname}.nscf.out

# create dir-wfn and create kmesh, paste into svo.win.ref > svo.win, and create svo.nscf_wannier.in
echo "pre-process"
wan2respack.py -pp conf.toml

echo "pw nscf wannier"
mpirun --map-by socket:pe=$OMP_NUM_THREADS pw.x -pd .true. < ${seedname}.nscf_wannier.in > ${seedname}.nscf_wannier.out

echo "wannier90 pp"
wannier90.x -pp ${seedname}

echo "pw2wannier90"
mpirun --map-by socket:pe=$OMP_NUM_THREADS pw2wannier90.x < ${seedname}.pw2wan.in > ${seedname}.pw2wan.out

echo "wannier90 run"
wannier90.x ${seedname}

# convert wannier90 output to respack format
echo "wannier90 results to RESPACK inputs"
wan2respack.py conf.toml

echo "run respack"
mpirun --map-by socket:pe=$OMP_NUM_THREADS calc_chiqw < ${seedname}.crpa.in > ${seedname}.crpa.out

echo "calc screened U / J in Wannier basis"
mpirun -n 1 calc_w3d < ${seedname}.crpa.in > ${seedname}.w3d.out
mpirun -n 1 calc_j3d < ${seedname}.crpa.in > ${seedname}.j3d.out

#=====END====
