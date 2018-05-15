({
	toggleSidebar : function(component, event, helper) {
        var sidebarElement = component.find("sidebarElement");
        if(sidebarElement.getElement().className === "sidebar-nav-container") {
            $A.util.removeClass(sidebarElement, "sidebar-nav-container");
            $A.util.addClass(sidebarElement, "sidebar-collapse");
        } else {
            $A.util.removeClass(sidebarElement, "sidebar-collapse");
            $A.util.addClass(sidebarElement, "sidebar-nav-container");
        }
        
        var mainContainerElement = component.find("mainContainerElement");
        if(sidebarElement.getElement().className === "main-container") {
            $A.util.removeClass(sidebarElement, "main-container");
            $A.util.addClass(sidebarElement, "expand");
        } else {
            $A.util.removeClass(sidebarElement, "expand");
            $A.util.addClass(sidebarElement, "main-container");
        }
	},
	    
    showSmallNavBar : function(component, event, helper) {
        var fullNavBar = component.find("fullNavBar");
        var smallNavBar = component.find("smallNavBar");
        
        $A.util.addClass(fullNavBar, "hide");
        $A.util.removeClass(smallNavBar, "hide");
        $A.util.addClass(smallNavBar, "show");
        
        var pageBody = component.find("pageBody");
        $A.util.removeClass(pageBody, "mainContentArea");
        $A.util.addClass(pageBody, "mainContentAreaColaps");
    },
    
    showFullNavBar : function(component, event, helper) {
        var pageBody = component.find("pageBody");
        $A.util.removeClass(pageBody, "mainContentAreaColaps");
        $A.util.addClass(pageBody, "mainContentArea");
        
        var fullNavBar = component.find("fullNavBar");
        var smallNavBar = component.find("smallNavBar");
        
        $A.util.addClass(smallNavBar, "hide");
        $A.util.removeClass(fullNavBar, "hide");
        $A.util.addClass(fullNavBar, "show");
    }
    
   
})