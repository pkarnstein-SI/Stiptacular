usage() {
    echo "./setup.sh"
    echo "    -h | --help     print this helptext"
    echo "    -t | --train    re-train model (optional)"
}

handle_options() {
    while [ $# -gt 0 ]; do
        case $1 in
        -h | --help)
            usage
            exit 0
            ;;
        -t | --train)
            train=true
            ;;
        *)
            echo "Invalid option: $1\n" >&2
            usage
            exit 1
            ;;
        esac
        shift
    done
}

handle_options "$@"

ORIGINAL_PWD=$(pwd)
mkdir -p font-classify/sample_data/fonts
cd font-classify/sample_data/fonts

echo -e "\n\033[32;1;4mDownloading font files...\033[0m\n"

wget https://github.com/google/fonts/archive/main.zip
unzip main.zip && rm main.zip

if [ "$train" = true ]; then
    cd $ORIGINAL_PWD/assets/
    wget https://raw.githubusercontent.com/rcdm-uga/Gutenberg_Text/refs/heads/master/Hugo%2C%20Victor/Les%20Mis%C3%A9rables%2C%20v.%201-5%3A%20Fantine.txt

    cd $ORIGINAL_PWD

    echo -e "\n\033[32;1;4mGenerating training data...\033[0m\n"

    python dataset_generation.py 10000 --backgrounds="$ORIGINAL_PWD/font-classify/sample_data/backgrounds" --fonts="$ORIGINAL_PWD/font-classify/sample_data/fonts/fonts-main" --textfile="$ORIGINAL_PWD/font-classify/assets/Les Misérables, v. 1-5: Fantine.txt" --text_source="textfile"

    echo -e "\n\033[32;1;4mTraining OCR...\033[0m\n"

    python train.py --image_folder="$ORIGINAL_PWD/font-classify/sample_data/output" --num_epochs 1000

    echo -e "\n\033[32;1;4mFinished. Model saved to $ORIGINAL_PWD/font-classify/sample_data/model/\033[0m\n"
fi