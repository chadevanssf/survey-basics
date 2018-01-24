# SFDX  App

sfdx force:auth:web:login –a surveys

## Pull Latest

sfdx force:mdapi:retrieve -w 5 -r ./mdapi/ -u surveys -p "SurveyEnhancements"

unzip -a ./mdapi/unpackaged.zip -d ./mdapi/

rm ./mdapi/unpackaged.zip

sfdx force:mdapi:convert -r ./mdapi

## Push latest

sfdx force:source:convert -d ./mdapi/

sfdx force:mdapi:deploy -d ./mdapi/ -u surveys -w 5

## Description of Files and Directories

## Issues
