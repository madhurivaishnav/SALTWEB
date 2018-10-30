<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="EmergingSystemsCalendar.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.EmergingControls.EmergingSystemsCalendar" %>
<%@ Register assembly="System.Web.DynamicData, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.DynamicData" tagprefix="cc1" %>



        <script language="javascript">
        
            function OpenCal(DayFieldName, MonthFieldName, YearFieldName) 
{
    //var ParmA = document.frmOrgDetails.cboQCompletionDay.value;
    //var ParmB = frmOrgDetails.cboQCompletionMonth.value;
    //var ParmC = frmOrgDetails.cboQCompletionYear.value;
    var ParmA = DayFieldName.value;
    
    //alert(DayFieldName.name);
    var ParmB = MonthFieldName.value;
    var ParmC = YearFieldName.value;
    var MyArgs = new Array(ParmA, ParmB, ParmC);

    // set the calendar font to match that in css for website
    var stylesheet = document.styleSheets[0];
    var cssRules = stylesheet.cssRules ? stylesheet.cssRules : stylesheet.rules;

    for (var i = 0; i < cssRules.length; i++) {
        if (cssRules[i].selectorText.toLowerCase() == "body") {
            var fontsize = cssRules[i].style.fontSize;
            var fontfamily = cssRules[i].style.fontFamily;
            break;
        }
    }
    
    if (navigator.appName == 'Microsoft Internet Explorer') {
        var WinSettings = "unadorned:yes;status:no;center:yes;resizable:no;dialogHeight:240px;dialogWidth:270px;font-size:" + fontsize + ";font-family:" + fontfamily;
        var MyArgs = window.showModalDialog("../../General/UserControls/EmergingControls/ESCalendar.aspx?" + ParmA + "/" + ParmB + "/" + ParmC, MyArgs, WinSettings);
    }
    else {//Safari nested modal dialog has to directly modify the parent form rather than returning a window.dialogResult so include the names of the components so child knows what controls to hack
        var WinSettings = "unadorned:yes;status:no;center:yes;resizable:no;dialogHeight:255px;dialogWidth:285px;font-size:" + fontsize + ";font-family:" + fontfamily;
        var MyArgs = window.showModalDialog("../../General/UserControls/EmergingControls/ESCalendar.aspx?" + ParmA + "/" + ParmB + "/" + ParmC + "&p=" + DayFieldName.name + "&p=" + MonthFieldName.name + "&p=" + YearFieldName.name, MyArgs, WinSettings);
    }
    
    
    if (MyArgs == null)
    {
        //window.alert( "Changes cancelled!")
    }
    else {
        DayFieldName.value = MyArgs[0].toString();
        MonthFieldName.value = MyArgs[1].toString();
        YearFieldName.value = MyArgs[2].toString();

    }
}
</script>

   	
        
