public with sharing class OpportunityTriggerHandler {
    public void countNumber(List<Id>AccIds) {
        Account acc;
        List<Account>acclist= new List<Account>();
        for(AggregateResult a:[select count(Id)opp,AccountId from Opportunity where accountId in :AccIds group by AccountId])
        {
            acc=new Account();
            acc.Id=(Id)a.get('AccountId');
            acc.TotalOpportunities__c=(Decimal)a.get('opp');
            accList.add(acc);
        }
if(acclist.size()>0)
update acclist;

    }
    public static void recalculatingAmount(List<Opportunity>oppList)
    {
        Set<Id>accIds=new Set<Id>();
        List<Account>accList=new List<Account>();
        for(Opportunity opp:oppList)
        {
            accIds.add(opp.AccountId);
        }
        map<Id,Account>existingaccMap=new map<Id,Account>([select id,MaximumAmountOpportunity__c,MaximumAmountOpportunity__r.Amount from Account where MaximumAmountOpportunity__c!=null and id in:accIds]);
        map<Id,Opportunity>maxAmountMap=new Map<Id,Opportunity>();
        for(Opportunity opp:oppList)
        {   
            System.debug('outside existingaccMap --> ' + existingaccMap.get(opp.AccountId).MaximumAmountOpportunity__r.amount);
            System.debug('outside opp.Amount --> ' + opp.Amount);
            if((existingaccMap!=null &&existingaccMap.keySet().contains(opp.AccountId)&&existingaccMap.get(opp.AccountId).MaximumAmountOpportunity__r.amount<opp.Amount)||(existingaccMap==null &&existingaccMap.keySet().size()==0)){
                if(maxAmountMap!=null &&maxAmountMap.keySet().contains(opp.AccountId)&&maxAmountMap.get(opp.AccountId).Amount<opp.Amount)
                {
                    System.debug('inside existingaccMap --> ' + existingaccMap.get(opp.AccountId).MaximumAmountOpportunity__r.amount);
                    System.debug('inside opp.Amount --> ' + opp.Amount);
                    maxAmountMap.put(opp.AccountId,opp);
                }
            }
            else if(!maxAmountMap.keySet().contains(opp.AccountId)){
                maxAmountMap.put(opp.AccountId,opp);
            }
        }
        if(maxAmountMap.keySet().size()>0)
        {
            Account acc;
            for(Id accId:maxAmountMap.keySet())
            {
                acc=new Account(id=accId);
                acc.MaximumAmountOpportunity__c=maxAmountMap.get(accId).Id;
                accList.add(acc);
            }
        }
        if (accList.size()>0) {
            update accList;
        }
    }

public static void deleteHandlerRecalculate(Set<id>AccountIds)
{
    List<Account>accList=new List<Account>();
    map<Id,Account>existingaccMap=new map<Id,Account>([select id,MaximumAmountOpportunity__c,MaximumAmountOpportunity__r.Amount from Account where MaximumAmountOpportunity__c = null and id in: AccountIds]);
    map<Id,Opportunity>maxAmountMap=new Map<Id,Opportunity>();
       for(Opportunity opp:[select Id,amount,accountId from opportunity where accountId in :AccountIds])  
       {
        if((existingaccMap!=null &&existingaccMap.keySet().contains(opp.AccountId)&&existingaccMap.get(opp.AccountId).MaximumAmountOpportunity__r.Amount < opp.Amount)||(existingaccMap==null &&existingaccMap.keySet().size()==0)){
            if(maxAmountMap!=null &&maxAmountMap.keySet().contains(opp.AccountId)&&maxAmountMap.get(opp.AccountId).Amount<opp.Amount)
            {
                maxAmountMap.put(opp.AccountId,opp);
            }
        }
        else if(!maxAmountMap.keySet().contains(opp.AccountId)){
            maxAmountMap.put(opp.AccountId,opp);
        }
    }
    if(maxAmountMap.keySet().size()>0)
    {Account acc;
        for(Id accId:maxAmountMap.keySet())
        {acc=new Account(id=accId);
            acc.MaximumAmountOpportunity__c=maxAmountMap.get(accId).Id;
            accList.add(acc);
        }
    }
    if(accList.size()>0)
    update accList;
       
}
}