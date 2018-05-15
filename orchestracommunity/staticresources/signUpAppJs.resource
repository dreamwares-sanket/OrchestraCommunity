function callVfRemoting(options) {
    var deferred = jQuery.Deferred();
    options.callback = function(result, event) {
        console.log('event=='+event);
        if (event.status) {
            deferred.resolve(result);
        }
        else {
            deferred.reject(event.message);
        }
    };
    options.vfConfig = { escape: false };
    // array for all arguments for VF invoke action method
    var argumentsArray = [];
    // push remote action url
    argumentsArray.push(options.url);
    // push all parameters for remote method
    for(var i = 0; i < options.params.length; i++){
        argumentsArray.push(options.params[i]);
    }
    // push callback function
    argumentsArray.push(options.callback);
    // push extra arguments
    argumentsArray.push(options.vfConfig);
    console.log(argumentsArray);
    Visualforce.remoting.Manager.invokeAction.apply(Visualforce.remoting.Manager, argumentsArray);
    console.log(deferred.promise());
    return deferred.promise();
}

function showToastMessage( headingTxt, message, icon ) {
    $.toast({
        heading: headingTxt,
        text: message,
        icon: icon,
        position: 'top-center'
    });      
}

/*
* Function to show loader for asyn functions
*/
function displayLoader() {
    $( '.spin-bg' ).show();
}
/*
* Function to hide loader
*/
function hideLoader() {
    $( '.spin-bg' ).hide();
}

function getFormDataInRequiredFormat( formData ) {
    var signupData = {
        accountData : {
            billingEntityName : '',
            physicalAddress: '',
            billingStreet: '',
            billingCity : '',
            billingState : '',
            billingPostalCode : '',
            billingCountry : '',
            isBillingAddress: '',
            billingAddress: '',
            physicalCountry: '',
            physicalPostalCode: '',
            physicalState: '',
            physicalCity : '',
            physicalStreet : '',
            isSameAddress: false,
            officePhone : ''
        },
        contactData: {
            firstName: '',
            lastName : '',
            email : '',
            mobilePhone: ''
        }   
    };
    var mobileStr = officePhoneStr = '';
    $.each( formData, function ( index, field ) {
        //console.log( "field: ", field.name, field.value );
        //collect contact data
        if( field.name == 'firstName' || field.name == 'lastName' || field.name == 'email' ) {
            signupData.contactData[ field.name ] = field.value;
        } else if( field.name == 'mobilePhoneOne' || field.name == 'mobilePhoneTwo' || field.name == 'mobilePhoneThree'  ) { //mobile phone
            mobileStr += field.value;                     
        } else if( field.name == 'officePhoneOne' || field.name == 'officePhoneTwo' || field.name == 'officePhoneThree' ) { //account data : phone number
            officePhoneStr += field.value;    
        } else if( field.name != 'agreeCheck' ) { //rest account data
            signupData.accountData[ field.name ] = field.value;
        }
    });
    if( $( '.address-samecheck' ).prop( 'checked' ) ) {
        signupData.accountData[ 'isSameAddress' ] = true;
    } else {
        signupData.accountData[ 'isSameAddress' ] = false;
    }
    signupData.contactData[ 'mobilePhone' ] = mobileStr;
    signupData.accountData[ 'officePhone' ] = officePhoneStr;
    return signupData;
}