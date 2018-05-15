/*
@PURPOSE : 1. TO RETRIEVE Locations
*/
public class UserRegistrationComponentController {
    
    
    /**
    @ PURPOSE     : TO FETCH Accounts  FOR CURRENT LOGGED IN USER.
    @ RETURN TYPE : LocationWrapper [ RESULT WITH CASES AND MESSAGE ].
    */
    @AuraEnabled
    public static CommunityUserWrapper getInvitedUsers() {
        CommunityUserWrapper result = new CommunityUserWrapper();
        
        try {
            //Contact loggedInUserContact = OrchestraUtility.fetchCommunityUserContact(UserInfo.getUserId());
            String accountId = '0011g000009VI4U';//loggedInUserContact.accountId;
            //if(loggedInUserContact.Admin__c){
            // FETCH Accounts BY USERID.
            List<Contact> listcontacts = [ SELECT Id, Name, Email, MobilePhone, Account.Name
                                          FROM Contact 
                                          WHERE AccountId =:  accountId ];
            if(listcontacts.size() > 0){
                result.invitedUsers = [SELECT Id, ContactId, LastLoginDate 
                                       FROM User
                                       WHERE ContactId IN: listcontacts
                                       AND LastLoginDate = NULL ];
            }
            
            result.setStatus(TRUE, '');
            system.debug('result::::'+result);
            /*}else{
            result.setStatus(FALSE, 'You are not authorized to check other locations');
            }*/
            
        } catch(Exception e) {
            result.setStatus(FALSE, getPageErrorMessage(e));
        }
        
        return result;
    }
    
    
    /*
    @
    */
    
    
    /**
    @ PURPOSE     : FETCHES AND DISPLAYS AN EXCEPTION MESSAGE.
    @ PARAMETER   : EXCEPTION.
    @ RETURN TYPE : STRING [ DETAILS OF THE EXCEPTION ].
    */
    public static String getPageErrorMessage(Exception e) {
        
        String strErrorMessage = e.getMessage();
        if(strErrorMessage.contains(',') && !strErrorMessage.endswith(',')) {         
            strErrorMessage = strErrorMessage.split(',').get(1);
        }
        return strErrorMessage;
    }
    
    /**
    @ PURPOSE : HOLDS Account RESULT.
    */
    public class CommunityUserWrapper {
        
        // HOLDS CASES RETRIEVED.
        @AuraEnabled public List<User> invitedUsers;
        
        // HOLDS TRANSACTION STATUS.
        @AuraEnabled public Boolean isSucceeded;
        
        // HOLDS TRANSACTION MESSAGE.
        @AuraEnabled public String strPageMessage;
        
        /**
        @ PURPOSE : SETS THE DEFAULT VALUES.
        */
        public CommunityUserWrapper() {
            this.invitedUsers = new List<User>();
            this.isSucceeded = FALSE;
            this.strPageMessage = '';
        }
        
        /**
         @ PURPOSE : SETS THE STATES BASED ON THE VALUES RECEIVED.
        */
        public void setStatus(Boolean isSucceeded, String strPageMessage) {
            
            if(isSucceeded != NULL) {
                this.isSucceeded = isSucceeded;
            }
            
            if( String.isNotBlank(strPageMessage)) {
                this.strPageMessage = strPageMessage;
            }
        }
    }
}