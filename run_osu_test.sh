#! /bin/bash
#SBATCH --job-name=lumi-g-bw-test   # Job name
#SBATCH --output=lumi-g-bw-test.o%j # Name of stdout output file
#SBATCH --error=lumi-g-bw-test.e%j  # Name of stderr error file
#SBATCH --partition=standard-g  # Partition (queue) name
#SBATCH --nodes=2               # Total number of nodes 
#SBATCH --gpus-per-node=8       # Allocate one gpu per MPI rank
#SBATCH --time=2:00:00
#SBATCH --account=project_465000572

ml PrgEnv-gnu/8.4.0 craype-accel-amd-gfx90a rocm/5.2.3 cray-python/3.10.10

#wget https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.3.tar.gz

curl https://mvapich.cse.ohio-state.edu/download/mvapich/osu-micro-benchmarks-7.3.tar.gz --output osu-micro-benchmarks-7.3.tar.gz

mkdir -p data

export PYTHONUSERBASE=$PWD/.local
pip install --user matplotlib

tar -xf osu-micro-benchmarks-7.3.tar.gz && cd ./osu-micro-benchmarks-7.3

mkdir build && cd build

export CC=cc
export CXX=CC
../configure  --enable-rocm && make

cd ../

for i in 0 1
do
if [[ "$i" == 0 ]]
then
    EXE=osu_latency
    PREFIX=LAT_
    UNIT=milis
else
    EXE=osu_bw
    PREFIX=BW_
    UNIT="MB/s"
fi

export MPICH_GPU_SUPPORT_ENABLED=1

cat << EOF > select_gpu
#!/bin/bash
gpus=(1 0)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,50"
chmod +x ./select_gpu


FILENAME=${PREFIX}NUMA_3_CCX_6_to_GCD_0

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 H D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu

######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(1 0)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:55,49"
chmod +x ./select_gpu

FILENAME=${PREFIX}NUMA_3_CCX_7_to_GCD_0

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 H D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################


cat << EOF > select_gpu
#!/bin/bash
gpus=(2 0)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:17,49"
chmod +x ./select_gpu

FILENAME=${PREFIX}NUMA_1_CCX_2_to_GCD_0

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 H D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu

######################################################################


cat << EOF > select_gpu
#!/bin/bash
gpus=(4 0)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:1,49"
chmod +x ./select_gpu

FILENAME=${PREFIX}NUMA_0_CCX_0_to_GCD_0

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 H D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(7 0)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:41,49"
chmod +x ./select_gpu

FILENAME=${PREFIX}NUMA_2_CCX_5_to_GCD_0

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 H D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################


cat << EOF > select_gpu
#!/bin/bash
gpus=(0 1)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,57"
chmod +x ./select_gpu

FILENAME=${PREFIX}GCD_0_to_GCD_1

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu

######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(0 6)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,33"
chmod +x ./select_gpu

FILENAME=${PREFIX}GCD_0_to_GCD_6

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu

######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(0 2)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,17"
chmod +x ./select_gpu

FILENAME=${PREFIX}GCD_0_to_GCD_2

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(0 3)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,25"
chmod +x ./select_gpu

FILENAME=${PREFIX}GCD_0_to_GCD_3

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(0 4)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,1"
chmod +x ./select_gpu

FILENAME=${PREFIX}GCD_0_to_GCD_4

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(0 7)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49,41"
chmod +x ./select_gpu

FILENAME=${PREFIX}GCD_0_to_GCD_7

srun -N 1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu


######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(0 0)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:49"
chmod +x ./select_gpu

FILENAME=${PREFIX}NODE_0_GCD_0_to_NODE_1_GCD_0

srun --ntasks-per-node=1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu

######################################################################

cat << EOF > select_gpu
#!/bin/bash
gpus=(1 7)
export ROCR_VISIBLE_DEVICES=\${gpus[\$SLURM_PROCID]}
exec \$*
EOF
CPU_BIND="map_cpu:17"
chmod +x ./select_gpu

FILENAME=${PREFIX}NODE_0_GCD_1_to_NODE_7_GCD_0

srun --ntasks-per-node=1 -n 2 --cpu-bind=${CPU_BIND} ./select_gpu ./build/c/mpi/pt2pt/standard/${EXE} -m 67108864 D D > ${FILENAME}.txt

echo "bytes, ${UNIT}" > ../data/${FILENAME}.csv
sed -nr 's/(^[[:digit:]]+)\s*([[:digit:]]*\.[[:digit:]]*)/ \1, \2 /p'  ${FILENAME}.txt >> ../data/${FILENAME}.csv
rm ${FILENAME}.txt

rm -rf ./select_gpu
done

cd ../ && python3 postprocess.py
