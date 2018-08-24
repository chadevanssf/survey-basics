@IsTest(seeAllData=true)
public class SurveyInvitationManager_Test
{
    private static String getContactId(String lastName)
    {
        Contact newContact = new Contact(
            FirstName = 'Generic',
            LastName = lastName,
        	Email = 'Generic@example.com');
        insert newContact;
        
        Contact record = [SELECT Id FROM Contact LIMIT 1];
        return record.Id;
    }
    
    private static String getSurveyIdOrName(Boolean useId)
    {
        //Survey newSurvey = new Survey();
        
        //insert newSurvey; // cannot make DML on Survey
        
        Survey record = [SELECT Id, Name FROM Survey LIMIT 1];
        if (useId) {
            return record.Id;
        } else {
            return record.Name;
        }
    }

    private static String getNetworkIdOrName(Boolean useId)
    {
        // no way to create a network / community from a test
        Network record = [SELECT Id, Name FROM Network LIMIT 1];
        if (useId) {
            return record.Id;
        } else {
            return record.Name;
        }
    }
    
    @IsTest
    static void testCreateSurveyRequestsById()
    {
        Test.startTest();
        
        List<SurveyInvitationManager.SurveyInvitationRequest> requestsById =
            new List<SurveyInvitationManager.SurveyInvitationRequest>();
        
        SurveyInvitationManager.SurveyInvitationRequest requestById = new SurveyInvitationManager.SurveyInvitationRequest();
        
        requestById.participantId = getContactId('TestById');
        requestById.surveyId = getSurveyIdOrName(true);
        requestById.networkId = getNetworkIdOrName(true);

        requestsById.add(requestById);
        
        List<SurveyInvitationManager.SurveyInvitationResult> results =
            SurveyInvitationManager.createSurveyRequests(requestsById);

        System.assertEquals(1, results.size());
        
        Test.stopTest();
    }

    @IsTest
    static void testCreateSurveyRequestsByName()
    {
        Test.startTest();
        
        List<SurveyInvitationManager.SurveyInvitationRequest> requestsByName =
            new List<SurveyInvitationManager.SurveyInvitationRequest>();
        
        SurveyInvitationManager.SurveyInvitationRequest requestByName = new SurveyInvitationManager.SurveyInvitationRequest();
        
        requestByName.participantId = getContactId('TestByName');
        requestByName.surveyId = getSurveyIdOrName(false);
        requestByName.networkId = getNetworkIdOrName(false);

        requestsByName.add(requestByName);
        
        List<SurveyInvitationManager.SurveyInvitationResult> results =
            SurveyInvitationManager.createSurveyRequests(requestsByName);

        System.assertEquals(1, results.size());
        
        Test.stopTest();
    }
    
    @IsTest
    static void testSalesforceIdFormat()
    {
        // Account Like
        System.assert(SurveyInvitationManager.isSalesforceIdFormat('001f200001cQxJvAdx'));
        
        // Contact Like
        System.assert(SurveyInvitationManager.isSalesforceIdFormat('003f200002SNO5GAAd'));
        
        // not like anything
        System.assert(!SurveyInvitationManager.isSalesforceIdFormat('123456'));
        
        System.assert(!SurveyInvitationManager.isSalesforceIdFormat('Hello World'));
    }
}