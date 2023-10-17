#!/bin/bash
git clone -b release-2.23 https://github.com/kubernetes-sigs/kubespray.git
rm -rf kubespray-venv
python3.12 -m venv kubespray-venv
source kubespray-venv/bin/activate
#bumping ruamel.clib 0.2.7->0.2.8
cp -f requirements.txt kubespray/
cd kubespray
pip install -U -r requirements.txt
cd ..
mkdir -p clusters/k8s-cluster
declare -a IPS=(175.30.0.2 175.30.0.3 175.30.0.4 175.30.0.5 175.30.0.6)
CONFIG_FILE=clusters/k8s-cluster/hosts.yaml python3 kubespray/contrib/inventory_builder/inventory.py ${IPS[@]}
ansible-playbook -i clusters/k8s-cluster/hosts.yaml -e @clusters/k8s-cluster/cluster-config.yaml --user=k8s --become --become-user root kubespray/cluster.yml

