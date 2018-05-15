({
    casesDataTableInit: function (cmp, event, helper) {
        console.log('================== casesDataTableInit ');
        var tableData = cmp.get("v.tableData");
        var tableColumns = cmp.get("v.tableColumns");
        console.log('table Data: ', tableData, 'tableColumns: ', tableColumns )
        var formatedTableData = [];
        for( var i = 0; i < tableData.length; i++ ) {
            var singleRow = { account : tableData[i].account, cases : [] };
            for( var j = 0; j < tableData[i].cases.length; j++ ) {
                singleRow.cases[ j ] = { fieldsToShow : [] };
                for( var k = 1; k < tableColumns.length; k++ ) { 
                    var singleFieldDetail = {};
                    singleFieldDetail.fieldLabel = tableColumns[ k ].label;
                    singleFieldDetail.fieldType = tableColumns[ k ].type.toLowerCase();
                    singleFieldDetail.fieldValue = tableData[i].cases[ j ][ tableColumns[ k ].fieldName ]; //Obj.Email, Obj.Phone
                    singleRow.cases[ j ].fieldsToShow.push( singleFieldDetail );
                }
                console.log("singleRow", singleRow);        
            }
            formatedTableData.push( singleRow );       
        }
        console.log("formatedTableData", formatedTableData); 
        cmp.set("v.formatedTableData",formatedTableData);
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
        $A.enqueueAction(cmp.get('c.casesDataTableInit'));
    },
})