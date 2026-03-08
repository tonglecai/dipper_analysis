#!/bin/bash

#SBATCH --job-name=mvm
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64GB
#SBATCH --time=1-00:00:00
#SBATCH --account=kuhl_lab
#SBATCH --partition=kuhl
#SBATCH --output=path/to/grouplevel_%j.log

module load afni

3dMVM -prefix Group_Interaction_Stats \
    -jobs 10 \
    -wsVars "Trial*Task_Order" \
    -num_glt 18 \
    -gltLabel 1 MainEff_Sim_vs_Ret      -gltCode 1 'Trial : 1*sim -1*ret' \
    -gltLabel 2 MainEff_Enc_vs_Ret      -gltCode 2 'Trial : 1*enc -1*ret' \
    -gltLabel 3 MainEff_Enc_vs_Sim      -gltCode 3 'Trial : 1*enc -1*sim' \
    -gltLabel 4 Sim_ESR_vs_SER          -gltCode 4 'Trial : 1*sim Task_Order : 1*esr -1*ser'\
    -gltLabel 5 Sim_ESR_vs_ERS          -gltCode 5 'Trial : 1*sim Task_Order : 1*esr -1*ers'\
    -gltLabel 6 Sim_ESR_vs_SER          -gltCode 6 'Trial : 1*sim Task_Order : 1*ers -1*ser'\
    -gltLabel 7 Ret_ESR_vs_SER          -gltCode 7 'Trial : 1*ret Task_Order : 1*esr -1*ser'\
    -gltLabel 8 Ret_ESR_vs_ERS          -gltCode 8 'Trial : 1*ret Task_Order : 1*esr -1*ers'\
    -gltLabel 9 Ret_ESR_vs_SER          -gltCode 9 'Trial : 1*ret Task_Order : 1*ers -1*ser'\
    -gltLabel 10 Enc_ESR_vs_SER          -gltCode 10 'Trial : 1*enc Task_Order : 1*esr -1*ser'\
    -gltLabel 11 Enc_ESR_vs_ERS          -gltCode 11 'Trial : 1*enc Task_Order : 1*esr -1*ers'\
    -gltLabel 12 Enc_ESR_vs_SER          -gltCode 12 'Trial : 1*enc Task_Order : 1*ers -1*ser'\
    -gltLabel 13 Sim_sfirst_vs_safter    -gltCode 13 'Trial : 1*sim Task_Order : 1*esr +1*ers -2*ser'\
    -gltLabel 14 Ret_sfirst_vs_safter    -gltCode 14 'Trial : 1*ret Task_Order : 1*esr +1*ers -2*ser'\
    -gltLabel 15 Enc_sfirst_vs_safter    -gltCode 15 'Trial : 1*enc Task_Order : 1*esr +1*ers -2*ser'\
    -gltLabel 16 Sim_Ret_interaction     -gltCode 16 'Trial : 1*sim -1*ret Task_Order : 1*esr +1*ers -2*ser'\
    -gltLabel 17 Enc_Ret_interaction     -gltCode 17 'Trial : 1*enc -1*ret Task_Order : 1*esr +1*ers -2*ser'\
    -gltLabel 18 Sim_Enc_interaction     -gltCode 18 'Trial : 1*sim -1*enc Task_Order : 1*esr +1*ers -2*ser'\
    -dataTable @data_table.txt