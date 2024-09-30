public class FutureApex {
//commit sept30
@Future(callout=true)
public static void callout(List<Id>accIdList)
{ 
    if(accIdList.size()>0)
   { 
    for(Account acc:[select id,Name,Phone from Account where Id in :accIdList])
    {
        Http http=new Http();
        HttpRequest req=new HttpRequest();
        req.setEndpoint('callout:KiranOrg/services/apexrest/DataServiceIntegration?Phn='+acc.Phone);
        req.setMethod('GET');
        HttpResponse res=new HttpResponse();
        res=http.send(req);
        System.debug('Status code: '+res.getStatusCode());
       
        if(res.getStatusCode()==200)
        {
            system.debug('success');
            System.debug('Response body: '+res.getBody());
        }


    }
}
}
 
}