trigger accountTrigger on Account (after update,before Delete) {
    if(trigger.isUpdate){
        if(trigger.isAfter){
            Map<id,Account>accMap=new Map<Id,Account>();
            for(Account acc:trigger.new)
            {
                if(acc.BillingState!=trigger.oldMap.get(acc.Id).BillingState)
                {
                    accMap.put(acc.Id,acc);
                }
            }
            List<Contact>conToUpdate=new List<Contact>();
            for(Contact con:[select AccountbillingState__c,Id,accountId from contact where accountId IN:(accMap.keySet()) limit 49999 ])
            {
                con.AccountbillingState__c=accMap.get(con.accountId).BillingState;
                conToUpdate.add(con);
            }
            if(conToUpdate.size()>0)
            Database.update(conToUpdate);
        }
    }
    if(trigger.isBefore)
    { if(trigger.isDelete)
        {
            Set<Id>accIds=new Set<Id>();
            for(Case cs:[select id,AccountId,status from Case where AccountId in: trigger.oldMap.keySet() and status != 'CLOSED'])
            {
                accIds.add(cs.AccountId);
            }
            for(Account acc:trigger.old)
            {
                if(acc.OwnerId!=UserInfo.getUserId()|| accIds.contains(acc.Id))
                acc.addError('You are not allowed to delete the record');
            }
        }

    }

}