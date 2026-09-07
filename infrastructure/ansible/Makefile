    init:
	python3 -m pip install --user --upgrade pip ansible ansible-lint
	ansible-galaxy install -r requirements.yml

    vault-edit:
	ansible-vault edit inventories/lab/group_vars/vault.yml --vault-id dev@lab@~/.ansible/vault_lab.txt

    k3s:
	ansible-playbook playbooks/10-deploy-k3s.yml

    kubeconfig:
	ansible-playbook playbooks/20-kubeconfig-to-devsecops.yml

    splunk-operator:
	ansible-playbook playbooks/30-deploy-splunk-operator.yml

    splunk:
	ansible-playbook playbooks/40-deploy-splunk-enterprise.yml

    sc4s:
	ansible-playbook playbooks/50-deploy-sc4s.yml
