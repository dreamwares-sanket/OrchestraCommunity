({
    getInvitedUsers : function(component, event, helper) {
        var getInvitedUsersAction = component.get("c.getInvitedUsers");
        getInvitedUsersAction.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log("result", result);
            if(result != null) {
                if (result.isSucceeded) {
                    component.set("v.invitedUsers", result.invitedUsersContact);
                } else {
                    helper.showToastMessage('Error', result.strPageMessage, 'error');
                }
            }
        });
        $A.enqueueAction(getInvitedUsersAction);
    },
    
    setColumnsToShow: function(component, event, helper) {
        component.set('v.tableColumns', [
            {label: 'Name', fieldName: 'Name', type: 'text', disabled:'true'},
            {label: 'Mobile', fieldName: 'MobilePhone', type: 'text', disabled:'true'},
            {label: 'Email', fieldName: 'Email', type: 'text', disabled:'true'}
            
        ]);
    },
    
    
    
    
    showToastMessage : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    
    navigateToCommunity : function(urlAddress) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlAddress,
            "isredirect" :false
        });
        urlEvent.fire();
    }
})