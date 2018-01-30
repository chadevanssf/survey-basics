trigger TestOnSurveyComplete on SurveyResponse (after update) {
    // get all the responses, that are completed
    Set<Id> responseIds = new Set<Id>();
    for (SurveyResponse sr : Trigger.new)
    {
        if (sr.Status == 'Completed')
        {
            responseIds.add(sr.Id);
        }
    }
    
    // are there any responses that we need to process?
    if (responseIds.size() > 0)
    {
        // get the question responses for the responses
        // for the correct type to score, 'Rating' is of interest here
        List<SurveyQuestionResponse> sqrs = [SELECT ResponseShortText, Response.Invitation.Case__c
                                             FROM SurveyQuestionResponse
                                             WHERE Question.QuestionType = 'Rating'
                                             AND Response.Invitation.Case__c != null
                                             AND ResponseId in :responseIds];
        
        // are there any cases we need to process?
        if (sqrs.size() > 0)
        {
            // gather all the Cases that are under consideration
            Set<Id> caseIds = new Set<Id>();
            for (SurveyQuestionResponse sqr : sqrs)
            {
                caseIds.add(sqr.Response.Invitation.Case__c);
            }
            
            // get the cases
            List<Case> caseList = [SELECT Survey_Latest_Score__c, Survey_Latest_Score_Date__c
                                                     FROM Case
                                                     WHERE Id in :caseIds];
            Map<Id, Case> caseMap = new Map<Id, Case>(caseList);
            
            // add the values of the question response to the cases
            for (SurveyQUestionResponse sqr : sqrs)
            {
                Case c = caseMap.get(sqr.Response.Invitation.Case__c);
                String scoreStr = sqr.ResponseShortText;
                if (String.isNotBlank(scoreStr))
                {
                    Decimal score = Decimal.valueOf(scoreStr);
                    c.Survey_Latest_Score__c = score;
                    c.Survey_Latest_Score_Date__c = DateTime.now();
                }
            }
            
            // update the cases
            update caseList;
        }
    }
}