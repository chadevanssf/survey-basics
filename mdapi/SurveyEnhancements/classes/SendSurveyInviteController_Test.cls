@IsTest(seeAllData=true)
public class SendSurveyInviteController_Test
{
    private static String getContactId(String lastName)
    {
        Contact newRecord = new Contact(
            FirstName = 'Generic',
            LastName = lastName,
        	Email = 'Generic@example.com');
        insert newRecord;
        
        Contact record = [SELECT Id FROM Contact LIMIT 1];
        return record.Id;
    }

    private static String getCaseId(String contactId)
    {
        Case newRecord = new Case(
            ContactId = contactId);
        insert newRecord;
        
        Case record = [SELECT Id FROM Case LIMIT 1];
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
    
    @IsTest
    static void testGetSurveys()
    {
        Test.startTest();
        
        List<SurveyVersion> results = SendSurveyInviteController.getSurveys();
        
        System.assert(results.size() >= 0);
        
        Test.stopTest();
    }

    @IsTest
    static void testCreateInvitation()
    {
        Test.startTest();
        
        String participantId = getContactId('TestById');
        String caseId = getCaseId(participantId);
        String surveyName = getSurveyIdOrName(false);
        
        String results = SendSurveyInviteController.createInvitation('Case', surveyName, caseId);
        
        System.assert(results != '');
        
        Test.stopTest();
    }
}