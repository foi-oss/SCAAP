#!/bin/bash

# ---------------------------------------------
# -- Constants and utilities
# ---------------------------------------------
readonly ROOT_REPORT_FOLDER="reports";
readonly MCORE_REPORT_FOLDER="mcode_reports";
readonly MYTH_REPORT_FOLDER="myth_reports";
readonly OYENTE_REPORT_FOLDER="oyente_reports";
readonly LINTERS_REPORT_FOLDER="linters_reports";
readonly CONTRACTS_FOLDER="contracts";

function usage() {
    echo "Solidity static code autoanalysis tool";
    echo "Usage: ./autoanalyse.sh [OPTIONS] project_name link_to_source [solc_version]";
    echo "";
    echo "OPTIONS:";
    echo "  -h  show usage information";
    echo "PARAMETERS:";
    echo "  project_name    Name of the project";
    echo "  link_to_source  Link to GitHub repository"; 
    echo "  solc_version    (Optional) solc version, defaults to 4.19.0";
}

# ---------------------------------------------
# -- Creates report directory in report folder
# ---------------------------------------------
# -- Arguments:
# --   $1 = Folder to create in reports folder
# ---------------------------------------------
# -- Returns:
# --   None
# ---------------------------------------------
function mkrepdir() {
    repdir=$ROOT_REPORT_FOLDER/$1;
    mkdir $repdir && cd $repdir;
}

# ---------------------------------------------
# --- Initiates core contract analysis 
# ---------------------------------------------
# -- Arguments:
# --   $1 = Folder with contracts
# ---------------------------------------------
# -- Returns:
# --   None
# ---------------------------------------------
function tools() {
    # Manticore
    # Note: assumes that contract file name equals to [contract name].sol   
    mkrepdir $MCORE_REPORT_FOLDER
    for file in $(ls ../../$1); do
        contract=$(echo $file | cut -d . -f 1);
        # Unfortunately, manticore requires contract name
        manticore ../../contracts/$file --contract $contract;
    done;
    cd ../..;

    # Mythrill
    mkrepdir $MYTH_REPORT_FOLDER
    myth -o markdown -x ../../$1/* > mythrill.report
    cd ../..;
    
    # Oyente
    mkrepdir $OYENTE_REPORT_FOLDER
    for file in $(ls ../../$1); do
        oyente -a -s ../../$1/$file 2> $file.oyente;
    done;
    cd ../..;
}

# --------------------------------------------
# -- Runs linters on contracts
# --------------------------------------------
# -- Arguments:
# --   $1 = Folder containing contracts
# --------------------------------------------
# -- Returns
# --   None
# --------------------------------------------
function linters() {
    mkrepdir $LINTERS_REPORT_FOLDER;
    # Solhint
    solhint -f table ../../$1/*.sol > solhint.report;
    # Solcheck
    solcheck ../../$1/* > solcheck.report;
    # Solium
    solium --init;
    solium --reporter pretty --dir ../../$1 > solium.report;
    cd ../..;
}

# --------------------------------------------
# -- Runs the analysis on the source
# --------------------------------------------
# -- Arguments:
# --   $1 = Project name
# --------------------------------------------
# -- Returns:
# --   None
# --------------------------------------------
function analysis() {
    mkdir $ROOT_REPORT_FOLDER;
    tools $CONTRACTS_FOLDER;
    linters $CONTRACTS_FOLDER;
    zip -r ../$1.zip $ROOT_REPORT_FOLDER;
}

# --------------------------------------------
# -- Creates new workspace, pulls source and
# -- compiles the contracts for assessment
# --------------------------------------------
# -- Arguments:
# --   $1 = Project name
# --   $2 = Link to source
# --   #3 = (Optional) solc version
# --------------------------------------------
# -- Returns:
# --   None
# --------------------------------------------
function prepare() {
    # Check for solc version and configure
    if [ ! -z "$3" ]; then
        case "$3" in
            "18" | "17")
                echo "Using solidity version 4.$3.0";
                unzip /solcv/solc$3.zip && cp solc /usr/bin/solc;
                ;;
            "*")
                echo "Using solidity version 4.19.0";
                cp /solcv/solc19 /usr/bin/solc;
                ;;
        esac;
    fi;

    # Remove leftovers
    dir=/home/$1;
    if [ -d "$dir" ]; then
        rm -rf $dir;
    fi;

    # Prepare directory and pull source
    mkdir $dir;
    cd $dir;
    git clone $2;

    # Compile contracts
    cd $(ls);
    truffle compile;
}

# --------------------------------------------
# -- Main entry point to the program
# --------------------------------------------
# -- Arguments:
# --   $1 = Project name
# --   $2 = Link to source
# --   $3 = (Optional) solc version
# --------------------------------------------
# -- Returns:
# --   None
# --------------------------------------------
function main() {
    if [ "$#" -eq 3 ] || [ "$#" -eq 2]; then
        prepare "$@";
        analysis $1;
    else
        usage;
    fi;
}

main "$@" | tee $1_analysis.log
