/**
    @ Purpose : 1. Controls the visualforce component --> SignUpComponent
                2. Supports self registration of users in community.
*/

public with sharing class SignUpController extends BaseClass {
    
    public SignUpController() {
        
        super();
    }
    
    @RemoteAction 
    public Static Response createUser( SignUpHandler signUpData ) {
        
        System.debug( 'signUpData:-\n' + JSON.serialize( signUpData ) );
        Response response = new Response();
        
        if( signUpData != NULL ) {
            response = signUpData.signUpUser();
        }
        else {
            response.setStatus( FALSE, System.Label.Form_Data_Missing, NULL );
        }
        return response;
    }
}