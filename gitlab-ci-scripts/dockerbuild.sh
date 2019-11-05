#!/usr/bin/bash

while getopts "c:i:r:l:m:n:" option
  do 
    case $option in
        c)  CI_COMMIT_SHORT_SHA=$OPTARG;;
        i)  DEV_IMAGE=$OPTARG;;
        r)  RELEASE_IMAGE=$OPTARG;;
        l)  LATEST_IMAGE=$OPTARG;;
        m)  RELEASEMODE=$OPTARG;;
        n)  LATEST=$OPTARG;;			
        esac
done

echo "option are:"
echo " CI_COMMIT_SHORT_SHA ==  " $CI_COMMIT_SHORT_SHA 
echo " RELEASEMODE ==  " $RELEASEMODE " LATEST === " $LATEST
echo " DEV_IMAGE     === " $DEV_IMAGE 
echo " RELEASE_IMAGE === " $RELEASE_IMAGE 
echo " LATEST_IMAGE  === " $LATEST_IMAGE 


if [[ -z $CI_COMMIT_SHORT_SHA || -z $DEV_IMAGE || -z $RELEASE_IMAGE || -z $LATEST_IMAGE || -z $RELEASEMODE || -z $LATEST  ]]
then echo -e "Missing option!\nUsage:"
     echo -e "option -c : CI_COMMIT_SHORT_SHA "
	 echo -e "option -i : DEV_IMAGE "
     echo -e "option -r : RELEASE_IMAGE "
     echo -e "option -l : LATEST_IMAGE "
     echo -e "option -m : RELEASEMODE "
     echo -e "option -n : LATEST "


         exit 1
fi

docker build --pull --build-arg COMMIT=$CI_COMMIT_SHORT_SHA -t $DEV_IMAGE .

if [ "$RELEASEMODE" = "true" ]  ;  then
 echo "--------------------------"
 echo "add tag to release image"
 docker tag $DEV_IMAGE $RELEASE_IMAGE
fi

if [ "$LATEST" = "true" ]  ;  then
 echo "--------------------------"
 echo "add tag to latest image"
 docker tag $DEV_IMAGE $LATEST_IMAGE
fi

