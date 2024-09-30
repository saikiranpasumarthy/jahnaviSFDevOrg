trigger opportunityTrigger on Opportunity (after insert,after update,after delete,after undelete) {
OpportunityTriggerHandler oth=new OpportunityTriggerHandler();
    /*if(trigger.isAfter)
    {List<Id>AccList=new List<Id>();
        if(Trigger.isInsert)
        {
            for(Opportunity o:trigger.new)
            {
                if(o.AccountId!=null)
                AccList.add(o.AccountId);
            }

        }
        if(Trigger.isUpdate)
        {
            for(Opportunity o:trigger.new)
            {
                if(o.AccountId!=null && o.AccountId!=trigger.oldMap.get(o.Id).AccountId)
                AccList.add(o.AccountId);
            }

            
        }
        if(Trigger.isDelete)
        {for(Opportunity o:trigger.old)
            {
                if(o.AccountId!=null)
                AccList.add(o.AccountId);
            }
            
        }
        if(Trigger.isUndelete)
        {
            for(Opportunity o:trigger.new)
            {
                if(o.AccountId!=null)
                AccList.add(o.AccountId);
            }
        }
        if(AccList.size()>0)
        oth.countNumber(AccList);
    }*/
    if(trigger.isAfter)
    {
        List<Opportunity>oppList=new List<Opportunity>();
        if(trigger.isInsert)
        {
            OpportunityTriggerHandler.recalculatingAmount(trigger.new);
        }
        if(trigger.isUpdate)
        {   
            for(Opportunity opp:trigger.new)
            {
                if(opp.Amount!=trigger.oldMap.get(opp.Id).Amount)
                oppList.add(opp);
            }
            OpportunityTriggerHandler.recalculatingAmount(oppList);
        }
        if(trigger.isDelete)
        {
            Set<Id>accList=new Set<Id>();
            for(Opportunity opp:trigger.old)
            {
                oppList.add(opp);
            }
            OpportunityTriggerHandler.deleteHandlerRecalculate(accList);
        }
    }
}