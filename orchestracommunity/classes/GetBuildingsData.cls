/*
    @PURPOSE :  1. Get all Accounts related to current logged in User.
                2. Statuses of all Cases.
                3. Names of User ( Created by )
*/
public class GetBuildingsData {

   /*
    @ PURPOSE     : Get all Building records.
    @ RETURN TYPE : ResponseWrapper
    */
    @AuraEnabled
    public static ResponseWrapper getData() {
        
        ResponseWrapper result = new ResponseWrapper();
        
        List<PicklistWrapper> buildingList = new List<PicklistWrapper>();
        List<PicklistWrapper> statuseList = new List<PicklistWrapper>();
        List<PicklistWrapper> userList = new List<PicklistWrapper>();
        List<CaseWrapper> caseList = new List<CaseWrapper>();
        
        try {
            //Contact loggedInUserContact = OrchestraUtility.fetchCommunityUserContact(UserInfo.getUserId());
            //System.debug('loggedInUserContact :' + loggedInUserContact);
            
            String accountId = '0011g000009ddci';//loggedInUserContact.accountId;
            //accountId = '0011g000009eAEe';
            String contactId = '0031g000007tXTa';
            String userId = '0051g000000fSU7';
           // if( loggedInUserContact != NULL && loggedInUserContact.Admin__c)
            if( String.isBlank(accountId) ){ //This codition is just for testing child Account, will remove while testing from Community
                
                List<Account> buildings = [SELECT Id, Name
                                           FROM Account 
                                           WHERE Id =: accountId];
                
                for( Account account : buildings ) {
                    PicklistWrapper picklistData = new PicklistWrapper( account.Id, account.Name );
                    buildingList.add( picklistData );
                }
         
                result.setStatus(TRUE, '');
            }else{
                if( String.isNotBlank(accountId)){
                    // Get all Role of Current User from Account Contact Relationship record.
                    String contactRole = [SELECT AccountId, ContactId, Id, Role__c 
                                          FROM AccountContactRelation
                                          Where ContactId =: contactId
                                          		AND AccountId =: accountId
                                          LIMIT 1].Role__c;                    
                    
                    if( String.isNotBlank(contactRole) ){
                        // Get all AccountContactRelation records.            
                        List<AccountContactRelation> accountContactRelationList = [SELECT AccountId, ContactId, Id, Role__c 
                                                                                   FROM AccountContactRelation
                                                                                   Where ContactId = : contactId 
                                                                                         AND Role__c =: contactRole];
                        Set<Id> accountIdSet = new Set<Id>();
                        
                        for( AccountContactRelation accountContactRelation : accountContactRelationList ){
                            accountIdSet.add(accountContactRelation.AccountId);
                        }
                        
                        // Get all Accounts(Building) having above Contact with above Role and in above accountIdSet
                        if( !accountIdSet.isEmpty() ){                             
                            
                            Map<Id, Account> buildingMap ;
                            
                            if( contactRole.equals('Employee') ){
                                buildingMap = new Map<Id, Account>([SELECT Id, Name
                                                                    FROM Account 
                                                                    WHERE Id IN : accountIdSet]);
                            }else if( contactRole.equals('Tenant') ){
                                buildingMap = new Map<Id, Account>([SELECT Id, Name
                                                                    FROM Account 
                                                                    WHERE Id IN : accountIdSet AND CreatedById =: userId]);
                            }
                            
                            /*Map<Id, Account> buildingMap = new Map<Id, Account>([SELECT Id, Name
                                                                                 FROM Account 
                                                                                 WHERE Id IN : accountIdSet]); */
                            System.debug('buildingMap::::'+buildingMap);
                            
                            if( buildingMap != NULL && !buildingMap.isEmpty() ){
                                for( Account account : buildingMap.values() ) {
                                    PicklistWrapper picklistData = new PicklistWrapper( account.Id, account.Name );
                                    System.debug( 'picklistData::'+picklistData );
                                    buildingList.add( picklistData );
                                }
                                
                                // Get all Cases related to Account (Building)
                                List<Account> accountList = getCases(buildingMap.keySet());
                                System.debug( 'accountList::'+accountList );
                                
                                for( Account account : accountList ){
                                    CaseWrapper casewrapper = new CaseWrapper(account, account.cases);
                                    caseList.add( casewrapper );
                                    System.debug( 'account.cases::'+account.cases );
                                }
                            }
                            
                            System.debug( 'buildingList::'+buildingList );
                            //Get Status
                            statuseList = getStatuses();
                            
                            //Get created By (Users)
                            userList = getUserDetails();                            
                            
                            PageDataWrapper data = new PageDataWrapper( buildingList, statuseList, userList ,caseList );
                            result.data = data;
                            
                            System.debug( 'result.data::'+ JSON.serializePretty(result.data) );
                            
                            result.setStatus(TRUE, '');
                        } 
                    }
                }
            }
        }catch(Exception ex){
            System.debug('Error occured : ' + ex.getMessage());
            result.setStatus(FALSE, 'Error Occured, Please contact your System Administrator');
        }    
        
        return result;
    }
    
    /*
    @ PURPOSE     : Get all values of Status picklist of Case object.
    @ RETURN TYPE : List<Map<String,String>>
    */
    public static List<PicklistWrapper> getStatuses(){         
        Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
        List<Schema.PicklistEntry> picklistValues = fieldResult.getPicklistValues();
        
        List<PicklistWrapper> statusPicklist = new List<PicklistWrapper>();
        
        for( Schema.PicklistEntry value : picklistValues){
            PicklistWrapper picklistData = new PicklistWrapper( value.getValue(),value.getValue() );
            statusPicklist.add( picklistData );
        }  
        
        return statusPicklist;
        
    }
    
    /*
    @ PURPOSE     : Get all User's.
    @ RETURN TYPE : List<Map<String,String>>
    */
    public static List<PicklistWrapper> getUserDetails(){   
        List<PicklistWrapper> userDetails = new List<PicklistWrapper>();
        List<User> userList ;
        
        try{
            userList = [SELECT Id, Name
                        FROM USER];
        }catch(Exception ex){
            System.debug('Error occured while fetching Users: ' + ex.getMessage());
        }        
        
        for(User user : userList ){
            PicklistWrapper picklistData = new PicklistWrapper( user.Id, user.Name ); 
            userDetails.add( picklistData );
        }        
        return userDetails;
        
    }
    
    /*
    @ PURPOSE     : Get all Cases realted to AccountId.
    @ RETURN TYPE : List<Case>
    */
    public static List<Account> getCases(Set<Id> accountIdSet ){ 
    
        List<Account> accountList = new List<Account>();
        
        if( accountIdSet != NULL && !accountIdSet.isEmpty() ){
            // Fetch all Cases realted to accountId
            try{
                accountList = [SELECT Id, Name, 
                               (SELECT Id, Type, Status,CaseNumber,Reason,Subject,Room_Name_Number__c,mHelpDesk_ID__c,CreatedById,CreatedBy.Name,
                                Due_Date__c,Time_Work_Total__c,Scheduled_End_Date_Time__c,Scheduled_Start_Date_Time__c FROM Cases)
                               FROM Account
                               WHERE Id IN : accountIdSet];
            }catch(Exception ex){
                System.debug('Error occured while fetching Account records' + ex.getMessage());
            }
        }
        
        return accountList;
    }

    public class PageDataWrapper {
        @AuraEnabled public List<PicklistWrapper> Buildings;          
        @AuraEnabled public List<PicklistWrapper> Status;  
        @AuraEnabled public List<PicklistWrapper> Users; 
        @AuraEnabled public List<CaseWrapper> cases;
        
        public PageDataWrapper( List<PicklistWrapper> Buildings, List<PicklistWrapper> Status, List<PicklistWrapper> Users, List<CaseWrapper> cases ) {
            this.Buildings = Buildings;
            this.Status = Status;
            this.Users = Users;
            this.cases = cases;
        }  
    }
    
    /**
    @ PURPOSE : Holds list of Buildong retrived.
    */
    public class ResponseWrapper {        
        
        @AuraEnabled
        public Object data;
        
         // Holds status.
        @AuraEnabled public Boolean isSucceeded;
        
        // Holds Page message.
        @AuraEnabled public String strPageMessage;
        
        /**
        @ PURPOSE : Initialisation of list.
        */
        public ResponseWrapper() {
            PageDataWrapper pageData = new PageDataWrapper( new List<PicklistWrapper>(), new List<PicklistWrapper>(), new List<PicklistWrapper>(),new List<CaseWrapper>() );
            this.data = pageData;
            this.isSucceeded = FALSE;
            this.strPageMessage = '';
        }    
        
        
        /**
        @ PURPOSE : Set Status and PageMessage.
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

    
    /**
    @ PURPOSE : Wrapper for all picklists
    */
    public class PicklistWrapper {                
        @AuraEnabled public String Id;          
        @AuraEnabled public String Label; 
        
        /**
        @ PURPOSE : Initialisation of list.
        */
        public PicklistWrapper( String Id, String Label ) {
            this.Id = Id;
            this.Label = Label;
        } 
    }
    
    
    /**
    @ PURPOSE : Wrapper for all cases
    */
    public class CaseWrapper {                
        @AuraEnabled public Account account;          
        @AuraEnabled public List<case> cases; 
        
        /**
        @ PURPOSE : Initialisation of list.
        */
        public CaseWrapper( Account account, List<Case> caseList ) {
            this.Account = account;
            this.cases = caseList;
        } 
    }
}