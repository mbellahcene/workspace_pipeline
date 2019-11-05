#!/usr/bin/bash

while getopts "c:u:t:d:n:i:" option
do
    case $option in
                c)  CI_COMMIT_SHA=$OPTARG;;
                u)  CI_PROJECT_URL=$OPTARG;;
                t)  CI_JOB_TOKEN=$OPTARG;;
                d)  CI_PROJECT_PATH =$OPTARG;;
				        n)  CI_PROJECT_NAME =$OPTARG;;
                i)  SNAME_IMAGE=$OPTARG;;
				
				
        esac
done

if [[ -z $CI_COMMIT_SHA || -z $CI_PROJECT_URL || -z $CI_JOB_TOKEN || -z $CI_PROJECT_PATH || -z $CI_PROJECT_NAME || -z $SNAME_IMAGE ]]
then echo -e "Missing option!\nUsage:"
     echo -e "option -c : CI_COMMIT_SHORT_SHA "
	   echo -e "option -u : CI_PROJECT_URL "
	   echo -e "option -d : CI_PROJECT_PATH "
	   echo -e "option -n : CI_PROJECT_NAME "
	   echo -e "option -t : CI_JOB_TOKEN"
     echo -e "option -i : SNAME_IMAGE"

         exit 1
else echo "option are:"
         echo $CI_COMMIT_SHORT_SHA " " $CI_PROJECT_URL " " $CI_PROJECT_PATH " " $CI_PROJECT_NAME  " " $SNAME_IMAGE " " $CI_JOB_TOKEN
fi

#_TOKEN=Dh5bT9hxCaQsjtz9PZ4x

CI_PROJECT_DIR=$(pwd)
url_no_protocol=${CI_PROJECT_URL/https:\/\//}
url=${url_no_protocol%%/*}
git clone https://gitlab-ci-token:$CI_JOB_TOKEN@$url/pipeline/docker.manifests.git
pushd docker.manifests

if git ls-remote --exit-code https://gitlab-ci-token:$CI_JOB_TOKEN@$url/pipeline/docker.manifests.git $CI_PROJECT_NAME; then  
  git checkout $CI_PROJECT_NAME --
  git rebase master
else
  git checkout -b $CI_PROJECT_NAME
fi

 dockermanifest="$CI_PROJECT_DIR/docker.manifest.json"
 echo "$dockermanifest"
 VERSION=$(jq -r ".version" $dockermanifest)
 LATEST=$(jq -r ".latest" $dockermanifest)
 MAINTAINERS=$(jq -r ".maintainers" $dockermanifest)

cat > $CI_PROJECT_NAME <<EOF
{
 "maintainers": $( echo "\"$MAINTAINERS\""),
 "version": $( echo "\"$VERSION\""),
 "repository": $( echo "\"$CI_PROJECT_PATH\""),
 "image_name": $( echo "\"$SNAME_IMAGE\""),
 "latest": $( echo "\"$LATEST\""),
 "ci_commit_short_sha": $( echo "\"$CI_COMMIT_SHORT_SHA\"")
}
EOF

git add $CI_PROJECT_NAME
git commit -m "Promote $CI_PROJECT_PATH@$CI_COMMIT_SHORT_SHA"
git push --force origin $CI_PROJECT_NAME -o merge_request.create -o ci.skip -o merge_request.remove_source_branch -o merge_request.description="$CI_PROJECT_NAME" 