/**
@ PURPOSE : Wrapper for Community User.
*/
public class CommunityUserWrapper {
    
    @AuraEnabled public User user;
    @AuraEnabled public Contact contact;
    @AuraEnabled public Account account;          
    @AuraEnabled public Boolean isAdmin; 
    
    /**
    @ PURPOSE : Initialisation of list.
    */
    public CommunityUserWrapper( User user, Contact contact, Account account, Boolean isAdmin ) {
        this.user = user;
        this.contact = contact;
        this.account = account;
        this.isAdmin = isAdmin;
    } 
}