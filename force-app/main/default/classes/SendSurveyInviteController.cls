public with sharing class SendSurveyInviteController {
    @AuraEnabled
    public static List<SurveyVersion> getSurveys()
    {
        return [SELECT Name,SurveyId,SurveyStatus FROM SurveyVersion ORDER BY Name];
    }
    
    @AuraEnabled
    public static String createInvitation(String config, String surveyId, String recordId)
    {
        // get the MDT for settings: query, networkid, lookup id field
        List<Survey_Setting__mdt> settings = [SELECT NetworkId__c, Lookup_Id_Field__c,
                                               Participant_Lookup_Query__c, Participant_Lookup_Query_Id_Field__c
                                               FROM Survey_Setting__mdt
                                               WHERE DeveloperName = :config];
        Survey_Setting__mdt setting = settings[0];
        
        // process the query to get the participant id
        String contextId = recordId; // for substitution into the query, below
		sObject lookup = Database.query(setting.Participant_Lookup_Query__c);
        
        String ParticipantId = (String)lookup.get(setting.Participant_Lookup_Query_Id_Field__c);
        
        SurveyInvitation invite = SurveyLinkManager.createSurveyRequest(surveyId, 
                                                                        ParticipantId, 
                                                                        setting.NetworkId__c, 
                                                                        setting.Lookup_Id_Field__c, 
                                                                        recordId);
        insert invite;
        return invite.InvitationLink;
    }
}