<%@ Page language="c#" Codebehind="DeadLockManagement_PartB.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Administration.Application.DeadLockManagement_PartB" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title>DeadLockManagement_PartB</title>
		<meta name="GENERATOR" Content="Microsoft Visual Studio .NET 7.1">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
	</HEAD>
	<body MS_POSITIONING="FlowLayout">
		<form id="Form1" method="post" runat="server">
			<P>
				<asp:Button ID="btnStartPartB" Text="Start Part B" Runat="server" onclick="btnStartPartB_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnScalar" Runat="server" Text="Start Part B - Scalar" onclick="btnScalar_Click"></asp:Button>&nbsp;</P>
			<P>
				<asp:Button id="btnReader" Runat="server" Text="Start Part B - Reader" onclick="btnReader_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnXmlReader" Runat="server" Text="Start Part B - XmlReader" onclick="btnXmlReader_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnDataSet" Runat="server" Text="Start Part B - DataSet" onclick="btnDataSet_Click"></asp:Button></P>
			<P>
				<asp:Button id="btnDataTable" Runat="server" Text="Start Part B - DataTable" onclick="btnDataTable_Click"></asp:Button></P>
			<P>
				<asp:Label id="lblResult" runat="server" Height="120px" Width="224px">Label</asp:Label></P>
		</form>
	</body>
</HTML>
