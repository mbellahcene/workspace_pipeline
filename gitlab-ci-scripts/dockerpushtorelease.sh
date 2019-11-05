#!/usr/bin/bash

while getopts "p:r:l:m:n:" option
do
    case $option in
                p)  RPASSW=$OPTARG;;
                r)  RELEASE_IMAGE=$OPTARG;;
                l)  LATEST_IMAGE=$OPTARG;;
                m)  RELEASEMODE=$OPTARG;;
                n)  LATEST=$OPTARG;;
                
                
        esac
done



echo "option are:"
echo " RELEASEMODE ==    " $RELEASEMODE " LATEST === " $LATEST

if [[ -z $RELEASE_IMAGE || -z $LATEST_IMAGE || -z $RELEASEMODE || -z $LATEST || -z $RPASSW  ]]
    then echo -e "Missing option!\nUsage:"
                    echo -e "option -r : RELEASE_IMAGE "
                    echo -e "option -l : LATEST_IMAGE "
                    echo -e "option -m : RELEASEMODE "
                    echo -e "option -n : LATEST "
                    echo -e "option -p : RPASSW "

                        exit 1
fi

if [ "$RELEASEMODE" = "true" ]  ;  then

                echo " DEV_IMAGE     === " $DEV_IMAGE 
                echo " RELEASE_IMAGE === " $RELEASE_IMAGE 
                echo " LATEST_IMAGE  === " $LATEST_IMAGE 



                confpipeline=$(pwd)"/gitlab-ci-scripts/confpipeline.json"
                RURL=$(jq -r ".docker.release.registry.url" $confpipeline)
                LOGIN=$(jq -r ".docker.release.registry.login" $confpipeline)


                echo "------------Registry $ENVNAME informations------------"
                echo "LOGIN       ===== $LOGIN"
                echo "PASSWD      ===== $RPASSW"
                echo "URL         ===== $RURL"

                docker login -u $LOGIN -p $RPASSW $RURL
                
                 echo "--------------------------"
                 echo "push release image"
                PUSHED_RELEASEIMAGE=$RURL/$RELEASE_IMAGE
                docker tag $RELEASE_IMAGE $PUSHED_RELEASEIMAGE
                docker push $PUSHED_RELEASEIMAGE

                if [ "$LATEST" = "true" ]  ;  then
                echo "--------------------------"
                echo "push latest image"
                PUSHED_LATESTIMAGE=$RURL/$LATEST_IMAGE
                docker tag $LATEST_IMAGE $PUSHED_LATESTIMAGE
                docker push $PUSHED_LATESTIMAGE
                fi
else
   echo "------------Not Push to release registry------------"
fi