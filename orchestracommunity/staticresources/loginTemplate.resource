<div class="login-window">
    <form name="data.loginform" novalidate="true">
        <div>
            <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.loginform.username.$invalid && data.isLoginFormSubmitted }">
                <div class="slds-form-element__control">
                    <input type="email" name="username" placeholder="Username" class="slds-input" ng-model="data.loginData.userName" required="true" ng-pattern="data.emailFormat" />
                </div>
                <div class="slds-form-element__help" ng-show="data.loginform.username.$invalid && data.isLoginFormSubmitted">Please enter valid username</div>
            </div>
            <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.loginform.password.$invalid && data.isLoginFormSubmitted }">
                <div class="slds-form-element__control">
                    <input type="password" name="password" placeholder="Password" class="slds-input" ng-model="data.loginData.password" required="true" minlength="8" />
                </div>
                <div class="slds-form-element__help" ng-show="data.loginform.password.$invalid && data.isLoginFormSubmitted">Please enter at least 8 charecters password</div>
                <div class="slds-text-align_right forgotLink">
                    <a href="javascript:void(0);" class="linkTxt" ng-click="data.currentView = 'forgotPassword'">Forgot Password?</a>
                </div>
            </div>
            <div class="btnClass">
                <button class="login-btn" ng-click="loginUser()">Login</button>
            </div>
        </div>
        <div class="">
            <a href="javascript:void(0);" ng-click="data.currentView = 'signUp'" class="slds-text-align_center sign-btn">SIGN UP</a>
        </div>
    </form>
</div>