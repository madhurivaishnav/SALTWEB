<%@ Page language="c#" Codebehind="RunModuleStatusUpdateJob.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.RunModuleStatusUpdateJob" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<HTML>
    <HEAD>
        <title>Run Module Status Update Job</title>
    </HEAD>
    <body bottomMargin="0" leftMargin="0" topMargin="0" rightMargin="0" ms_positioning="FlowLayout">
        <form id="frmApplicationAuditing" method="post" runat="server">
            <table width="95%" align="left" border="0">
                <tr>
                    <td>
						<b>REDUNDANT - Access to this page is blocked</b><br><br>
                        Opening this page launches the Nightly Module Status Update Job.<br>
                        This page has been supplied as an alternative to using the Sql Server agent 
                        where it is not available. In this case a cron or at job should be scheduled to 
                        touch this page.
                    </td>
                </tr>
            </table>
        </form>
    </body>
</HTML>
