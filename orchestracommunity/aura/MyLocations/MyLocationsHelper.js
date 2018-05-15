({
    getMyLocations : function(component, event, helper) {
        var getMyLocationsAction = component.get("c.getMyLocations");
        getMyLocationsAction.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log("result", result);
            if(result != null) {
                if (result.isSucceeded) {
                    component.set("v.myLocations", result.buildings);
                } else {
                    helper.showToastMessage('Error', result.strPageMessage, 'error');
                }
            }
        });
        $A.enqueueAction(getMyLocationsAction);
    },
    
    setColumnsToShow: function(component, event, helper) {
        component.set('v.tableColumns', [
            {label: 'Location', fieldName: 'Name', type: 'text', disabled:'true'}
            
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