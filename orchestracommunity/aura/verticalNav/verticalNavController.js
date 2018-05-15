({
    onClick : function(component, event, helper) {
        var id = event.target.dataset.menuItemId;
        if (id) {
            component.getSuper().navigate(id);
        }
    },
    
    toggleNavBar : function(component, event, helper) {
        var navBar = component.find("navigationBar");
        $A.util.toggleClass(navBar, "navBarToggle");
    }
})