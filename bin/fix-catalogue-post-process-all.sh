#!/bin/bash

executeQuery(){
    mysql --login-path=app -Ddb01bfy_app -BNe"$1"
    exit 0
    if [ -n "$?" ] && [ "$?" -ne "0" ]; then
        exit 1
    fi

    echo $result
}

echo "Searching for modules in POST_PROCESS and PROGRESS more than 10 minutes...💨"
modulesQuery="select concat_ws('@', module_id, catalogue_type) from bf_catalogue_steps_status where step = 'POST_PROCESS' and step_status = 'PROGRESS' and update_at < unix_timestamp() - (60*10)"

modules=$(executeQuery "${modulesQuery}")

for module in $modules
do
    # Set delimiter
    IFS='@'
    read -a module_arr <<< "$module"
    echo "Updating into database for ${module_arr[0]} and ${module_arr[1]}...👌"
    mysql --login-path=app -Ddb01bfy_app -e "update bf_catalogue_steps_status set step = 'CHUNK_PROCESS', step_status = 'DONE' where module_id = '${module_arr[0]}' and catalogue_type = '${module_arr[1]}';"
    echo "Launch post-process commnad for ${module_arr[0]} and ${module_arr[1]}...👌"
    kubectl exec -ti `kubectl get po | awk '{print $1}' | grep admin -m1` -- php bin/console bf:catalogue:post-process "${module_arr[0]}" "${module_arr[1]}"
    sleep 1
done
exit 0;
