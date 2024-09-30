trigger contactTrigger on Contact (before insert) {
if(trigger.isBefore){
    if(trigger.isInsert)
    {
        Set<String>emailIdData=new Set<String>();
        Set<String>phoneNum=new Set<String>();
        for(Contact con : trigger.new)
        {
            emailIdData.add(String.valueOf(con.Email));
            phoneNum.add(String.valueOf(con.Phone));
        }
        Set<String>existingEmailIdData=new Set<String>();
        Set<String>existingPhoneNum=new Set<String>();
        for(Contact con : [select email,phone from contact where email in :emailIdData or phone in :phoneNum])
        {
            existingEmailIdData.add(con.Email);
            existingPhoneNum.add(con.Phone);
        }
        for(Contact con : trigger.new)
        {
            if(existingEmailIdData.size()>0 && existingE)
        }

    }
}
}