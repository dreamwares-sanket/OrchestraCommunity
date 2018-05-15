({
    customDataTableInit: function (cmp, event, helper) {
        
        console.log("window", window);
        
        console.log('================== customDataTableInit ');
        var rowsToShow = [];
        var tableData = cmp.get("v.tableData");
        var tableColumns = cmp.get("v.tableColumns");
        var keyField = cmp.get("v.keyField");
        console.log('================== tableData '+tableData);
        console.log('================== tableColumns '+tableColumns);
        console.log('================== keyField '+keyField);
        
        for(var i=0; i<tableData.length; i++){
            var singleRow = {Id: tableData[i][keyField]}; //Obj.Id
            singleRow.fieldsToShow = [];
            for(var j=0; j<tableColumns.length; j++){
                var singleFieldDetail = {fieldLabel: tableColumns[j].label};
                singleFieldDetail.fieldLabel = tableColumns[j].label;
                singleFieldDetail.fieldType = tableColumns[j].type.toLowerCase();
                singleFieldDetail.fieldValue = tableData[i][tableColumns[j].fieldName]; //Obj.Email, Obj.Phone
                singleRow.fieldsToShow.push(singleFieldDetail);
            }
            console.log("singleRow", singleRow);
            rowsToShow.push(singleRow);
        }
        console.log('================== rowsToShow.length '+rowsToShow);
        cmp.set("v.rowsToShow",rowsToShow);
    },
    
    rowSelected: function (cmp, event, helper) {      
        var rowLabel = event.getSource().get("v.label");
        helper.doRowSelected(cmp, rowLabel);
    },
    
    rowSelected2: function (cmp, event, helper) {
        var rowLabel = event.currentTarget.id;
        helper.doRowSelected(cmp, rowLabel);
    },
    
    tableDataChange: function (cmp, event, helper) {
        $A.enqueueAction(cmp.get('c.customDataTableInit'));
    },
})