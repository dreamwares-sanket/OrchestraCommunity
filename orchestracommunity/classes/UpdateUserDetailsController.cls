/**
@ PURPOSE : Controller for UpdateUserDetails lightning component.
*/
public with sharing class UpdateUserDetailsController {
    
    /*
    @ PURPOSE     : Get current User details.
    */
    @AuraEnabled
    public static User getCurrentUser() {
        
        User communityUser;
        
        try{
            communityUser = [SELECT Id, FirstName, LastName, Email, Phone,ContactId
                             FROM User 
                             WHERE Id = :UserInfo.getUserId() 
                             LIMIT 1
                            ];
        }catch(Exception ex ){
            system.debug('Error occred while fetching User details:'+ ex.getMessage());
        }
        
        return communityUser;
    }    
    
    /*
    @ PURPOSE     : Update User and Contact.
    */
    @AuraEnabled
    public static String updateUserContact(User user) {
        String responseMessage = 'User and Contact updated successfully.';
        Contact communityUserContact;
        
        system.debug('user::' + user);
        
        if( user != NULL ){   
            try{
                communityUserContact = [SELECT Id, Name, email, Phone
                                        FROM Contact 
                                        WHERE ID =: user.ContactId	
                                       ];
            }catch( Exception ex){
                system.debug('Error occred while fetching Contact:'+ ex.getMessage());
            }
            
            system.debug('communityUserContact::' + communityUserContact);
            
            if( communityUserContact != NULL ){
                communityUserContact.FirstName = user.FirstName;
                communityUserContact.LastName = user.LastName;
                communityUserContact.email = user.email;
                communityUserContact.Phone = user.Phone;                
            }
            
            try{
                //UPDATE user;
                
                if( communityUserContact != NULL ){
                    //UPDATE communityUserContact;
                }
                
            }catch( Exception ex){
                system.debug('Error occred while updating:'+ ex.getMessage());
                return responseMessage = 'Error occured while updating';
            }
        }
        return responseMessage;
    }
}