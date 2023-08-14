<#
Create Scheduler and schedule runbook 
#>

Connect-AzAccount -Identity
$automationAccountName = "AUTOMATION_ACCOUNT_NAME"
$schedulerName="SCHEDULER_NAME"
$runbookName="RUNBOOK_NAME"
$scheduleTime="SCHEDULE_TIME"
$resourceAutomationGroupName="RAGNAME"
New-AzAutomationSchedule -AutomationAccountName $automationAccountName -Name $schedulerName  -StartTime $scheduleTime -ResourceGroupName $resourceAutomationGroupName -OneTime 
$test=(Register-AzAutomationScheduledRunbook -AutomationAccountName $automationAccountName -RunbookName $runbookName -ScheduleName $schedulerName -ResourceGroupName $resourceAutomationGroupName)          
Write-Output "azure account schedule $test"
