public with sharing class SendSurveyInviteController {
    @AuraEnabled
    public static List<SurveyVersion> getSurveys()
    {
        if (Schema.SObjectType.SurveyVersion.isAccessible() && 
           Schema.SObjectType.SurveyVersion.fields.Name.isAccessible() &&
           Schema.SObjectType.SurveyVersion.fields.SurveyId.isAccessible() &&
           Schema.SObjectType.SurveyVersion.fields.SurveyStatus.isAccessible())
        {
            return [SELECT Name, SurveyId, SurveyStatus
                    FROM SurveyVersion
                    ORDER BY Name];
        } else {
            return null;
        }
    }
    
    @AuraEnabled
    public static String createInvitation(String config, String surveyId, String recordId)
    {
        String resultLink = '';
        
        // get the MDT for settings: query, networkid, lookup id field
        List<Survey_Setting__mdt> settings = [SELECT NetworkId__c, Lookup_Id_Field__c,
                                               Participant_Lookup_Query__c, Participant_Lookup_Query_Id_Field__c
                                               FROM Survey_Setting__mdt
                                               WHERE DeveloperName = :config];
        
        if (settings.size() > 0)
        {
            Survey_Setting__mdt setting = settings[0];
        
            resultLink = createInvitation(surveyId,
                                          recordId,
                                          setting.NetworkId__c,
                                          setting.Lookup_Id_Field__c,
                                          setting.Participant_Lookup_Query__c,
                                          setting.Participant_Lookup_Query_Id_Field__c);
        }
        return resultLink;
    }
    
    private static String createInvitation(String surveyId, String recordId, String nwId, String luField, String luQuery, String luQueryField)
    {
        // process the query to get the participant id
        String contextId = recordId; // for substitution into the query, below
        sObject lookup = Database.query(luQuery);
        
        String ParticipantId = (String)lookup.get(luQueryField);
        
        SurveyInvitation invite = SurveyInvitationManager.createSurveyRequestWithLookup(surveyId,
                                                                                        ParticipantId,
                                                                                        nwId,
                                                                                        luField,
                                                                                        recordId);
        insert invite;
        
        return invite.InvitationLink;
    }
}