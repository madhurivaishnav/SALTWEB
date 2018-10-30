<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Page language="c#" Codebehind="Certificate.aspx.cs" AutoEventWireup="false" Inherits="Bdw.Application.Salt.Web.Certificate" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<title id="pagTitle" runat="server"></title>
		<meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
		<meta content="C#" name="CODE_LANGUAGE">
		<meta content="JavaScript" name="vs_defaultClientScript">
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
		<Style:Style id="ucStyle" runat="server"></Style:Style>
		<script>
		function printWindow()
		{
			bV = parseInt(navigator.appVersion)
			if (bV >= 4) 
				{
					window.print();
				}
		}
		</script>
	</HEAD>
	<body MS_POSITIONING="FlowLayout" onload="printWindow();">
		<form id="frmCertificate" method="post" runat="server">
			<!-- Page Table -->
			<table width="100%" height="100%" cellSpacing="0" cellPadding="0" border="0">
				<tr>
					<td>
						&nbsp;&nbsp;
					</td>
					<td>
						<!-- Certificate sized to printed page -->
						<table class="CertificateBody">
							<tr>
								<!-- Left Hand Image -->
								<td class="Certificate_LeftImage">
									<IMG height="842" src="General/Images/Comply_banner_for_certificate.jpg" width="198">
								</td>
								<!-- printed area of certificate-->
								<td class="Certificate_RightText">
									<!-- Company Image <img Src="/General/Images/BDW-Standard-Blue.jpg" class="Certificate_CompanyImage"/>-->
									<div class="Certificate_CompanyImage">
										<IMG src="General/Images/CC_Logo.jpg">
									</div>
									<asp:label id="lblCertificateComplete" runat="server" cssclass="Certificate_Text_Line1"></asp:label>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		</FORM>
	</body>
</HTML>
