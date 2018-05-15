public class SignUpHandler {
    
    public AccountDTO  accountData;
    public ContactDTO  contactData;
    
    public class AccountDTO {
        public String billingEntityName;   
        public String officePhone ;
        public String billingAddress ;
        public String billingStreet;
        public String billingCity;
        public String billingCountry;
        public String billingState;
        public String billingPostalCode;
        public String physicalAddress;
        public String physicalStreet;
        public String physicalCity;
        public String physicalCountry;
        public String physicalState;
        public String physicalPostalCode;
        public Boolean isBillingAddress;
        public Boolean isSameAddress;
        
    }
    
    public class ContactDTO {
        public String firstName;   
        public String lastName ;
        public String email;
        public String mobilePhone;
    }
    
   
    /**
     *@purpose : Handle signup User functionality
	 *@return  : response
     */
    public Response signUpUser() {
        Response response;
        Savepoint sp = Database.setSavepoint();
        Account	account;
		Contact contact;
        List<Account> accountList;
        System.debug('signUpData ==' +JSON.serialize(accountData));
        if(accountData != null && contactData != null && String.isNotBlank(contactData.Email)) {
            if(validateEmail(contactData.Email)) {
                
                // Create Account
                try {
                    accountList = getAccountByName();
                    if(accountList != null && !accountList.isEmpty()) {
                        account = accountList[0];
                        System.debug('accountList[0] ==' +account);
                    }
                    else{
                        account = createAccount();
                        INSERT account;
                        System.debug('account ==' +account);
                    }
                }
                catch(Exception e) {
                    Database.Rollback(sp);
                    displayExceptionMessage(e);
                    return new Response(false, 'Error in creating Account.', null);
                }
                
                // Create Contact
                try {
                    contact = createContact(account.Id);
                    System.debug('account ==' +account);
                    INSERT contact;
                    return new Response(true, 'Success', null);
                }
                catch(Exception e) {
                    Database.Rollback(sp);
                    displayExceptionMessage(e);
                    return new Response(false, 'Error in creating Contact.', null);
                }                
                /*response = CommunityUser.createUserForCommunity(contact);
                if(!response.Success) {
                   Database.Rollback(sp);
                }*/
                
            }
            else{
                 return new Response(false, 'Please enter valid emailId', null);
            }
        }
        else{
            return new Response(false, 'Required data does not exist', null);
        }
        //return response;
    }
    
       
    /**
     *@purpose : Handle account operation
	 *@return  : Account
     */
    private Account createAccount() {
        Account account; 

        if(accountData != null && String.isNotBlank(accountData.billingEntityName)) {
            
            account = new Account();
            account.Name = accountData.billingEntityName;
            account.Phone = accountData.officePhone;
            account.ShippingStreet = accountData.physicalStreet;
            account.ShippingCity = accountData.physicalCity;
            account.ShippingCountry = accountData.physicalCountry;
            account.ShippingState = accountData.physicalState;
            account.ShippingPostalCode = accountData.physicalPostalCode;
            
            if(accountData.isSameAddress) {
                account.BillingStreet = accountData.physicalStreet;
                account.ShippingCity = accountData.physicalCity;
                account.ShippingCountry =accountData.physicalCountry;
                account.ShippingState = accountData.physicalState;
                account.ShippingPostalCode = accountData.physicalPostalCode;
            }
            //else if(accountData.isBillingAddress) {
            else {
                account.BillingStreet = accountData.billingStreet;
                account.ShippingCity = accountData.billingCity;
                account.ShippingCountry = accountData.billingCountry;
                account.ShippingState = accountData.billingState;
                account.ShippingPostalCode = accountData.billingPostalCode;
            }
        }
        return account;
    }
    
    /**
     *@purpose : Fetch account by name
	 *@return  : account
     */
    private List<Account> getAccountByName() {
        List<Account> accountList = [SELECT Id, Name, OwnerId, Owner.UserRoleId
                                     FROM Account 
                                     WHERE Name = : accountData.billingEntityName];
        System.debug('accountList ==' +accountList);
        return accountList;
    }

    /**
     *@purpose : Populate contact fields
	 *@return  : contact
     */
    private Contact createContact(Id accountId) {
        Contact contact = new Contact(); 
        
        if(contactData != null && String.isNotBlank(accountId) 
           && String.isNotBlank(contactData.lastName) 
           && String.isNotBlank(contactData.email)) {
               
            contact.FirstName = contactData.firstName;
            contact.LastName = contactData.lastName;
            contact.Email = contactData.email;
            contact.MobilePhone = contactData.mobilePhone;
        }    
        return contact;
    }
    
   /**
	*@PURPOSE     : FETCHES AND DISPLAYS AN EXCEPTION MESSAGE.
    *@PARAMETER   : EXCEPTION.
    *@RETURN TYPE : STRING [ DETAILS OF THE EXCEPTION ].
    */
   public static String displayExceptionMessage(Exception e) {

       String strErrorMessage = '\nError Message:-{0}\nError LineNumber:-{1}';
       List<String> listOfMessageTokens = new List<String>{e.getMessage(), String.valueOf(e.getLineNumber())};
       strErrorMessage = String.format(strErrorMessage, listOfMessageTokens);
       System.debug(strErrorMessage);
       return strErrorMessage;
   }
    
    
    /**
     *@Purpose : To Check Email Format
     *@Parameter: Email address
     *@Returns  : "true" if Email format is valid otherwise returns "false"
     */
    public static Boolean validateEmail(String email) { 
        String emailRegex = '^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$'; 
        //Create a new Pattern object for Email address
        Pattern emailPattern = Pattern.compile(emailRegex);
        //Create a new Matcher object with  email as a parameter to compare
        Matcher emailMatcher = emailPattern.matcher(email);
        //Verify the match returns "true" if matches otherwise "false"
        Boolean result = emailMatcher.matches();
        
        return result;
    }
}