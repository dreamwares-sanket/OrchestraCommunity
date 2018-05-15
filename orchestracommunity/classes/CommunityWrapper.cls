/**
 * Created by Dream on 5/15/2018.
 */

public with sharing class CommunityWrapper {
    public virtual class Status {

        // HOLDS TRUE IF OPERATION IS PERFORMED SUCCESSFULLY OTHERWISE FALSE.
        @AuraEnabled public Boolean isSucceeded { get; set; }

        // HOLDS THE MESSAGE TO BE DISPLAYED ON PAGE.
        @AuraEnabled public String strPageMessage { get; set; }

    /**
    @ PURPOSE : SETS THE STATES BASED ON THE VALUES RECEIVED.
    */
        public Status() {

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

    public class CommunityBuildings {
        @AuraEnabled public List<Account> buildingAccounts;

    }
    public class CommunityUsers{

    }
}