/**
	@ Purpose : Creates Account, Contact, and a Customer community user records.
*/
public without sharing class SignUpHandler {
    
    public AccountDTO accountData;
    public ContactDTO contactData;
    
    public class AccountDTO {
		
        public String searchEntity;
        public String billingEntityId; 
        public String billingEntityName;
        public String officePhone;
        
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
        public Boolean isAgreedToTermsAndConditions;
        
    }
    
    public class ContactDTO {
		
        public String firstName;   
        public String lastName ;
        public String email;
        public String mobilePhone;
    }
    
   
	/*
		@ Purpose : Creates Account, Contact, and a Customer community user records.
	*/
	public Response signUpUser() {
        
		System.debug( 'signUpData:-\n' + JSON.serialize( this ) );
        Response response = new response();
        
        if( accountData != NULL ) {
            if( contactData != NULL && String.isNotBlank( contactData.Email ) ) {
                if( validateEmail( contactData.Email ) ) {
                    
                    Savepoint sp = Database.setSavepoint();
                    Account account = new Account();
                    if( String.isNotBlank( accountData.billingEntityId ) ) {
                        account.Id = accountData.billingEntityId;
                    }
                    else {
                        accountData.billingEntityName = accountData.searchEntity;
                    }
                    
                    if( String.isBlank( account.Id ) ) {
                        try {
                            account = createAccount();
                            INSERT account;
                        }
                        catch( Exception e ) {
                            Database.Rollback( sp );
                            displayExceptionMessage( e );
                            response.setStatus( FALSE, System.Label.Failed_To_Save_Billing_Entity, NULL );
                        }
                        finally {
                            System.debug( 'Inserted account:-\n' + JSON.serialize( account ) );
                        }
                    } 
                    
                    if( String.isNotBlank( account.Id ) ) {
                        
                        // Create Contact
                        Contact contact = new Contact();
                        try {
                            contact = createContact( account );
                            INSERT contact;
                        }
                        catch( Exception e ) {
                            Database.Rollback( sp );
                            displayExceptionMessage( e );
                        }
                        finally {
                            System.debug( 'Inserted contact:-\n' + JSON.serialize( contact ) );
                        }
                        
                        if( contact.Id != NULL ) {
                            response = CommunityUser.createUserForCommunity( contact );
                            if( !response.success ) {
                                Database.Rollback( sp );
                            }
                        }
                        else {
                            response.setStatus( FALSE, System.Label.Failed_To_Save_Contact, NULL );
                        }
                    }
                    else {
                        response.setStatus( FALSE, System.Label.Failed_To_Save_Billing_Entity, NULL );
                    }
                }
                else {
                    response.setStatus( FALSE, System.Label.Invalid_Email_Address, NULL );
                }
            }
            else {
                response.setStatus( FALSE, System.Label.User_Details_Missing, NULL );
            }   
        }
        else {
            response.setStatus( FALSE, System.Label.Billing_Entity_Details_Missing, NULL );
        }
        return response;
    }
    
       
	/*
		@ Purpose : Forms an account record from accountdata state.
	*/
    private Account createAccount() {
		
        Account account; 
		CommunityUserSetting__c communityUserSetting = CommunityUserSetting__c.getInstance();
        if( accountData != NULL && String.isNotBlank( accountData.billingEntityName ) &&
			communityUserSetting != NULL && String.isNotBlank( communityUserSetting.Account_Default_Owner_ID__c )
		) {
            account = new Account();
            account.Name = accountData.billingEntityName;
            account.Phone = accountData.officePhone;
            account.ShippingStreet = accountData.physicalStreet;
            account.ShippingCity = accountData.physicalCity;
            account.ShippingCountry = accountData.physicalCountry;
            account.ShippingState = accountData.physicalState;
            account.ShippingPostalCode = accountData.physicalPostalCode;
			
            account.OwnerId = communityUserSetting.Account_Default_Owner_ID__c;
			account.RecordTypeId = getRecordTypeId( 'Account', 'Management' );
            account.Agree_to_Terms_and_Conditions__c = accountData.isAgreedToTermsAndConditions;
                
            if( accountData.isSameAddress ) {
                account.BillingStreet = accountData.physicalStreet;
                account.ShippingCity = accountData.physicalCity;
                account.ShippingCountry =accountData.physicalCountry;
                account.ShippingState = accountData.physicalState;
                account.ShippingPostalCode = accountData.physicalPostalCode;
            }
            else {
                account.BillingStreet = accountData.billingStreet;
                account.billingCity = accountData.billingCity;
                account.billingCountry = accountData.billingCountry;
                account.billingState = accountData.billingState;
                account.billingPostalCode = accountData.billingPostalCode;
            }
        }
        return account;
    }

    /*
		@ Purpose : Forms a contact record from contactdata state.
	*/
    private Contact createContact( Account recordAccount ) {
        
        Contact contact = new Contact(); 
        if( contactData != NULL && recordAccount != NULL && String.isNotBlank( recordAccount.Id ) && 
            String.isNotBlank( contactData.lastName ) && String.isNotBlank( contactData.email )
        ) { 
            contact.FirstName = contactData.firstName;
            contact.LastName = contactData.lastName;
            contact.Email = contactData.email;
            contact.MobilePhone = contactData.mobilePhone;
            
            contact.MailingStreet = recordAccount.ShippingStreet;
            contact.MailingCity = recordAccount.ShippingCity;
            contact.MailingCountry = recordAccount.ShippingCountry;
            contact.MailingState = recordAccount.ShippingState;
            contact.MailingPostalCode = recordAccount.ShippingPostalCode;
			
			contact.AccountId = recordAccount.Id;
            contact.Agree_to_Terms_and_Conditions__c = recordAccount.Agree_to_Terms_and_Conditions__c;
        }
        return contact;
    }
    
   /*
		@ Purpose     : Fetches and displays an exception message.
		@ Parameter   : Exception.
		@ Return Type : STRING [ Details of the Exception ].
    */
   public static String displayExceptionMessage(Exception e) {

       String strErrorMessage = '\nError Message:-{0}\nError LineNumber:-{1}';
       List<String> listOfMessageTokens = new List<String>{e.getMessage(), String.valueOf(e.getLineNumber())};
       strErrorMessage = String.format(strErrorMessage, listOfMessageTokens);
       System.debug(strErrorMessage);
       return strErrorMessage;
   }
    
    
    /*
		@ Purpose : Validates the provided email address by returning TRUE/FALSE.
	*/
    public static Boolean validateEmail( String email ) { 
	
        String emailRegex = '^([a-zA-Z0-9_\\-\\.]+)@([a-zA-Z0-9_\\-\\.]+)\\.([a-zA-Z]{2,5})$'; 
        
		//Create a new Pattern object for Email address
        Pattern emailPattern = Pattern.compile(emailRegex);
        
		//Create a new Matcher object with  email as a parameter to compare
        Matcher emailMatcher = emailPattern.matcher(email);
        
		//Verify the match returns "true" if matches otherwise "false"
        Boolean result = emailMatcher.matches();
        
        return result;
    }
	
	/*
		@ Purpose : Fetches record type id from object name and record type name.
	*/
	public static ID getRecordTypeId( String strObjectApiName, String strRecordTypeName ) {
    
        ID recordTypeId;
        if( String.isNotBlank( strObjectApiName ) && String.isNotBlank( strRecordTypeName ) ) {
            SObjectType sobjType = Schema.getGlobalDescribe().get( strObjectApiName );
            if( sobjType != NULL ) {
                
                Map<String, Schema.RecordTypeInfo> recordTypeNameToInfo;
                recordTypeNameToInfo = sobjType.getDescribe().getRecordTypeInfosByName();
                
                if( recordTypeNameToInfo.containsKey( strRecordTypeName ) ) {
                    recordTypeId = recordTypeNameToInfo.get( strRecordTypeName ).getRecordTypeId();
                }
            }
        }
        System.debug( 'recordTypeId:-\n' + recordTypeId );
        return recordTypeId;
    }
}