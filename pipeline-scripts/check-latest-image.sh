# PROJECT_DEPLOYMENT_NAME: name of the current deployment
# NEW_DEPLOYMENT_TAG: latest pipeline image tag
for i in `seq 1 30`; do
  aws lambda invoke --function-name arn:aws:lambda:ap-southeast-1:<account_id>:function:<function_name> --region ap-southeast-1 --payload '{ "type": "fetch", "name": "'"${PROJECT_DEPLOYMENT_NAME}-${CLUSTER_ENV}"'" }' response.json > /dev/null
  export DEPLOYED_TAG=$(cat response.json)
  echo "Checking..."
  if [ "${DEPLOYED_TAG:1:-1}" == "${NEW_DEPLOYMENT_TAG}" ]; then
    echo "Deployment is complete!";
    exit 0
  fi
  echo "Deployment is not ready!"
  rm response.json
  sleep 30;
done
