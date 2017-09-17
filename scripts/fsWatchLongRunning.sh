#!/usr/bin/env bash
#{{{                    MARK:Header
#**************************************************************
#####   Author: JACOBMENKE
#####   Date: Mon Jul 10 19:33:52 EDT 2017
#####   Purpose: bash script to list files on file change
#####   Notes: 
#}}}***********************************************************
DIR_WATCHING="$1"
first_iteration=true
while read -d "" event; do

    echo "The event was $event"

    # initial run
    if [[ $first_iteration = true ]]; then
        first_iteration=false
        {
            echo "First Iteration.  Starting long running task..."
            sleep 10
            echo "First Iteration.  Completing long running task like rsync..."
        } &
        pid=$!
    else
        #subsequent runs
        #dont execute commands is previous command still running
        ps -ef | awk '{print $1,$2}' | grep -q "$pid" && echo "blocking next call..." || {

            {
                echo "Starting long running task..."
                sleep 10
                echo "completing long running task like rsync"
            } &
            pid=$!
        }

    fi

done < <(fswatch -r -0 -E "$DIR_WATCHING" -e "/\.." )
