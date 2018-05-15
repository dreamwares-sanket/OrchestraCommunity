*{margin:0;padding:0;}
:focus{outline:none !important;box-shadow:none !important;}
.banner{
    width:100%;
    background:#000;
    height:300px;
    display: flex; 
    align-items: center; 
    justify-content: center;
    background-image:url("{!URLFOR($Resource.bannerImg,'images/logoImg.png')}");  
    background-size: cover;
	background-repeat: no-repeat;
}
.banner h2{font-size: 75px  !important; letter-spacing: 0px; text-transform: none; line-height: 1.1em; color: rgba(255,136,56,.9); }
.banner img{position:absolute;top:0;left:0;margin-top:20px;margin-left:20px;}
.form-container{width:100%;padding:120px 20px;margin:0 auto;max-width:1000px;background:#fff;}
.form-container form div input.slds-input, textarea{width: 100% !important; padding: 12px !important; margin: 6px 0 4px; border: 1px solid #ccc !important; background: #fafafa !important; color: #000; font-family: sans-serif; font-size: 12px; line-height: normal !important; box-sizing: border-box; border-radius: 0 !important; }
.form-container form div input:focus, textarea:focus{background-color:#fff !important;}
.slds-scope .slds-form-element__label{font-size: 16px !important;letter-spacing: .6px;color:#000!important;}
.displayBlock{display:block !important;}
.contentFlex{display: flex !important;}
.btnDefault{color: #fff !important; background-color: rgba(240,96,0,.9);letter-spacing: .9px; border-color: rgba(240,96,0,.9); display: inline-block; width: auto; height: auto; padding: 1em 2.5em; border-width: 0; text-align: center; cursor: pointer; outline: none; -webkit-appearance: none;}
.btnDefault:hover, .btnDefault:focus{opacity: .8;}
.footer{padding: 64px 32px;background-color: #211a16;color: rgba(255,255,255,.4);text-align:center;font-size: 16px;}
.footer a{color: inherit !important; text-decoration: underline !important;}
.slds-size_1-of-12 input {width: 70px !important;}

/********************************************************************/
.fix-container{position:relative !important;width:100%;}
.slds-container_small{max-width:100% !important;background: #fff !important;text-align:left !important;}
.form-container form div input.slds-input.error {
    border : 1px solid red !important;
}
label.error { display: block; color: rgb(194, 57, 52); }
@media (max-width:48em)
    {
   .banner h2{font-size:22px !important;}
}
@media (max-width:586px)
    {    
    .contentFlex{display: inherit !important;}
    .contentFlex .slds-size_1-of-12{width: 100% !important;}
    .contentFlex .slds-size_1-of-12 input {width: 120px !important;
}
}
