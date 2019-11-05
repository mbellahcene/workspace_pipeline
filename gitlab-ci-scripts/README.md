# gitlab-ci-scripts

[gitlab-runner@srvgitlablinuxrunner3 temp]$ cat ak.sh
#!/usr/bin/bash

#CI_COMMIT_TITLE="Merge branch 'docker.hello' into 'master'"
CI_COMMIT_TITLE="Merge branch docker.hello into master"

echo $CI_COMMIT_TITLE[gitlab-runner@srvgitlablinuxrunner3 temp]$ cat awk.sh
#!/usr/bin/bash

CI_COMMIT_TITLE="Merge branch 'docker.hello' into 'master'"
project=$(echo $CI_COMMIT_TITLE | awk '{print $3}'| sed s/\'//g)
echo $project
[gitlab-runner@srvgitlablinuxrunner3 temp]$
