<%@ Register TagPrefix="dialogs" TagName="EScalendar" Src="/General/UserControls/EmergingControls/EmergingSystemsCalendar.ascx" %>
<%@ Register TagPrefix="GridExport" TagName="ESDataSetExport" Src="/General/UserControls/EmergingControls/DataSetExport.ascx" %>
<%@ Page Language="c#" CodeBehind="PeriodicReport.aspx.cs" AutoEventWireup="True"
    Inherits="Bdw.Application.Salt.Web.Reporting.PeriodicReport"  EnableEventValidation="true" %>
<%@ Register TagPrefix="cc2" Namespace="Bdw.SqlServer.Reporting.WebControls" Assembly="Bdw.SqlServer.Reporting" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="reportsmenu" Src="/General/UserControls/Navigation/reportsmenu.ascx" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Register Assembly="Uws.Framework.WebControl" Namespace="Uws.Framework.WebControl" TagPrefix="cc1" %>
<%@ Register TagPrefix="pr" TagName="periodic" Src="/Reporting/PeriodicReportControl.ascx" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
<script type="text/javascript" language="javascript" >
    function verifyDate(NVCday, NVCmonth, NVCyear, NVClocalizedMessage) {
        //debugger;
        if (!NVCday) alert("syntax error: Control not found '" + NVCday + "'");
        if (!NVCmonth) alert("syntax error: Control not found '" + NVCmonth + "'");
        if (!NVCyear) alert("syntax error: Control not found '" + NVCyear + "'");
        if ((NVCday.value != "") && (NVCmonth.value != "") && (NVCyear.value != "")) {
            var d = new Date(NVCyear.value, NVCmonth.value - 1, NVCday.value);
            if (d.getDate() != NVCday.value) {
                //alert(NVCday.value + "/" + NVCmonth.value + "/" + NVCyear.value + " is not a valid date");
                //alert(NVClocalizedMessage.value);
                if (navigator.appName == "Microsoft Internet Explorer") {
                    var WinSettings = "unadorned:yes;status:no;center:yes;resizable:no;dialogHeight:115px;dialogWidth:355px"
                }
                else {
                    var WinSettings = "unadorned:yes;status:no;center:yes;resizable:no;dialogHeight:165px;dialogWidth:355px"
                }
                var MyArgs = window.showModalDialog("/General/UserControls/EmergingControls/ESDialog.aspx?&p=" + NVCday.value + "/" + NVCmonth.value + "/" + NVCyear.value + " " + NVClocalizedMessage.value + "&p=", MyArgs, WinSettings);
            }
        }
    }
</script>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:Style id="ucStyle" runat="server">
    </Style:Style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<script type="text/javascript" src="../General/Js/navigationmenu-jquery-latest.min.js"></script>
    <script type="text/javascript" src="../General/Js/navigationmenuscript.js"></script>
		 <script type="text/javascript" language="javascript">
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
		<script language="JavaScript" type="text/javascript">
		    function SaveConfirm() {
		        return confirm("Do you want to delete this schedule?");
		    }

		</script> 
		<script language="JavaScript" type="text/javascript">
		    function DisableValidators() {
		        //debugger; 
		        var validator = document.getElementById("cboQCompletionYearValidator");
		        if (validator) {

		            ValidatorEnable(validator, false);
		        }
		    }


		</script>    
</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">

    
    <form id="frmPeriodicReport" method="post" runat="server">
    <table id="Table1" height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!-- Header -->
        <tr valign="top" align="center" width="100%">
            <td valign="top" align="center" width="100%" colspan="2">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
        <tr valign="top" align="left" height="100%">
            <!-- Left Navigation -->
            <td class="ReportMenuContainer"><navigation:reportsmenu id="ucLeftMenu" runat="server"></navigation:reportsmenu></td>            <!-- Body/Conent -->
            <td class="DataContainer">
                <asp:Label ID="lblPageTitle" runat="server" CssClass="pageTitle">Periodic Report Delivery</asp:Label><br>
                <asp:Label ID="lblError" Runat="server" CssClass="" ForeColor="Red"></asp:Label>

                <table cellspacing="0" border="0" style="width: 100%; border-collapse: collapse;">
                    <tr>
                        <td class="formLabel">
                            <asp:TextBox ID="scheduleHolder" runat="server" Visible="False"></asp:TextBox>
                        </td>
                    </tr>
                    <dialogs:EScalendar runat="server" id="Calendar1"  ></dialogs:EScalendar> 
                    <GridExport:ESDataSetExport runat="server" id="GridExport"  ></GridExport:ESDataSetExport> 
                     
                </table>
                <table cellspacing="0"  border="0">
                    <asp:placeholder id="pnlSearchCriteria" runat="server">
                       <tr>
                        <td class="formLabel" colspan="2">
                            &nbsp;
                            <asp:Table ID="Table2" runat="server" Height="100%" Width="100%">
                            
								
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="TableRow1" Visible=false>
                                    <asp:TableCell ID="TableCell47" runat="server">
                                        <Localized:LocalizedLabel ID="lblReportName" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell>
                                    <asp:TableCell ID="TableCell48" runat="server">

                                        <asp:DropDownList ID="listReports" runat="server" 
                                            runat="server" AutoPostBack="True"  Enabled = "false" >
                                        </asp:DropDownList>
                                    </asp:TableCell>
                                </asp:TableRow>
                                

                                

                                

                                 
                                <asp:TableRow runat="server" Height="1" Width="100%" ID="units">
                                    <asp:TableCell ID="TableCell9" runat="server">
                                        <Localized:LocalizedLabel ID="lblUnits" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell10" runat="server">
                                        <cc1:treeview id="trvUnitsSelector" runat="server" nodetext="Unit" outputstyle="MultipleSelection"
												systemimagespath="/General/Images/TreeView/"></cc1:treeview>
                                    </asp:TableCell>
                                </asp:TableRow>                               
                                

                                                                        
                                <asp:TableRow ID="PolicyIDs" Visible ="false">
                                    <asp:TableCell ID="TableCell71" runat="server">
                                        <asp:Label ID="LocalizedLabel3" runat="server">Policy</asp:Label>
                                    </asp:TableCell><asp:TableCell ID="TableCell72" runat="server">
                                        <asp:ListBox ID="lstPolicy" runat="server"  SelectionMode=Multiple>

                                        </asp:ListBox>

                                    </asp:TableCell>
                                </asp:TableRow>	
                                
                               

                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="course">
                                    <asp:TableCell ID="TableCell5" runat="server">
                                        <Localized:LocalizedLabel ID="lblCourses" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell6" runat="server">
                                        <asp:ListBox ID="courseList" runat="server"></asp:ListBox>
                                        <asp:RequiredFieldValidator ID="courseListValidator" ControlToValidate="courseList" Display="Dynamic"
                                           Text="Course is required" runat="server"  Enabled="false"/>
                                        <asp:DropDownList ID="courseListDropdown" runat="server" OnSelectedIndexChanged="course_SelectedIndexChanged" AutoPostBack="True">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="courseListDropdownValidator" ControlToValidate="courseListDropdown"
                                           Text="Course is required" runat="server"  Enabled = "false" />
                                           
                                    </asp:TableCell>
                                </asp:TableRow>
                               
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="reportstatus">
                                    <asp:TableCell ID="TableCell1" runat="server">
                                        <Localized:LocalizedLabel ID="lblStatus" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell2" runat="server">
                                        <asp:radiobuttonlist ID="reportStatusList" runat="server">
                                            <asp:ListItem Value="0">Complete</asp:ListItem>
                                            <asp:ListItem Value="1">Incomplete</asp:ListItem>
                                            <asp:ListItem Value="2">Incomplete (with details)</asp:ListItem>
                                        </asp:radiobuttonlist>
                                    </asp:TableCell>
                                </asp:TableRow>                               
                               
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="failCounter">
                                    <asp:TableCell ID="TableCell3" runat="server">
                                        <Localized:LocalizedLabel ID="lblFailCounter" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell4" runat="server">
                                        <asp:TextBox ID="failCounterBox" runat="server"></asp:TextBox>
                                        <asp:RangeValidator ID="failCounterBoxValidator" ControlToValidate="failCounterBox" MinimumValue="0"
                                            MaximumValue="10000" Type="Integer" Text="The value must be a integer!"
                                            runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>

                              
                                <asp:TableRow>
                                    <asp:TableCell ID="TableCell7" runat="server">
                                        <Localized:LocalizedLabel ID="lblHistoricCourse" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell8" runat="server">
                                        <asp:ListBox ID="histCourse" runat="server">

                                        </asp:ListBox>
                                        <asp:RequiredFieldValidator ID="histCourseListValidator" ControlToValidate="histCourse"
                                            Text="History is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="expire">
                                    <asp:TableCell ID="TableCell11" runat="server">
                                        <Localized:LocalizedLabel ID="lblExpiredIn" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell12" runat="server">
                                        <asp:TextBox ID="expireBox" runat="server" Width="120px" TextMode="SingleLine" MaxLength="4"
                                            Style="margin-right: 1ex;"></asp:TextBox>
                                        <asp:DropDownList ID="expireUnit" runat="server" Width="80px">
                                            <asp:ListItem Value="m">month/s</asp:ListItem>
                                            <asp:ListItem Value="d" Selected="True">day/s</asp:ListItem>
                                        </asp:DropDownList>
                                        <Localized:LocalizedRequiredFieldValidator ID="validatorWarningPeriod" runat="server"
                                            CssClass="ValidatorMessage" Display="Dynamic" ErrorMessage="You must specify the warning period."
                                            ControlToValidate="expireBox">
                                        </Localized:LocalizedRequiredFieldValidator>
                                        <Localized:LocalizedRangeValidator ID="validatorWarningRange" runat="server" ControlToValidate="expireBox"
                                            Type="Integer" MaximumValue="1095" MinimumValue="1">
                                        </Localized:LocalizedRangeValidator>
                                    </asp:TableCell>
                                </asp:TableRow>


                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="firstName">
                                    <asp:TableCell ID="TableCell17" runat="server">
                                        <Localized:LocalizedLabel ID="lblFirstName" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell18" runat="server">
                                        <asp:TextBox ID="firstNameBox" runat="server" TextMode="SingleLine" MaxLength="200"
                                            Style="margin-right: 1ex;">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="firstNameBoxValidator" ControlToValidate="firstNameBox"
                                            Text="First Name is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="lastName">
                                    <asp:TableCell ID="TableCell19" runat="server">
                                        <Localized:LocalizedLabel ID="lblLastName" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell20" runat="server">
                                        <asp:TextBox ID="lastNameBox" runat="server" TextMode="SingleLine" MaxLength="200" Style="margin-right: 1ex;">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="lastNameBoxFieldValidator" ControlToValidate="lastNameBox"
                                            Text="Last Name is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="userName">
                                    <asp:TableCell ID="TableCell21" runat="server">
                                        <Localized:LocalizedLabel ID="lblUserName" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell22" runat="server">
                                        <asp:TextBox ID="userNameBox" runat="server" Width="120px" TextMode="SingleLine" MaxLength="200" Style="margin-right: 1ex;">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="userNameBoxValidator" ControlToValidate="userNameBox"
                                            Text="User Name is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="email">
                                    <asp:TableCell ID="TableCell23" runat="server">
                                        <Localized:LocalizedLabel ID="lblEmail" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell24" runat="server">
                                        <asp:TextBox ID="emailBox" runat="server" Width="120px" TextMode="SingleLine" MaxLength="200" Style="margin-right: 1ex;">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="emailBoxValidator" ControlToValidate="emailBox" Text="Email is required" runat="server" />
                                        <asp:RegularExpressionValidator ID="regexEmailValid" runat="server" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" ControlToValidate="emailBox" ErrorMessage="Invalid Email Format"></asp:RegularExpressionValidator> 
                                    </asp:TableCell>
                                </asp:TableRow>
                              
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="reportSubject">
                                    <asp:TableCell ID="TableCell27" runat="server">
                                        <Localized:LocalizedLabel ID="lblSubject" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell28" runat="server">
                                        <asp:TextBox ID="subjectBox" runat="server" Width="120px" TextMode="SingleLine" MaxLength="200" Style="margin-right: 1ex;">
                                        </asp:TextBox>
                                        <asp:RequiredFieldValidator ID="subjectBoxValidator" ControlToValidate="subjectBox" Text="Subject is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="reportBody">
                                    <asp:TableCell ID="TableCell29" runat="server">
                                        <Localized:LocalizedLabel ID="lblBody" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell30" runat="server">
                                        <asp:TextBox ID="bodyBox" runat="server" Width="120px" TextMode="SingleLine" MaxLength="200" Style="margin-right: 1ex;" ></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="bodyBoxValidator" ControlToValidate="bodyBox" Text="Body is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>

                                 <asp:TableRow runat="server" Height="25px" Width="100%" ID="TableRow2">
                                    <asp:TableCell ID="TableCell38" runat="server">
                                    <asp:TextBox ID="CourseIDsVisible"   visible = "false"  runat = "server"   ></asp:TextBox>
                                    </asp:TableCell>
                                </asp:TableRow>                               
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="quizStatus">
                                    <asp:TableCell ID="TableCell13" runat="server">
                                        <Localized:LocalizedLabel ID="lblQuizStatus" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell>
                                    <asp:TableCell ID="TableCell14" runat="server">
                                        <asp:radiobuttonlist ID="quizStatusList" runat="server">
                                           <asp:ListItem Value="1">Complete</asp:ListItem>
                                            <asp:ListItem Value="0">Incomplete</asp:ListItem>
                                            <asp:ListItem Value="2">Fail</asp:ListItem>
                                            <asp:ListItem Value="3">Not Started</asp:ListItem>
                                            <asp:ListItem Value="4">Expired (Time Elapsed)</asp:ListItem>
                                            <asp:ListItem Value="5">Expired (New Content)</asp:ListItem>
                                        </asp:radiobuttonlist>
                                    </asp:TableCell>
                                </asp:TableRow>
                                
                                
                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="dateFrom">
                                    <asp:TableCell ID="TableCell33" runat="server">
                                        <Localized:LocalizedLabel ID="lblDateFrom" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell>
                                    <asp:TableCell ID="TableCell34" runat="server">
                                        <asp:DropDownList ID="cboFCompletionDay" runat="server" onchange ="javascript:verifyDate(TableCell34.childNodes.item(0), TableCell34.childNodes.item(1), TableCell34.childNodes.item(2), TableCell34.childNodes.item(9),TableCell34.childNodes.item(10))"></asp:DropDownList>
                                        <asp:DropDownList ID="cboFCompletionMonth" runat="server" onchange ="javascript:verifyDate(TableCell34.childNodes.item(0), TableCell34.childNodes.item(1), TableCell34.childNodes.item(2), TableCell34.childNodes.item(9),TableCell34.childNodes.item(10))"></asp:DropDownList>
                                        <asp:DropDownList ID="cboFCompletionYear" runat="server" onchange ="javascript:verifyDate(TableCell34.childNodes.item(0), TableCell34.childNodes.item(1), TableCell34.childNodes.item(2), TableCell34.childNodes.item(9),TableCell34.childNodes.item(10))"></asp:DropDownList>
                                        <img id="imgBut" alt="" src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(cboFCompletionDay, cboFCompletionMonth, cboFCompletionYear)" />
                                        <asp:RequiredFieldValidator ID="cboFCompletionDayValidator" Display="Dynamic" ControlToValidate="cboFCompletionDay" Text="Day is required" runat="server" enabled=false/>
                                        <asp:RequiredFieldValidator ID="cboFCompletionMonthValidator" Display="Dynamic" ControlToValidate="cboFCompletionMonth" Text="Month is required" runat="server" enabled=false/>
                                        <asp:RequiredFieldValidator ID="cboFCompletionYearValidator" Display="Dynamic" ControlToValidate="cboFCompletionYear" Text="Year is required" runat="server" enabled=false/>
                                        <Localized:LocalizedButton  id="localizedBadDateMsg" height = "1px" Width = "1px" BorderStyle="None"  runat="server" > </Localized:LocalizedButton>
                                        <asp:Button ID="apptitle"  runat = "server" height = "1px" Width = "1px"  ></asp:Button>
                                    </asp:TableCell>
                                </asp:TableRow>
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="dateTo">
                                    <asp:TableCell ID="TableCell31" runat="server">
                                        <Localized:LocalizedLabel ID="lblDateTo" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell>
                                    <asp:TableCell ID="TableCell32" runat="server">
                                        <asp:DropDownList ID="cboQCompletionDay" runat="server" onchange ="javascript:verifyDate(TableCell32.childNodes.item(0), TableCell32.childNodes.item(1), TableCell32.childNodes.item(2), TableCell34.childNodes.item(9),TableCell34.childNodes.item(10))"></asp:DropDownList>
                                        <asp:DropDownList ID="cboQCompletionMonth" runat="server" onchange ="javascript:verifyDate(TableCell32.childNodes.item(0), TableCell32.childNodes.item(1), TableCell32.childNodes.item(2), TableCell34.childNodes.item(9),TableCell34.childNodes.item(10))"></asp:DropDownList>
                                        <asp:DropDownList ID="cboQCompletionYear" runat="server" onchange ="javascript:verifyDate(TableCell32.childNodes.item(0), TableCell32.childNodes.item(1), TableCell32.childNodes.item(2), TableCell34.childNodes.item(9),TableCell34.childNodes.item(10))"></asp:DropDownList>
                                        <img alt="" src="../../General/Images/ESCalendar2.bmp" onclick="OpenCal(cboQCompletionDay, cboQCompletionMonth, cboQCompletionYear)" />
                                        <asp:RequiredFieldValidator ID="cboQCompletionDayValidator" Display="Dynamic" ControlToValidate="cboQCompletionDay" Text="Day is required" runat="server" enabled=false/>
                                        <asp:RequiredFieldValidator ID="cboQCompletionMonthValidator" Display="Dynamic" ControlToValidate="cboQCompletionMonth" Text="Month is required" runat="server" enabled=false/>
                                        <asp:RequiredFieldValidator ID="cboQCompletionYearValidator" Display="Dynamic" ControlToValidate="cboQCompletionYear" Text="Year is required" runat="server" enabled=false/>
                                    </asp:TableCell>
                                </asp:TableRow>

                                
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="profile">
                                    <asp:TableCell ID="TableCell39" runat="server">
                                        <Localized:LocalizedLabel ID="lblProfile" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell40" runat="server">
                                        <asp:DropDownList ID="profileList"   autopostback="True" OnSelectedIndexChanged = "profileList_SelectedIndexChanged"  runat="server"></asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="profileListValidator" ControlToValidate="profileList"
                                                Text="Profile is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="licensingPeriod">
                                    <asp:TableCell ID="TableCell50" runat="server">
                                        <Localized:LocalizedLabel ID="lblLicensingPeriod" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell53" runat="server">
                                        <asp:DropDownList ID="licensingPeriodList" runat="server" 
                                            runat="server" AutoPostBack="True">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="licensingPeriodListValidator" ControlToValidate="licensingPeriodList" Display="Dynamic"
                                           Text="Licensing Period is required" runat="server" />

                                    </asp:TableCell>
                               </asp:TableRow>

                                                                
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="shortFall">
                                    <asp:TableCell ID="TableCell35" runat="server">
                                        <Localized:LocalizedLabel ID="lblShortfall" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell36" runat="server">
                                        <asp:CheckBox ID="shortFallCheck" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                      
                              <asp:TableRow runat="server" Height="25px" Width="100%" ID="SortBy" Visible = false >
                                    <asp:TableCell ID="TableCell55" runat="server">
                                    <Localized:LocalizedLabel id="lblSortBy" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell>
										<asp:TableCell ID="TableCell56" runat="server">
											<asp:dropdownlist id="lstWithinUserSort" runat="server" width="200px">
												<asp:listitem value="LAST_NAME" selected="True">Last Name</asp:listitem>
												<asp:listitem value="QUIZ_SCORE">Quiz Score</asp:listitem>
												<asp:listitem value="QUIZ_DATE">Quiz Date</asp:listitem>
											</asp:dropdownlist>
								</asp:TableCell>
                                </asp:TableRow>								
								                                    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="groupoption">
										<asp:TableCell ID="TableCell14a" runat="server">
											<Localized:Localizedlabel id="lblCustomClassification" runat="server">Grouping Option</Localized:Localizedlabel>
									    </asp:TableCell>
										<asp:TableCell ID="TableCell14b" runat="server">
											<asp:dropdownlist id="cboCustomClassification" runat="server" width="200px"></asp:dropdownlist>
										</asp:TableCell>
								</asp:TableRow>
								
                                        
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="acceptance" Visible="false">
                                    <asp:TableCell ID="TableCell69" runat="server">
                                        <asp:Label ID="Label6" runat="server">Acceptance</asp:Label>
                                    </asp:TableCell>
                                    <asp:TableCell ID="TableCell70" runat="server">
                                        <asp:radiobuttonlist ID="Radiobuttonlist3" runat="server">
<%--                                            <asp:ListItem Value=""></asp:ListItem>
--%>                                            <asp:ListItem Selected="True" Value="0">Accepted</asp:ListItem>
                                            <asp:ListItem Value="1">Not Accepted</asp:ListItem>
                                            <asp:ListItem Value="2">Both</asp:ListItem>

                                        </asp:radiobuttonlist>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator14" ControlToValidate="quizStatusList"
                                            Text="Quiz Status is required" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>				
                                
			
                                       
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="inactiveUser">
                                    <asp:TableCell ID="TableCell25" runat="server">
                                        <Localized:LocalizedLabel ID="lblIncludeInactiveUsers" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell26" runat="server">
                                        <asp:CheckBox ID="inactiveUserCheck" runat="server" />
                                    </asp:TableCell>
                                </asp:TableRow>
                                                               
                              <asp:TableRow runat="server" Height="25px" Width="100%" ID="TableRowSummary">
                                    <asp:TableCell ID="formLabel" runat="server">
                                    <Localized:LocalizedLabel id="lblReportType" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell>
										<asp:TableCell ID="TableCellReportType" runat="server">
											<asp:radiobuttonlist id="optReportType" runat="server">
												<asp:ListItem Value="Table" Selected="True">Table</asp:ListItem>
												<asp:ListItem Value="StackedColumn">Stacked Column Chart</asp:ListItem>
												<asp:ListItem Value="StackedBar">Stacked Bar Chart</asp:ListItem>
												<asp:ListItem Value="Pie">Pie Chart</asp:ListItem>
											</asp:radiobuttonlist>
											</asp:TableCell>
                                </asp:TableRow>   
                                								    
                                <asp:TableRow runat="server" Height="25px" Width="100%" ID="groupby">
                                    <asp:TableCell ID="TableCell15" runat="server">
                                        <Localized:LocalizedLabel ID="lblGroupBy" runat="server"></Localized:LocalizedLabel>
                                    </asp:TableCell><asp:TableCell ID="TableCell16" runat="server">
                                        <asp:radiobuttonlist ID="groupbyList" runat="server" autopostback="True" onselectedindexchanged="groupbyList_SelectedIndexChanged">
                                            <asp:ListItem Value="1">Unit/User</asp:ListItem>
                                            <asp:ListItem Value="0">Course</asp:ListItem>
                                        </asp:radiobuttonlist>
                                    </asp:TableCell>
                                </asp:TableRow>
                            </asp:Table>          
                                
  							<asp:Panel ID="panCourse" visible ="false"  Runat="server">
							<table cellpadding="6" cellspacing="0" border="1" style="border-collapse: collapse;">
							    <tr class="tablerowtop">
								    <td><Localized:LocalizedLabel id="lblCourseName" runat="server"></Localized:LocalizedLabel></td>
								    <td><Localized:LocalizedLabel id="lblPeriod" runat="server"></Localized:LocalizedLabel></td>
								    <td><Localized:LocalizedLabel id="lblAction" runat="server"></Localized:LocalizedLabel></td>
							    </tr>
							
							    <asp:Repeater ID="rptList" Runat="server">
							    <ItemTemplate>
								    <tr class="tablerow1">
									    <td><%# DataBinder.Eval(Container.DataItem, "Name") %></td>
									    <td>
										    <asp:DropDownList ID="ddlPeriod" Runat="server">
										    </asp:DropDownList>
									    </td>
									    <td>
										    <asp:checkbox id="lnkReportPeriod" runat="server"  AutoPostBack="true" OnCheckedChanged="rptList_OnCheckedChanged"   ></asp:checkbox>
									    </td>
								    </tr>
							    </ItemTemplate>
							    <AlternatingItemTemplate>
								    <tr class="tablerow2">
									    <td><%# DataBinder.Eval(Container.DataItem, "Name") %></td>
									    <td>
										    <asp:DropDownList ID="ddlPeriod" Runat="server">
										    </asp:DropDownList>
									    </td>
									    <td>
										    <asp:checkbox id="lnkReportPeriod" runat="server" AutoPostBack="true" OnCheckedChanged="rptList_OnCheckedChanged" ></asp:checkbox>
									    </td>
								    </tr>							
							    </AlternatingItemTemplate>

							    </asp:Repeater>
							    <tr>
								    <td colspan = "3" align = "right">
									    <asp:checkbox id="lnkReportAll"  Text = "INCLUDE ALL" runat="server" AutoPostBack="true"  OnCheckedChanged="rptList_OnAllCheckedChanged"  ></asp:checkbox>
								    </td>
							    </tr>
							    <tr>
								    <td colspan="3" style="text-align: right;">
									    <Localized:LocalizedLabel id="lblNote" runat="server"></Localized:LocalizedLabel>
								    </td>
							    </tr>
							</table>
							</asp:Panel>
                                                                     
                        </td>
                    </tr>
                    <tr>
                        <td>   
                            <table cellspacing="5" cellpadding="5">
                                <tr>
                                    <td>
                                        <!-- </div> -->
							            <Localized:Localizedbutton id="btnRunReport" runat="server" cssclass="generateButton" text="Run Report" onclick="btnRunReport_Click"></Localized:Localizedbutton>&nbsp;
							        </td>
							        <td>
							            <Localized:Localizedbutton id="btnResetReport" runat="server" cssclass="generateButton" text="Reset Report" onclick="btnResetReport_Click"></Localized:Localizedbutton>&nbsp;
							        </td>
							    </tr>
							</table> 
                        </td>
                    </tr>
                    <tr></tr>

                    <tr>
                        <td>
                            <pr:periodic ID="PeriodicReportControl" runat="server">
                            </pr:periodic>
                        </td>                        
                    </tr>                        
                    <tr>
                        <td>
                            <table cellspacing="5" cellpadding="5">
                                <tr>
                                    <td>
                                        <!-- </div> -->
							            <asp:Button ID="butSavePeriodicReportSchedule" runat="server" cssclass="generateButton" onclick="butSavePeriodicReportSchedule_Click" Text = "Save/Send" >
							            </asp:Button>&nbsp;
							        </td>
							        <td>
							            <Localized:Localizedbutton id="btnResetReportSchedule" runat="server" CausesValidation="false" cssclass="generateButton" text="Reset Report" onclick="btnResetReportSchedule_Click"></Localized:Localizedbutton>&nbsp;
							        </td>
							    </tr>
							</table>
                        </td>
                    </tr>
                    </asp:placeholder>
				    <asp:placeholder id="plhReportResults" runat="server">
				    <TR>
					    <TD colSpan="2">
						    <cc2:PeriodicReportViewer id="rvReport" runat="server" ReportPath="/AtRiskReport" onpageindexchanged="rvReport_PageIndexChanged"  ></cc2:PeriodicReportViewer></TD>
				    </TR>
				    </asp:placeholder>
                </table>
                <asp:Label runat="server" ID="lblMessage" EnableViewState="False"></asp:Label>
            </td>
        </tr>
        <!-- Footer -->
        <tr valign="bottom" align="center">
            <td valign="middle" align="center" colspan="2">
                <navigation:footer id="ucFooter" runat="server">
                </navigation:footer>
            </td>
        </tr>
    </table>
    </form>
</body>
</html>
