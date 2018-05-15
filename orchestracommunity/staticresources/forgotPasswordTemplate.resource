<div class="forgot-window">
    <div class="titleSection">
        <h1 class="pageTitle">
            Forgot Password
        </h1>
    </div> 
    <form name="data.forgotpassfrm" novalidate="true">
        <div>                        
            <div class="slds-m-top_large">   
                <span class="page-message messageStyle">
                    Please enter your username below.
                </span>
                {{ data.isForgotpassFormSubmitted }} {{ data.forgotpassfrm.username.$invalid }}
                <div class="slds-m-top_xxx-small"> 
                    <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.forgotpassfrm.username.$invalid && data.isForgotpassFormSubmitted }">                                  
                        <div class="slds-form-element__control">
                            <input type="email" name="username" placeholder="Username" class="slds-input" ng-model="data.forgotPassEmail" required="true" ng-pattern="data.emailFormat" />
                        </div>
                        <div class="slds-form-element__help" ng-show="data.forgotpassfrm.username.$invalid && data.isForgotpassFormSubmitted">Please enter valid username</div>  
                    </div>                         
                </div>                                                                                         
            </div>                        
        </div>  
        <div class="slds-m-top_medium">
            <button class="slds-button slds-button_neutral" ng-click="forgotPassword()">Send Link</button>
        </div>
    </form>                   
    <div>
        <div class="slds-form-element__control">
            <a href="javascript:void(0);" ng-click="data.currentView = 'login'" class="linkTxt">Back to Login</a>
        </div>
    </div>
</div>