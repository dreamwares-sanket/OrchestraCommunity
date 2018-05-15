<div>
  <header>
    <div class="banner">
        <apex:image url="{{bannerImageUrl}}/images/logoImg.png" width="168" /> 
        <h2>Account Set-Up</h2>
    </div>
  </header>
  <div class="form-container">
   <form name="data.signupform" novalidate="true">
       <div class="slds-form slds-form_stacked slds-m-bottom_large">
           <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.signupform.billingEntityName.$invalid && data.isFormSubmitted }">
               <label class="slds-form-element__label" for="input-id-12">Billing Entity Name *</label>
               <div class="slds-form-element__control">
                   <input type="text" id="input-id-12" class="slds-input" name="billingEntityName" required="true" ng-model="data.accountData.billingEntityName" maxlength="80" />
                   
               </div>
               <div class="slds-form-element__help" id="billing-entity-error" ng-show="data.signupform.billingEntityName.$invalid && data.isFormSubmitted">Please enter billing entity name</div>
           </div>
       </div>
       
       <div class="slds-form slds-form_compound slds-m-bottom_large">
           <fieldset class="slds-form-element">
                <legend class="slds-form-element__label">Name *</legend>
               <div class="slds-form-element__group">
                   <div class="slds-form-element__row">
                       <div class="slds-form-element slds-size_1-of-2" ng-class="{ 'slds-has-error' : data.signupform.firstName.$invalid && data.isFormSubmitted }">                               
                           <input type="text" id="input-11" class="slds-input" name="firstName" required="true" ng-model="data.contactData.firstName" maxlength="40" />
                           <label class="sub-label" for="input-11">First Name </label>
                       </div>
                       <div class="slds-form-element__help" ng-show="data.signupform.firstName.$invalid && data.isFormSubmitted">Please enter first name</div>
                       <div class="slds-form-element slds-size_1-of-2" ng-class="{ 'slds-has-error' : data.signupform.lastName.$invalid && data.isFormSubmitted }">
                           
                           <input type="text" id="input-02" class="slds-input" name="lastName" required="true" ng-model="data.contactData.lastName"  />
                           <label class="sub-label" for="input-02" maxlength="80">Last Name</label>
                       </div>
                       <div class="slds-form-element__help" ng-show="data.signupform.lastName.$invalid && data.isFormSubmitted">Please enter last name</div>
                   </div>
               </div>
           </fieldset>
       </div>
       
       <div class="slds-form slds-form_stacked slds-m-bottom_large">
           <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.signupform.email.$invalid && data.isFormSubmitted }">
               <label class="slds-form-element__label" for="input-id-01">Email Address *</label>
               <div class="slds-form-element__control">
                   <input type="email" id="input-id-01" class="slds-input" name="email" required="true" ng-model="data.contactData.email" ng-pattern="data.emailFormat"  />
               </div>
               <div class="slds-form-element__help" ng-show="data.signupform.email.$invalid && data.isFormSubmitted">Please enter valid email</div>
           </div>
       </div>
       
       <div class="slds-form slds-form_stacked slds-m-bottom_large">
           <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.signupform.physicalStreet.$invalid && data.isFormSubmitted }">
               <label class="slds-form-element__label" for="input-id-02">Physical Address  *</label>
               <div class="slds-form-element__control">
                   <input type="text" id="input-id-02" class="slds-input" name="physicalStreet" required="true" ng-model="data.accountData.physicalStreet"  />
                    <label class="sub-label" for="input-02">Address</label>
               </div>
               <div class="slds-form-element__help" ng-show="data.signupform.physicalStreet.$invalid && data.isFormSubmitted">Please enter physical address</div>
           </div>
       </div>
       
        <div class="slds-form slds-form_compound slds-m-bottom_large">
       <fieldset class="slds-form-element">
           
           <div class="slds-form-element__group">
             
               <div class="slds-form-element__row">
                   <div class="slds-form-element slds-size_1-of-2">                           
                       <input type="text" id="input-04" class="slds-input" ng-model="data.accountData.physicalCity" />
                       <label class="sub-label" for="input-04">City</label>
                   </div>
                   <div class="slds-form-element slds-size_1-of-2">
                       <input type="text" id="input-05" class="slds-input" ng-model="data.accountData.physicalState" />                           
                       <label class="sub-label" for="input-05">State/Province</label>
                   </div>
               </div>
               <div class="slds-form-element__row slds-m-bottom_large">
                   <div class="slds-form-element slds-size_1-of-2">                           
                       <input type="text" id="input-06" class="slds-input" ng-model="data.accountData.physicalPostalCode" integer-only="true" />
                       <label class="sub-label" for="input-06">Zip/Postal Code</label>
                   </div>
               </div>
               <div class="slds-form-element__row">
                   <div class="slds-form-element slds-size_1-of-1">                          
                       <input type="text" id="input-03" class="slds-input" ng-model="data.accountData.physicalCountry" />
                        <label class="sub-label" for="input-03">Country</label>
                   </div>
               </div>
           </div>
       </fieldset>
       </div>
       <div class="slds-form-element__row slds-m-bottom_large">
           <div class="slds-form-element slds-size_1-of-1">
               <div class="slds-form-element__label displayBlock">Billing Address Same as Physical Address</div>
               <span class="slds-checkbox">              
                   <input type="checkbox" name="options" id="checkbox-1" ng-model="data.accountData.isSameAddress" />
                   <label class="slds-checkbox__label" for="checkbox-1">
                       <span class="slds-checkbox_faux"></span>                  
                   </label>
               </span>
           </div>
       </div>
       
       <div class="billingStreetFields" ng-hide="data.accountData.isSameAddress">
            <div class="slds-form slds-form_stacked slds-m-bottom_large">
               <div class="slds-form-element" ng-class="{ 'slds-has-error' : data.signupform.billingStreet.$invalid && data.isFormSubmitted }">
                   <label class="slds-form-element__label" for="input-id-04">Billing Address  *</label>
                   <div class="slds-form-element__control">
                       <input type="text" name="billingStreet" id="input-id-04" class="slds-input" ng-model="data.accountData.billingStreet" ng-required="!data.accountData.isSameAddress" />
                        <label class="sub-label" for="input-04">Address</label>
                   </div>
                   <div class="slds-form-element__help" ng-show="data.signupform.billingStreet.$invalid && data.isFormSubmitted">Please enter billing address</div>
               </div>
           </div>
           
           <div class="slds-form slds-form_compound slds-m-bottom_large">
               <fieldset class="slds-form-element">
                   
                   <div class="slds-form-element__group">
                      
                       <div class="slds-form-element__row">
                           <div class="slds-form-element slds-size_1-of-2">                           
                               <input type="text" id="input-04" class="slds-input" />                               
                               <label class="sub-label" for="input-04" ng-model="data.accountData.billingCity">City</label>
                           </div>
                           <div class="slds-form-element slds-size_1-of-2">
                               <input type="text" id="input-05" class="slds-input" />                           
                               <label class="sub-label" for="input-05" ng-model="data.accountData.billingState">State/Province</label>
                           </div>
                       </div>
                       <div class="slds-form-element__row slds-m-bottom_large">
                           <div class="slds-form-element slds-size_1-of-2">                           
                               <input type="text" id="input-06" class="slds-input" />
                             <label class="sub-label" for="input-05" ng-model="data.accountData.billingPostalCode">Zip/Postal Code</label>
                           </div>
                       </div>
                       <div class="slds-form-element__row">
                           <div class="slds-form-element slds-size_1-of-1">                          
                               <input type="text" id="input-03" class="slds-input" />
                               <label class="sub-label" for="input-05" ng-model="data.accountData.billingCountry">Country</label>
                           </div>
                       </div>
                   </div>
               </fieldset>
           </div>
       </div>
         
       <div class="slds-form-element__group slds-m-bottom_large">
           <label class="slds-form-element__label" for="input-id-01">Office Phone</label>
           <div class="slds-form-element__row contentFlex">
               <div class="slds-form-element slds-size_1-of-12 slds-m-right_medium">                           
                   <input type="text" id="input-04" class="slds-input" integer-only="true" ng-model="data.officePhonePart1" maxlength="3"  />
                   <label class="sub-label" for="input-04">(###)</label>
               </div>
               <div class="slds-form-element slds-size_1-of-12 slds-m-right_medium">
                   <input type="text" id="input-05" class="slds-input" integer-only="true" ng-model="data.officePhonePart2" maxlength="3" /> 
                   <label class="sub-label" for="input-06">###</label>
                   
               </div>
               <div class="slds-form-element slds-size_1-of-12">
                   <input type="text" id="input-05" class="slds-input" integer-only="true" ng-model="data.officePhonePart3" maxlength="4" />
                   <label class="sub-label" for="input-03">####</label>
                   
               </div>
           </div>
       </div>
       
       <div class="slds-form-element__group slds-m-bottom_large">
           <label class="slds-form-element__label" for="input-id-01">Mobile  Phone *</label>
           <div class="slds-form-element__row contentFlex">
               <div class="slds-form-element slds-size_1-of-12 slds-m-right_medium">                           
                   <input type="text" id="input-04" integer-only="true" class="slds-input" ng-model="data.mobilePart1" maxlength="3" />
                   <label class="sub-label" for="input-04" >(###)</label>
               </div>
               <div class="slds-form-element slds-size_1-of-12 slds-m-right_medium">
                   <input type="text" id="input-05" integer-only="true" class="slds-input" ng-model="data.mobilePart2" maxlength="3" /> 
                   <label class="sub-label" for="input-06"  >###</label>
                   
               </div>
               <div class="slds-form-element slds-size_1-of-12">
                   <input type="text" id="input-05" integer-only="true" class="slds-input" ng-model="data.mobilePart3" maxlength="4" />
                   <label class="sub-label" for="input-03" >####</label>
                   
               </div>
           </div>
           </div>
      
       
        <div class="slds-form slds-form_stacked slds-m-bottom_large">
           <div class="slds-form-element">
               <label class="slds-form-element__label" for="input-id-01">Notes</label>
               <div class="slds-form-element__control">
                   <label class="sub-label" for="input-03">Provide any additional information that you feel necessary</label>
                     <textarea id="input-unique-id" class="slds-textarea" ></textarea>
               </div>
           </div>
       </div>
       
       <button class="btnDefault" ng-click="createUser()">SUBMIT</button>
    </form> 
</div>
      <footer class="footer">Powered by <a href="#">Squarespace</a></footer>
</div>