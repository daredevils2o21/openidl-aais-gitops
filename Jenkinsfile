/*
Edited to alpine version because its cleaner than ubuntu
*/
pipeline {
	agent {
    	kubernetes {
			containerTemplate {
			name 'alpine'
			image 'docker-cbcore.prodlb.travp.net/builder/awshelper:current-alpine'
			ttyEnabled true
			command 'cat'
			}
    	}
  	}
	environment {
        ansible_python_interpreter='/usr/local/bin/python3'
		env = "dev"
		org = "trv"
		repo_user_token = credentials('gitops_repo_user_token')
		access_id = credentials('baf-user')
		access_key = credentials('baf-user-secret-access-key')
 	}
	parameters {
        choice(
            choices: ['', 'vault', 'vault_cleanup', 'new_org', 'baf_image', 'deploy_network', 'reset', 'chaincode_default_channel', 'chaincode_new_channel', 'add_new_channel', 'add_new_org', 'join_peer_carrier_1', 'join_peer_carrier_2', 'register_users'],
            description: '',
            name: 'REQUESTED_ACTION')
    }
	stages {
		stage('check_parameters_step') { 
			when{
				expression { params.REQUESTED_ACTION == '' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){

				sh '''export ORDERER_TLS_CERT=$(aws secretsmanager get-secret-value --secret-id ${env}-orderer-tls)''' 
				sh ''' echo $ORDERER_TLS_CERT'''
				error("Invalid target environment: ${params.REQUESTED_ACTION}")
				}
			}
		}
   		stage('Install Dependencies') {
			steps {
				container('alpine'){
					sh 'apk --update --upgrade add gcc musl-dev jpeg-dev zlib-dev libffi-dev cairo-dev pango-dev gdk-pixbuf-dev'
				}
				container('alpine') {  
					sh "apk -q update && apk -q add ansible py3-requests-oauthlib py-yaml jq openssl"				
				}
				container(name: 'alpine') {
					sh '''
						chmod +x ./pyathena.sh
						./pyathena.sh && rm ./pyathena.sh
						'''
				}
				container('alpine'){
					sh 'pip3 install --upgrade pip'
				}
				container('alpine') {  
					sh "pip3 install openshift ansible docker"				
				}
				container(name: 'alpine') {
			sh '''
				ansible --version
				which python
				ansible-galaxy collection install community.docker
				ansible-galaxy collection install community.kubernetes:==1.2.1
			'''
			}
				container('alpine') { 
					sh '''
						ansible --version
						ansible-playbook --version
						ansible-galaxy --version
						'''
				}
				container(name: 'alpine') {
					sh '''
						curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
						chmod 700 get_helm.sh
						./get_helm.sh
					'''
				}
			container(name: 'alpine') {
					sh '''
							curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
							install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
						'''
				}
			container(name: 'alpine') {
			sh '''
				kubectl version --client
				helm version
				'''
				}
			}
		}
		stage('EKS check') {
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh 'aws eks update-kubeconfig --region us-east-1 --name trv-dev-blk-cluster'
						}
					}
				}
			}
		}
		stage('Ansible_vault') { 
			when{
				expression { params.REQUESTED_ACTION == 'vault' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook vault-setup.yml -i ./inventory/ansible_provisioners \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
							
						}
					}
				} 
			}
		}
		stage('Ansible_vault_cleanup') { 
			when{
				expression { params.REQUESTED_ACTION == 'vault_cleanup' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook vault-cleanup.yml -i ./inventory/ansible_provisioners \
							-e "action=vault_cleanup" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_new_org') { 
			when{
				expression { params.REQUESTED_ACTION == 'new_org' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''export ORDERER_TLS_CERT=$(aws secretsmanager get-secret-value --secret-id ${env}-orderer-tls) 
							ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=new_org" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "org_json='${ORDERER_TLS_CERT}'" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_baf_image') { 
			when{
				expression { params.REQUESTED_ACTION == 'baf_image' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook baf-image.yml -i ./inventory/ansible_provisioners \
							-e "action=baf_image" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_deploy_network') { 
			when{
				expression { params.REQUESTED_ACTION == 'deploy_network' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''aws ecr get-login-password | docker login --username AWS --password-stdin $(aws sts get-caller-identity --query Account --output text).dkr.ecr.us-east-1.amazonaws.com \
							ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=deploy_network" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=nv.repo_user_token" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_reset') { 
			when{
				expression { params.REQUESTED_ACTION == 'reset' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=reset" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=nv.access_id" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_chaincode_default_channel') { 
			when{
				expression { params.REQUESTED_ACTION == 'chaincode_default_channel' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=chaincode" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "extra_vars='-e add_new_org=true'" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_chaincode_new_channel') { 
			when{
				expression { params.REQUESTED_ACTION == 'chaincode_new_channel' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=chaincode" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "channel_name=anal-${org}" \
							-e "extra_vars='-e add_new_org=true'" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_add_new_channel') { 
			when{
				expression { params.REQUESTED_ACTION == 'add_new_channel' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=add_new_channel" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_add_new_org') { 
			when{
				expression { params.REQUESTED_ACTION == 'add_new_org' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''export ORG_MSP=$(aws secretsmanager get-secret-value --secret-id ${env}-${org}-msp \
							--version-stage AWSCURRENT | jq -r .SecretString) \
							ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=add_new_org" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_join_peer_carrier_1') { 
			when{
				expression { params.REQUESTED_ACTION == 'join_peer_carrier_1' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=join_peer" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_join_peer_carrier_2') { 
			when{
				expression { params.REQUESTED_ACTION == 'join_peer_carrier_2' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
							-e "action=join_peer" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "channel_name=anal-${org}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('Ansible_register_users') { 
			when{
				expression { params.REQUESTED_ACTION == 'register_users' }
			}
			steps {
				withAwsCli(credentialsId: 'OpenIDL', defaultRegion: 'us-east-1'){
					dir('ansible-automation'){
						container(name: 'alpine') {
							sh '''ansible-playbook pre-register-users.yml -i ./inventory/ansible_provisioners \
							-e "action=register_users" \
							-e "@./trv-config-dev.yml" \
							-e "access_id=${access_id}" \
							-e "access_key=${access_key}" \
							-e "gitops_repo_user_token=${repo_user_token}" \
							-e "ansible_python_interpreter=/usr/local/bin/python3"'''
						}
					}
				}
			}
		}
		stage('BDH Scan'){ 
			steps{
					//hub_detect '--detect.project.version.name="${detectVersionName}" --detect.project.name="${ucdComponent}"'
					echo 'skipping Black Duck Step'
			}
		}
	}
}