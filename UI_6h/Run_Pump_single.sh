#!/bin/bash
set -euo pipefail

# Load necessary modules (on the host)
module load gcc12-env/12.3.0
module load singularity/3.11.5

# Paths
container_path="/gxfs_work/geomar/smomw662/parcels-container_2024.10.03-921b2b0.sif"
notebook_path="/gxfs_work/geomar/smomw662/NHCS/notebooks/UI_6h/Ek_Pump_good.ipynb"
output_notebook="/gxfs_work/geomar/smomw662/NHCS/notebooks/UI_6h/Ek_Pump_out.ipynb"

echo "Running on host: $(hostname)"
echo "PWD: $PWD"
echo "Container: ${container_path}"
echo "Notebook in: ${notebook_path}"
echo "Notebook out: ${output_notebook}"

# Run the notebook via papermill inside the container (NO srun)
singularity exec \
  -B /gxfs_work:/gxfs_work \
  -B /nfs/ceph_geomar:/nfs/ceph_geomar \
  -B "$PWD":/work \
  --pwd /work \
  "${container_path}" bash -lc "
    . /opt/conda/etc/profile.d/conda.sh
    conda activate base
    papermill '${notebook_path}' '${output_notebook}'
  "