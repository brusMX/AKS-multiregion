#/bin/bash
set -e
# Read variables from local .env file
source .env
# Set up the infrastructure
# Create both resource groups
export RG1="${RG_PREFIX}${LOC1}"
export RG2="${RG_PREFIX}${LOC2}"
echo "Creating RG1 ${RG1}"
az group create -n "${RG1}" -l "${LOC1}" --self-destruct 1h
echo "Creating RG2 ${RG2}"
az group create -n "${RG2}" -l "${LOC2}" --self-destruct 1h
# Deploy K8s clusters
export CLUSTER1="${K8S_CLUSTER_NAME_PREFIX}-${LOC1}"
echo "Creating AKS cluster1 ${CLUSTER1}"
az aks create -n "${CLUSTER1}" -g $RG1 \
 -c $NODE_COUNT --enable-addons monitoring --generate-ssh-keys

export CLUSTER2="${K8S_CLUSTER_NAME_PREFIX}-${LOC2}"
echo "Creating AKS cluster2 ${CLUSTER2}"
 az aks create -n "${CLUSTER2}" -g $RG2\
 -c $NODE_COUNT --enable-addons monitoring --generate-ssh-keys

az aks get-credentials -g $RG1 -name myAKSCluster
