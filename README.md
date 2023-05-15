# Introduction 
This document provides steps to import this "az-test-pipeline" repo in order to onboard a new application to the FXE Azure DevOps organization.  

# Getting Started

1.	In the Controller Tier Project, create a new repository  

    ![Screenshot of creating a new repo](/.assets/CreateRepo.png)  


2.	In the empty repository, deselect "Add a README" and select "Import"  

    ![Screenshot of importing a repo](/.assets/ImportRepo.png)
  

3.  In the Common project, copy the desired Common repo URL, then "Generate Git Credentials" and copy the password to your clipboard for use in step 4.  

    ![Screenshot of Common repo URL and authentication password](/.assets/ImportAuthentication.png)


4.	In the Controller Tier project, clone the Common repo into the new repo with the URL and password obtained from Step 3.

    `https://fxe-data-mgmt@dev.azure.com/fxe-data-mgmt/common/_git/az-test-pipeline`

    ![Screenshot of cloning the Common repo to the new repo](/.assets/CloneURLandKey.png)


5.	Rename the new repo as needed, but in this example, the "az-test-pipeline" repo was cloned into the new repo in the Controller Tier project in order to build a pipeline.

    ![Screenshot of cloning the Common repo to the new repo](/.assets/SuccessfulRepoImport.png)


6.  Change the `backend.tf` file to point to the new state file by editing line 5 to update the key, as indicated below

    ```
    terraform {
        backend "azurerm" {
            storage_account_name = "storage-ac-name-xxx"
            container_name       = "platform-terraform-state"
            key                  = ##editMe "<env>.<pipeline>.tfstate"
            subscription_id      = "subscription-name"
            resource_group_name  = "rg-xxxxx-xxxx"
        }
    }
    ```

7.  Change the `terraform.yml` file to update the `secureVarsFile` and `deploymentEnvironment` parameters with the appropriate environment, as shown below

    ```
    name: $(SourceBranchName)-$(Date:yyyyMMdd)-$(Rev:rrr)

    resources:
    repositories:
    - repository: templates
        type: git
        name: common/azure-pipeline-templates
        ref: refs/heads/main

    trigger:
    branches:
        include:
        - main

    pool: terraform

    stages:
    - template: terraform/terraform.yaml@templates
        parameters:
        secureVarsFile: ##editMe '<env>.env'
        deploymentEnvironment: ##editeMe <env>
        terraformVersion: latest
    ```
  
8.  Create a new pipeline.
    - Navigate to the Pipelines pane
    - Connect to Azure Repos Git
    - Select the new repo
    - Configure your pipeline by selecting "Existing Azure Pipeline YAML File"
    - Validate the branch
    - Click the drop down menu for "Path" and select the file path for the YAML file

        ![Pipeline Creation Screenshot](/.assets/PipelineCreation.png)

    - Review your pipeline YAML and click "Run" to build your new pipeline