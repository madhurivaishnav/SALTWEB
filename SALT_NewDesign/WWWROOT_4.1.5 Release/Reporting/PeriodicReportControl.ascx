<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="PeriodicReportControl.ascx.cs" Inherits="Bdw.Application.Salt.Web.Reporting.PeriodicReportControl" %>

<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="dialogs" TagName="EScalendar" Src="/General/UserControls/EmergingControls/EmergingSystemsCalendar.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<script LANGUAGE=JAVASCRIPT SRC="../../General/js/ESDateTime.js">
</Script>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<script language="javascript">
		    //This must be placed on each page where you want to use the client-side resource manager
		    var ResourceManager = new RM();
		    function RM() {
		        this.list = new Array();
		    };
		    RM.prototype.AddString = function(key, value) {
		        this.list[key] = value;
		    };
		    RM.prototype.GetString = function(key) {
		        var result = this.list[key];
		        for (var i = 1; i < arguments.length; ++i) {
		            result = result.replace("{" + (i - 1) + "}", arguments[i]);
		        }
		        return result;
		    };   
		</script>
        <script language="javascript">
        function OpenParent() {
            var evtObj = document.createEventObject();
            //should FIRST test if parent = frmPeriodicReport.butSavePeriodicReportSchedule
            //before calling methods on that form
            //debugger;
            var parent = document.getElementById("butSavePeriodicReportSchedule");
            if (parent) {

                parent.fireEvent("onclick");
            }
    }
        </script>
</head>
<asp:placeholder id="plhPeriodicControls" runat="server">
<asp:ScriptManager ID="CCGridScriptManager" EnablePartialRendering="true" runat="server"  AsyncPostBackTimeOut="56000" >
</asp:ScriptManager>
<br />
<div>
    <Localized:LocalizedLabel ID="ReportTitle" runat="server" Text="Report Title" />&nbsp;
    <asp:TextBox ID="ReportTitleTextBox" Width="300px"  runat="server"></asp:TextBox>
</div>
<br />
<div>
<asp:Table runat="server">
    <asp:TableRow runat="server">
        <asp:TableCell runat="server">
            <asp:Panel ID="PeriodicReportTimes" Width="400px" GroupingText="How many times" runat="server">
                <asp:Table runat="server">
                    <asp:TableRow runat="server">
                        <asp:TableCell runat="server">
                            <Localized:LocalizedRadioButton  style="white-space:nowrap"  Text="Now" ID="Now" GroupName="PeriodicReportWhen" AutoPostBack="true" Checked="True" OnCheckedChanged="now_CheckChanged" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell runat="server">
                        </asp:TableCell>
                    </asp:TableRow>
                    <asp:TableRow runat="server">
                        <asp:TableCell runat="server">
                            <Localized:LocalizedRadioButton style="white-space:nowrap" Text="Once only" ID="Onceonly" GroupName="PeriodicReportWhen" AutoPostBack="true" OnCheckedChanged="onceonly_CheckChanged" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell ID="OnceonlyDate" Visible="false" runat="server">
                            <asp:DropDownList ID="cboFCompletionDay1" runat="server" ></asp:DropDownList>
                            <asp:DropDownList ID="cboFCompletionMonth1" runat="server" ></asp:DropDownList>
                            <asp:DropDownList ID="cboFCompletionYear1" runat="server" ></asp:DropDownList>
                            <img id="img1" alt="" src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(PeriodicReportControl_cboFCompletionDay1, PeriodicReportControl_cboFCompletionMonth1, PeriodicReportControl_cboFCompletionYear1)" />
                            <asp:RequiredFieldValidator ID="cboFCompletionDayValidator1" Display="Dynamic" ControlToValidate="cboFCompletionDay1" Text="Day is required" runat="server" />
                            <asp:RequiredFieldValidator ID="cboFCompletionMonthValidator1" Display="Dynamic" ControlToValidate="cboFCompletionMonth1" Text="Month is required" runat="server" />
                            <asp:RequiredFieldValidator ID="cboFCompletionYearValidator1" Display="Dynamic" ControlToValidate="cboFCompletionYear1" Text="Year is required" runat="server" />                    
                        </asp:TableCell>            
                    </asp:TableRow>
                    <asp:TableRow runat="server">
                        <asp:TableCell VerticalAlign="Top" runat="server">
                            <Localized:LocalizedRadioButton style="white-space:nowrap" Text="More than once" ID="Morethanonce" GroupName="PeriodicReportWhen" AutoPostBack="true" OnCheckedChanged="morethanonce_CheckChanged" runat="server" />
                        </asp:TableCell>
                        <asp:TableCell runat="server">
                            <asp:Panel ID="MorethanonceGroup" Visible="false" runat="server">
                                <asp:Table runat="server">
                                    <asp:TableRow runat="server">
                                        <asp:TableCell runat="server">
                                            <Localized:LocalizedLabel ID="lblStartOn" runat="server" style="white-space:nowrap" Text="Start on" />
                                        </asp:TableCell>
                                        <asp:TableCell ID="MorethanonceDate" runat="server">
                                            <asp:DropDownList ID="cboFCompletionDay2" runat="server" ></asp:DropDownList>
                                            <asp:DropDownList ID="cboFCompletionMonth2" runat="server" ></asp:DropDownList>
                                            <asp:DropDownList ID="cboFCompletionYear2" runat="server" ></asp:DropDownList>
                                            <img id="img2" alt="" src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(PeriodicReportControl_cboFCompletionDay2, PeriodicReportControl_cboFCompletionMonth2, PeriodicReportControl_cboFCompletionYear2)" />
                                            <asp:RequiredFieldValidator ID="cboFCompletionDayValidator2" Display="Dynamic" ControlToValidate="cboFCompletionDay2" Text="Day is required" runat="server" />
                                            <asp:RequiredFieldValidator ID="cboFCompletionMonthValidator2" Display="Dynamic" ControlToValidate="cboFCompletionMonth2" Text="Month is required" runat="server" />
                                            <asp:RequiredFieldValidator ID="cboFCompletionYearValidator2" Display="Dynamic" ControlToValidate="cboFCompletionYear2" Text="Year is required" runat="server" />
                                            <asp:CustomValidator ID="StartOnDayValidator" Display="Dynamic" runat="server" OnServerValidate="StartOnValidate" 
                                                ControlToValidate="cboFCompletionDay2" ValidationGroup="StartOnValidators" ErrorMessage="Start Date cannot be in past"></asp:CustomValidator>
                                            <asp:CustomValidator ID="StartMonthValidator" Display="Dynamic" runat="server" OnServerValidate="StartOnValidate" 
                                                ControlToValidate="cboFCompletionMonth2" ValidationGroup="StartOnValidators" ErrorMessage="Start Date cannot be in past"></asp:CustomValidator>
                                            <asp:CustomValidator ID="StartOnYearValidator" Display="Dynamic" runat="server" OnServerValidate="StartOnValidate" 
                                                ControlToValidate="cboFCompletionYear2" ValidationGroup="StartOnValidators" ErrorMessage="Start Date cannot be in past"></asp:CustomValidator>
                                        </asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow runat="server">
                                        <asp:TableCell runat="server">
                                            <Localized:LocalizedLabel ID="lblEvery" runat="server" Text="Every" />
                                        </asp:TableCell>
                                        <asp:TableCell runat="server">
                                            <asp:Table runat="server">
                                                <asp:TableRow runat="server">
                                                    <asp:TableCell runat="server">
                                                        <asp:TextBox ID="EveryHowMany" Width="50px" style="white-space:nowrap" runat="server"></asp:TextBox>
                                                    </asp:TableCell>
                                                    <asp:TableCell runat="server">
                                                        <asp:DropDownList ID="EveryUnit" style="white-space:nowrap" runat="server">
                                                        <asp:ListItem Value="Days">Days</asp:ListItem>
                                                        <asp:ListItem Value="Weeks">Weeks</asp:ListItem>
                                                        <asp:ListItem Value="Months">Months</asp:ListItem>
                                                        <asp:ListItem Value="Years">Years</asp:ListItem>
                                                        </asp:DropDownList>
                                                   </asp:TableCell>
                                                </asp:TableRow>
                                                <asp:TableRow runat="server">
                                                    <asp:TableCell>
                                                        <asp:RequiredFieldValidator ID="EveryTextboxRequiredValidator" Display="Dynamic" ControlToValidate="EveryHowMany" Text="Every Textbox is required" runat="server"></asp:RequiredFieldValidator>                                                    
                                                    </asp:TableCell>
                                                    <asp:TableCell>
                                                        <asp:RangeValidator ID="EveryTextboxValidator" Display="Dynamic" ControlToValidate="EveryHowMany" MinimumValue="0" MaximumValue="10000"
                                                            Type="Integer" Text="The value must be an integer." runat="server">
                                                        </asp:RangeValidator>
                                                   </asp:TableCell> 
                                                </asp:TableRow>                                                
                                            </asp:Table>                                  
                                        </asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow runat="server">
                                        <asp:TableCell runat="server">
                                            <Localized:LocalizedRadioButton ID="NoEndDate" style="white-space:nowrap" AutoPostBack="true" Text="No end date" GroupName="EndWhen" Checked="true" OnCheckedChanged="noEndDate_CheckChanged" runat="server" />
                                        </asp:TableCell>
                                        <asp:TableCell runat="server">
                                        </asp:TableCell>
                                    </asp:TableRow>
                                    <asp:TableRow runat="server">
                                        <asp:TableCell runat="server">
                                            <Localized:LocalizedRadioButton ID="EndAfter" style="white-space:nowrap" AutoPostBack="true" Text="End after" GroupName="EndWhen" OnCheckedChanged="endAfter_CheckChanged" runat="server" />
                                        </asp:TableCell>
                                        <asp:TableCell runat="server">
                                            <asp:TextBox ID="EndAfterTextbox" Width="50px" OnTextChanged="EndAfterTextbox_TextChanged" AutoPostBack="true" Enabled="false" CausesValidation="false" style="white-space:nowrap; padding:0" runat="server"></asp:TextBox>
                                            <Localized:LocalizedLabel ID="lblAfterReports" Text=" report(s)" runat="server" ></Localized:LocalizedLabel>
                                            <asp:RequiredFieldValidator ID="EndAfterTextboxRequiredValidator" EnableClientScript="false" Display="Dynamic" ControlToValidate="EndAfterTextbox" Text="End After is required" runat="server"></asp:RequiredFieldValidator>
                                            <asp:RangeValidator ID="EndAfterTextboxValidator" EnableClientScript="false" Display="Dynamic" ControlToValidate="EndAfterTextbox" MinimumValue="0" MaximumValue="10000"
                                                Type="Integer" Text="The value must be an integer." runat="server">
                                            </asp:RangeValidator>
                                        </asp:TableCell>
                                    </asp:TableRow> 
                                    <asp:TableRow ID="TableRow2" runat="server">
                                        <asp:TableCell runat="server">
                                            <Localized:LocalizedRadioButton ID="EndOn" style="white-space:nowrap" AutoPostBack="true" Text="End on" GroupName="EndWhen" OnCheckedChanged="endOn_CheckChanged" runat="server" />
                                        </asp:TableCell>
                                        <asp:TableCell ID="EndOnDate" Enabled="false" runat="server">
                                            <asp:DropDownList ID="cboFCompletionDay3" CausesValidation="false" runat="server" ></asp:DropDownList>
                                            <asp:DropDownList ID="cboFCompletionMonth3" CausesValidation="false" runat="server" ></asp:DropDownList>
                                            <asp:DropDownList ID="cboFCompletionYear3" CausesValidation="false" runat="server" ></asp:DropDownList>
                                            <img id="img3" alt="" src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(PeriodicReportControl_cboFCompletionDay3, PeriodicReportControl_cboFCompletionMonth3, PeriodicReportControl_cboFCompletionYear3)" />
                                            <asp:RequiredFieldValidator ID="cboFCompletionDayValidator3" EnableClientScript="false" NAME = "cboFCompletionDayValidator3" Display="Dynamic" ControlToValidate="cboFCompletionDay3" Text="Day is required" runat="server" />
                                            <asp:RequiredFieldValidator ID="cboFCompletionMonthValidator3" EnableClientScript="false" NAME ="cboFCompletionMonthValidator3"  Display="Dynamic" ControlToValidate="cboFCompletionMonth3" Text="Month is required" runat="server" />
                                            <asp:RequiredFieldValidator ID="cboFCompletionYearValidator3" EnableClientScript="false" NAME ="cboFCompletionYearValidator3" Display="Dynamic" ControlToValidate="cboFCompletionYear3" Text="Year is required" runat="server" />
                                        </asp:TableCell>
                                    </asp:TableRow>                                                       
                                </asp:Table>
                            </asp:Panel>
                        </asp:TableCell>            
                    </asp:TableRow>
                </asp:Table>
            </asp:Panel>
        </asp:TableCell>
        <asp:TableCell>
            <asp:Panel ID="ForWhatPeriod" GroupingText="For what period" Visible="false" runat="server">
                <Localized:LocalizedRadioButton ID="rbtnAllDays" style="white-space:nowrap" AutoPostBack="true" Checked="true" GroupName="rbtnsPrWhatPeriod" OnCheckedChanged="allDays_CheckChanged" Text="ALL days up to the day of Report" Value="0" Selected="True" runat="server" />
                <br />
                <Localized:LocalizedRadioButton ID="rbtnPreced" style="white-space:nowrap" AutoPostBack="true" GroupName="rbtnsPrWhatPeriod" OnCheckedChanged="preced_CheckChanged" Text="The preceding" Value="1" runat="server" />
                <asp:Label ID="lblPreced" Text=" 0 Days " runat="server"></asp:Label>
                <Localized:LocalizedLiteral ID="ltrReportDate" Text="before the report date" runat="server"></Localized:LocalizedLiteral>
                <br />
                <Localized:LocalizedRadioButton ID="rbtnPeriodStartOn" style="white-space:nowrap" AutoPostBack="true" GroupName="rbtnsPrWhatPeriod" OnCheckedChanged="periodStartOn_CheckChanged" Text="The period starting on" Value="2" runat="server" />
                <asp:DropDownList ID="cboFCompletionDay4" CausesValidation="false" Enabled="false" runat="server" ></asp:DropDownList>
                <asp:DropDownList ID="cboFCompletionMonth4" CausesValidation="false" Enabled="false" runat="server" ></asp:DropDownList>
                <asp:DropDownList ID="cboFCompletionYear4" CausesValidation="false" Enabled="false" runat="server" ></asp:DropDownList>
                <img id="img4" alt="" src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(PeriodicReportControl_cboFCompletionDay4, PeriodicReportControl_cboFCompletionMonth4, PeriodicReportControl_cboFCompletionYear4)" />
                <asp:RequiredFieldValidator ID="cboFCompletionDayValidator4" EnableClientScript="false" Display="Dynamic" ControlToValidate="cboFCompletionDay4" Text="Day is required" runat="server" />
                <asp:RequiredFieldValidator ID="cboFCompletionMonthValidator4" EnableClientScript="false" Display="Dynamic" ControlToValidate="cboFCompletionMonth4" Text="Month is required" runat="server" />
                <asp:RequiredFieldValidator ID="cboFCompletionYearValidator4" EnableClientScript="false" Display="Dynamic" ControlToValidate="cboFCompletionYear4" Text="Year is required" runat="server" />
                <Localized:LocalizedLiteral ID="ltrEnding" Text="and ending 23:59:59 the day before the report" runat="server" />                        
            </asp:Panel>
        </asp:TableCell>
    </asp:TableRow>
</asp:Table> 
<dialogs:EScalendar runat="server" id="Calendar1"  ></dialogs:EScalendar>   
</div>
<br />
<div>
    <Localized:LocalizedLabel ID="lblCC" runat="server" Text="CC " />&nbsp;
    <Localized:LocalizedButton ID="CCAddEdit" cssclass="generateButton" CausesValidation="false" runat="server" Text="Add/Edit" />

    <asp:UpdatePanel ID="CCGridUpdatePanel" OnLoad="CCGridUpdatePanel_Load" runat="server" UpdateMode="Conditional" >
    <ContentTemplate>
        <asp:GridView ID="CCListGridMain" AllowPaging="True" AllowSorting="True"
            CssClass="tablerow2" BorderStyle="Solid" EnableViewState="false"
            runat="server" AutoGenerateColumns="False" PageSize="15"
            OnPreRender="CCListGridMain_PreRender" OnRowDataBound="CCListGridMain_OnRowDataBound"
            OnDataBound="CCListGridMain_DataBound" OnRowCreated="CCListGridMain_RowCreated" >
            <AlternatingRowStyle CssClass="tablerow1"></AlternatingRowStyle>
            <RowStyle CssClass="tablerow2"></RowStyle>        
		    <headerstyle cssclass="tablerowtop" ForeColor="White" Font-Size="X-Small"></headerstyle>
            <Columns>
                <asp:BoundField DataField="UserId" />
                <asp:BoundField DataField="FirstName" HeaderText="FirstName" 
                    SortExpression="FirstName" />
                <asp:BoundField DataField="LastName" HeaderText="LastName" 
                    SortExpression="LastName" />
                <asp:BoundField DataField="Email" HeaderText="Email" SortExpression="Email" />
            </Columns>
            <PagerTemplate>
                <table width="100%">
                    <tr>
                        <td style="width: 70%">
                            <asp:DropDownList ID="PageDropDownList" AutoPostBack="true" OnSelectedIndexChanged="PageDropDownList_SelectedIndexChanged"
                                runat="server" />
                            <asp:Label ID="CurrentPageLabel" ForeColor="Blue" Text="" runat="server" />
                        </td>
                        <td style="width: 70%; text-align: right">
                            <asp:Label ID="MessageLabel" Text="" ForeColor="Blue" runat="server" />
                        </td>
                    </tr>
                </table>
            </PagerTemplate>        
        </asp:GridView>
        
        <asp:SqlDataSource ID="CCListDataSource" runat="server"  
            SelectCommand="prcGetCCListMain" SelectCommandType="StoredProcedure" OnSelected="CCListDataSource_Selected" >
            <SelectParameters>
                <asp:QueryStringParameter Name="ScheduleId" QueryStringField="scheduleid" 
                    Type="Int32" />
            </SelectParameters>
        </asp:SqlDataSource>
    </ContentTemplate>   
    </asp:UpdatePanel>
</div>
<br />
<div>
    <Localized:LocalizedLabel ID="lblDocType" runat="server" Text="Document Type" />&nbsp;
    <asp:DropDownList ID="DocType" runat="server">
    </asp:DropDownList>
</div>
<br />
<div>
<%--    <asp:Button ID="btnPRptSaveSend" padding="10" cssclass="generateButton" OnClick="SaveSend_OnClick"  Text="Save/Send" ValidationGroup="StartOnValidators" visible = "false" runat="server" />    
    <asp:Button ID="btnPRptReset" padding="10" cssclass="generateButton" runat="server" Text="Reset"  visible = "false" />--%>
    <asp:TextBox ID="NumDateControls" Visible = "false" runat="server"/>
</div>
</asp:placeholder>