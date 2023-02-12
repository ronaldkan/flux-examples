# PROJECT_IMAGE_TAG_KEY: name of the yaml key that is used for specifing the image tag
# NEW_DEPLOYMENT_TAG: latest pipeline image tag
# PROJECT_NAME: current project name for deployment
# PROJECT_CONFIG_PATH: path where the application configuration are defined
# PROJECT_IMAGETAG_FILEPATH: file path where the yaml key that image tag are specified
# CONFIG_PROJECT_DEFAULT_BRANCH: default branch of the project (master or main)
sed -i "s/${PROJECT_IMAGETAG_KEY}:.*/${PROJECT_IMAGETAG_KEY}: ${NEW_DEPLOYMENT_TAG}/g" ${PROJECT_NAME}/${PROJECT_CONFIG_PATH}/${PROJECT_IMAGETAG_FILEPATH} || true
cd ${PROJECT_NAME} && git add . > /dev/null && git commit -m "[flux][${CLUSTER_ENV}] image has been updated" > /dev/null
i=0
until git pull --rebase origin ${CONFIG_PROJECT_DEFAULT_BRANCH} > /dev/null && git push origin ${CONFIG_PROJECT_DEFAULT_BRANCH} > /dev/null; do
  if [[ "$i" -gt 5 ]]; then
    echo "Please check git permissions."
    exit 1
  fi
  sleep 5
  ((i=i+1))
done
