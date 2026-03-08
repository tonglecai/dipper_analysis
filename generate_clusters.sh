#!/bin/bash


#SBATCH --job-name=clu
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --time=1-00:00:00
#SBATCH --account=kuhl_lab
#SBATCH --partition=kuhl
#SBATCH --output=path/to/clu__%j.log

STATS_FILE="Group_Interaction_Stats+tlrc"
MASK_FILE="path/to/firstlevel/sub-001/mask_resampled.nii.gz"


CLUST_SIZE=25 
PTHR=0.01

LABELS=(
    'Sim_sfirst_vs_safter t'
    'Ret_sfirst_vs_safter t'
    'Sim_Ret_interaction t'
    'MainEff_Sim_vs_Ret t'
    'MainEff_Enc_vs_Ret t'
    'MainEff_Enc_vs_Sim t'
    'Enc_sfirst_vs_safter t'
    'Trial:Task_Order F'
    'Trial F'
    'Task_Order F'
)

echo "Starting Batch Clusterize..."
echo "Cluster Size: $CLUST_SIZE voxels"

module load afni

for label in "${LABELS[@]}"; do
    
    idx=$(3dinfo -label2index "${label}" "${STATS_FILE}")

    echo "Processing: $label (Index #$idx)"

    clean_name=$(echo "$label" | tr ' #:' '___')
    output_map="Cleaned_Map_${clean_name}.nii.gz"
    output_report="Report_${clean_name}.txt"

    if [[ "$label" == *"Fstat"* ]]; then
        echo "Type: F-test (1-sided)"
        3dClusterize \
            -inset "${STATS_FILE}" \
            -ithr "${idx}" \
            -idat "${idx}" \
            -mask "${MASK_FILE}" \
            -NN 2 \
            -1sided RIGHT_TAIL p=$PTHR \
            -clust_nvox $CLUST_SIZE \
            -pref_dat "${output_map}" \
            > "${output_report}"
            
    else
        echo "Type: T-test (2-sided)"
        3dClusterize \
            -inset "${STATS_FILE}" \
            -ithr "${idx}" \
            -idat "${idx}" \
            -mask "${MASK_FILE}" \
            -NN 2 \
            -bisided p=$PTHR \
            -clust_nvox $CLUST_SIZE \
            -pref_dat "${output_map}" \
            > "${output_report}"
    fi
    
    if [ -f "${output_report}" ]; then
        lines=$(wc -l < "${output_report}")
        if [ "$lines" -le 1 ]; then
            echo "   -> Result: NO SIGNIFICANT CLUSTERS FOUND."
        else
            echo "   -> Result: Clusters saved to ${output_map}"
        fi
    fi

done