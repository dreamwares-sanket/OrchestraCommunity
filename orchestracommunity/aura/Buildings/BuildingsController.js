({
	showModal : function( component, event, helper ) {
        document.getElementById("newBuildingSection").style.display = "block";
    },
    hideModal : function( component, event, helper ) {
    	document.getElementById("newBuildingSection").style.display = "none"; 
    },
    clickCreateBuilding : function( component, event, helper ) {
    	console.log( "in click of clickCreateBuilding" );
        var validCase = component.find('addbuildingform').reduce(function ( validSoFar, inputCmp ) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        console.log( "is form valid : ", validCase );
        // If form is valid then send data to back-end for save
        if( validCase ){
            // Create the new expense
            var newBuilding = component.get( "v.newBuilding" );
            helper.createBuilding( component, newBuilding );            
        }
    }
})