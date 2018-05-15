({
	createBuilding : function( component, newBuilding ) {
		console.log( "in createBuilding helper method" );
        var newBuilding = component.get("v.newBuilding");
        console.log( "Create item: " + JSON.stringify( newBuilding ) );
        //apex controller method : saveBuilding
        /*var action = component.get( "c.saveBuilding" );
        action.setParams({
            building : JSON.stringify( newBuilding )
        });
        action.setCallback( this, function( response ) {
            console.log( 'State: ',response.getState() );
            if( response.getState() == 'SUCCESS' ) {
                var buildings = component.get("v.allBuildings");
                buildings.push( response.getReturnValue() );
                component.set( "v.allBuildings", buildings );
                console.log( "buildings : ", buildings );
                //reset newBuilding object and clear form once submitted successfully
                component.set( "v.newBuilding", {'sobjectType':'Account' } );
            }
        } );
        $A.enqueueAction( action );*/
	}
})