/**
 *@Purpose    : Return response
 *@CreateDate : 3 May 2018
*/
public class Response {
    
    public Boolean success;
    public String message;  
    public Object data;
    
    public Response() {
        
        this.success = FALSE;
        this.message = '';
    }
    
    public Response( Boolean success, String message, Object data){
        this.success = success;
        this.message = message;
        this.data = data;
    }
    
    public void setStatus( Boolean success, String message, Object data ) {
        
        if( success == NULL ) {
            success = FALSE;
        }
        this.success = success;
        
        if( message == NULL ) {
            message = '';
        }
        this.message = message;
        
        this.data = data;
    }
 }