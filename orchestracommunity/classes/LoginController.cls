/**
 * @Description : Controller for Login visualforce page that exposes the site login functionality.
 * @CreatedDate : 02-04-2018
*/
public class LoginController extends BaseClass {
  
    public String username { get; set; }
    public String password { get; set; }
        
    /**
     * @Purpose : Login to the active site.
     * @Return  : PageReference
    */
    public PageReference login() {  
        
        PageReference reference;
              
        if( String.isNotBlank( username ) &&
            String.isNotBlank( password ) ) {
            
            reference = Site.login(username, password, '/s/');
        } else {
            isMsgShow = true;
            msgType = 'Error'; 
            pageMsg = 'Please enter username and password..!';
        }
        return reference;
    }
}