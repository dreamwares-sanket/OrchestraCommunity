public with sharing virtual class BaseClass {    
    
    public String pageMsg         { get; set; }
    public String pageMsgDetail   { get; set; }
    public String msgType         { get; set; }
    public Boolean isMsgShow      { get; set; }
    public Boolean isShowSpinner  { get; set; }
    
    public BaseClass() {
        
        this.pageMsg = '';
        this.pageMsgDetail = '';
        this.msgType = '';
        this.isMsgShow = FALSE;
        this.isShowSpinner = FALSE;
    }
}