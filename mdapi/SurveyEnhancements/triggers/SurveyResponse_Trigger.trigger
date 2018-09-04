trigger SurveyResponse_Trigger on SurveyResponse (before update)
{
    if(Trigger.isBefore && Trigger.isUpdate) {
        SurveyResponse_TriggerHelper.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
}