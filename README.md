# Release Azure Web Apps with A/B Testing using GitHub Actions Sample

Demonstrates CI/CD for Azure Web Apps using GitHub Actions and ChatOps.

## Overview
In this demo, the process is as follows:

1. Developer creates a branch for changes to code, and pushes changes to the branch.
1. When the developer is ready, a PR is created to merge the changes into master.
1. A team member will review the changes.
1. If changes are approved, an issue comment `/deploy:{slot}` is issued. This triggers a GitHub action to:
   - compile and unit test the code
   - provision resources in Azure (specifically Azure Web App)
   - deploy the packaged code to the specified `slot`
1. After deployment to the slot, another comment is issued to route a percentage of traffic to the slot: `/route:{slot},{percentage}`
1. A message is issued to revert the traffic monitoring in antipation of a slot swap: `/route:{slot},0`
1. After checking changes and monitoring the traffic to the slot, a final message is issued: `/swap:{slot},production` to perform a slot swap.
1. The PR is then merged to master to complete the loop.

## ChatOps
The messages that are issues must be on a single line and have the following syntax:

|Message|Parameters|Notes|Example|
|---|---|---|---|
|`/deploy:{slot}`| `slot` = slot to deploy to|Deploys the code to the specified `slot`|`/deploy:blue`|
|`/route:{slot},{percentage}`| `slot` = slot to deploy to; `percentage` = percentage of traffic to route to slot|Routes `percentage` of traffic to the `slot`|`/route:blue,20`|
|`/swap:{slot1},{slot2}`| `slot1` = source slot; `slot2` = target slot|Swaps slots `slot1` and `slot2`|`/swap:blue,production`|

## Learning
The biggest gotcha is that because the trigger is `issue_comment` and not `pull_request`, the code that is checked out is the current `master` code. I had to update the `deploy` action to fetch the code from the PR so that it would deploy that version of the code rather than the `master` code.