({
    doInit : function(component, event, helper) {
        var action = component.get("c.getSurveys");
        
        action.setCallback(this, function(response) {
            var records = response.getReturnValue();
            
            var options = [];
            
            var i;
            for (i = 0; i < records.length; i++) {
                var record = records[i];
                options.push({
                    value: record.SurveyId,
                    label: record.Name
                })
            }
            
            component.set("v.surveys", options);
        });
        $A.enqueueAction(action);
        
        var action = component.get("c.getCommunities");
        
        action.setCallback(this, function(response) {
            var records = response.getReturnValue();
            
            var options = [];
            
            var i;
            for (i = 0; i < records.length; i++) {
                var record = records[i];
                options.push({
                    value: record.Id,
                    label: record.Name
                })
            }
            
            component.set("v.communities", options);
        });
        $A.enqueueAction(action);
    },
    
    handleSurveyChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.surveyId", selectedOptionValue);
    },
    
    handleCommunityChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        component.set("v.communityId", selectedOptionValue);
        
        var btn = component.find("send");
        if (btn) {
            btn.set("v.disabled", "false");
        }
    },
    
    handleSend : function(component, event, helper) {
        var survId = component.get("v.surveyId");
        var commId = component.get("v.communityId");
        var recId = component.get("v.recordId");
        
        var action = component.get("c.createInvitation");
        action.setParams({
            surveyId: survId,
            networkId: commId,
            recordId: recId
        });
        
        action.setCallback(this, function(response) {
            var link = response.getReturnValue();
            
            component.set("v.getDetails", false);
            var btn = component.find("send");
            if (btn) {
                btn.set("v.disabled", "true");
            }
            
            component.set("v.surveyLink", "https://sdodemo-main-15b43c605eb-15b-1610a158e54.force.com/audiophiles/survey/runtimeApp.app?invitationId=0KiB00000004Ch5&surveyName=my_first_mysurvey");
        });
        $A.enqueueAction(action);
    }
})