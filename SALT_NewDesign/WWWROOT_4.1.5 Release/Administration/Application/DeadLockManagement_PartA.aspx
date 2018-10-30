<%@ Page language="c#" Codebehind="DeadLockManagement_PartA.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.DeadLockManagement_PartA" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>DeadLockManagement_PartA</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<P>
				<asp:Button ID="btnStartPartA" Text="Start Part A - NonQuery" Runat="server" onclick="btnStartPartA_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnScalar" Runat="server" Text="Start Part A - Scalar" onclick="btnScalar_Click"></asp:Button>&nbsp;</P>
			<P>
				<asp:Button id="btnReader" Runat="server" Text="Start Part A - Reader" onclick="btnReader_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnXmlReader" Runat="server" Text="Start Part A - XmlReader" onclick="btnXmlReader_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnDataSet" Runat="server" Text="Start Part A - DataSet" onclick="btnDataSet_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnDataTable" Runat="server" Text="Start Part A - DataTable" onclick="btnDataTable_Click"></asp:Button></P>
			<P>
				<asp:Label id="lblResult" runat="server" Width="224px" Height="120px">Label</asp:Label></P>
		</form>
	</body>
</HTML>
