### **Caveat**
We are not saying that the deployment given by AAIS for the open-idl technical configuration does not work as given by them.
What the changes below refer to is, when replacing *one* technology "github actions" with a Travelers production level ready technology such as TFE and Cloudbees (aka Jenkins), their standard deployment does not work without such modifications.

Justification to remove github actions is thus that the github actions required by AAIS are not available at the time of writing this.

# **Here is a list of changes needed to be made to** 
- Deploy within Travelers Tech Stack
- Make deployment operational

## **Summary**
### **Current Changes**
- GitHub actions to Terraform Enterprise anc CloudBees Jenkins
- Building, storing and managing Docker image in Travelers repository
  - Removed Github dependency inside Blockchain-automation Framework (BAF) and replaced it by packing Docker images with necessary scripts. This makes with project containerized.
- Terraform code modifications to get ingress controller to properly deploy
- Ansible code modifications to 
    - Remove FluxCD dependency (FluxCD is software the listens for code changes in a github repo and automatically deploys to a K8s cluster. Not a vetted software)
      - Remove Github pushing and pulling roles
      - Added code to replace the functionality of FluxCD
        - This functionality was replaced by storing the files inside the K8 cluster. This makes the project self contained in regards to storing config files.
    - Removed aws cli setup, helm and kubectl setup from BAF environment-setup because these tools were installed during image create via Dockerfile and by having these steps down afterward created issues with aws setup.
    - To create a working Jenkins pipeline that utilizes a K8's agent inside Jenkins
      - Removed all community.kubernetes.k8s dependencies in ansible and replaced them with kubectl commands. 
        - When a deployment/job/pod was to be created, ansible modules to create .yaml from .yaml.j2 were created.
    - Parameterized Jenkins to build with needed parameters
    - Added task to apply the value file for the k8 components in OpenIDL-POC/blockchain-automation-framework/platforms/hyperledger-fabric/configuration/roles/k8_component/tasks/main.yaml 
    - Reworked chaincode installation procedure because original deployment had wrong looping parameter, which caused chaincode to install by number of orderers and not peers. This includes changes to the .j2 template to create unique deployment names for helm.
    - Modify global-values-dev-carrier.yaml to include our own env, domain, and subdomain. Template not provided. OpenIDL-POC/openidl-k8s/global-values-dev-carrier.yaml.
## **Changes by vendor during Travelers development**
  - During development by the Travelers team, the AAIS team made several "aesthetic" changes to their directory and code structure. The Travelers team were not made aware of such changes until 4 months later. Their changes did not affect the deployment other than having to rework a pipeline to point to other directories. We did not make these changes to our development pipeline because some changes were deemed counterintuitive, i.e. placing a terraform module that have its own file, for s3, in a script name cloudtrail, where cloudtrail and a singleton s3 resided, all while haveing separate terraform files for other s3 buckets.
### **Upcoming changes**
- Code modifications to migrate from HAProxy to Travelers approves NginX load balancing

---
---
## **Deploy within Travelers Tech Stack**
OpenIDL extensively relies on GitHub and Github actions for automation.
Their out of the box deployment requires Terraform actions within Github to create the AWS architecture as well as Ansible for environment setup within the AWS resources provisioned.

As Github actions is not a whitelisted service for Travelers we had to modify OPenIDL's AWS deployment to work with the whitelisted service Terraform Enterprise (TFE).

### **Modification for TFE**
Modification to deploy with TFE was to create a terraform file at the base level of the github repository. This is currently the only method for TFE to automatically deploy services once the repository is updated with a merge.
An example of this change:

Previous repository (top level)
```
📦openidl-aais-gitops
 ┣ 📂.git
 ┣ 📂.github
 ┣ 📂ansible-automation
 ┣ 📂aws
 ┣ 📂blockchain-automation-framework
 ┣ 📂docs
 ┣ 📜.DS_Store
 ┣ 📜.gitignore
 ┣ 📜LICENSE
 ┗ 📜README.md
 ```

 TFE Modification of repository (top level)
```
📦OpenIDL-POC
 
 ┣ 📂.git
 ┣ 📂.github
 ┣ 📂ansible-automation
 ┣ 📂aws
 ┣ 📂blockchain-automation-framework
 ┣ 📂docs
 ┣ 📜LICENSE
 ┣ 📜README.md
 ┣ 📜aws_module.tf ☂
 ┣ 📜k8s_module.tf ☂
 ┣ 📜outputs.tf ☂
 ┣ 📜providers.tf ☂
 ┣ 📜terraform.auto.tfvars ☂
 ┣ 📜variables.tf ☂
 ┗ 📜versions.tf ☂

 ```
 Where the ☂ denotes the added files.
 #### **Brief file explanation**
aws_module.tf : Contains a terraform module who's source is ```./aws/aws_resources ```

k8s_module.tf  : Contains a terraform module who's source is ```./aws/k8s_resources ```

outputs.tf : outputs for modules contained in 
- aws_module.tf
- k8s_module.tf

providers.tf : Terraform provider file

terraform.auto.tfvars : Variable file for TFE to use automatically

variables.tf : Contains the variables declaration

versions.tf : Contains information on Terraform version used by Travelers 

It should also be noted that we dismissed the need for separate Terraform configuration backend files on the cloud as this is the practical approach for TFE.

---

### **Make deployment operational**

#### **BAF Images**
The Blockchain Automatic Framework (BAF) docker image was built and placed inside the Elastic Container Repository (ECR) in the experimental account. This was done because the repository name given to us for this image was invalid and no one knew the correct repository in which the image was hosted externally. However, place this image and all future images into ECR will be our practice in the future because our normal Travelers AWS accounts have no http/https to docker repositories and all images used inside Travelers AWS must be scanned with "twistlock" (PCC) and put into ECR and/or Nexus.

Inside the deployment for any pod that utilized BAF, a redundant `git pull` was performed. This was deemed potentially dangerous if code was modified in parallel and potentially dangerous as this required constantly storing and passing git credentials. 
We removed this Github dependency inside Blockchain-automation Framework (BAF) and replaced it by packing Docker images with necessary scripts. Therefore any BAF modifications only need one managed `git pull` and a docker build. This makes with project containerized.

#### **Haproxy** 
Haproxy configuration in terraform does not deploy from out-of-box configuration. Multiple problems had to be addressed to correct this

- Terraform syntax for location of files was incorrect
    - Out-of-box
        ```java
        "${file("FILE")}"
        ```
    - Travelers modification
        ```java
        "${file("\${path.module}FILE")}"
        ```
    Where FILE is file located in a directory of the deployment.

- haproxy deployment configuration was ill-defined. Here is their original deployment
```python
resource "helm_release" "blk_haproxy" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  name = "haproxy-ingress"
  chart ="resources/haproxy-blk-cluster"
  timeout = 600
  force_update = true
  wait = true
  wait_for_jobs = true
  values = ["${file("resources/haproxy-blk-cluster/values.yaml")}"]
}
```
this had to be modified to 

```python
resource "helm_release" "blk_haproxy" {
  depends_on = [data.aws_eks_cluster.blk_eks_cluster, data.aws_eks_cluster_auth.blk_eks_cluster_auth, kubernetes_config_map.blk_config_map]
  provider = helm.blk_cluster
  cleanup_on_fail = true
  name = "haproxy-blk-ingress"
  chart ="${path.module}/resources/haproxy-blk-cluster"
  timeout = 600
  ☂force_update = false
  ☂wait = false
  ☂wait_for_jobs = false
  ☂values = ["${file("${path.module}/resources/haproxy-blk-cluster/values.yaml")}"]
  ☂namespace="ingress-controller"
  ☂create_namespace = true

}
```
where ☂ denotes Travelers working modifications. Also in the file 
```/aws/k8s_resources/resources/haproxy-app-cluster/templates/namespace-rbac.yaml``` 

and 

```/aws/k8s_resources/resources/haproxy-blk-cluster/templates/namespace-rbac.yaml```

the Namespace declaration was removed, i.e.

```
apiVersion: v1
kind: Namespace
metadata:
  name: {{ .Values.metadata.namespace }}
```
- Note: the current versions of RBAC that is being deployed is deprecated and will no longer be in use as of Kubernetes version 1.22. Currently we are using version 1.20

Without these changes to haproxy, vault would not set up correctly, however this still needs further investigation as to making this more autonomous. If HAProxy is replaced by Nginx, as is Travelers preference this can be bypassed.

#### **Ansible Deployments**
No longer is the deployment 

```python
ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
-e "action=new_org_prereq" 
```
required as the need to fluxCD has been removed, haproxy had already been created via Terraform in a previous step and the current setup uses haproxy over ambassador. See FluxCD ratification section below.
- #### **FluxCD Ratification**
FluxCD was not a technology listed on the white-paper of AAIS open-idl during the Travelers deployment, yet this technology resided inside the tech-stack itself. Due to this and also the fact that FluxCD requires GitHub credentials to be stored, passed and used multiple times during the deployment, we removed this functionality. The purpose of FluxCD was to listen for a helm chart to be pushed to Github, then FluxCD would download this helm chart from GitHub and deploy it, using helm, into the cluster. We replaced FluxCD with a simple command to helm install the created chart and a simple command to install the valuefile as a config map, using kubectl, into the default namespace of the cluster. Now no GitHub credentials are needed anywhere in the BAF CI/CD portion of the deployment, therefore we removed all ansible role that were performing Github pushing and pulling.

In the file 

```blockchain-automation-framework/platforms/shared/configuration/roles/helm_lint/tasks/main.yaml```

a role was created to install the created helm chart using helm. This role also checks for the completion of a previous role which checks the validity of the helm chart. An additional step was added to save the value files configmap in the default namespace. These addons were included to get helm charts deployed without the use of FluxCD. Furthermore, another reason why we removed FluxCD is that it was not compatible with GitHub Enterprise at the time. See code snips below.


For helm install:
```python 
# Execute helm install. If this fails, fix the errors.
#This was a TRV addon to get helm charts deployed without the use of FluxCD
- name: "Run helm install"
  shell: |
    helm install -f "./build/test/{{metadata.name}}.yaml" "{{ component_name }}" "{{playbook_dir}}/../../../../{{chart_path}}/{{charts[helmtemplate_type]}}"
  when:
    - value_stat_result.stat.exists == True
    - lint_stat_result.stderr_lines | length == 0
```
For saving config files:
```python
- name: "Saving value files configmap"
  shell: |
    kubectl create configmap {{metadata.name}} --from-file "./build/test/{{metadata.name}}.yaml" -n default
```

For the ansible deployment
```python
ansible-playbook fabric-network.yml -i ./inventory/ansible_provisioners \
-e "action=new_org
```
which relays on the setup established in 

```blockchain-automation-framework/platforms/shared/configuration/environment-setup.yaml```

All roles but the ```setup/vault``` were removed because 
- setup/kubectl
- setup/aws-cli

come packed already with the image used by this deployment, and having ```aws-cli``` being reinstalled from apt breaks docker installed version due to apt having aws version < 2

In the file

```blockchain-automation-framework/platforms/hyperledger-fabric/configuration/launch-new-organization.yaml```

all roles that have github dependency were modified to remove said github dependency.

#### **Jenkins Pipeline**
- AAIS started building a Jenkins pipeline **after** we had already begun ours. Theirs, however, relies on a deprecated technology, which is now open-source, Ansible Tower. 
- We use a kubernetes agent in our pipeline, however, the AAIS ansible deployment  relies on community.kubernetes.k8s modules. Therefore, we had to reqork the ansible for all module containing community.kubernetes.k8s. The remaining modified ansible deployment is now agnostic to CI/CD implementation, i.e. this makes ansible generic enough to use other agents for Jenkins deployment.
- This community.kubernetes.k8s dependency was replaced by using ansible to create a kubernetes manifest from a jinja2 template, then utilizing kubectl to apply ansible created manifest files. The use of kubectl was also extended to replace other community.kubernetes.k8s modules such as namespace and configmap creation. Finally, kubectl replaced community.kubernetes.k8s in deleting; pods created by manifest file; namespaces and configmaps.

An example of community.kubernetes.k8s replacement can be shown in the file

```ansible-automation/roles/baf/pre-register-users/tasks/main.yaml```

where the original community.kubernetes.k8s command supplied by AAIS
```python
- name: Delete user script pod
  community.kubernetes.k8s:
    name: pre-register-user-script
    namespace: vault
    api_version: v1
    kind: Pod
    state: absent
    wait: yes
```
was replaced with 
```python
- name: Delete user script pod
  ignore_errors: yes
  shell: |
    kubectl delete pod pre-register-user-script -n vault
```

- Two pipelines were created in Jenkins, one to model the App cluster pipeline, and one to model the Blockchain cluster pipeline.
- Both Jenkins pipelines were parameterized to segregate the different steps as outlined in AAIS's github workflows for the App and Blockchain clusters.

#### **K8 Components Value File**
We were required to add a task to apply the value file for the k8 components in order to address some deployments that weren't helm.

In the file 

```openidl-aais-gitops/blockchain-automation-framework/platforms/hyperledger-fabric/configuration/roles/k8_component/tasks/main.yaml```

we added the following:
```python
# This task applies the value file for the k8 components
- name: "apply {{ component_type }} file for {{ component_type_name }}"
  shell: |
    kubectl apply -f {{ values_file }}
  vars:
    values_file: "{{ release_dir }}/{{ component_type_name }}/{{ component_type }}.yaml"
    type: "{{ component_type }}"
```

#### **Chaincode Installation Procedure**
We were required to modify the chaincode installation procedure because the original deployment, supplied by AAIS, had an incorrect looping parameter. This, in turn, caused chaincode to install by number of orderers and not peers. This includes changes to the jinja template to create unique deployment names for helm.

In the file

```blockchain-automation-framework/platforms/hyperledger-fabric/configuration/roles/create/chaincode/install/tasks/valuefile.yaml```

the original task can be found iterating over orderers instead of its intended iteration over peers as shown below:

```python
# Nested task for chanincode installation
- name: "Create value file for chaincode installation - nested"
  include_role:
    name: helm_component
  vars:
    orderer_address: "{{ orderer.uri }}"
    type: "install_chaincode_job"
    peer_name: "{{ peer.name }}"
    peer_address: "{{ peer.name }}.{{ namespace }}:{{ peer.grpc.port }}"
    component_name: "install-{{ peer.chaincode.name }}-{{ peer.chaincode.version | replace('.','-')}}"
    component_chaincode: "{{ peer.chaincode }}"
    fabrictools_image: "hyperledger/fabric-tools:{{ network.version }}"
    alpine_image: "{{ docker_url }}/alpine-utils:1.0"
  loop: "{{ network['orderers'] }}"
  loop_control:
    loop_var: orderer
  when: install_chaincode.resources|length == 0
  ```

  We adapted and overcame this problem by modifying the iteration of orderers as shown below:
  ```python
# Nested task for chanincode installation
- name: "Create value file for chaincode installation - nested"
  include_role:
    name: helm_component
  vars:
    orderer_address: "{{ orderer.uri }}"
    orderer_name: "{{ orderer.name }}"
    type: "install_chaincode_job"
    peer_name: "{{ peer.name }}"
    peer_address: "{{ peer.name }}.{{ namespace }}:{{ peer.grpc.port }}"
    component_name: "{{ orderer.name }}-{{ peer.chaincode.name }}-{{ peer.chaincode.version | replace('.','-')}}"
    component_chaincode: "{{ peer.chaincode }}"
    fabrictools_image: "hyperledger/fabric-tools:{{ network.version }}"
    alpine_image: "{{ docker_url }}/alpine-utils:1.0"
  loop: "{{ network['orderers'] }}"
  loop_control:
    loop_var: orderer
  when: install_chaincode.resources|length == 0
  ```

#### **Carrier Specific Global Values**
As part of the app cluster deployment, the carrier global values file needs to be updated to include specific values relating to the carrier, such as environment, domain, and subdomain. At the time of implementation, there was no template file for this required, manual action. 

See file below:

```openidl-k8s/global-values-dev-carrier.yaml```

#### **NGINX**
At some point we will have to pursue a change in load balancing and network communications from haproxy to NGINX as NGINX is Travelers pattern.



---