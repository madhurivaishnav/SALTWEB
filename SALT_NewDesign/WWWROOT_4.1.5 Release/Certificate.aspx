<%--<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>--%>
<%@ Page language="c#" Codebehind="Certificate.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.Certificate" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<%--<Style:Style id="ucStyle" runat="server"></Style:Style>--%>
		<link type="text/css" rel="stylesheet" runat="server" id="lnkStyleSheet" />
		<script>
		    function printWindow() {
			bV = parseInt(navigator.appVersion)
		        if (bV >= 4) {
					window.print();
				}
		}
		</script>
	</HEAD>
	<body MS_POSITIONING="FlowLayout" onLoad="printWindow();">
		<form id="frmCertificate" method="post" runat="server">
			<div id="CertificateBody">
								<!-- Left Hand Image -->
			<div id="Certificate_LeftImage"><img src="General/Images/banner_for_certificate.jpg" width="198" height="842"></div>
			<!-- Certificate Right Content -->
			<div id="Certificate_RightContainer">

			<div id="Certificate_RightContent">
			<div id="Certificate_ApplicationName"><img src="General/Images/salt_enterprise_standard-black.jpg"></div>
			<div id="Certificate_RightText"><asp:Label id="lblCertificateComplete" cssclass="Certificate_Text_Line1" runat="server"></asp:Label></div>
									</div>
									
			<!-- Company Logo -->
									<asp:placeholder ID="pnlLogoImage" Runat ="server">
			<div id="Certificate_CompanyLogo">
											<asp:image ID="imgCompanyLogo" Runat="server" Height="63" CssClass="Certificate_LogoImage"></asp:image>
			</div>
									</asp:placeholder>
			</div>
			</div>
		</FORM>
	</body>
</HTML>
