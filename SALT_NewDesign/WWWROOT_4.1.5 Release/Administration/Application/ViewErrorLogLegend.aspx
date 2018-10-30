<%@ Page language="c#" Codebehind="ViewErrorLogLegend.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.ViewErrorLogLegend" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<!doctype html public "//w3c//dtd html 4.0 transitional//en" >
<html>
    <head>
        <title>ImportUsersSample</title>
        <style:style id="ucStyle" runat="server"></style:style>
        <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
        <meta name="CODE_LANGUAGE" content="C#">
        <meta name="vs_defaultClientScript" content="JavaScript">
        <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    </head>
    <body ms_positioning="FlowLayout">
        <form id="Form1" method="post" runat="server">
            <table width="200px" border="1" cellpadding="0" cellspacing="0">
                <tr class="tablerowtop">
                    <td>Legend:</td>
                </tr>
                <tr class="ErrorRow_High">
                    <td>High Severity</td>
                </tr>
                <tr class="ErrorRow_Medium">
                    <td>Medium Severity</td>
                </tr>
                <tr class="ErrorRow_Low">
                    <td>Low Severity</td>
                </tr>
                <tr class="ErrorRow_Warning">
                    <td>Warning</td>
                </tr>
                <tr class="ErrorRow_InformationOnly">
                    <td>Information Only</td>
                </tr>
            </table>
        </form>
    </body>
</html>
