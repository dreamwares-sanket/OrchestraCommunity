({
    doInit : function(component, event, helper) {
        var action = component.get("c.getCurrentUser");
        action.setCallback(this, function(response) {
            var user = response.getReturnValue();
            console.log(user);
            component.set("v.user", user);
        })
        $A.enqueueAction(action);
    },
    
    update : function(component, event, helper) {
        var user = component.get("v.user");
        console.log(user);
        alert('hi');
        var action = component.get("c.updateUserContact");
        
        action.setParams({ "user" : user });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if (state === "Success") {
                // Do stuff
            } 
            else {
                console.log(state);
            }
        });
        $A.enqueueAction(action);
    }    
})