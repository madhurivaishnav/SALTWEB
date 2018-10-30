<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OrgMailSetup.aspx.cs" Inherits="Bdw.Application.Salt.Web.Administration.Organisation.OrgMailSetup" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="../../General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="../../General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="../../General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="../../General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<HTML>
    <HEAD>
		<title runat="server" id="pagTitle"></title>
		<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />				
		<script src="../../General/Js/jquery-1.9.1.min.js" type="text/javascript"></script>
		<script>
            $( document ).ready(function() {$("#reminderblurb").toggle();}); 
        </script>
		 
	</HEAD>
	<body ms_positioning="FlowLayout" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
		<form id="frmOrgMailSetup"  method="post" runat="server">
			<table border="0" align="center" height="100%" width="100%" cellpadding="0" cellspacing="0">
				<!-- Header -->
				<tr align="center" valign="top" width="100%">
					<td align="center" valign="top" width="100%" colspan="2">
						<navigation:header id="ucHeader" runat="server"></navigation:header>
					</td>
				</tr>
				<tr height="100%" align="left" valign="top">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer">
						<navigation:adminmenu runat="server" id="ucAdminMenu"></navigation:adminmenu>
					</td>
					<!-- Body/Conent -->
					<td class="DataContainer">
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Organisation Mail Setup</Localized:LocalizedLabel><br />
												
						
						<table  align="left" border="0" width = "100%">
							<tr>
								<td>
									<asp:PlaceHolder ID="plhOrgMailSetup" Runat="server">
									    <asp:label ID = "lblValidationMSG" runat= "server" CssClass = "ValidatorMessage" />
									    <asp:label ID="lblRemEscID" runat ="server" Visible ="false" />
                                            <table id="tblCourses" width="100%"  border="0" rules="none"  cellpadding ="5">
                                    		    <tr>
                                    		        <td colspan = "3">
                                    		            <b><Localized:LocalizedLiteral ID="ltrConfigureCourse" runat="server"></Localized:LocalizedLiteral></b>
                                    		        </td>
                                    		    </tr>                                    		    
                                    		    <tr>
			                                        <!-- courselist here -->
				                                    <td colspan = "3" >
                                                        <asp:CheckBoxList ID="chkCourseList" runat="server" RepeatColumns = "3"/> 
				                                    </td>			                                  						    
			                                    </tr> 
			                                </table>
			                                <br />
			                                <hr  style="size:.5px" />
			                                <br />
			                                <table id ="tblInitialEnrolment"  width ="100%" border="0" rules =none   cellpadding = "5">
			                                     <tr>
                                                    <td >
                                                    <!-- initial enrolment reminder header -->
                                                        <b><Localized:LocalizedLabel ID="capTblOrgMailSetupTop" runat="server"></Localized:LocalizedLabel></b>
                                                    </td>
                                                    <td><br /></td><td/>
                                                </tr>
                                                <tr>
			                                        <td>
			                                            <!-- enable initial enrolment-->
			                                            &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrWarnUsers" runat="server"></Localized:LocalizedLiteral>
			                                            <asp:CheckBox ID="chkWarnUsers" runat="server" OnCheckedChanged = "chkWarnUsers_check" AutoPostBack = "true">
                                                            </asp:CheckBox>
                                                    </td>                                                        
                                                
			                                    </tr>
                                                <tr>
                                                    <!-- number of days for user to complete the course -->
                                                    <td width="50%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrNumberofDaysDelinq" runat="server"></Localized:LocalizedLiteral>
                                                    </td>
                                                    <td align="left"width="20%">
                                                        <asp:TextBox Width="50px" ID="txtNumberofDaysDelinq" runat="server">
                                                        </asp:TextBox>
                                                    </td>
                                                    <td width="30%"><br /></td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID = "ltrMyTraining" runat= "server"></Localized:LocalizedLiteral>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
			                                <hr  style="size:.5px" />
			                                <br />
                                            <table id ="tblPreExpiryReminder"  width ="100%"  border="0" rules =none   cellpadding = "5">
                                                <tr>
                                                    <td colspan = "3">
                                                        <b><Localized:LocalizedLabel ID="capTblOrgSetupBottom" runat="server"></Localized:LocalizedLabel></b>
                                                    </td>
                                                </tr>
                                             
                                                <tr>
                                                    <td align="left" width="50%" colspan="3">
                                                        <Localized:LocalizedLiteral ID="ltrQuizResults" runat="server"></Localized:LocalizedLiteral>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width ="15%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral runat="server" id ="ltrQuizExpiry" />
                                                    <asp:checkbox runat = "server" id = "chkWarnQuizExpiry"  OnCheckedChanged = "chkWarnQuizExpiry_check" AutoPostBack = true/>
                                                    </td>
                                                </tr>
                                                
                                                <tr>
                                                    <td width="15%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="radDaysBeforeExpiry" runat="server" />
                                                    </td>
                                                    <td width="20%">
                                                        <asp:TextBox Width="50px" ID="txtDaysBeforeWarn" runat="server"> 
                                                        </asp:TextBox>                                                        
                                                    </td>
                                                    <td width="30%"/>
                                                </tr>
                                                <tr>
                                                    <td >
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrAplyTo" runat="server" />
                                                        <br/>    
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:checkbox id = "chkPreExpInitEnrolment" runat = "server" />
                                                        <Localized:LocalizedLiteral ID="ltrPreExpinitEnrolment" runat="server" />
                                                        <br />
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:checkbox id = "chkPreExpiryResitPeriod" runat = "server"   style="display:none"  />
                                                        <Localized:LocalizedLiteral ID="ltrPreExpResitPeriod" runat="server" Visible="false" />
                                                    </td>
                                                    <td colspan ="2">
                                                        <div style="font-size:xx-small;"><Localized:LocalizedLiteral  ID="ltrPreExpCalc" runat="server" /></div>
                                                    </td>                                                    
                                                    
                                                </tr>  
                                            </table>    
                                            <br />
			                                <hr  style="size:.5px" />
			                                <br />   
                                            <table id ="tblPostExpiry" border="0" width ="100%" rules =none   cellpadding = "5"> 
                                                <tr>
                                                    <td>
                                                        <b><Localized:LocalizedLabel ID="ltrPostExpReminder" runat="server"></Localized:LocalizedLabel></b>
                                                    </td>                                                    
                                                </tr>
                                                <tr>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral runat="server" id ="ltrSendReminder" />
                                                    </td>
                                                </tr>
                                                
                                                
                                                <tr>
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral runat="server" id ="ltrEnablePostExpReminder" />
                                                        <asp:CheckBox id="chkPostExpiryReminder" OnCheckedChanged="chkPostExpiryReminder_check" AutoPostBack =true runat="server" />                                                        
                                                    </td>
                                                </tr>   
                                                <tr>
                                                    <td width="50%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrNumberofWarns" runat="server"></Localized:LocalizedLiteral>
                                                    </td>
                                                    <td align="left" width="20%">
                                                        <asp:TextBox Width="50px" ID="txtNumberOfWarns" runat="server">
                                                        </asp:TextBox>
                                                    </td>                                                    
                                                </tr>
                                                <tr>
                                                    <td width="50%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrNumberofDaysWarns" runat="server"></Localized:LocalizedLiteral>
                                                    </td>
                                                    <td align="left" width="20%">
                                                        <asp:TextBox Width="50px" ID="txtNumberofDaysWarns" runat="server">
                                                        </asp:TextBox>
                                                        &nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrDays" runat="server"></Localized:LocalizedLiteral>
                                                    </td>
                                                    <td width="30%"><br /></td>
                                                </tr>
                                                <tr>                                                    
                                                    <td>
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrPostExpiryApplyto" runat="server" />
                                                        <br/>    
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:checkbox id = "chkPostExpiryInit" runat = "server" />
                                                        <Localized:LocalizedLiteral ID="ltrPostExpiryInit" runat="server" /><br />
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:checkbox id = "chkPostExpiryResit" runat = "server" />
                                                        <Localized:LocalizedLiteral ID="ltrPostExpiryResit" runat="server" />
                                                    </td>                                                      
                                                </tr>
                                                </table>
                                                <br /> 
                                                <a href="#" id="clickme"> <Localized:LocalizedLiteral  ID="ltrShowHide" runat="server"></Localized:LocalizedLiteral></a>
                                                <div id ="reminderblurb" runat="server">
                                                    <table>
                                                        <tr>
                                                            <td>
                                                                <Localized:LocalizedLiteral  ID="ltrReminders" runat="server"></Localized:LocalizedLiteral>
                                                            </td>                                                    
                                                        </tr>
                                                        <tr>
                                                            <td colspan = "3">    
                                                                <img id="timeline"  Src="/general/images/email_timeline.png"  border="0">
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                                <script>
                                                    $("#clickme").click(function() { $("#reminderblurb").toggle(400); return false; });
                                                </script>                                                                                       		
                                            <br />
			                                <hr  style="size:.5px" />
			                                <br />
                                            <table id ="tblManagerNotify" border="0" width ="100%" rules =none frame ="box"  cellpadding = "5">
                                                <tr>
                                                    <td >
                                                        <b><Localized:LocalizedLiteral ID="ltrManagerNotification" runat="server"></Localized:LocalizedLiteral></b>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td width="60%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrWarnMgrs" runat="server"></Localized:LocalizedLiteral>
                                                        <asp:CheckBox ID="chkWarnMgrs" runat="server" OnCheckedChanged = "chkWarnMgrs_check" AutoPostBack = "true" />                                                        
                                                    </td>
                                                    <td width="30%"></td>
                                                </tr>
                                                <tr>
                                                    <td width = "50%">
                                                        &nbsp;&nbsp;&nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrEscalationOptions" runat="server" />
                                                        <br />
                                                        
                                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<asp:radiobuttonlist id="radEscMgrMailOpts" runat="server" OnSelectedIndexChanged = "radEscMgrMailOpts_changed" AutoPostBack = "true" >
                                                            <asp:ListItem Value = "PERUSER"></asp:ListItem>
                                                            <asp:ListItem value = "REGULAR"></asp:ListItem>
                                                        </asp:radiobuttonlist>
                                                        
                                                    </td>
                                                    <td width="20%">
                                                        <br />
                                                        <br />
                                                        <br />
                                                        <br />
                                                        <asp:textbox id ="txtREegularDays" runat ="server"  Width ="50px"/>
                                                        &nbsp;&nbsp;<Localized:LocalizedLiteral ID="ltrDays2" runat="server"></Localized:LocalizedLiteral>
                                                    </td>                                                    
                                                </tr>
                                                <tr>
                                                    <td />
                                                    <td colspan = "2">
                                                        <asp:checkbox runat = "server" ID = "chkCumulative"></asp:checkbox>
                                                        &nbsp;<Localized:LocalizedLiteral ID="ltrCumulative" runat="server"></Localized:LocalizedLiteral>
                                                        <br />
                                                    </td>
                                                </tr>                                                                                              
                                            </table>
                                            <br />
                                            <Localized:LocalizedButton ID="btnOrgMailSetupSave" OnClick="btnOrgMailSetupSave_Click" runat="server"  CssClass = "saveButton" />                                           
									</asp:PlaceHolder>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<!-- Footer -->
				<tr align="center" valign="bottom">
					<td align="center" valign="middle" colspan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
			</table>
		</form>
    </body>
</html>
