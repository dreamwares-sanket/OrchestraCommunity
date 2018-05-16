/**
    @ Purpose : 1. Controls the visualforce component --> Typeahead
                2. Fetches sObject records based on the search keyword and object details.
*/
public without sharing class TypeaheadController {

    @RemoteAction
    public static List<sObject> searchRecords( String queryString, String objectName, 
                                               list<String> fieldNames, 
                                               String fieldsToSearch, 
                                               String filterClause, String orderBy, 
                                               Integer recordLimit 
    ) {
        List<sObject> listOfSearchedRecords;
        if( String.isNotBlank( queryString ) && String.isNotBlank( objectName )  ) {
            queryString = String.escapeSingleQuotes( queryString );
            objectName = String.escapeSingleQuotes( objectName );
            if( String.isNotBlank( queryString ) && String.isNotBlank( objectName )  ) {
                
                // SETS FIELDS TO BE SEARCHED IN.
                String sInFields = '';
                if( String.isNotBlank( fieldsToSearch ) || fieldsToSearch != 'ALL' ) {
                    sInFields = ' IN ' + String.escapeSingleQuotes( fieldsToSearch ) + ' FIELDS';
                }
                
                // SETS FIELDS TO BE FETCHED.
                String sFields = 'ID, Name';
                if( fieldNames != NULL && !fieldNames.isEmpty() ) {
                    sFields = String.escapeSingleQuotes( String.join( fieldNames, ', ' ) );
                }
                
                // SETS FILTER CLAUSE [ HARD CODED FOR ACCOUNT OBJECT ].
                String sWhere = '';
                if( objectName == 'Account' ) {
                    ID recordTypeId = SignUpHandler.getRecordTypeId( 'Account', 'Management' );
                    if( recordTypeId != NULL ) {
                        sWhere = ' WHERE RecordTypeId = \'' + recordTypeId + '\' ';
                    }
                }
                else if( String.isNotBlank( filterClause ) ) {
                    sWhere = ' WHERE ' + filterClause;
                }
                
                // SETS ORDER.
                String sOrder = ' ORDER BY ';
                if( String.isBlank( orderBy ) ) {
                    sOrder += 'Name';
                }
                else {
                    sOrder += String.escapeSingleQuotes( orderBy );
                }
                
                // SETS RECORDS LIMIT.
                String sLimit = '';
                if( recordLimit != null && recordLimit != 0 && 
                    recordLimit < 2000
                
                ) {
                    sLimit = ' LIMIT ' + recordLimit;
                }
                
                List<List<sObject>> results = new List<List<sObject>>();
                try {
                    String strQuery = 'FIND \'' + queryString + '*\'' + sInFields +
                                      ' RETURNING ' + objectName + '( ' + sFields + 
                                      sWhere + sOrder + sLimit + ' )';
                    strQuery = strQuery.normalizeSpace();
                    System.debug( 'strQuery:-\n' + strQuery );
                    results = Search.query( strQuery );
                }
                catch( Exception e ) {
                    System.debug( 'Sorry, an unexpected error occurred while fetching searh results. ' +
                                  'Please contact System Administrator. ' +
                                  'Exception details:-\n' + e.getMessage() 
                                );
                }
                finally {
                    if( !results.isEmpty() ) {
                        listOfSearchedRecords = results.get( 0 );
                    }
                }
            }
        }
        return listOfSearchedRecords;
    }
}