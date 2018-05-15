({
	doRowSelected: function (cmp, rowLabel) {      
        var cmpEvent = cmp.getEvent("CustomDataTableRowSelection");
        var splitValue = rowLabel.split("-");
        var selectedId = splitValue[0];
        var selectedIndex = parseInt(splitValue[1]);
        var selectedRow =  cmp.get("v.tableData")[selectedIndex];
        var tableId = cmp.get("v.tableId");
        
        
        console.log('================== selectedId ',selectedId);
        console.log('================== selectedIndex ',selectedIndex);
        console.log('================== tableId ',tableId);
        console.log('================== selectedRow ',selectedRow);
        
        this.heighLightRow(cmp, rowLabel); 
        if(tableId != null && selectedId != null && selectedRow ){
            cmpEvent.setParams({
                "dataTableId" : tableId,
                "selectedRowId" : selectedId,
                "selectedRow" : selectedRow
            });        
            cmpEvent.fire();
        }
    },
    
    heighLightRow : function(cmp, rowLabel) {
        //GOING TO REMOVE ACTIVE CLASS FROM ALL ROWS
    	var allRows = document.getElementsByClassName("custom-selectable-row");
        for(var i=0; i<allRows.length; i++){
            allRows[i].className = allRows[i].className.replace('custom-active','');
        }
        
        //GOING TO ADD ACTIVE CLASS TO CURRENT ROW ONLY
        var currentRow = document.getElementById(rowLabel);
        currentRow.className = currentRow.className+' custom-active';
    },
})