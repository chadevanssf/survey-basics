# survey-basics

Some helper functions to get up and running with Salesforce Surveys. Not complete yet, but have some interesting examples.

## Examples

### SurveyInvitation Link Manager

Does the creation of a Private SurveyInvitation. Example uses a SurveyInvitation linked to a Case and a Contact. See [SuveyLinkManager](https://github.com/chadevanssf/survey-basics/blob/master/force-app/main/default/classes/SurveyLinkManager.cls) for details.

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

sfdx force:auth:web:login –a surveys

### Pull Latest

rm -r ./mdapi/

mkdir ./mdapi

sfdx force:mdapi:retrieve -w 5 -r ./mdapi/ -u surveys -p "SurveyEnhancements"

unzip -aou ./mdapi/unpackaged.zip -d ./mdapi/

rm ./mdapi/unpackaged.zip

sfdx force:mdapi:convert -r ./mdapi

### Push latest

sfdx force:source:convert -d ./mdapi/