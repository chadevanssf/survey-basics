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