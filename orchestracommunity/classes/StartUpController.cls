/**
 * @Description : Controller for Login visualforce page that exposes the site login functionality.
 * @CreatedDate : 02-04-2018
*/
public class StartUpController extends BaseClass{
  
    public Boolean isLoginShow { get; set; }
    public Boolean isSignUpShow { get; set; }
    public Boolean isForgotPasswordShow { get; set; }    
    
    public StartUpController() {
        isLoginShow = true;
    }  
        
   /**
    *@Purpose : Login to the active site.
    *@Return  : response
    */
    @RemoteAction 
    public Static Response loginUser(StartUpHandler.LoginUserDTO loginData) {
        Response response;

        if( loginData != null && String.isNotBlank( loginData.userName ) &&
           String.isNotBlank( loginData.password ) ) {
               
              Site.login(loginData.userName, loginData.password, '/s/');
              response = new Response(true, 'Login successfully!', null);
           } else {
               return new Response(false, 'Please enter username and password..!', null );
           }
        return Response;
    }
    
    /**
     *@Purpose : Send forgot passowrd link
	 *@Param   : UserName 
     *@Return  : response
     */
     @RemoteAction
     public Static Response forgotPassword(String userName) {
        Response response;
        if( String.isNotBlank( userName ) ) {            
            boolean success = Site.isValidUsername(userName);
            if(success) {              
                if( Site.forgotPassword(userName) ) {
                   response = new Response(true, 'UserName is Valid.. !', null);
                }                
            } else {
                return new Response(false, 'Username Dose Not Exist..!', null );
            }
        } else {
            return new Response(false, 'Please Enter Username..!', null );
        }
        return response;
    }
    
    
    /**
     *@Purpose : Create Community user
	 *@param   : signUpData 	
     *@Return  : response
     */
    @RemoteAction 
    public Static Response createUser(SignUpHandler signUpData) {
        Response response;
        if(signUpData != null) {
            response = signUpData.signUpUser();
        }
        else {
            return new Response(false, 'Please fillup required data..!', null);
        }
        
        return response;
    }
}