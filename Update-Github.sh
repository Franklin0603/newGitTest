#!/bin/bash

keywords=${1?Error: Enter file name -> $0 --help}

Start()
{
    echo
    echo "==> Hello $USER <=="
    echo "type '$0 --help' if you need help"
    echo
}

display_help()
{
    echo
    echo "==> $0:"
    echo "-- Program to Push and Pull code in Github."
    echo
    echo "Syntax: ScriptTemplate [--push|pull|help]"
    echo "options:"
    echo "    --push  run the python script."
    echo "    --pull  Print this help."
    echo "    --help show log: detail of the last python run date."
    echo
}

################################
# Pull Code from Github        #
################################

github_Pull_code() 
{
    # Default to working directory
    LOCAL_REPO="."
    # Default to git pull with FF merge in quiet mode
    GIT_COMMAND="git pull --quiet"

    # User messages
    GU_ERROR_FETCH_FAIL="Unable to fetch the remote repository."
    GU_ERROR_UPDATE_FAIL="Unable to update the local repository."
    GU_ERROR_NO_GIT="This directory has not been initialized with Git."
    GU_INFO_REPOS_EQUAL="The local repository is current. No update is needed."
    GU_SUCCESS_REPORT="Update complete."


    if [ $# -eq 1 ]; then
    LOCAL_REPO="$1"
    cd "$LOCAL_REPO"
    fi

    if [ -d ".git" ]; then
    # update remote tracking branch
    git remote update >&-
    if (( $? )); then
        echo $GU_ERROR_FETCH_FAIL >&2
        exit 1
    else
        LOCAL_SHA=$(git rev-parse --verify HEAD)
        REMOTE_SHA=$(git rev-parse --verify FETCH_HEAD)
        if [ $LOCAL_SHA = $REMOTE_SHA ]; then
            echo $GU_INFO_REPOS_EQUAL
            exit 0
        else
            $GIT_COMMAND
            if (( $? )); then
                echo $GU_ERROR_UPDATE_FAIL >&2
                exit 1
            else
                echo $GU_SUCCESS_REPORT
            fi
        fi
    fi
    else
    echo $GU_ERROR_NO_GIT >&2
    exit 1
    fi
    exit 0
}

################################
# Push Code from Github        #
################################

github_Push_code()
{
    git add .
    read -p "Commit description: " desc
    git commit -m "$desc"
    git push origin master
}


case "$keywords" in
    -ps | --push)
        echo " ====> Push codes to github Project ... <===="
        github_Push_code
        echo
        echo " ====> files have push to Github Project ... <===="
        ;;

     -pu | --pull)
        echo " ====> Pull codes from github Project ... <===="
        github_Pull_code
        echo
        echo " ====> files have pull from Github Project ... <===="
        ;;

     -h | --help)
          display_help  # Call your function
          exit 0
          ;;
    *)
     exit 1
esac

