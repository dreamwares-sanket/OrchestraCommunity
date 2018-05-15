({
	doInit : function(component, event, helper) {
        helper.setColumnsToShow(component, event, helper);
		helper.getMyLocations(component, event, helper);
	},
    
    handleNewAccount: function(component, event, helper) {
        helper.navigateToCommunity(urlAddress);
    },
    
  
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
})