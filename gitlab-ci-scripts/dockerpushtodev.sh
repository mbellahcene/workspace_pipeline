#!/usr/bin/bash

while getopts "p:i:r:l:m:n:" option
do
    case $option in
                p)  RPASSW=$OPTARG;;
                i)  DEV_IMAGE=$OPTARG;;
                r)  RELEASE_IMAGE=$OPTARG;;
                l)  LATEST_IMAGE=$OPTARG;;
                m)  RELEASEMODE=$OPTARG;;
                n)  LATEST=$OPTARG;;
				
				
        esac
done

echo "option are:"
echo " RELEASEMODE ==  " $RELEASEMODE " LATEST === " $LATEST
echo " DEV_IMAGE     === " $DEV_IMAGE 
echo " RELEASE_IMAGE === " $RELEASE_IMAGE 
echo " LATEST_IMAGE  === " $LATEST_IMAGE 


if [[ -z $DEV_IMAGE || -z $RELEASE_IMAGE || -z $LATEST_IMAGE || -z $RELEASEMODE || -z $LATEST || -z $RPASSW  ]]
then echo -e "Missing option!\nUsage:"
	 echo -e "option -i : DEV_IMAGE "
     echo -e "option -r : RELEASE_IMAGE "
     echo -e "option -l : LATEST_IMAGE "
     echo -e "option -m : RELEASEMODE "
     echo -e "option -n : LATEST "
     echo -e "option -p : RPASSW "

         exit 1
fi

confpipeline=$(pwd)"/gitlab-ci-scripts/confpipeline.json"
RURL=$(jq -r ".docker.dev.registry.url" $confpipeline)
LOGIN=$(jq -r ".docker.dev.registry.login" $confpipeline)


echo "------------Registry $ENVNAME informations------------"
echo "LOGIN       ===== $LOGIN"
echo "PASSWD      ===== $RPASSW"
echo "URL         ===== $RURL"

docker login -u $LOGIN -p $RPASSW $RURL

PUSHED_DEVIMAGE=$RURL/$DEV_IMAGE
docker tag $DEV_IMAGE $PUSHED_DEVIMAGE
docker push $PUSHED_DEVIMAGE

if [ "$RELEASEMODE" = "true" ]  ;  then
 echo "--------------------------"
 echo "push release image"
 PUSHED_RELEASEIMAGE=$RURL/$RELEASE_IMAGE
 docker tag $RELEASE_IMAGE $PUSHED_RELEASEIMAGE
 docker push $PUSHED_RELEASEIMAGE
fi

if [ "$LATEST" = "true" ]  ;  then
 echo "--------------------------"
 echo "push latest image"
 PUSHED_LATESTIMAGE=$RURL/$LATEST_IMAGE
 docker tag $LATEST_IMAGE $PUSHED_LATESTIMAGE
 docker push $PUSHED_LATESTIMAGE
fi