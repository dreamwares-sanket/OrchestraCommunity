/**
    @ Purpose : 1. Receives details of Contact record.
                2. Creates community user by setting unique nick name to a new user.
*/
public without sharing class CommunityUser {
    
    /*
        @ Purpose : Creates a community user from a contact record.
    */
    public static Response createUserForCommunity( Contact contact ) {
        
        Response response = new Response();
        if( contact != null && String.isNotBlank( contact.Email ) ) {
            
            //Get Id of Community user profile
            ID profileId = getProfileId();
            if( profileId != NULL ) {
                
                Integer intMatchedUsers = [ SELECT COUNT() FROM User WHERE UserName =: contact.Email ];
                if( intMatchedUsers > 0 ) {
                    response.setStatus( FALSE, System.Label.Email_already_exists, NULL );
                }
                else {
                    String strUniqueNickName = getUniqueName( contact );
                    if( String.isNotBlank( strUniqueNickName ) ) {
                        
                        User communityUser = new User
                                             (
                                              LastName = contact.LastName,
                                              UserName = contact.Email,
                                              CommunityNickName = strUniqueNickName,
                                              ProfileId = profileId,
                                              Email = contact.Email,
                                              EmailEncodingKey = 'UTF-8',
                                              LanguageLocaleKey = 'en_US',
                                              LocaleSidKey = 'en_US',
                                              TimeZoneSidKey = 'America/Los_Angeles',
                                              IsActive = TRUE,
                                              ContactId = contact.Id
                                             );
                                                 
                        communityUser.Alias = '';
                        if( String.isNotBlank( contact.FirstName ) ) {
                            communityUser.Alias += contact.FirstName.left( 1 );
                        }
                        communityUser.Alias += contact.LastName.left( 1 );
                        try {
                            INSERT communityUser;
                            response.setStatus( TRUE, System.Label.Signup_Success, communityUser );
                        }
                        Catch( Exception e ) {
                           SignUpHandler.displayExceptionMessage( e );
                           response.setStatus( FALSE, System.Label.Signup_Failed, NULL );
                        }
                        finally {
                            System.debug( 'communityUser:-\n' + JSON.serialize( communityUser ) );
                        }
                    } 
                    else {
                        response.setStatus( FALSE, System.Label.Nickname_Failed, NULL );
                    }
                }
            }
            else{
                response.setStatus( FALSE, System.Label.Community_User_Profile_Missing, NULL );
            }
        }
        else {
            response.setStatus( FALSE, System.Label.User_Details_Missing, NULL );
        }
        return response;
    }
   
    /*
        @ Purpose : Fetches community user's profile id from CommunityUserSetting__c hierarchy settings.
    */
    private static ID getProfileId() {
        
        ID profileId;
        CommunityUserSetting__c communityUserSetting = CommunityUserSetting__c.getInstance();
        if( communityUserSetting != NULL && 
            String.isNotBlank( communityUserSetting.Community_User_Profile_ID__c )
        ) {
            try {
                profileId = communityUserSetting.Community_User_Profile_ID__c;
            }
            catch( Exception e ) {
                SignUpHandler.displayExceptionMessage( e );
            }
        }
        return profileId;
    }
    
    /*
        @ Purpose : Creates a unique nick name for a user based on the number of existing users with same name.
    */
    private static String getUniqueName( Contact contact ) {
        
        String strUniqueNickName = '';
        if( contact != NULL ) {
            strUniqueNickName = getFormattedNickName( contact.FirstName, contact.LastName );
            if( String.isNotBlank( strUniqueNickName ) ) {
                Set<String> setOfNickNames = getSetOfNickNames();
                Integer intUniqueCount = 0;
                while( setOfNickNames.contains( strUniqueNickName) ) {
                    strUniqueNickName += intUniqueCount;
                    intUniqueCount ++;
                }
            }
        }
        return strUniqueNickName;
    }
    
    /*
        @ Purpose     : Fetches a defaults nick name based on the first name and last name received.
        @ Parameter   : [ First Name - bob, Last Name - wilber ]  
        @ Return Type : [ Nick Name - BobW ]
    */
    private static String getFormattedNickName( String firstName, String lastName ) {
        
        String strNickName = '';
        if( String.isNotBlank( firstName ) ) {
            strNickName = firstName.capitalize() + lastName.substring( 0, 1 ).toUpperCase();
        }
        else if( String.isNotBlank( lastName ) ) {
            strNickName = lastName.capitalize();
        }
        return strNickName;
    }
    
    /*
        @ Purpose : Fetches nick names of all existing users.
    */
    private static Set<String> getSetOfNickNames() {
        
        Set<String> setOfNickNames = new Set<String>();
        for( User user : [ SELECT CommunityNickName FROM User ] ) {
            setOfNickNames.add( user.CommunityNickName );
        }
        return setOfNickNames;
    }
}