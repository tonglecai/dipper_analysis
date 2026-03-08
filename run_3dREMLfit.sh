#!/bin/bash

#SBATCH --job-name=remlfit
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --time=1-00:00:00
#SBATCH --account=kuhl_lab
#SBATCH --partition=kuhl
#SBATCH --output=path/to/remlfit_%j.log

module load afni

subjects=("001" "002" "003" "004" "005" "006" "007" "008" "009" "010" "011" "012" "013" "014" "015" "016" "017" "018" "019" "020" "021" "022" "023" "024" "025" "026" "027" "028" "029" "030" "031" "032" "033" "034" "035")

for sub in "${subjects[@]}"; do
    echo "Processing sub-${sub}..."

    OUT_DIR="path/to/firstlevel/sub-${sub}"
    mkdir -p $OUT_DIR
    cd $OUT_DIR

    3dDeconvolve \
        -input path/to/mriprep/sub-${sub}/func/sub-${sub}_task-ers_run-*_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz \
        -num_stimts 9 \
        -polort 3 \
        -stim_label 1 enc_ers -stim_times 1 path/to/enc_ers_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 2 enc_esr -stim_times 2 path/to/enc_esr_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 3 enc_ser -stim_times 3 path/to/enc_ser_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 4 ret_ers -stim_times 4 path/to/ret_ers_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 5 ret_esr -stim_times 5 path/to/ret_esr_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 6 ret_ser -stim_times 6 path/to/ret_ser_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 7 sim_ers -stim_times 7 path/to/sim_ers_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 8 sim_esr -stim_times 8 path/to/sim_esr_sub-${sub}.txt 'BLOCK(3,1)' \
        -stim_label 9 sim_ser -stim_times 9 path/to/sim_ser_sub-${sub}.txt 'BLOCK(3,1)' \
        -ortvec path/to/confounds/sub-${sub}/sub-${sub}_motion_all_runs.1D confounds\
        -x1D sub-${sub}.xmat.1D \
        -xjpeg sub-${sub}.jpg \
        -bucket stats_sub-${sub} \
        -x1D_stop

    3dresample -master path/to/fmriprep/sub-${sub}/func/sub-${sub}_task-ers_run-1_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz \
           -prefix mask_resampled.nii.gz \
           -input path/to/combined_union_mask.nii.gz

    3dREMLfit -matrix path/to/firstlevel/sub-${sub}/sub-${sub}.xmat.1D \
        -input "path/to/fmriprep/sub-${sub}/func/sub-${sub}_task-ers_run-*_space-MNI152NLin6Asym_res-2_desc-preproc_bold.nii.gz" \
        -mask mask_resampled.nii.gz \
        -Rbuck results/stats_sub-${sub}_REML -Rvar sub-${sub}/stats_sub-${sub}_REMLvar -tout -fout \
        -verb

done