# Scripts

This repository contains a collection of scripts that automate various tasks related to Python, Google Workspace user validation, Docker installation, GitHub Actions workflow triggering, and Azure Automation scheduling.

## Description

- **install_prerequisites.sh** - This script simplifies the installation of prerequisites, such as Docker, for the smooth execution of tasks.

- **google-workspace-validate-users.py** - This Python script validates users in Google Workspace. It checks the validity and existence of user email addresses within the workspace and create userlist csv file.

   **_NOTE_**: Update the domain_name for google workspace user domain validation in `google-workspace-validate-users.py` script.
 
- **google-workspace-user.sh** - This script creates a virtual environment and installs Python requirements for a script **google-workspace-validate-users.py** . It then calls the `google-workspace-validate-users.py` and taking input as user from github actions.

   **_NOTE_**: Update the google_auth_email_id used for google workspace authentication in `google-workspace-user.sh` script.

- **github_trigger.ps1** - This PowerShell script triggers a GitHub Actions workflow by making a POST request to the GitHub API. It uses a custom event type to initiate the workflow. It will send a request to trigger the specified GitHub Actions workflow.

- **scheduler.ps1** - This PowerShell script uses the Azure PowerShell module to create an Azure Automation schedule and register a runbook with the schedule. It outputs the details of the created schedule.



