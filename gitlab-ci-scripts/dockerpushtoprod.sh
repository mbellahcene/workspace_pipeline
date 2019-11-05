#!/usr/bin/bash
while getopts "p:r:l:n:o:" option
do
    case $option in
                p)  RPASSW=$OPTARG;;
                r)  PROD_IMAGE=$OPTARG;;
                l)  LATEST_IMAGE=$OPTARG;;
                n)  LATEST=$OPTARG;;
                o)  PROJECT=$OPTARG;;
                
                
        esac
done

if [[ -z $PROJECT ]] ; then
echo -e "not merge request branch "
exit 1 
fi

echo "option are:"
echo "LATEST === " $LATEST
echo "PROD_IMAGE     === " $PROD_IMAGE 
echo "LATEST_IMAGE === " $LATEST_IMAGE 


if [[ -z $RPASSW || -z $PROD_IMAGE || -z $LATEST_IMAGE || -z $LATEST ]]
then echo -e "Missing option!\nUsage:"
    echo -e "option -r : PROD_IMAGE "
    echo -e "option -l : LATEST_IMAGE "
    echo -e "option -n : LATEST "
    echo -e "option -p : RPASSW "

        exit 1
fi

confpipeline=$(pwd)"/gitlab-ci-scripts/confpipeline.json"
RURL=$(jq -r ".docker.prod.registry.url" $confpipeline)
LOGIN=$(jq -r ".docker.prod.registry.login" $confpipeline)


echo "------------Registry $ENVNAME informations------------"
echo "LOGIN       ===== $LOGIN"
echo "PASSWD      ===== $RPASSW"
echo "URL         ===== $RURL"

docker login -u $LOGIN -p $RPASSW $RURL

echo "--------------------------"
echo "push prod image"
PUSHED_PRODIMAGE=$RURL/$PROD_IMAGE
docker tag $PROD_IMAGE $PUSHED_PRODIMAGE
docker push $PUSHED_PRODIMAGE

if [ "$LATEST" = "true" ]  ;  then
echo "--------------------------"
echo "push latest image"
PUSHED_LATESTIMAGE=$RURL/$LATEST_IMAGE
docker tag $LATEST_IMAGE $PUSHED_LATESTIMAGE
docker push $PUSHED_LATESTIMAGE
fi
