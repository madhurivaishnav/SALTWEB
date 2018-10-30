<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Control Language="c#" AutoEventWireup="True" Codebehind="ImportUsers.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.ImportUsers" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>

<STYLE>
.nowrap { WHITE-SPACE: nowrap }
</STYLE>
<table width="100%" align="left" border="0" id="tblMain">
	<TR>
		<TD align="left">
			<a href="#" onclick="window.open('../Organisation/ImportUsersSample.aspx','Sample','height=750,width=900,scrollbars=0')">
				<Localized:LocalizedLiteral id="litSampleCSVLink" runat="server"></Localized:LocalizedLiteral></a>
		</TD>
	</TR>
	
	<TR>
		<TD align=left>
			<TABLE width="100%" align=left border=0>
			<TR>
				<TD colSpan=2>
					<asp:label id=lblMessage runat="server"></asp:label>
				</TD>
			</TR>
			<tr>
			    <td colspan =2>
			        <localized:localizedlinkbutton id="btnPeriodicReport" runat="server" onclick="btnPeriodicReport_Click"></Localized:Localizedlinkbutton>
			    </td>    
			</tr>
			<TR>
				<TD class=formLabel width="20%"><asp:Label id=lblUnitNameLabel Runat="server"></asp:Label>
				</TD>
				<TD><asp:Label id=lblUnitName Runat="server"></asp:Label>
				</TD>
			</TR>

			<asp:PlaceHolder ID="plhSearchCriteria" Runat="server">
			<TR>
				<TD class=formLabel width="20%">
					<localized:localizedLabel id=lblUniqueField runat="server"></localized:localizedLabel>
				</TD>
				<TD>
					<asp:dropdownlist id=cboUniqueField Runat="server">
					<asp:listitem selected="true" value="" Text=""/>
					</asp:dropdownlist>
				</TD>
			</TR>
			<TR>
				<TD colSpan=2>&nbsp;</TD>
			</TR>
			<TR>
				<TD class=formLabel>
					<Localized:LocalizedLabel id=lblXmlFileUsers runat="server"></Localized:LocalizedLabel>&nbsp;
				</TD>
				<TD>
					<INPUT class=browseButton id=fileUserXML type=file name=fileUserXML runat="server">
				</TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
				<TD></TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
				<TD colSpan=2>
					<Localized:Localizedbutton id=btnUploadXML runat="server" width="175px" CssClass="uploadButton" text="Import Users From XML" onclick="btnUploadXML_Click"></Localized:Localizedbutton>
				</TD>
			</TR>
			<TR>
				<TD>
					<Localized:LocalizedLiteral id=litOR runat="server"></Localized:LocalizedLiteral>
				</TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
			</TR>
			<TR>
				<TD class=formLabel><Localized:LocalizedLabel id=lblCSVFileUsers runat="server"></Localized:LocalizedLabel>&nbsp;
				</TD>
				<TD><INPUT class=browseButton id=fileUserCSV type=file name=fileUserCSV runat="server">
				</TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
				<TD></TD>
			</TR>
			<TR>
				<TD>&nbsp;</TD>
				<TD colSpan=2>
					<Localized:Localizedbutton id=btnUploadCSV runat="server" width="175px" CssClass="uploadButton" text="Import Users From CSV" onclick="btnUploadCSV_Click"></Localized:Localizedbutton>
				</TD>
			</TR>
			</asp:PlaceHolder>
			</TABLE>
		</TD>
	</TR>
	
	
	<asp:PlaceHolder ID="plhResults" Runat="server" Visible="False">
	<TR>
		<TD>
			<TABLE width="100%" align=left border=0>
			<TR>
				<TD align=left></TD>
			</TR>
			<TR>
				<TD></TD>
			</TR>
			<TR>
				<TD align=left><!-- Pagination -->
					<TABLE id=tblPagination cellSpacing=0 cellPadding=0 width="95%" align=left border=0 runat="server">
					<TR>
						<TD align=left colSpan=2>
							<TABLE><!--preview outer table-->
							<TR>
								<TD><asp:Literal id=litPreviewData Runat="server"></asp:Literal></TD>
								<td></td>
							</TR>
							<TR>
								<TD><asp:Literal id=litUsersAdd Runat="server"></asp:Literal>&nbsp; <localized:LocalizedLinkButton id=btnShowAddedUsers Runat="server" onclick="btnShowAddedUsers_Click"></localized:LocalizedLinkButton>
								</TD>
								<TD>&nbsp;</TD>
							</TR>
							<TR>
								<TD><asp:Literal id=litUsersUpdate Runat="server"></asp:Literal>&nbsp; <localized:LocalizedLinkButton id=btnShowUpdatedUsers Runat="server" onclick="btnShowUpdatedUsers_Click"></localized:LocalizedLinkButton>
								</TD>
								<TD>&nbsp;</TD>
							</TR>
							<TR>
								<TD><asp:Literal id=litDetectedError Runat="server"></asp:Literal>&nbsp; <localized:LocalizedLinkButton id=btnShowDetectedError Runat="server" onclick="btnShowDetectedError_Click"></localized:LocalizedLinkButton>
								</TD>
								<TD>&nbsp; </TD>
							</TR>
							<TR>
								<TD colSpan=2><!-- preview Users table -->
								<asp:PlaceHolder ID="plhPreview" Runat="server">
									<TABLE class=previewUser cellSpacing=0 cellPadding=2 border=0>
									<TR class=headerRow>
										<TD>
											<localized:localizedlabel id="lblRowNumber" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblUsername" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblPassword" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblFirstname" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblLastname" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblEmail" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblExternalID" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblUnitID" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblArchive" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<localized:localizedlabel id="lblClassification" runat="server"></localized:localizedlabel>
										</TD>
										<TD>
											<asp:label   Text="Notify Unit Admin" runat="server"></asp:label>
										</TD>
										<TD>
											<asp:label Text="Notify Org Admin" runat="server"></asp:label>
										</TD>
										<TD>
											<asp:label Text="Notify Admins" runat="server"></asp:label>
										</TD>
										<TD>
											<asp:label Text="Manager to Notify" runat="server"></asp:label>
										</TD>
									</TR>
									<TR>
										<TD colSpan=9>
											<asp:Literal id=litTableSummary Runat="server"></asp:Literal>
										</TD>
									</TR>
									<asp:repeater id=repPreView Runat="server">
									<headerTemplate>
									</headerTemplate>									 
									<ItemTemplate>
									<tr id="trUserRecord" runat="server">
										<td id="tdRowNumber" runat="server">
											<%# DataBinder.Eval(Container.DataItem,"RowNumber") %>
										</td>
										<td id="tdUsername" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "Username") %> 
										</td>
										<td id="tdPassword" runat="server">
											<%# DataBinder.Eval(Container.DataItem, "Password") %>
										</td>
										<td id="tdFirstName" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "FirstName") %> 
										</td>
										<td id="tdLastName" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "LastName") %> 
										</td>
										<td id="tdEmail" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "Email") %> 
										</td>
										<td id="tdExternalID" runat="server">
											<%# DataBinder.Eval(Container.DataItem, "ExternalID") %>
										</td>
										<td id="tdUnitID" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "UnitID")%> 
										</td>
										<td id="tdArchive" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "Archive")%> 
										</td>
										<td id="tdClassification" runat="server">
											<%# DataBinder.Eval(Container.DataItem, "ClassificationOption")%>
										</td>
										<td id="tdNotifyUnitAdmin" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "NotifyUnitAdmin")%> 
										</td>
										<td id="tdNotifyOrgAdmin" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "NotifyOrgAdmin")%> 
										</td>
										<td id="tdManagerNotification" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "ManagerNotification")%> 
										</td>
										<td id="tdManagerToNotify" runat="server"> 
											<%# DataBinder.Eval(Container.DataItem, "ManagerToNotify")%> 
										</td>

									</tr>
									<asp:PlaceHolder ID="plhErrMsg" Runat="server" Visible="true">
									<tr>
										<td colspan="9" id="tdReason" runat="server">
											<%# DataBinder.Eval(Container.DataItem,"Reason") %>
										</td>
									</tr>
									</asp:PlaceHolder>	
									<asp:PlaceHolder ID="plhErrField" Runat="server" Visible="False">
									<tr>
										<td colspan="10">
											<%# DataBinder.Eval(Container.DataItem,"ErrField") %>
										</td>
									</tr>
									</asp:PlaceHolder> 													
									</ItemTemplate>
									<footerTemplate>
									</footerTemplate>
									</asp:repeater>
									<TR>
										<TD colSpan=9><localized:localizedbutton id="btnCommitImport" runat="server" onclick="btnCommitImport_Click"></localized:localizedbutton>&nbsp; 
										&nbsp; <localized:localizedbutton id="btnCancel" runat="server" onclick="btnCancel_Click"></localized:localizedbutton>
										</TD>
									</TR>
									</TABLE>
								</asp:PlaceHolder>
								</TD><!--end preview users table-->
                            </TR>
							</TABLE><!-- end preview outer table-->
						</TD>
					</TR>
					<TR id=trPagination runat="server">
						<TD align=left>
							<Localized:LocalizedLiteral id=litPage runat="server"></Localized:LocalizedLiteral>&nbsp; 
							<asp:dropdownlist id=cboPage runat="server" autopostback="True" onselectedindexchanged="cboPage_SelectedIndexChanged"></asp:dropdownlist>&nbsp; 
							<Localized:LocalizedLiteral id=Localizedliteral1 runat="server" key="litOf"></Localized:LocalizedLiteral>&nbsp; 
							<asp:label id=lblPageCount runat="server">3</asp:label>: <asp:label id=lblCurrentPageRecordCount runat="server">30 - 40</asp:label>&nbsp; 
							<Localized:LocalizedLiteral id=litOf runat="server"></Localized:LocalizedLiteral>&nbsp; <asp:label id=lblTotalRecordCount runat="server">81</asp:label>&nbsp; 
							<Localized:LocalizedLiteral id=litDisplayed runat="server"></Localized:LocalizedLiteral>
						</TD>
						<TD align=right>
							<Localized:Localizedlinkbutton id=btnPrev runat="server" causesvalidation="False" onclick="btnPrev_Click">&lt;&lt; Prev</Localized:Localizedlinkbutton>&nbsp;&nbsp; 
							<Localized:Localizedlinkbutton id=btnNext runat="server" causesvalidation="False" onclick="btnNext_Click">Next&gt;&gt;</Localized:Localizedlinkbutton>
						</TD>
					</TR>
				</TABLE>
				<!-- Pagination -->
			</TD>
		</TR>
        <TR>
          <TD>
			<A href='ImportUsers.aspx?UnitID=<%=Request.QueryString["UnitID"] %>'>
				<Localized:LocalizedLiteral id=lnkMoreUsers runat="server"></Localized:LocalizedLiteral>
			</A>
            
          </TD>
        </TR>
		</TABLE>
		</TD>
	</TR>
	</asp:PlaceHolder>
</table>
<script language="javascript">
    window.document.getElementById('tblMain').focus();
</script>
<script language="javascript">
		//This must be placed on each page where you want to use the client-side resource manager
		var ResourceManager = new RM();
		function RM()
		{
		this.list = new Array();
		};
		RM.prototype.AddString = function(key, value)
		{
		this.list[key] = value;
		};
		RM.prototype.GetString = function(key)
		{
		var result = this.list[key];  
		for (var i = 1; i < arguments.length; ++i)
		{
			result = result.replace("{" + (i-1) + "}", arguments[i]);
		}
		return result;
		};
	</script>
    <script language="javascript">
	function ConfirmCommitImport() {
			return confirm(ResourceManager.GetString("ConfirmMessage"));
		}

    </script>
