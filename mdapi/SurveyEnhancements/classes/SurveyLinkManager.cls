global class SurveyLinkManager 
{
    public static SurveyInvitation createSurveyRequest(Id SurveyId, Id ParticipantId, Id NetworkId, String AdditionalIdField, Id AdditionalId)
    {
        SurveyInvitation invite = new SurveyInvitation(
            SurveyId = SurveyId,
            ParticipantId = ParticipantId,
            //OptionsAllowGuestUserResponse = true,
            CommunityId = NetworkId,
            Name = 'Private Invite_' + String.valueOfGmt(DateTime.now()),
            OwnerId = UserInfo.getUserId()
        );
        
        if (String.isNotBlank(AdditionalIdField))
        {
            invite.put(AdditionalIdField, AdditionalId);
        }
        
        return invite;
    }
    
    @InvocableMethod
    public static List<SurveyInvitationResult> createSurveyRequests(List<SurveyInvitationRequest> requests)
    {
        List<SurveyInvitationResult> results = new List<SurveyInvitationResult>();
        List<SurveyInvitation> invites = new List<SurveyInvitation>();
        
        for (SurveyInvitationRequest request : requests)
        {
            invites.add(createSurveyRequest(
                request.surveyId,
                request.participantId,
                request.networkId,
                request.additionalIdField,
                request.additionalId
            ));
        }
        
        insert invites;
        
        for (SurveyInvitation invite : invites)
        {
            String inviteId = invite.Id;
            
            SurveyInvitationResult result = new SurveyInvitationResult();
            result.inviteId = inviteId;
            result.success = true;
            results.add(result);
        }
        
        return results;
    }
    
    global class SurveyInvitationRequest {
        @InvocableVariable(label='Survey Id' description='Id of Survey' required=true)
        global ID surveyId;
        
        @InvocableVariable(label='Participant Id' description='Id of Contact or User' required=true)
        global ID participantId;
        
        @InvocableVariable(label='Community Id' description='Id of Community aka Network' required=true)
        global ID networkId;
        
        @InvocableVariable(label='Additional Id Field Name' description='An optional lookup id field, for example to Case, API like Case__c' required=false)
        global String additionalIdField;
        
        @InvocableVariable(label='Additional Id' description='An optional lookup id, e.g. Id of Case' required=false)
        global ID additionalId;
    }
    
    global class SurveyInvitationResult {
        @InvocableVariable
        global ID inviteId;
        
        @InvocableVariable
        global Boolean success;
    }
}