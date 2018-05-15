({
	getData : function(component, event, helper) {
        var getDataAction = component.get("c.getData");
        
        getDataAction.setCallback(this, function(response) {
            var result = response.getReturnValue();
            console.log("result", result);
            if(result != null) {
                if (result.isSucceeded) {
                    component.set("v.myCases", result.data.cases);
                    component.set("v.filteredTableData", result.data.cases);
                    component.set( "v.pageData.status", result.data.Status );
                    component.set( "v.pageData.users", result.data.Users );
                    component.set( "v.pageData.buildings", result.data.Buildings );
                } else {
                    helper.showToastMessage('Error', result.strPageMessage, 'error');
                }
            }
        });
        $A.enqueueAction(getDataAction);
	},
    
    setColumnsToShow: function(component, event, helper) {
        component.set('v.tableColumns', [
            {label: 'Building', fieldName: 'Building__c', type: 'text'},
            {label: 'Case Number', fieldName: 'CaseNumber', type: 'text'},
            {label: 'Status', fieldName: 'Status', type: 'text'},
            {label: 'Type', fieldName: 'Type', type: 'text'},
            {label: 'Reason', fieldName: 'Reason', type: 'text'},
            {label: 'Subject', fieldName: 'Subject', type: 'text'},
            {label: 'Room Name', fieldName: 'Room_Name_Number__c', type: 'text'},
            {label: 'Help Desk ID', fieldName: 'mHelpDesk_ID__c', type: 'text'},
            {label: 'Due Date', fieldName: 'Due_Date__c', type: 'datetime'},
            {label: 'Work Total', fieldName: 'Time_Work_Total__c', type: 'text'},
            {label: 'Scheduled Start Date', fieldName: 'Scheduled_Start_Date_Time__c', type: 'datetime'},
            {label: 'Scheduled End Date', fieldName: 'Scheduled_End_Date_Time__c', type: 'datetime'}
       ]);
    },
    
    fireCreateNewCaseEvent: function(ObjectApiName) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": ObjectApiName
        });
        createRecordEvent.fire();
    },
    
    fireEditCaseRecord : function(caseId) {
        console.log('caseId ==' +caseId);
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": caseId
        });
        editRecordEvent.fire();
    },  
    
    showToastMessage : function(title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    
    navigateToCommunity : function(urlAddress) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": urlAddress,
            "isredirect" :false
        });
        urlEvent.fire();
    },
    
    createCase : function( component, newCase ) {
        var newCase = component.get("v.newCase");
        console.log( "Create item: " + JSON.stringify( newCase ) );
        //apex controller method : saveCase
        /*var action = component.get( "c.saveCase" );
        action.setParams({
            case : JSON.stringify( newCase )
        });
        action.setCallback( this, function( response ) {
            console.log( 'State: ',response.getState() );
            if( response.getState() == 'SUCCESS' ) {
                var cases = component.get("v.myCases");
                cases.push( response.getReturnValue() );
                component.set( "v.myCases", cases );
                console.log( "cases : ", cases );
                //reset newCase object and clear form once submitted successfully
                component.set( "v.newCase", {'sobjectType':'Case',
                                             'Account': '',
                                             'Building__c': '',
                                             'Contact': '',
                                             'Subject': '',
                                             'Description' : '',
                                             'Room_Name_Number__c' : '' } );
            }
        } );
        $A.enqueueAction( action );*/
    }
})