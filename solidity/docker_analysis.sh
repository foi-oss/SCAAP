# ------------------------------------------------
# -- Initiates automatic security analysis in 
# -- docker from the host
# ------------------------------------------------
# -- Arguments:
# --   $1 = Container name
# --   $2 = Project name
# --   $3 = URL to source
# --   $4 = (Optional) solc version [19|18|17]
# ------------------------------------------------

# Check arguments
if [ "$#" -ne 3 ] || [ "$#" -ne 4]; then
    echo "Usage: [sudo] docker_analysis.sh container_name project_name source_url [solc_version]";
    echo "";
    echo "PARAMETERS:";
    echo "  container_name  Docker container to use for contract analysis" 
    echo "  project_name    Name of the project"
    echo "  source_url      URL to source (GitHub)"
    echo "  solc_version    (Optional) solc version [19|18|17], defaults to 4.[19].0"
fi;

# Warn if not sudo
if [ "$UID" -ne 0]; then
    echo "Warning: this script may need to be run with root privileges";
fi;

# Fail all if one command fails
set -e;
readonly SCRIPT_NAME="autoanalyse.sh";

echo "Transfering file ...";
# TODO Think about doing this via Dockerfile
docker cp ./$SCRIPT_NAME $1:/$SCRIPT_NAME;

# Execute script in docker
echo "Giving execution permission ...";
docker exec -d $1 sh -c "sudo chmod +x /$SCRIPT_NAME";
echo "Starting analysis ...";
docker exec -it $1 /$SCRIPT_NAME $2 $3 $4;

# Pull zip with reports back to host
reports=$2.zip;
analysis=$2_analysis.log

docker cp $1:/home/$2/$reports $reports;
echo "Reports pulled ($reports)";
docker cp $1:/$analysis $analysis;
echo "Log pulled ($analysis)";
