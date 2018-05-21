/**
    @ Purpose : Tests the functionality of class --> TypeaheadController
*/

@isTest
public class TypeaheadControllerTest {
    
    public final static String ACCOUNT_RECORD_TYPE = 'Management';
    
    @Testsetup static void inserTestData() {
        
        Integer intNoOfRecords = 0;
        ID recordTypeId = [ SELECT ID FROM RecordType 
                            WHERE sObjectType = 'Account' AND Name =: ACCOUNT_RECORD_TYPE 
                            LIMIT 1 
                          ][0].ID;
        
        List<Account> listOfAccounts = new List<Account>();
        intNoOfRecords = 10;
        for( Integer i = 0; i < intNoOfRecords; i ++ ) {
            listOfAccounts.add( new Account( Name = 'Test_' +  i, RecordTypeId = recordTypeId ) );
        }
        
        insert listOfAccounts;
        System.debug( 'listOfAccounts:-\n' + JSON.serialize( listOfAccounts ) );
        System.assertEquals( intNoOfRecords, [ SELECT COUNT() FROM Account WHERE RecordTypeId =: recordTypeId ] );
    }
    
    public static TestMethod void testSearchRecords() {
        
        Test.startTest();
        
        List<sObject> listOfSobjects = TypeaheadController.searchRecords
                                                           (
                                                            'Test', 'Account', 
                                                             new List<String>{ 'ID', 'Name' }, 'Name',
                                                             '', 'Name', 10
                                                           );
        System.debug( 'listOfSobjects:-\n' + JSON.serialize( listOfSobjects ) );
        
        Test.stopTest();
        
        System.assertNotEquals( NULL, listOfSobjects );
    }
}