/**
 *@Purpose    : Create community user
 *@CreateDate : 3 May 2018
 */
public class CommunityUser {
    
    
    /**
     *@Purpose  : Initaiate to create community user
     *@Param    : Contact
     *@return   : Response(true, false)
     */
    public static Response createUserForCommunity(Contact contact) {
        Response response;

        List<User> userList;
        Set<String> userEmailSet = new Set<String>();
        Set<String> userNickNameSet = new Set<String>();
        
        if(contact != null && String.isNotBlank(contact.Email)) {
            
            //Get Id of Community user profile
            String profileId = getProfileId();
            if(String.isNotBlank(profileId)) {
                
              userNickNameSet.add(getFormattedNickName(contact.FirstName, contact.LastName)); 
                
                // get existing user by email Id
                try {
                    userList = [SELECT Id, Name, UserName, CommunityNickName 
                                FROM User 
                                WHERE UserName = :contact.Email
                                OR CommunityNickName IN : userNickNameSet
                                ];
                } 
                Catch(Exception e) {
                   SignUpHandler.displayExceptionMessage(e);
                   return new Response(false, 'Something went wrong while fetching existing user', null);
                }
                
                if(userList != null && !userList.isEmpty()) {
                    for(User user : userList) {
                        userNickNameSet.add(user.CommunityNickName);
                        userEmailSet.add(user.Email);
                    }
                }
             
                if(userEmailSet != null && !userEmailSet.isEmpty() && userEmailSet.contains(contact.Email)) {
                    return new Response(false, 'User Already Exist for this Email Address', null);
                }
                else{
                   response = createUser(userNickNameSet, contact, profileId);
                }
            }
            else{
                return new Response(false, 'Profile not exist', null);
            }
        }
        return response;
    }
    
    
    /**
     *@Purpose  : Create community user
     *@Param    : Contact
     *@return   : Response(true, false)
     */
    private static Response createUser(Set<String> nickNameSet, Contact contact, Id profileId) {
        Response response;
        Integer intCount = 2;                   
        String aliasStr; 
        User communityUser = new User();
        
        if(contact != null && String.isNotBlank(profileId)) {
            
            String communityUserNickName = getFormattedNickName( contact.FirstName, contact.LastName );
            
            if(nickNameSet != null && !nickNameSet.isEmpty() ) {
                while( nickNameSet.contains( communityUserNickName ) ) {
                    
                    //  keep updating nickname until a unique one is created.                             
                    communityUserNickName += intCount;
                    intCount += 1;
                }
            }   
            
            if( String.isNotBlank( communityUserNickName ) ) {
                communityUser.CommunityNickName = communityUserNickName;
            }
            aliasStr = contact.FirstName != null ? contact.FirstName.left( 1 ) : '';
            aliasStr += String.isNotBlank(contact.LastName)?contact.LastName.left( 1 ):'';
            
            communityUser.FirstName = String.isNotBlank(contact.FirstName) ? contact.FirstName :'' ;
            communityUser.LastName = contact.LastName;
            communityUser.UserName = contact.Email;
            communityUser.ProfileId = profileId;
            communityUser.Email = contact.Email;
            communityUser.Alias = aliasStr;
            communityUser.EmailEncodingKey = 'UTF-8';
            communityUser.LanguageLocaleKey = 'en_US';
            communityUser.LocaleSidKey = 'en_US';
            communityUser.TimeZoneSidKey = 'America/Los_Angeles';
            communityUser.IsActive = true;
            communityUser.ContactId = contact.Id;
            
            try{
                INSERT communityUser;
                response = new Response(true, 'User Created Succesfully', communityUser);
            }
            Catch(Exception e) {
               SignUpHandler.displayExceptionMessage(e);
               return new Response(false, 'Oops something went wrong while creating user! please try again', null);
            }
        }
        else{
             response = new Response(false, 'Required data does not exist', null);
        }
        return response;
    }

   
    /**
     * @Purpose : Function to fetch profile from custom setting data
     * @Parameter: -
     * @Returns  : Community user profile Id 
     */
    private static String getProfileId(){
        List<CommunityUserSetting__c> communityUserSetting = CommunityUserSetting__c.getall().values();
        
        String profileName = '';
        profileName = communityUserSetting[0].UserProfile__c;
        String profileId;
        
        //Get Id of profile
        try{
            profileId = [SELECT Id FROM Profile WHERE Name =: profileName].id;
            
        }catch(Exception e){
            System.debug('Exception occured : '+e.getMessage());
        }
        
        return profileId;
    }
    
    
    /**
     *@Purpose : Create formatted nickName.
     *@Param   : users FirstName, users LastName
     *@Return   : String
    */
    private static String getFormattedNickName(String firstName, String lastName ){
        
        String nickNameStr;
        
        if( String.isNotBlank( firstName ) ) {
            nickNameStr = firstName.capitalize() + lastName.substring(0,1).toUpperCase();
        }
        else {
            nickNameStr = String.isNotBlank( lastName )?lastName.capitalize():'';
        }       
        
        return nickNameStr;
    }
    
}