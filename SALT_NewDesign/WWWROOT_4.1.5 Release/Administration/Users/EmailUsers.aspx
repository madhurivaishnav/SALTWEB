<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Page language="c#" Codebehind="EmailUsers.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Users.EmailUsers" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="navigation" Tagname="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="navigation" TagName="HelpLink" Src="/General/UserControls/Navigation/HelpLink.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
	<HEAD>
		<title runat="server" id="pagTitle"></title>
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<script language="javascript">
		<!--
		function TreeView_ClickCheckBox(treeViewName, checkBox, nodeID)
		{
			var selectedNodes = document.forms[0].item(treeViewName);
			if (checkBox.checked)
			{
				selectedNodes.value = TreeView_AddStrArray(nodeID, selectedNodes.value)
			}
			else
			{
				selectedNodes.value = TreeView_RemoveStrArray(nodeID, selectedNodes.value)
			}
		}
		
		//String array functions
		//Check a string is in the comma delimited string array
		//Ex: alert(inStrArray("1","2,1"));		
		function TreeView_InStrArray(val, vals)
		{
			var valArray = vals.split(",");
			
			for(var i=0;i<valArray.length;i++)
			{
				if (valArray[i]==val)
					break;
			}
			if (i==valArray.length)
				return false;
			else
				return true;	
		}

		//add a string to  the comma delimited string array
		//Ex: alert(addStrArray("1","2,1"));		
		function TreeView_AddStrArray(val, vals)
		{
			return (vals.length==0)?val:(vals+","+ val);	
		}
		
		
		//Remove a string from the comma delimited string array
		//Ex: alert(removeStrArray("1","2,1"));		
		function TreeView_RemoveStrArray(val, vals)
		{
			var valArray = vals.split(",");
			var newArray = new Array();
			
			for(var i=0, j=0;i<valArray.length;i++)
			{
				if (valArray[i]!=val)
					newArray[j++]=valArray[i];
			}
			
			return 	newArray.join(",");
		}
		// -->
		</script>
	</HEAD>
	<body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<table height="100%" cellSpacing="0" cellPadding="0" width="100%" align="center" border="0">
				<!-- Header -->
				<tr vAlign="top" align="center" width="100%">
					<td style="HEIGHT: 31px" vAlign="top" align="center" width="100%" colSpan="2"><navigation:header id="ucHeader" runat="server"></navigation:header></td>
				</tr>
				<tr vAlign="top" align="left" height="100%">
					<!-- Left Navigation -->
					<td class="AdminMenuContainer">
						<navigation:adminmenu id="ucAdminMenu" runat="server"></navigation:adminmenu>
					</td>
					<!-- Body/Content -->
					<td  class="DataContainer">
						<navigation:helplink id="ucHelp" runat="Server" desc="" key="10.2.7"></navigation:helplink>
						<Localized:LocalizedLabel id="lblPageTitle" CssClass="pageTitle" Runat="server">Email Users</Localized:LocalizedLabel><br>
						<asp:label id="lblError" runat="server"></asp:label>
						<table width="98%" align="left" border="0">
							<!----------------------- First Section ------------------->
							<TBODY>
								<asp:PlaceHolder ID="plhEditEmail" Runat="server">
									<TR>
										<TD class="formLabel" vAlign="top" width="20%">
											<Localized:LocalizedLabel id="lblUnits" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<cc1:treeview id="trvUnitsSelector" runat="server" NodeText="Unit" OutputStyle="MultipleSelection"
												SystemImagesPath="/General/Images/TreeView/"></cc1:treeview></TD>
									</TR>
									<TR>
										<TD colSpan="2">&nbsp;
										</TD>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top" width="20%">
											<Localized:LocalizedLabel id="lblCC" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:TextBox id="txtCC" Runat="server" Width="100%"></asp:TextBox>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top" width="20%">
											<Localized:LocalizedLabel id="lblSubject" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:TextBox id="txtEmailSubject" Runat="server" Width="100%"></asp:TextBox>
									</TR>
									<TR>
										<TD class="formLabel" vAlign="top" width="20%">
											<Localized:LocalizedLabel id="lblEmailBody" runat="server"></Localized:LocalizedLabel></TD>
										<TD>
											<asp:TextBox id="txtEmailBody" Runat="server" Width="100%" Rows="15" TextMode="MultiLine"></asp:TextBox></TD>
									</TR>
									<TR>
										<TD>&nbsp;</TD>
										<TD>
											<Localized:LocalizedLabel id="lblWarning" runat="server"></Localized:LocalizedLabel><BR><BR>
											<Localized:LocalizedButton id="btnBack" Runat="server" CssClass="backButton" Text="Back" onclick="btnBack_Click"></Localized:LocalizedButton>&nbsp;
											<Localized:LocalizedButton id="btnSendEmail" Runat="server" CssClass="sendButton" Text="Send Email" onclick="btnSendEmail_Click"></Localized:LocalizedButton>
									</TR>
								</asp:PlaceHolder>
								<!----------------- End Second Section -------------------->
								<!----------------- Second Section -------------------->
								<asp:PlaceHolder id="plhComplete" Runat="server" Visible="False">
									<TR>
										<TD>
											<Localized:LocalizedLabel id="lblEmailSent" runat="server"></Localized:LocalizedLabel><BR><BR>
											<Localized:LocalizedButton id="btnHome" Runat="server" CssClass="backButton" style="width: 200px;" Text="Return" onclick="btnBack_Click"></Localized:LocalizedButton></TD>
									</TR>
								</asp:PlaceHolder>
								<!----------------- End Second Section -------------------->
							</TBODY>
						</table>
					</td>
					<!--End Body/Content--></tr>
				<!-- Footer -->
				<tr vAlign="bottom" align="center">
					<td vAlign="middle" align="center" colSpan="2">
						<navigation:footer id="ucFooter" runat="server"></navigation:footer>
					</td>
				</tr>
			</table>
		</form>
		</TD></TR></TBODY></TABLE>
	</body>
</HTML>
