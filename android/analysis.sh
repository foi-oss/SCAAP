# TODO zip report folder
# TODO polish code and cleaner folder setup for docker image
# TODO think about separate direct source/apk analysis
# TODO see into JAADAS problems
# TODO everything logged on screen should be saved into a log file and pulled from docker
# Example (current) ./analysis.sh -p Bach --url https://github.com/mjurinic/Bach 

function source {
    projectfolder=/home/$1
    git clone $2 $projectfolder
    cd $projectfolder
    ./gradlew assembleDebug
}

function analysis {
    resultsfolder=/home/results
    mkdir $resultsfolder

    # SUPER
    mkdir $resultsfolder/super
    super -v $location --results $resultsfolder/super

    # qark
    mkdir $resultsfolder/qark
    python /home/tools/qark/qark/qarkMain.py --source=1 -p $location -b /home/tools/android-sdk -r $resultsfolder/qark

    # androbugs (APK only)
    mkdir $resultsfolder/androbugs
    python /home/tools/AndroBugs_Framework/androbugs.py -f $location -o $resultsfolder/androbugs

    # StaCoAn (APK only)
    mkdir $resultsfolder/stacoan
    # Next line is importat to store results in appropriate folder
    cd $resultsfolder/stacoan
    python3 /home/tools/StaCoAn/src/stacoan.py -p $location --log-all --disable-browser

    # JAADAS no work, why?
}

while [ "${1:-}" != "" ]; do
    case "$1" in
        "-p" | "--project")
            shift
            echo "Project name: $1"
            project=$1
            ;;
        "--url")
            shift
            url=true
            echo "URL to source: $1"
            location=$1
            ;;
        "--apk")
            shift
            echo "APK location: $1"
            location=$1
            ;;
    esac
    shift
done

if [ $url ]; then
    source $project $location
    location=/home/$project/app/build/outputs/apk/app-debug.apk
fi;

analysis $project $location
