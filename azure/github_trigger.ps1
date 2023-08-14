
Connect-AzAccount -Identity
#region variables
$GithubToken = "GIT_TOKEN" # Personal Access Token stored as environment variable
$GithubUserName = "GITHUB_USER_NAME" 
$GithubRepo ="GITHUBREPO" 

<#

       Triggering Github Actions from a webhook call

#>

$uri = ('https://api.github.com/repos/{0}/{1}/dispatches' -f $GithubUserName, $GithubRepo)

#region web request call
$Body = @{

    event_type = 'nuke-azure-sandbox-access'
    client_payload = @{
    resourceGroup='RESOURCE_GROUP'
    scheduler='SCHEDULER_NAME'
    runbook = 'RUNBOOK_NAME'
    #assignee = 'ASSIGNEE'
    subscription_id = 'SUBSCRIPTION_ID'

    
  
}

} | ConvertTo-Json


$params = @{
    ContentType = 'application/json'
    Headers     = @{
        'authorization' = "token $($GithubToken)"
        'accept'        = 'application/vnd.github.everest-preview+json'
    }
    Method      = 'Post'
    URI         = $Uri
    Body        = $Body
}

Invoke-RestMethod @params -verbose
#endregion 
