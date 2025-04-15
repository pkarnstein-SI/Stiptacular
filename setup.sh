ORIGINAL_PWD=$(pwd)
cd font-classify/sample_data/fonts

echo "\n\033[32;1;4mDownloading font files...\033[0m\n"

wget https://github.com/google/fonts/archive/main.zip 
unzip main.zip && rm main.zip

cd $ORIGINAL_PWD/assets/
wget https://raw.githubusercontent.com/rcdm-uga/Gutenberg_Text/refs/heads/master/Hugo%2C%20Victor/Les%20Mis%C3%A9rables%2C%20v.%201-5%3A%20Fantine.txt

cd $ORIGINAL_PWD

echo "\n\033[32;1;4mGenerating training data...\033[0m\n"

python dataset_generation.py 10000 --backgrounds="$ORIGINAL_PWD/font-classify/sample_data/backgrounds" --fonts="$ORIGINAL_PWD/font-classify/sample_data/fonts/fonts-main" --textfile="$ORIGINAL_PWD/font-classify/assets/Les Misérables, v. 1-5: Fantine.txt" --text_source="textfile"

echo "\n\033[32;1;4mTraining OCR...\033[0m\n"

python train.py --image_folder="$ORIGINAL_PWD/font-classify/sample_data/output"

