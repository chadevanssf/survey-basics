# survey-basics

Some helper functions to get up and running with Salesforce Surveys. Not complete yet, but have some interesting examples.

<!-- markdownlint-disable MD007 -->
<!-- TOC -->

- [survey-basics](#survey-basics)
    - [Examples](#examples)
        - [SurveyInvitation Link Manager](#surveyinvitation-link-manager)
    - [Deployment Options](#deployment-options)
        - [Deploy using SFDX](#deploy-using-sfdx)
        - [Deploy via Metadata API](#deploy-via-metadata-api)
    - [Development](#development)
        - [Manual Setup Steps](#manual-setup-steps)
        - [SFDX Dev Hub Login](#sfdx-dev-hub-login)
        - [Pull Latest](#pull-latest)
        - [Push latest](#push-latest)

<!-- /TOC -->
<!-- markdownlint-enable MD007 -->

## Examples

### SurveyInvitation Link Manager

Does the creation of a Private SurveyInvitation. Example uses a SurveyInvitation linked to a Case and a Contact. Can be used from Process Builder, or Apex. See [SuveyLinkManager](https://github.com/chadevanssf/survey-basics/blob/master/force-app/main/default/classes/SurveyLinkManager.cls) for details.

## Deployment Options

### Deploy using SFDX

[![Deploy](https://deploy-to-sfdx.com/dist/assets/images/DeployToSFDX.svg)](https://deploy-to-sfdx.com/deploy?template=https://github.com/chadevanssf/survey-basics)

### Deploy via Metadata API

<!-- markdownlint-disable MD033 -->
<a href="https://githubsfdeploy.herokuapp.com">
  <img alt="Deploy to Salesforce"
       src="https://raw.githubusercontent.com/afawcett/githubsfdeploy/master/deploy.png">
</a>
<!-- markdownlint-enable MD033 -->

## Development

### Manual Setup Steps

After creation of a scratch org, you will need to enable the surveys product, under Setup > Feature Settings > Survey > Survey Settings.

Modify the Sharing Settings (Setup > Security > Sharing Settings) for the User object to have Public Read Only access.

Assign the default Surveys permission set

```bash
sfdx force:user:permset:assign -n "SurveyCreator"
```

Once you create a Community, you will have to modify the default user permissions to have Public access for the Survey Response object. Setup > User Interface > Sites and Domains > Sites, select the correct Community (not the site url), click Public Access Settings, click Object Settings, select Survey Responses, edit the settings to have Edit rights to the object.

To leverage the Lightning Component to select the Survey and send out the link, like on a record home page or through a Lightning Flow, you will also have to create a record for the custom metadata type 'Survey Settings'

- Label: anything you want to use
- Survey Setting Name: A dev name that you will need to refer to in the component configuration
- Network Name or Id: The name or id of the network to use
- Lookup Id Field: The name of the field on the survey that links to the parent context record
- Participant Lookup Query: How are you going to get the value on the parent record to know what the participant is? This is something like 'SELECT ContactId FROM Case WHERE Id = :contextId', must have the :contextId as the key variable that gets substituted in
- Participant Lookup Query Id Field: This is the field that is returned from the above query, so in this example it is 'ContactId'

### SFDX Dev Hub Login

sfdx force:auth:web:login –a surveys

### Pull Latest

```bash
rm -r ./mdapi/

mkdir ./mdapi

sfdx force:mdapi:retrieve -w 5 -r ./mdapi/ -u surveys -p "SurveyEnhancements"

unzip -aou ./mdapi/unpackaged.zip -d ./mdapi/

rm ./mdapi/unpackaged.zip

sfdx force:mdapi:convert -r ./mdapi
```

### Push latest

```bash
sfdx force:source:convert -d ./mdapi/SurveyEnhancements/

sfdx force:mdapi:deploy -d ./mdpai/SurveyEnhancements/ -a surveys
```