# GitHub Actions Workflow for Azure Sandbox Creation and Cleanup

This repository contains GitHub Actions workflows for automating the creation and cleanup of Azure Sandbox Environment. The workflow is triggered by user input, validates the user's email ID, verifies their existence in Azure Active Directory (AAD), and then performs the necessary actions.

## Workflow Files

The following workflow files are included in this repository:

- azure-provision.yml
- azure-nuke.yml

# Azure Provisioning Workflow (azure-provision.yml)

The azure-provision.yml workflow is triggered when a user inputs their details. 

The workflow performs the following tasks:

- Checkout Repository: The workflow checks out the repository to access the necessary code and configurations.

- Install Dependencies: It installs the required dependencies to execute the subsequent steps.

- Validate User Email: The workflow validates the user's email address. If the email is not valid, the workflow exits, and the provisioning process is halted.

- Invite Guest User: If the user's email is valid and they are not already a guest user, the workflow invites them as a guest user.

- Create Resource Group: A resource group is created for the user to contain their Azure resources.

- Assign Permissions: The workflow assigns necessary permissions to the resource group to ensure the user has appropriate access.

- Create Runbook and Scheduler: A runbook is created to schedule the deletion of the resource group after a specified time. A scheduler is set up to trigger the runbook at the specified time.

- Alert on Slack: If any step fails during the process, an alert is sent to Slack to inform about the failure of the resources creation status.

# Azure Resource Cleanup Workflow (azure-nuke.yml)

The azure-nuke.yml workflow is responsible for resource cleanup. It performs the following tasks:

- Delete Resource Group: The workflow deletes the user's resource group along with all its associated Azure resources.

- Delete Runbook: The workflow removes the runbook created for the user's resource group deletion.

- Delete Scheduler: The scheduler associated with the runbook is deleted.

- Alert on Slack: If any step fails during the process, an alert is sent to Slack to inform about the failure of the resources deletion status.


Please note that this README provides an overview of the workflow. For a more detailed explanation of the workflow steps, configurations, and code samples, refer to the individual workflow YAML files in this repository.

