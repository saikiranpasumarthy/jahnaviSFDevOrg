trigger AccountTriggerIntegration on Account (after update) {

    if(trigger.isAfter)
    {List<Id>accIds=new List<Id>();
        if(trigger.isUpdate)
        {
            for(Account acc:trigger.new)
            {
                Account oldAcc=trigger.oldMap.get(acc.Id);
                if(acc.Phone!=oldAcc.phone)
                {
                        accIds.add(acc.Id);
                }
            }
            FutureApex.callout(accIds);
        }
    }
}