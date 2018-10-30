<%@ Page language="c#" Codebehind="ViewPolicy.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.ViewPolicy" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
    <title runat="server" id="pagTitle">ViewPolicy</title>
    <meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" Content="C#">
    <meta name=vs_defaultClientScript content="JavaScript">
    <meta name=vs_targetSchema content="http://schemas.microsoft.com/intellisense/ie5">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <link href="/General/Infopath/Styles/BDW/Presentation.css" rel="stylesheet" type="text/css">
	<link href="/General/Infopath/Styles/BDW/layout.css" rel="stylesheet" type="text/css">
	<link href="/General/Infopath/Styles/BDW/LegalPage.css" rel="stylesheet" type="text/css">

	<script src="/General/InfoPath/Include/Javascript.js"></script>
  </HEAD>
  <body MS_POSITIONING="FlowLayout">
	<script language="javascript" type="text/javascript">
		<!--
	    function __doPostBack(eventTarget, eventArgument) {
	        var theform;
	        if (window.navigator.appName.toLowerCase().indexOf("microsoft") > -1) {
	            theform = document.Form1;
	        }
	        else {
	            theform = document.forms["Form1"];
	        }
	        theform.__EVENTTARGET.value = eventTarget.split("$").join(":");
	        theform.__EVENTARGUMENT.value = eventArgument;
	        theform.submit();
	    }
		-->
	</script>	
    <form id="Form1" method="post" runat="server">
    <input type="hidden" name="__EVENTTARGET" value="" />
	<input type="hidden" name="__EVENTARGUMENT" value="" />
    <table class="Main_Table" id="Main_Table" align="center" cellpadding="0" cellspacing="0" border="0">
  <tr class="Main_Table_Top_Row">
    <td valign="top">
      <table class="PageHeader" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td class="PageHeaderTitleImage">
            &nbsp;
        </td>
          <td class="PageHeaderTitle" nowrap="true"><asp:Label ID="lblTitle" Runat="server"></asp:Label></td>
        </tr>
      </table>
      <table class="TopNavBar" cellpadding="0" cellspacing="0" border="0">
        <tr>
          <td width="20px" align="center" nowrap="true">
            &nbsp;
        </td>
          <td width="100%" align="center"> </td>
          <td class="ButtonExit">
            <div class="Navigation_Button_General">
              <a href="javascript:__doPostBack('Exit_Click','');"><localized:LocalizedLabel id="lblExit" runat="server" /></a>
            </div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
  <tr> 
	<td>
		<iframe id="pdfFrame" 
            width="100%" 
            height="100%" align="middle" frameborder=0 runat="server"  />
    </td>
  </tr>
  <tr height="5%">
	<td>
		<table>
			<tr>
				<td width="100%" align="right">
					<asp:Checkbox id="chkAgree" runat="server" />
				</td>  
				<td>
					<localized:localizedbutton id="btnFinish" runat="server" onclick="btnFinish_Click" />
				</td>
			</tr>
		</table> 
	</td> 
  </tr> 
  <tr>
    <td class="Main_Table_Navigation">
      <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td width="80%" align="right">
            <div class="Copyright">
		</div>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>
     </form>
	
  </body>
</HTML>
