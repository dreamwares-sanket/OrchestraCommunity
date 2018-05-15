/*
	@PURPOSE : 1. .
*/

public class OrchestraUtility {
    public static Contact fetchCommunityUserContact(String userId){
        Contact communityUserContact;
        try{
            
            if(String.isNotBlank(userId)){
                User communityUser = [ SELECT Id, Name, AccountId, ContactId
                                 FROM User 
                                 WHERE ID =: userId	
                                ];
                if( communityUser!= null ){
                    
                    communityUserContact = [ SELECT Id, Name, AccountId, Admin__c
                                 FROM Contact 
                                 WHERE ID =: communityUser.ContactId	
                                ];
                }
            }
            
        }catch(Exception ex ){
            system.debug('Exception in fetchCommunityUserDetails:'+ex);
        }
        return communityUserContact;
    }
}