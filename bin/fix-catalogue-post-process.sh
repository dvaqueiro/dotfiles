#!/bin/bash
function showMessage {
    echo -e "Fix freeze catalogues in app.";
    echo -e "Usage: fix-catalogue-post-process.sh [OPTIONS] moduleId";
    echo -e "Options:";
    echo -e "\t-c\tPerform catalogue type";
    echo -e "\t-a\tPerform addittional-data type";
    echo
    echo -e "Example: fix-catalogue-post-process.sh -c 111-222-333\n";
    exit 1;
}
if [ "$2" == "" ]
then
    showMessage;
else
    moduleId="$2"
fi
while getopts a:c: flag
do
    case "${flag}" in
        a) catalogueType="addittional-data";;
        c) catalogueType="catalogue";;
    esac
done
echo "Perfom to $moduleId and $catalogueType ...";
echo "Updating into database..."
mysql --login-path=app -e "use app; update bf_catalogue_steps_status set step = 'CHUNK_PROCESS', step_status = 'DONE'  where module_id = '$moduleId' and catalogue_type = '$catalogueType';"
echo "Launch post-process commnad..."
kubectl exec -ti `kubectl get po | awk '{print $1}' | grep admin -m1` -- php bin/console bf:catalogue:post-process "$moduleId" "$catalogueType"
