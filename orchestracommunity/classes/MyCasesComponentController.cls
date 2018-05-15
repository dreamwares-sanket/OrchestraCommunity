/*
	@PURPOSE : 1. TO RETRIEVE CASES FOR CURRENT LOGGED IN USER.
*/
public class MyCasesComponentController {

    /**
       @ PURPOSE     : TO FETCH CASES FOR CURRENT LOGGED IN USER.
       @ RETURN TYPE : CaseWrapper [ RESULT WITH CASES AND MESSAGE ].
    */
    @AuraEnabled
    public static CaseWrapper getMyCases() {
        CaseWrapper result = new CaseWrapper();
        
        try {
            // FETCH CASES BY USERID.
            result.cases = [ SELECT Id, Scheduled_End_Date_Time__c, Scheduled_Start_Date_Time__c, Time_Work_Total__c, 
                            		Due_Date__c, mHelpDesk_ID__c, Room_Name_Number__c, Status, Type, Reason, Subject, 
                            		CaseNumber
                             FROM Case 
                             WHERE OwnerId = : UserInfo.getUserId() ];
            result.setStatus(TRUE, '');
        } catch(Exception e) {
            result.setStatus(FALSE, getPageErrorMessage(e));
        }
        
        return result;
    }
    
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
		@ PURPOSE : HOLDS CASES RESULT.
	*/
    public class CaseWrapper {
        // HOLDS CASES RETRIEVED.
        @AuraEnabled public List<Case> cases;
        
        // HOLDS TRANSACTION STATUS.
        @AuraEnabled public Boolean isSucceeded;
        
        // HOLDS TRANSACTION MESSAGE.
        @AuraEnabled public String strPageMessage;
        
        /**
			@ PURPOSE : SETS THE DEFAULT VALUES.
		*/
        public CaseWrapper() {
            this.cases = new List<Case>();
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