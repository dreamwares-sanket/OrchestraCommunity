({
	doInit : function(component, event, helper) {
        helper.setColumnsToShow(component, event, helper);
		helper.getData(component, event, helper);
	},
    
    handleNewCase: function(component, event, helper) {
        helper.fireCreateNewCaseEvent('Case');
        helper.navigateToCommunity(urlAddress);
    },
    
    /*handleEditCase : function(component, event, helper) {
        helper.fireEditCaseRecord(component.get("v.contact.Id"));
    },*/
    
    getSelectedName: function(component, event, helper) {   
          console.log("You selected:");
        var selectedRows = event.getParam('selectedRows');
        for (var i = 0; i < selectedRows.length; i++) {
            console.log("You selected: " .selectedRows[i].Id);
        }
    },
    
    getSelectedRecords : function(component, event, helper) {
        var dataTableId = event.getParam("dataTableId");
        var selectedRowId = event.getParam("selectedRowId");
        var selectedRow = event.getParam("selectedRow");
        
        var caseId = selectedRow.Id;
      /*  component.set("v.caseId", selectedRow.Id);
        var element = component.find("editCase");
        console.log('element ==' ,element);
        component.set("v.caseId", selectedRow.Id);
        component.find("editCase").get("e.recordSave").fire();*/
        
        helper.fireEditCaseRecord(caseId);
      /*  urlAddress = 'https://partial-maestromaintenance.cs96.force.com/s/';
        //helper.navigateToCommunity(urlAddress);*/
    },
    showModal : function( component, event, helper ) {
        document.getElementById("newCaseSection").style.display = "block";
    },
    hideModal : function( component, event, helper ) {
    	document.getElementById("newCaseSection").style.display = "none"; 
    },
    clickCreateCase : function(component, event, helper) {
		console.log( "in click of clickCreateCase" );
        var validCase = component.find('addcaseform').reduce(function ( validSoFar, inputCmp ) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        console.log( "is form valid : ", validCase );
        // If form is valid then send data to back-end for save
        if( validCase ){
            // Create the new expense
            var newCase = component.get( "v.newCase" );
            helper.createCase( component, newCase );            
        }
	},
    filterChange : function(component, event, helper) {
        console.log( "in filterChange", component.get('v.filter.building'), component.get('v.filter.status'), component.get('v.filter.user') );
        var buildingData = component.get( "v.myCases" );
        console.log( "buildingData before: ", buildingData );
        var buildingFilter = component.get('v.filter.building');
        var statusFilter = component.get('v.filter.status');
        var createdByFilter = component.get('v.filter.user');
        var filteredTableData = [];
        if( buildingFilter != '' || statusFilter != '' ||  createdByFilter != '' ) {
            for( var buildingDataIdx = 0; buildingDataIdx < buildingData.length; buildingDataIdx++ ) {
                var buildingDataRow = buildingData[ buildingDataIdx ];
                console.log( "buildingData[ buildingDataIdx ]: ", buildingDataRow );
                if( buildingFilter != '' ) { //if building filter is applied
                    if( buildingDataRow.account.Id == buildingFilter ) {
                        if( statusFilter != '' || createdByFilter != '' ) { //if status filter or created by filter is applied
                            var filterMatchCases = [];
                            for( var caseIdx = 0; caseIdx < buildingDataRow.cases.length; caseIdx++ ) {                            
                                if( statusFilter != '' &&  createdByFilter == '' ) {                                
                                    if( buildingDataRow.cases[ caseIdx ].Status 
                                       && buildingDataRow.cases[ caseIdx ].Status == statusFilter ) {
                                        filterMatchCases.push( buildingDataRow.cases[ caseIdx ] );
                                    }
                                } else if( createdByFilter != '' &&  statusFilter == '' ) {
                                    if( buildingDataRow.cases[ caseIdx ].CreatedBy.Id == createdByFilter ) {
                                        filterMatchCases.push( buildingDataRow.cases[ caseIdx ] );
                                    }
                                } else if( createdByFilter != '' &&  statusFilter != '' ) {
                                    if( buildingDataRow.cases[ caseIdx ].Status 
                                       && buildingDataRow.cases[ caseIdx ].Status == statusFilter 
                                       && buildingDataRow.cases[ caseIdx ].CreatedBy.Id == createdByFilter  ) {
                                        filterMatchCases.push( buildingDataRow.cases[ caseIdx ] );
                                    }
                                }
                            }
                            buildingDataRow.cases = filterMatchCases;
                            filteredTableData.push( buildingDataRow );
                        }
                        if( statusFilter == '' && createdByFilter == '' ) {
                            filteredTableData.push( buildingDataRow );
                        }
                	}
                } else if( statusFilter != '' || createdByFilter != '' ) { //if no building filter and status filter or created by filter is applied
                    var filterMatchCases = [];
                    for( var caseIdx = 0; caseIdx < buildingDataRow.cases.length; caseIdx++ ) {                            
                        if( statusFilter != '' &&  createdByFilter == '' ) {                                
                            if( buildingDataRow.cases[ caseIdx ].Status 
                               && buildingDataRow.cases[ caseIdx ].Status == statusFilter ) {
                                filterMatchCases.push( buildingDataRow.cases[ caseIdx ] );
                            }
                        } else if( createdByFilter != '' &&  statusFilter == '' ) {
                            if( buildingDataRow.cases[ caseIdx ].CreatedBy.Id == createdByFilter ) {
                                filterMatchCases.push( buildingDataRow.cases[ caseIdx ] );
                            }
                        } else if( createdByFilter != '' &&  statusFilter != '' ) {
                            if( buildingDataRow.cases[ caseIdx ].Status 
                               && buildingDataRow.cases[ caseIdx ].Status == statusFilter 
                               && buildingDataRow.cases[ caseIdx ].CreatedBy.Id == createdByFilter  ) {
                                filterMatchCases.push( buildingDataRow.cases[ caseIdx ] );
                            }
                        }
                    }
                    buildingDataRow.cases = filterMatchCases;
                    filteredTableData.push( buildingDataRow );
                }
            }
            component.set( "v.filteredTableData", filteredTableData );
        }        
    }
})