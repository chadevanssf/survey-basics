public class SendSurveyInviteController {
    @AuraEnabled
    public static List<SurveyVersion> getSurveys()
    {
        return [SELECT Name,SurveyId,SurveyStatus FROM SurveyVersion ORDER BY Name];
    }
    
    @AuraEnabled
    public static List<Network> getCommunities()
    {
        return [SELECT Id,Name,UrlPathPrefix FROM Network WHERE Status = 'Live' ORDER BY Name];
    }
    
    @AuraEnabled
    public static String createInvitation(String surveyId, String networkId, String recordId)
    {
        Id ParticipantId = '003B000000BCb4xIAD';
        String caseIdField = 'Case__c';
        SurveyInvitation invite = SurveyLinkManager.createSurveyRequest(surveyId, ParticipantId, networkId, caseIdField, recordId);
        insert invite;
        return 'https://sdodemo-main-15b43c605eb-15b-1610a158e54.force.com/audiophiles/survey/runtimeApp.app?invitationId=0KiB00000004Cgb&surveyName=my_first_mysurvey';//invite.InvitationLink;
    }
}