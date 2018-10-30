<%@ Page Language="c#" CodeBehind="MyTraining.aspx.cs" Trace="false" AutoEventWireup="True"
    Inherits="Bdw.Application.Salt.Web.MyTraining" %>

<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="usermenu" Src="/General/UserControls/Navigation/UserMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="OrgLogo" Src="/General/UserControls/Navigation/OrgLogo.ascx" %>

<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Import Namespace="Bdw.Application.Salt.Web.Utilities" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title runat="server" id="pagTitle"></title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <Style:style id="ucStyle" runat="server">
    </Style:style>
    <%--Madhuri CPD Event Start--%>

    <script language="javascript" type="text/javascript">
        function popitup(FileID,EventPeriodId) {
        newwindow=window.open("ViewEvent.aspx?term=y&FileID=" + FileID + "&EventPeriodId="+ EventPeriodId,'name','height=600px,width=750px ,toolbar=no,location=no,status=no,menubar=no,scrollbars=yes');
        if (window.focus) {newwindow.focus()}
        return false;
        }
        function Confirm() {
          var confirm_value = document.createElement("INPUT");
          confirm_value.type = "hidden";
          confirm_value.name = "confirm_value";
          if (confirm("Do you want to save data?")) {
              confirm_value.value = "Yes";
          } else {
              confirm_value.value = "No";
          }
          document.forms[0].appendChild(confirm_value);
      }
    </script>

    <%--Madhuri CPD Event Start--%>
</head>
<body class="QuizHomePageBgColor" bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0"
    ms_positioning="FlowLayout">
    <form id="frmHome" method="post" runat="server">
    <iframe id="PreventTimeout" src="/PreventTimeout.aspx" frameborder="no" width="0"
        height="0" runat="server" />
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!--tbody-->
        <!-- Header -->
        <tr>
            <td valign="top">
                <table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                    <tr valign="top" align="center" width="100%">
                        <td valign="top" align="center" width="100%">
                            <navigation:header id="ucHeader" runat="server">
                            </navigation:header>
                        </td>
                    </tr>
                </table>
                <!-- / Header -->
                <!-- Body/Content -->
                <table width="100%" height="80%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                        <td class="AdminMenuContainer">
                            <navigation:usermenu id="ucUserMenu" runat="server">
                            </navigation:usermenu>
                        </td>
                        <td valign="top" class="DataContainer" style="padding-right: 30px;">
                            <table cellpadding="0" cellspacing="0" align="right" border="0" width="100%">
                                <tr>
                                    <td valign="top" align="left" width="90%" style="min-height: 800px;    height: auto;">
                                        <table height="80%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">                                           
                                            <tr>
                                                <td>
                                                    <Localized:LocalizedLabel ID="lblPageTitle" CssClass="pageTitle" runat="server">
                                                    </Localized:LocalizedLabel>
                                                </td>
                                            </tr>
                                            <!-- Profile Picker -->
                                            <asp:PlaceHolder ID="phProfileSelect" runat="server">
                                                <tr>
                                                    <td>
                                                        &nbsp;&nbsp;<Localized:LocalizedLabel ID="lblCPDProfile" runat="server">
                                                        </Localized:LocalizedLabel>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <!--CPD Profiles listed in combobox to be placed here -->
                                                    <td valign="top" align="left" width="75%">
                                                        <div class="moduleTable">
                                                            <table class="tableborder" id="tblCPDProfile" cellspacing="0" cellpadding="1" runat="server">
                                                                <tr>
                                                                    <td>
                                                                        <table id="tblCPDProfileDetail" cellspacing="0" cellpadding="3" border="0">
                                                                            <tr class="tablerowtop">
                                                                                <td width="200">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="lblCPDProfileHeading" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="200" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblCPDPeriodHeading" runat="server">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="125">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="lblRequiredPointsHeading" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="125" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblPointsEarnedHeading" runat="server">
                                                                                    </Localized:LocalizedLabel>&nbsp;&nbsp;
                                                                                </td>
                                                                                <%--Madhuri CPD Event Start--%>
                                                                                <td align="center" width="125" style="display: none;">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="lblRequiredCPDPointsHeading" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="125" colspan="2" style="display: none;">
                                                                                    <Localized:LocalizedLabel ID="lblCPDPointsEarnedHeading" runat="server">
                                                                                    </Localized:LocalizedLabel>&nbsp;&nbsp;
                                                                                </td>
                                                                                <%--Madhuri CPD Event End--%>
                                                                            </tr>
                                                                            <tr>
                                                                                <td>
                                                                                    <tr class="tablerow1">
                                                                                        <td width="200">
                                                                                            <!-- CPD Profile ComboBox -->
                                                                                            <asp:DropDownList ID="ddlCPDProfile" runat="server" AutoPostBack="True" OnSelectedIndexChanged="ddlCPDProfile_SelectedIndexChanged" />
                                                                                            <asp:Label ID="lblCPDProfileName" runat="server" />
                                                                                        </td>
                                                                                        <td align="center" width="200" colspan="2">
                                                                                            <!-- Profile Period -->
                                                                                            <asp:Label ID="lblProfilePeriod" runat="server" />
                                                                                        </td>
                                                                                        <td align="center" width="125">
                                                                                            <!-- Required Points for Profile -->
                                                                                            <asp:Label ID="lblRequiredPoints" runat="server" />
                                                                                        </td>
                                                                                        <td align="center" width="125" colspan="2">
                                                                                            <!-- Points Earned already for Profile -->
                                                                                            <asp:Label ID="lblPointsEarned" runat="server" />
                                                                                        </td>
                                                                                        <%--Madhuri CPD Event Start--%>
                                                                                        <td align="center" width="125" style="display: none;">
                                                                                            <!-- Required Points for Profile -->
                                                                                            <asp:Label ID="lblCPDRequiredPoints" runat="server" />
                                                                                        </td>
                                                                                        <td align="center" width="125" colspan="2" style="display: none;">
                                                                                            <!-- Points Earned already for Profile -->
                                                                                            <asp:Label ID="lblCPDPointsEarned" runat="server" />
                                                                                        </td>
                                                                                        <%--Madhuri CPD Event End--%>
                                                                                    </tr>
                                                                                </td>
                                                                            </tr>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </asp:PlaceHolder>
                                            <!-- //Profile Picker -->
                                            <!-- spacer row -->
                                            <tr height="50">
                                                <td>
                                                </td>
                                            </tr>
                                            <!-- Course List -->
                                            <asp:PlaceHolder ID="phCourseList" runat="server">
                                                <tr>
                                                    <td>
                                                        &nbsp;&nbsp;<Localized:LocalizedLabel ID="lblChooseCourse" runat="server">
                                                        </Localized:LocalizedLabel>
                                                    </td>
                                                </tr>
                                                <tr height="100%">
                                                    <!-- List of courses to be completed to be placedhere -->
                                                    <td valign="top" align="left" width="75%">
                                                        <div class="moduleTable">
                                                            <table class="tableborder" id="tblCourseList" cellspacing="0" cellpadding="1" runat="server">
                                                                <tr>
                                                                    <td>
                                                                        <table id="tblCourseListDetail" cellspacing="0" cellpadding="3" border="0">
                                                                            <tr class="tablerowtop">
                                                                                <td width="300">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="lblCourseHeading" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <% if (ShowEbook && isIpad)
                                                                                   { %>
                                                                                <td align="center" width="80" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblEBookHeading" runat="server">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <% } %>
                                                                                <td align="center" width="80" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblStatusHeading" runat="server">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="120">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="lblPrintCertificateHeading" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td id="CoursePointsAvailableHeading" runat="server" align="center" width="150" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblCourseCPDPointsAvailable" runat="server" Key="lblCPDPointsAvailableHeading">
                                                                                    </Localized:LocalizedLabel>&nbsp;&nbsp;
                                                                                </td>
                                                                                <td align="center" id="colLastComp" runat="server">
                                                                                    <Localized:LocalizedLabel ID="lblLastComp" runat="server">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="150" colspan="2" runat="server" id="colDue">
                                                                                    <Localized:LocalizedLabel ID="lblDue" runat="server">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                            </tr>
                                                                            <% rowCourseList = 0; %>
                                                                            <asp:Repeater ID="rptCourseList" runat="server">
                                                                                <ItemTemplate>
                                                                                    <% rowCourseList = (rowCourseList + 1) % 2;
                                                                                       if (rowCourseList == 0)
                                                                                       {  %>
                                                                                    <tr class="tablerow1">
                                                                                        <% }
                                                                                       else
                                                                                       {%>
                                                                                        <tr class="tablerow2">
                                                                                            <% } %>
                                                                                            <td width="300">
                                                                                                <!-- Course -->
                                                                                                <asp:LinkButton ID="lbCourse" runat="server" CommandName="Course_Click" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "CourseID")+ "," + DataBinder.Eval(Container.DataItem, "ProfileID") %>'
                                                                                                    Text='<%# DataBinder.Eval(Container.DataItem, "Name") %>'></asp:LinkButton>
                                                                                            </td>
                                                                                            <% if (ShowEbook && isIpad)
                                                                                               { %>
                                                                                            <td align="center" width="80" colspan="2">
                                                                                                <!-- EBook -->
                                                                                                <asp:LinkButton ID="lnkDownloadEbook" runat="server" CommandName="DownloadEbook"
                                                                                                    CommandArgument='<%# DataBinder.Eval(Container.DataItem, "CourseID") %>' Enabled="True">
                                                                                        <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_ebookdownload.gif' border=0 />
                                                                                                </asp:LinkButton>
                                                                                            </td>
                                                                                            <% } %>
                                                                                            <td align="center" width="80" colspan="2">
                                                                                                <!-- Status -->
                                                                                                <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_coursestatus<%# DataBinder.Eval(Container.DataItem, "CourseStatusID") %>.gif' />
                                                                                            </td>
                                                                                            <td align="center" width="120">
                                                                                                <!-- Print Certificate -->
                                                                                                <asp:LinkButton ID="lnkPrintCertificate" runat="server" CommandName="Certificate_Print"
                                                                                                    CommandArgument='<%# DataBinder.Eval(Container.DataItem, "CourseStatusID") + "," + DataBinder.Eval(Container.DataItem, "CourseID") %>'
                                                                                                    Enabled="True">
                                                                                        <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_cert<%# DataBinder.Eval(Container.DataItem, "CourseStatusID") %>.gif' border=0 />
                                                                                                </asp:LinkButton>
                                                                                            </td>
                                                                                            <td id="CoursePointsAvailable" runat="server" align="center" width="150" colspan="2">
                                                                                                <!-- CPD Points Available -->
                                                                                                <asp:Label ID="lblCoursePoints" runat="server" />
                                                                                            </td>
                                                                                            <td id="Td2" runat="server" align="center" width="0" colspan="0">
                                                                                                <!-- Last Completion Date-->
                                                                                                <%# DataBinder.Eval(Container.DataItem, "LastComp") %>
                                                                                            </td>
                                                                                            <td id="Td3" runat="server" align="center" width="0" colspan="0">
                                                                                                <!-- Course Due-->
                                                                                                <%# DataBinder.Eval(Container.DataItem, "Due") %>
                                                                                            </td>
                                                                                            <td id="Td4" runat="server" align="center" width="0" colspan="0" visible="false">
                                                                                                <!-- Course Due colour-->
                                                                                                <%# DataBinder.Eval(Container.DataItem, "Red")  %>
                                                                                            </td>
                                                                                        </tr>
                                                                                </ItemTemplate>
                                                                            </asp:Repeater>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </asp:PlaceHolder>
                                            <!-- //Course List -->
                                            <tr>
                                                <td valign="top" align="left" width="75%">
                                                    <!-- Policy List -->
                                                    <asp:PlaceHolder ID="phPolicyList" runat="server">
                                                        <div>
                                                            <br />
                                                            <br />
                                                            &nbsp;&nbsp;<Localized:LocalizedLabel ID="lblPolicyInstructions" runat="server" /></div>
                                                        <div class="moduleTable">
                                                            <table class="tableborder" id="Table1" cellspacing="0" cellpadding="1" runat="server">
                                                                <tr>
                                                                    <td>
                                                                        <table id="tblPolicyListDetail" cellspacing="0" cellpadding="3" border="0">
                                                                            <tr class="tablerowtop">
                                                                                <td width="300">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="lblPolicyHeading" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="80" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblPolicyStatusHeading" runat="server" Key="lblStatusHeading">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="120" />
                                                                                <td align="center" width="150" colspan="2" id="PolicyPointsAvailableHeading" runat="server">
                                                                                    <Localized:LocalizedLabel ID="lblPolicyCPDPointsAvailableHeading" runat="server"
                                                                                        Key="lblCPDPointsAvailableHeading">
                                                                                    </Localized:LocalizedLabel>&nbsp;&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <asp:Repeater ID="rptPolicyList" runat="server">
                                                                                <ItemTemplate>
                                                                                    <tr class="tablerow2">
                                                                                        <td width="300">
                                                                                            <asp:LinkButton ID="lbPolicy" runat="server" CommandName="Policy_Click" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "PolicyID")+ "," + DataBinder.Eval(Container.DataItem, "ProfileID") %>'
                                                                                                Text='<%# DataBinder.Eval(Container.DataItem, "PolicyName") %>'></asp:LinkButton>
                                                                                        </td>
                                                                                        <td align="center" width="80" colspan="2">
                                                                                            <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_status<%# DataBinder.Eval(Container.DataItem, "PolicyStatus") %>.gif'>
                                                                                        </td>
                                                                                        <td align="center" width="120" />
                                                                                        <td align="center" width="150" colspan="2" id="PolicyPointsAvailable" runat="server">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Points") %>
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                                <AlternatingItemTemplate>
                                                                                    <tr class="tablerow1">
                                                                                        <td width="300">
                                                                                            <asp:LinkButton ID="lbPolicy" runat="server" CommandName="Policy_Click" CommandArgument='<%# DataBinder.Eval(Container.DataItem, "PolicyID")+ "," + DataBinder.Eval(Container.DataItem, "ProfileID") %>'
                                                                                                Text='<%# DataBinder.Eval(Container.DataItem, "PolicyName") %>'></asp:LinkButton>
                                                                                        </td>
                                                                                        <td align="center" width="80" colspan="2">
                                                                                            <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_status<%# DataBinder.Eval(Container.DataItem, "PolicyStatus") %>.gif'>
                                                                                        </td>
                                                                                        <td align="center" width="120" />
                                                                                        <td align="center" width="150" colspan="2" id="PolicyPointsAvailable" runat="server">
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Points") %>
                                                                                        </td>
                                                                                    </tr>
                                                                                </AlternatingItemTemplate>
                                                                            </asp:Repeater>
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </div>
                                                    </asp:PlaceHolder>
                                                    <!-- //Policy List -->
                                                </td>
                                            </tr>
                                            <tr height="100%">
                                                <td valign="top" align="left" width="75%">
                                                    <asp:PlaceHolder ID="phModuleList" runat="server">
                                                        <!-- table module holder  -->
                                                        <div class="HomePageCourseCertificate" id="divViewCertificate" runat="server">
                                                            <Localized:LocalizedHyperLink ID="lnkViewCertificate" runat="server" CssClass="HomePageCourseCertificate"
                                                                Target="_blank"></Localized:LocalizedHyperLink></div>
                                                        <div>
                                                            &nbsp;&nbsp;<asp:Label ID="lblCourseModuleList" runat="server" />
                                                        </div>
                                                        <div>
                                                            &nbsp;&nbsp;<asp:Label ID="lblLessonQuizReq" runat="server" />
                                                        </div>
                                                        <div class="moduleTable">
                                                            <!-- Module List table head -->
                                                            <table class="tableborder" id="tblModule" cellspacing="0" cellpadding="1" runat="server">
                                                                <tr>
                                                                    <td>
                                                                        <table id="Table4" cellspacing="0" cellpadding="3" border="0">
                                                                            <tr class="tablerowtop">
                                                                                <td width="310">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="locModule" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="110" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="locBegin" runat="server">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="80" id="tdQuickFactHeader" runat="server">
                                                                                    <%--New id to enable and disable--%>
                                                                                    &nbsp;<Localized:LocalizedLabel ID="locQuickFacts" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="80" id="collLastComp" runat="server">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="locLastComp" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" width="80" id="collDue" runat="server">
                                                                                    &nbsp;<Localized:LocalizedLabel ID="locDue" runat="server"></Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td id="ModulePointsAvailableHeading" runat="server" align="center" width="150" colspan="2">
                                                                                    <Localized:LocalizedLabel ID="lblModuleCPDPointsAvailable" runat="server" Key="lblCPDPointsAvailableHeading">
                                                                                    </Localized:LocalizedLabel>&nbsp;&nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <tr class="tablerow3">
                                                                                <td>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td align="center" id="tdLesson" runat="server">
                                                                                    <%--New id to enable and disable--%>
                                                                                    <Localized:LocalizedLabel ID="Localizedlabel1" runat="server" Key="locLesson">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td align="center" id="tdQuizHeader">
                                                                                    <Localized:LocalizedLabel ID="locQuizAdaptive" runat="server" Key="locQuizAdaptive">
                                                                                    </Localized:LocalizedLabel>
                                                                                    <Localized:LocalizedLabel ID="LocalizedLabel2" runat="server" Key="locQuiz">
                                                                                    </Localized:LocalizedLabel>
                                                                                </td>
                                                                                <td id="Td1" runat="server">
                                                                                    <%--New id to enable and disable--%>
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td id="SubHead1" runat="server">
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td id="SubHead2" runat="server">
                                                                                    &nbsp;
                                                                                </td>
                                                                                <td id="ModulePointsAvailableSubHeading" runat="server" align="center">
                                                                                    &nbsp;
                                                                                </td>
                                                                            </tr>
                                                                            <!-- Module List table content - repeater-->
                                                                            <asp:Repeater ID="rptModules" runat="server">
                                                                                <ItemTemplate>
                                                                                    <tr class="tablerow2">
                                                                                        <td align="left" class="Module">
                                                                                            <!-- Module name-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "ModuleName") %>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="tdLessonONClick">
                                                                                            <%--New id to enable and disable--%>
                                                                                            <!-- Launch Lesson -->
                                                                                            <asp:LinkButton runat="server" Enabled="true" CommandName="Lesson_OnClick" ID="Linkbutton1"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ModuleID") %>'>
                                                                            <!-- Lesson Status -->
                                                                                    <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_L<%# DataBinder.Eval(Container.DataItem, "LessonStatus") %>.gif' alt='<%# ResourceManager.GetString("lblLegend_" + DataBinder.Eval(Container.DataItem, "LessonStatusName").ToString().Replace("(Time Elapsed)", "").Replace("(New Content)", "").Replace(" ", "")) %>' border=0>
                                                                                            </asp:LinkButton>
                                                                                        </td>
                                                                                        <td align="center" class="Module">
                                                                                            <!-- Launch Quiz-->
                                                                                            <asp:LinkButton runat="server" Enabled="true" CommandName="Quiz_OnClick" ID="Linkbutton2"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ModuleID") %>'>
                                                                                <!-- Quiz Status -->
																			        <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_Q<%# DataBinder.Eval(Container.DataItem, "QuizStatus") %>.gif' alt='<%# ResourceManager.GetString("lblLegend_" + DataBinder.Eval(Container.DataItem, "QuizStatusName").ToString().Replace("(Time Elapsed)", "").Replace("(New Content)", "").Replace(" ", "")) %>' border=0>
                                                                                            </asp:LinkButton>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="tdQFSPath">
                                                                                            <%--New id to enable and disable--%>
                                                                                            <!-- QFS -->
                                                                                            <a href='<%# DataBinder.Eval(Container.DataItem, "QFSPath") %>' target="_blank" id="aQFSPath"
                                                                                                runat="server">
                                                                                                <asp:Image ID="imgQuickFacts" runat="server" BorderStyle="none" />
                                                                                            </a>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="LastComp" runat="server">
                                                                                            <!-- Last Completion Date-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "LastComp") %>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="ModuleQuizDue" runat="server">
                                                                                            <!-- Quiz Due-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "QuizDue") %>
                                                                                        </td>
                                                                                        <td id="HiddenColour" align="left" class="Module" runat="server" visible="false"
                                                                                            style="visibility: hidden">
                                                                                            <!-- Hidden Colour-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Red") %>
                                                                                        </td>
                                                                                        <td id="ModulePoints" runat="server" align="center" class="Module">
                                                                                            <asp:Label ID="lblModulePoints" runat="server" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </ItemTemplate>
                                                                                <AlternatingItemTemplate>
                                                                                    <tr class="tablerow1">
                                                                                        <td align="left" class="Module">
                                                                                            <!-- Module name-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "ModuleName") %>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="tdLaunchLesson">
                                                                                            <%--New id to enable and disable--%>
                                                                                            <!-- Launch Lesson -->
                                                                                            <asp:LinkButton runat="server" Enabled="true" CommandName="Lesson_OnClick" ID="Linkbutton3"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ModuleID") %>'>
                                                                        <!-- Lesson Status -->
                                                                        <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_L<%# DataBinder.Eval(Container.DataItem, "LessonStatus") %>.gif' alt='<%# ResourceManager.GetString("lblLegend_" + DataBinder.Eval(Container.DataItem, "LessonStatusName").ToString().Replace("(Time Elapsed)", "").Replace("(New Content)", "").Replace(" ", "")) %>' border=0>
                                                                                            </asp:LinkButton>
                                                                                        </td>
                                                                                        <td align="center" class="Module">
                                                                                            <!-- Launch Quiz-->
                                                                                            <asp:LinkButton runat="server" Enabled="true" CommandName="Quiz_OnClick" ID="Linkbutton4"
                                                                                                CommandArgument='<%# DataBinder.Eval(Container.DataItem, "ModuleID") %>'>
                                                                             <!-- Quiz Status -->
																			<img src='/general/images/<%= ApplicationSettings.ButtonSet %>_Q<%# DataBinder.Eval(Container.DataItem, "QuizStatus") %>.gif' alt='<%# ResourceManager.GetString("lblLegend_" + DataBinder.Eval(Container.DataItem, "QuizStatusName").ToString().Replace("(Time Elapsed)", "").Replace("(New Content)", "").Replace(" ", "")) %>' border=0>
                                                                                            </asp:LinkButton>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="tdQFSFact">
                                                                                            <%--New id to enable and disable--%>
                                                                                            <!-- QFS -->
                                                                                            <a href='<%# DataBinder.Eval(Container.DataItem, "QFSPath") %>' target="_blank" id="aQFSFact"
                                                                                                runat="server">
                                                                                                <asp:Image ID="imgQuickFacts" runat="server" BorderStyle="none" />
                                                                                            </a>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="LastComp" runat="server">
                                                                                            <!-- Last Completion Date-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "LastComp") %>
                                                                                        </td>
                                                                                        <td align="center" class="Module" id="ModuleQuizDue" runat="server">
                                                                                            <!-- Quiz Due-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "QuizDue") %>
                                                                                        </td>
                                                                                        <td id="HiddenColour" align="left" class="Module" visible="false" style="visibility: hidden"
                                                                                            runat="server">
                                                                                            <!-- Hidden Colour-->
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Red") %>
                                                                                        </td>
                                                                                        <td id="ModulePoints" runat="server" align="center" class="Module">
                                                                                            <asp:Label ID="lblModulePoints" runat="server" />
                                                                                        </td>
                                                                                    </tr>
                                                                                </AlternatingItemTemplate>
                                                                            </asp:Repeater>
                                                                            <!-- / Repeater-->
                                                                        </table>
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                            <!-- / Module List table-->
                                                        </div>
                                                        <!-- / table module holder -->
                                                        <div class="KeyTable" id="divModuleKeyTable" runat="server">
                                                            <div class="KeyTableHeader">
                                                                <Localized:LocalizedLabel ID="lblLegend_ModuleStatusKey" runat="server" Key="lblLegend_StatusKey">
                                                                </Localized:LocalizedLabel></div>
                                                            <div class="KeyTableRow">
                                                                <span class="KeyTableColumn">
                                                                    <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_not_started.gif">
                                                                    <Localized:LocalizedLabel ID="lblLegend_NotStarted" runat="server">
                                                                    </Localized:LocalizedLabel></span> <span class="KeyTableColumn">
                                                                        <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_in_progress.gif">
                                                                        <Localized:LocalizedLabel ID="lblLegend_InProgress" runat="server">
                                                                        </Localized:LocalizedLabel></span> <span class="KeyTableColumn">
                                                                            <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_completed.gif">
                                                                            <Localized:LocalizedLabel ID="lblLegend_Completed" runat="server">
                                                                            </Localized:LocalizedLabel></span> <span class="KeyTableColumn">
                                                                                <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_new_content.gif">
                                                                                <Localized:LocalizedLabel ID="lblLegend_NewContent" runat="server">
                                                                                </Localized:LocalizedLabel></span></div>
                                                            <div class="KeyTableRow">
                                                                <span class="KeyTableColumn">
                                                                    <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_expired.gif">
                                                                    <Localized:LocalizedLabel ID="lblLegend_Expired" runat="server">
                                                                    </Localized:LocalizedLabel></span> <span class="KeyTableColumn">
                                                                        <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_passed.gif">
                                                                        <Localized:LocalizedLabel ID="lblLegend_Passed" runat="server">
                                                                        </Localized:LocalizedLabel></span> <span class="KeyTableColumn">
                                                                            <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_failed.gif">
                                                                            <Localized:LocalizedLabel ID="lblLegend_Failed" runat="server">
                                                                            </Localized:LocalizedLabel></span></div>
                                                        </div>
                                                    </asp:PlaceHolder>
                                                </td>
                                            </tr>
                                            <%--Madhuri CPD Event Start--%>
                                            <tr>
                                                <td valign="top" align="left" width="100%">
                                                    <asp:PlaceHolder ID="phEvent" runat="server">
                                                        <asp:PlaceHolder ID="phEventList" runat="server">
                                                            <div>
                                                                <br />
                                                                <br />
                                                                &nbsp;&nbsp;<Localized:LocalizedLabel ID="lblEventInstructions" runat="server" /></div>
                                                            <div class="moduleTable">
                                                                <table class="tableborder" id="Table2" cellspacing="0" cellpadding="1" runat="server">
                                                                    <tr>
                                                                        <td>
                                                                            <asp:DataGrid ID="dgrCPD" runat="server" runat="server" AutoGenerateColumns="False"
                                                                                AllowPaging="True" BorderWidth="0" GridLines="None" Width="100%">
                                                                                <SelectedItemStyle CssClass="tablerow2"></SelectedItemStyle>
                                                                                <AlternatingItemStyle CssClass="tablerow2" BorderWidth="0"></AlternatingItemStyle>
                                                                                <ItemStyle CssClass="tablerow1"></ItemStyle>
                                                                                <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                                                                                <Columns>
                                                                                    <asp:TemplateColumn HeaderText="Event ID" Visible="False">
                                                                                        <ItemTemplate>
                                                                                            <asp:Label ID="lblEventID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventID").ToString()%>'
                                                                                                Width="100%"></asp:Label>
                                                                                            <asp:Label ID="lblEventPeriodID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventPeriodID").ToString()%>'
                                                                                                Width="100%"></asp:Label>
                                                                                            <%-- <asp:Label ID="lblProfileID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ProfileID").ToString()%>'
                                                                                Width="100%"></asp:Label>
                                                                            <asp:Label ID="lblEventName" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventName").ToString()%>'
                                                                                Width="100%"></asp:Label>
                                                                            <asp:Label ID="lblEventType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "EventTypeId").ToString()%>'
                                                                                Width="100%"></asp:Label>--%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="EventName">
                                                                                        <ItemTemplate>
                                                                                            <asp:HiddenField ID="hdUserType" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "UserType")%>'>
                                                                                            </asp:HiddenField>
                                                                                            <asp:HiddenField ID="lblUserId" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "UserID")%>'>
                                                                                            </asp:HiddenField>
                                                                                            <asp:HiddenField ID="hdAllowuser" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "AllowUser")%>'>
                                                                                            </asp:HiddenField>
                                                                                            <%--<%# DataBinder.Eval(Container.DataItem, "EventName").ToString()%>--%>
                                                                                            <%# Eval("UserType").ToString() == "1" ? ">" + Eval("EventName").ToString() : Eval("EventName").ToString()%>
                                                                                            <%# Convert.ToInt32(DataBinder.Eval(Container.DataItem, "UserType")) > 1 ? "*" : ""%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Event Item">
                                                                                        <ItemTemplate>
                                                                                            <%# DataBinder.Eval(Container.DataItem, "EventItem").ToString()%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <%-- <asp:TemplateColumn HeaderText="CPD profile" HeaderStyle-Width="50px">
                                                                            <ItemTemplate>
                                                                                <%# DataBinder.Eval(Container.DataItem, "ProfileName").ToString()%>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateColumn>--%>
                                                                                    <asp:TemplateColumn HeaderText="Event Date">
                                                                                        <ItemTemplate>
                                                                                            <asp:Label ID="lblCurrentDate" runat="server"></asp:Label>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Starttime" HeaderStyle-Width="50px" Visible="false">
                                                                                        <ItemTemplate>
                                                                                            <asp:Label ID="lblStarttime" runat="server"></asp:Label>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Endtime" HeaderStyle-Width="50px" Visible="false">
                                                                                        <ItemTemplate>
                                                                                            <asp:Label ID="lblendtime" runat="server"></asp:Label>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Event Type">
                                                                                        <ItemTemplate>
                                                                                            <%# DataBinder.Eval(Container.DataItem, "EventType").ToString()%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Point" HeaderStyle-Width="50px">
                                                                                        <ItemTemplate>
                                                                                            <asp:HiddenField ID="hdpoints" runat="server" Value='<%# DataBinder.Eval(Container.DataItem, "points")%>'>
                                                                                            </asp:HiddenField>
                                                                                            <%# DataBinder.Eval(Container.DataItem, "points").ToString()%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Event Provider" HeaderStyle-Width="100px">
                                                                                        <ItemTemplate>
                                                                                            <%# DataBinder.Eval(Container.DataItem, "EventProvider").ToString()%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <%--  <asp:TemplateColumn HeaderText="EventLocation" HeaderStyle-Width="100px">
                                                                            <ItemTemplate>
                                                                                <%# DataBinder.Eval(Container.DataItem, "EventLocation").ToString()%>
                                                                            </ItemTemplate>
                                                                        </asp:TemplateColumn>--%>
                                                                                    <asp:TemplateColumn HeaderText="File">
                                                                                        <ItemTemplate>
                                                                                            <%# DataBinder.Eval(Container.DataItem, "Files").ToString()%>
                                                                                            <%-- <%# Eval("UserType").ToString() == "0" ?   Eval("Files"):GetFilename(Eval("Files").ToString()) %>--%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Status">
                                                                                        <ItemTemplate>
                                                                                            <img src='/general/images/<%= ApplicationSettings.ButtonSet %>_status<%# DataBinder.Eval(Container.DataItem, "Status") %>.gif'>
                                                                                            <%--<asp:Label ID="Label1" Text='<%# Eval("Status").ToString() == "A" ? "Absent" : "Present" %>' runat="server" />--%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                    <asp:TemplateColumn HeaderText="Action">
                                                                                        <ItemTemplate>
                                                                                            <asp:LinkButton ID="lnkadd" Text="Add" runat="server" CommandName="Add" CommandArgument="Add"></asp:LinkButton>
                                                                                            <asp:LinkButton ID="lnkedit" Text="Edit" runat="server" CommandName="Edit" CommandArgument="Edit"></asp:LinkButton>
                                                                                            <%--<asp:LinkButton ID="lnkDelete" Text="Delete" runat="server" CommandName="Delete"
                                                                                OnClientClick="Confirm()" CommandArgument="Delete"></asp:LinkButton>--%>
                                                                                        </ItemTemplate>
                                                                                    </asp:TemplateColumn>
                                                                                </Columns>
                                                                                <PagerStyle Visible="true"></PagerStyle>
                                                                            </asp:DataGrid>
                                                                        </td>
                                                                    </tr>
                                                                </table>
                                                            </div>
                                                        </asp:PlaceHolder>
                                                        <div style="float: left; padding-top: 20px; padding-left: 10px;">
                                                            <Localized:LocalizedButton ID="btnCreateEvent" runat="server" Width="150px" CssClass="saveButton"
                                                                Text="Create New Profile" Key="btnCreateProfile" OnClick="btnCreateEvent_Click">
                                                            </Localized:LocalizedButton>
                                                        </div>
                                                    </asp:PlaceHolder>
                                                </td>
                                            </tr>
                                            <%--Madhuri CPD Event End--%>
                                            <tr>
                                                <td>
                                                    <div class="KeyTable" id="divCourseKeyTable" runat="server">
                                                        <div class="KeyTableHeader">
                                                            <Localized:LocalizedLabel ID="lblLegend_CourseStatusKey" runat="server" Key="lblLegend_StatusKey" />
                                                        </div>
                                                        <div class="KeyTableRow">
                                                            <span class="KeyTableColumn">
                                                                <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_not_started.gif">
                                                                <Localized:LocalizedLabel ID="lblLegend_Incomplete" runat="server" />
                                                            </span><span class="KeyTableColumn">
                                                                <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_passed.gif">
                                                                <Localized:LocalizedLabel ID="lblLegend_Complete" runat="server" />
                                                            </span><span id="spCertificate" runat="server" class="KeyTableColumn">
                                                                <img src="General/Images/<%= ApplicationSettings.ButtonSet %>_cert2.gif">
                                                                <Localized:LocalizedLabel ID="lblLegend_Certificate" runat="server" />
                                                            </span>
                                                        </div>
                                                    </div>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td valign="top" width="10%" align="right">
                                        <navigation:OrgLogo id="ucOrgLogo" runat="server">
                                        </navigation:OrgLogo>
                                    </td>
                                </tr>
                            </table>
                            <br />
                            <br />
                            <!-- Footer -->
                            <table cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                                <tr valign="bottom" align="center">
                                    <td valign="bottom" align="center">
                                        ©
                                        <asp:Label ID="lblCopyRightYear" runat="server"></asp:Label>
                                        &nbsp;<asp:HyperLink ID="lnkCompany" runat="server" Target="_blank"></asp:HyperLink>
                                        <br />
                                        <asp:Label ID="lblApplicationName" runat="server" CssClass="ApplicationNameInline"></asp:Label><asp:Label
                                            ID="lblTradeMark" runat="server" CssClass="TradeMarkInline"></asp:Label>
                                        <asp:Label ID="lblHomePageFooter" runat="server"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                <!--/tbody-->
            </td>
        </tr>
    </table>
    <asp:TextBox ID="txttoolbookloc" runat="server" Width="0px" Height="0px"></asp:TextBox>
    </form>
</body>
</html>
