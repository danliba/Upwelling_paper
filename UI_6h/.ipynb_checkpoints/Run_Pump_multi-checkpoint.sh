#!/bin/bash
#SBATCH --job-name=Pump_job
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=190G
#SBATCH --time=4:00:00
#SBATCH --partition=base
#SBATCH --constraint=web
#SBATCH --output=Pump_out_%j.log
#SBATCH --error=Pump_error_%j.log

module load gcc12-env/12.3.0
module load singularity/3.11.5

export OMP_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}
export MKL_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}
export OPENBLAS_NUM_THREADS=${SLURM_CPUS_PER_TASK:-1}

container_path="/gxfs_work/geomar/smomw662/parcels-container_2024.10.03-921b2b0.sif"
notebook_path="/gxfs_work/geomar/smomw662/NHCS/notebooks/UI_6h/Ek_Pump_good_run.ipynb"
output_notebook="/gxfs_work/geomar/smomw662/NHCS/notebooks/UI_6h/Ek_Pump_run_out.ipynb"

srun --ntasks=1 --cpus-per-task=12 --exclusive --cpu-bind=none \
  singularity exec \
    -B /gxfs_work:/gxfs_work \
    -B "$PWD":/work \
    --pwd /work \
    "${container_path}" bash -c "
      . /opt/conda/etc/profile.d/conda.sh && \
      conda activate base && \
      papermill '${notebook_path}' '${output_notebook}'
    "