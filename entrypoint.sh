#!/bin/sh

echo 'This script polls the "EC2 Spot Instance Termination Notices" endpoint to gracefully stop and then reschedule all the pods running on this Kubernetes node, up to 2 minutes before the EC2 Spot Instance backing this node is terminated.'
echo 'See https://aws.amazon.com/jp/blogs/aws/new-ec2-spot-instance-termination-notices/ for more information.'

[ -z "${NAMESPACE}" ] && (echo '[ERROR] Environment variable `NAMESPACE` has no value set. You must set it via PodSpec like described in http://stackoverflow.com/a/34418819' 1>&2; exit 1)
[ -z "${POD_NAME}" ] && (echo '[ERROR] Environment variable `POD_NAME` has no value set. You must set it via PodSpec like described in http://stackoverflow.com/a/34418819' 1>&2; exit 1)

NODE_NAME=$(kubectl --namespace ${NAMESPACE} get pod ${POD_NAME} --output jsonpath="{.spec.nodeName}")
[ -z "${NODE_NAME}" ] && (echo "[ERROR] Unable to fetch the name of the node running the pod \"${POD_NAME}\" in the namespace \"${NAMESPACE}\". Maybe a bug?: " 1>&2; exit 1)

echo "\`kubectl drain ${NODE_NAME}\` will be executed once a termination notice is made."

POLL_INTERVAL=${POLL_INTERVAL:-5}
NOTICE_URL=${NOTICE_URL:-http://169.254.169.254/latest/meta-data/spot/termination-time}

echo "Polling ${NOTICE_URL} every ${POLL_INTERVAL} second(s)"

while http_status=$(curl -o /dev/null -w '%{http_code}' -sL ${NOTICE_URL}); [ ${http_status} -ne 200 ]; do
  echo "notice absent"
  sleep ${POLL_INTERVAL}
done

echo "got spot termination notice"
echo "drain node ${NODE_NAME}"

kubectl drain ${NODE_NAME}
