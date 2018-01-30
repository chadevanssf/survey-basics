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
    },
    
    handleSurveyChange : function(component, event, helper) {
        var selectedOptionValues = event.getParam("value");
        component.set("v.surveyId", selectedOptionValues[0]);
        var btn = component.find("send");
        if (btn) {
            btn.set("v.disabled", "false");
        }
    },
    
    handleSend : function(component, event, helper) {
        var config = component.get("v.config");
        var survId = component.get("v.surveyId");
        var recId = component.get("v.recordId");
        
        var action = component.get("c.createInvitation");
        action.setParams({
            config: config,
            surveyId: survId,
            recordId: recId
        });
        
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                var link = response.getReturnValue();
                
                component.set("v.getDetails", false);
                var btn = component.find("send");
                if (btn) {
                    btn.set("v.disabled", "true");
                }
                
                component.set("v.surveyLink", link);

                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "success",
                    "duration": "1000",
                    "title": "Success!",
                    "message": "Survey sent"
                });
                toastEvent.fire();
            } else {
                var msg = "The survey was not sent.";
                var msgs = response.getError();
                
                for (var i = 0; i < msgs.length; i++) {
                    msg += "<br>" + msgs[i].message;
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type": "error",
                    "mode": "sticky",
                    "title": "Failure!",
                    "message": msg
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }
})