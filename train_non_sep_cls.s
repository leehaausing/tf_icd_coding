#!/bin/bash

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:3
#SBATCH --time=24:00:00
#SBATCH --mem=32GB
#SBATCH --job-name=bert_icd_pred
#SBATCH --mail-type=END
#SBATCH --mail-user=xl3119@nyu.edu
#SBATCH --output=/scratch/xl3119/tf_icd/clinical_bert_bs32_ns16_mp32.log

overlay_ext3=/scratch/xl3119/tf_icd/overlay-10GB-400K.ext3
model_name=bert_base
batch_size=32
ngram_size=16
maxpool_size=32
n_gpu=3
n_epochs=30
checkpt_path=../cnn_${model_name}_bs${batch_size}_ns${ngram_size}_mp${maxpool_size}.pt

singularity \
    exec --nv --overlay $overlay_ext3:ro \
    /beegfs/work/public/singularity/centos-7.8.2003.sif  \
    /bin/bash -c "module load  anaconda3/5.3.1; \
                  module load cuda/10.1.105; \
                  module load gcc/6.3.0; \
                  source /share/apps/anaconda3/5.3.1/etc/profile.d/conda.sh; \
                  conda activate /ext3/cenv; \
                  python3 main.py \
                              --data_dir ../data \
                              --model_name ../${model_name} \
                              --n_epochs ${n_epochs} \
                              --batch_size ${batch_size} \
                              --ngram_size ${ngram_size} \
                              --maxpool_size ${maxpool_size} \
                              --n_gpu ${n_gpu} \
                              --checkpt_path ${checkpt_path} "
