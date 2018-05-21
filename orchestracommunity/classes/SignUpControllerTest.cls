/**
    @ Purpose : Tests the functionality of class --> SignUpController
*/

@isTest
public class SignUpControllerTest {
    
    public final static String COMMUNITY_PROFILE = 'Maestro Community User';
    
    @Testsetup static void inserTestData() {
        
        Profile communityProfile = [ SELECT ID, Name FROM Profile WHERE Name =: COMMUNITY_PROFILE ];
        System.debug( 'communityProfile:-\n' + JSON.serialize( communityProfile ) );
        
        CommunityUserSetting__c communityUserSetting = new CommunityUserSetting__c
                                                       (
                                                        SetupOwnerId = UserInfo.getOrganizationId(),
                                                        Community_User_Profile_ID__c = communityProfile.Id,
                                                        Account_Default_Owner_ID__c = UserInfo.getUserId()
                                                       );
        insert communityUserSetting;
        System.assertNotEquals( NULL, CommunityUserSetting__c.getInstance() );
    }
    
    public static TestMethod void testCreateUser() {
        
        SignUpHandler signUpData;
        Response response;
        User guestUser = [ SELECT ID, UserName, Email, UserType FROM User WHERE UserType = 'Guest' LIMIT 1 ];
        
        System.runAs( guestUser ) {
        
            Test.startTest();
            
            // Tests base class states
            new SignUpController();
            
            // No Sign up data
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Form_Data_Missing, response.message );
            
            // Invalid account data
            signUpData = new SignUpHandler();
            signUpData.accountData = NULL;
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Billing_Entity_Details_Missing, response.message );
            
            // Invalid contact data
            signUpData = new SignUpHandler();
            signUpData.contactData = NULL;
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.User_Details_Missing, response.message );
            
            // Invalid contact email address
            signUpData = new SignUpHandler();
            signUpData.contactData.email = 'john.smith+1234@gmail.com';
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Invalid_Email_Address, response.message );
            
            // Invalid account details with valid contact details.
            signUpData = new SignUpHandler();
            signUpData.accountData = getDefaultAccountData();
            signUpData.accountData.searchEntity = '';
            signUpData.contactData = getDefaultContactData();
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Failed_To_Save_Billing_Entity, response.message );
            
            // Valid account details with invalid contact details.
            signUpData = new SignUpHandler();
            signUpData.accountData = getDefaultAccountData();
            signUpData.contactData = getDefaultContactData();
            signUpData.contactData.lastName = NULL;
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Failed_To_Save_Contact, response.message );
            
            // Valid account and contact details.
            signUpData = new SignUpHandler();
            signUpData.accountData = getDefaultAccountData();
            signUpData.contactData = getDefaultContactData();
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Signup_Success, response.message );
            
            // Valid account and contact details with duplicate user creation.
            signUpData = new SignUpHandler();
            signUpData.accountData = getDefaultAccountData();
            signUpData.contactData = getDefaultContactData();
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Email_already_exists, response.message );
            
            // Valid account and contact details with duplicate nickname.
            signUpData = new SignUpHandler();
            signUpData.accountData = getDefaultAccountData();
            signUpData.contactData = getDefaultContactData();
            signUpData.contactData.email = 'new' + signUpData.contactData.email;
            response = SignUpController.createUser( signUpData );
            System.assertEquals( System.Label.Signup_Success, response.message );
            
            CommunityUserSetting__c communityUserSetting = CommunityUserSetting__c.getOrgDefaults();
            communityUserSetting.Community_User_Profile_ID__c = 'INVALID PROFILE ID';
            update communityUserSetting;
            
            // Valid account and contact details with no community profile details.
            signUpData = new SignUpHandler();
            signUpData.accountData = getDefaultAccountData();
            signUpData.contactData = getDefaultContactData();
            signUpData.contactData.email = 'new' + signUpData.contactData.email;
            response = SignUpController.createUser( signUpData );
            
            Test.stopTest();
            
            System.assertEquals( System.Label.Community_User_Profile_Missing, response.message );
        }
    }
    
    private static SignUpHandler.AccountDTO getDefaultAccountData() {
        
        SignUpHandler.AccountDTO accountData = new SignUpHandler.AccountDTO();
        
        accountData.searchEntity = 'Maestro';
        accountData.officePhone = '562-377-3297';
        
        accountData.billingStreet = '2296  Sundown Lane';
        accountData.billingCity = 'Austin';
        accountData.billingState = 'Texas';
        accountData.billingCountry = 'USA';
        accountData.billingPostalCode = '78749';
        
        accountData.physicalStreet = '375  Reynolds Alley';
        accountData.physicalCity = 'Long Beach';
        accountData.physicalState = 'California';
        accountData.physicalCountry = 'USA';
        accountData.physicalPostalCode = '90808';
        
        accountData.isSameAddress = FALSE;
        accountData.isAgreedToTermsAndConditions = TRUE;
            
        return accountData;
    }
    
    private static SignUpHandler.ContactDTO getDefaultContactData() {
        
        SignUpHandler.ContactDTO conatctData = new SignUpHandler.ContactDTO();
        
        conatctData.firstName = 'Elizabeth';
        conatctData.lastName = 'Elizabeth W Hance';
        conatctData.email = 'elizabeth@dws.com';
        conatctData.mobilePhone = '214-621-9977';
            
        return conatctData;
    }
}