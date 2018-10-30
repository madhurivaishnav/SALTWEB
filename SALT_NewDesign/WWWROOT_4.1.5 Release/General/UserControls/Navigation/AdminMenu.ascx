<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<%@ Control Language="c#" AutoEventWireup="True" Codebehind="AdminMenu.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.Navigation.AdminMenu" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<%@ Register TagPrefix="uc1" TagName="SelectOrganisation" Src="SelectOrganisation.ascx" %>
<div id="NoPrint" name="NoPrint">
	<table runat="server" id="tblMenu" cellspacing="0" cellpadding="0" align="left" border="0"
		class="AdminMenu" width="295px">
		<tr>
			<td>
				<uc1:selectorganisation id="SelectOrganisation1" runat="server"></uc1:selectorganisation>
			</td>
		</tr>		
		<%--<tr runat="server" id="trUser">
			<td align="left"><br>
				<b>
				<Localized:LocalizedLabel id="lblAdminMenuUser" runat="server">User</Localized:LocalizedLabel></b><br>
				<div id="divApplicationAdministrators" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkApplicationAdministrators" causesvalidation="False" onclick="lnkApplicationAdministrators_Click">Application Administrators</Localized:Localizedlinkbutton><br></div>
				<div id="divUserSearch" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkUserSearch" causesvalidation="False" onclick="lnkUserSearch_Click">User Search</Localized:Localizedlinkbutton><br></div>
				<div id="divAddUser" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkAddUser" causesvalidation="False" onclick="lnkAddUser_Click">Add User</Localized:Localizedlinkbutton><br></div>
				<div id="divPersonDetails" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkPersonDetails" causesvalidation="False" onclick="lnkPersonDetails_Click">Personal Details</Localized:Localizedlinkbutton><br></div>
				<div id="divArchiveUsers" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkArchiveUsers" causesvalidation="False" onclick="lnkArchiveUsers_Click">Archive User</Localized:Localizedlinkbutton><br></div>
				<div id="divEmailUsers" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkEmailUsers" causesvalidation="False" onclick="lnkEmailUsers_Click">Email Users</Localized:Localizedlinkbutton><br></div>
			</td>
		</tr>
		<tr id="trUnit" runat="server">
			<td align="left"><br>
				<b>
				<Localized:LocalizedLabel id="lblAdminMenuUnit" runat="server">Unit</Localized:LocalizedLabel></b><br>
				<div id="divUnitSearch" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkUnitSearch" causesvalidation="False" onclick="lnkUnitSearch_Click">Unit Search</Localized:Localizedlinkbutton><br></div>
				<div id="divAddUnit" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkAddUnit" causesvalidation="False" onclick="lnkAddUnit_Click">Add Unit</Localized:Localizedlinkbutton><br></div>
				<div id="divUnitManagement" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkUnitMangement" causesvalidation="False" onclick="lnkUnitMangement_Click">Move Unit</Localized:Localizedlinkbutton><br></div>
			</td>
		</tr>
		<tr id="trOrganisation" runat="server">
			<td align="left"><br>
				<b>
				<Localized:LocalizedLabel id="lblAdminMenuOrganisation" runat="server">Organisation</Localized:LocalizedLabel></b><br>
				<div id="divAddOrganisation" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkAddOrganisation" runat="server" causesvalidation="False" onclick="lnkAddOrganisation_Click">Add Organisation</Localized:Localizedlinkbutton><br></div>
				<div id="divOrganisationDetails" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrganisationDetails" runat="server" causesvalidation="False" onclick="lnkOrganisationDetails_Click">Organisation Details</Localized:Localizedlinkbutton><br></div>
				<div id="divOrganisationConfiguration" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrganisationConfiguration" runat="server" causesvalidation="False" onclick="lnkOrganisationConfiguration_Click">Organisation Configuration</Localized:Localizedlinkbutton><br></div>
				<div id="divOrgAdministrators" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrgAdministrators" runat="server" causesvalidation="False" onclick="lnkOrgAdministrators_Click">Organisation Administrators</Localized:Localizedlinkbutton><br></div>
				<div id="divOrgMailSetup" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrgMailSetup" runat="server" causesvalidation="False" onclick="lnkOrgMailSetup_Click">Organisation Mail Setup</Localized:Localizedlinkbutton><br></div>
				<div id="divModifyLinks" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkModifyLinks" runat="server" causesvalidation="False" onclick="lnkModifyLinks_Click">Modify Links</Localized:Localizedlinkbutton><br></div>
				<div id="divOrgImportUsers" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrgImportUsers" runat="server" causesvalidation="False" onclick="lnkOrgImportUsers_Click">Import Users</Localized:Localizedlinkbutton><br></div>
				<div id="divBulkAssignUsers" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkBulkAssignUsers" runat="server" causesvalidation="False" onclick="lnkBulkAssignUsers_Click">Assign Users to Unit</Localized:Localizedlinkbutton><br></div>
				<div id="divMoveUsersToUnit" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" runat="server" id="lnkMoveUsersToUnit" causesvalidation="False" onclick="lnkMoveUsersToUnit_Click">Move Users To Unit</Localized:Localizedlinkbutton><br></div>
				<div id="divCourseAccess" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkCourseAccess" runat="server" causesvalidation="False" onclick="lnkCourseAccess_Click">Course Access</Localized:Localizedlinkbutton><br></div>
				<div id="divLicensing" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkLicensing" runat="server" causesvalidation="False" onclick="lnkLicensing_Click"></Localized:Localizedlinkbutton><br></div>
				<div id="divCPDProfile" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkCPDProfile" runat="server" causesvalidation="False" onclick="lnkCPDProfile_Click"></Localized:Localizedlinkbutton><br></div>
            
				<div id="divCPDEvent" runat="server"><Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkCPDEvent" runat="server" CausesValidation="False" OnClick="lnkCPDEvent_Click"></Localized:LocalizedLinkButton><br></div>
				
				<div id="divPolicyBuilder" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkPolicyBuilder" runat="server" causesvalidation="False" onclick="lnkPolicyBuilder_Click"></Localized:Localizedlinkbutton><br></div>
			    <div id="divOrganisationWelcomeScreen" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrganisationWelcomeScreen" runat="server" causesvalidation="False" onclick="lnkOrganisationWelcomeScreen_Click">Welcome Screen</Localized:Localizedlinkbutton><br></div>
			</td>
		</tr>
		<tr id="trContent" runat="server">
			<td align="left"><br>
				<b>
				<Localized:LocalizedLabel id="lblAdminMenuCourseContent" runat="server">Course Content</Localized:LocalizedLabel></b><br>
				<div id="divPublishContent" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkPublishContent" runat="server" causesvalidation="False" onclick="lnkPublishContent_Click">Publish Content</Localized:Localizedlinkbutton><br></div>
				<div id="divAddCourse" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkAddCourse" runat="server" causesvalidation="False" onclick="lnkAddCourse_Click">Add Course</Localized:Localizedlinkbutton><br></div>
				<div id="divEditCourse" runat="server"></div><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkEditCourse" runat="server" causesvalidation="False" onclick="lnkEditCourse_Click">Course Details</Localized:Localizedlinkbutton><br></div>
			</td>
		</tr>
		<tr id="trApplication" runat="server">
			<td align="left"><br>
				<b>
				<Localized:LocalizedLabel id="lblAdminMenuConfiguration" runat="server">Configuration</Localized:LocalizedLabel></b><br>
				<div id="divOrgApplicationAccess" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkOrgApplicationAccess" runat="server" causesvalidation="False" onclick="lnkOrgApplicationAccess_Click">Organisation Application Access</Localized:Localizedlinkbutton><br></div>
				<div id="divAppAuditing" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkAppAuditing" runat="server" causesvalidation="False" onclick="lnkAppAuditing_Click">Application Auditing</Localized:Localizedlinkbutton><br></div>
				<div id="divAppDependencies" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkAppDependencies" runat="server" causesvalidation="False" onclick="lnkAppDependencies_Click">Dependent Components</Localized:Localizedlinkbutton><br></div>
				<div id="divAppConfig" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkAppConfig" runat="server" causesvalidation="False" onclick="lnkAppConfig_Click">Configuration Values</Localized:Localizedlinkbutton><br></div>
				<div id="divDomainName" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkDomainName" runat="server" causesvalidation="False" onclick="lnkDomainName_Click">Organisation Domain Name</Localized:Localizedlinkbutton><br></div>
				<div id="divApplicationEmailDefault" runat="server"><Localized:LocalizedLinkButton cssclass="AdminMenu" id="lnkAppEmailDefault" runat="server" causesvalidation="False" onclick="lnkAppEmailDefault_Click">Application Email Default</Localized:Localizedlinkbutton><br></div>
				<div id="divLanguageTranslation" runat="server"><Localized:Localizedlinkbutton id="lnkLanguageTranslation" class="AdminMenu" runat="server" onclick="lnkLanguageTranslation_Click">Language Translation</Localized:Localizedlinkbutton><br></div>
				<div id="divViewErrorLog" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkViewErrorLog" runat="server" causesvalidation="False" onclick="lnkViewErrorLog_Click">View Error Log</Localized:Localizedlinkbutton></div>
				<div id="divMailThroughput" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkMailThroughput" runat="server" causesvalidation="False" onclick="lnkMailThroughput_Click">Mail Throughput</Localized:Localizedlinkbutton></div>
				<div id="divTimeZone" runat="server"><Localized:Localizedlinkbutton cssclass="AdminMenu" id="lnkTimeZone" runat="server" causesvalidation="False" onclick="lnkTimeZone_Click"></Localized:Localizedlinkbutton><br></div>				
			</td>
		</tr>
--%>

 <tr >
            <td>
                <div id='cssmenu'>
                    <ul>
                        <li id="trUser" runat="server" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="lblAdminMenuUser" runat="server">User</Localized:LocalizedLabel></a>
                            <ul id="uiUser" runat="server">
                                <li id="divApplicationAdministrators" runat="server" >
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkApplicationAdministrators"
                                        CausesValidation="False" OnClick="lnkApplicationAdministrators_Click" >Application Administrators</Localized:LocalizedLinkButton></li>
                                <li id="divUserSearch" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkUserSearch"
                                        CausesValidation="False" OnClick="lnkUserSearch_Click">User Search</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divAddUser" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkAddUser"
                                        CausesValidation="False" OnClick="lnkAddUser_Click">Add User</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divPersonDetails" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkPersonDetails"
                                        CausesValidation="False" OnClick="lnkPersonDetails_Click">Personal Details</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divArchiveUsers" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkArchiveUsers"
                                        CausesValidation="False" OnClick="lnkArchiveUsers_Click">Archive User</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divEmailUsers" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkEmailUsers"
                                        CausesValidation="False" OnClick="lnkEmailUsers_Click">Email Users</Localized:LocalizedLinkButton>
                                </li>
                            </ul>
                        </li>
                        <li class='has-sub' id="trUnit" runat="server"><a href='#'>
                            <Localized:LocalizedLabel ID="lblAdminMenuUnit" runat="server">Unit</Localized:LocalizedLabel></a>
                            <ul id="uiUnit" runat="server">
                                <li id="divUnitSearch" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkUnitSearch"
                                        CausesValidation="False" OnClick="lnkUnitSearch_Click">Unit Search</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divAddUnit" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkAddUnit"
                                        CausesValidation="False" OnClick="lnkAddUnit_Click">Add Unit</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divUnitManagement" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkUnitMangement"
                                        CausesValidation="False" OnClick="lnkUnitMangement_Click">Move Unit</Localized:LocalizedLinkButton>
                                </li>
                            </ul>
                        </li>
     
                        <li id="trOrganisation" runat="server" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="lblAdminMenuOrganisation" runat="server">Organisation</Localized:LocalizedLabel></a>
                            <ul id="uiOrganisation" runat="server">
                                <li id="divAddOrganisation" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkAddOrganisation" runat="server"
                                        CausesValidation="False" OnClick="lnkAddOrganisation_Click">Add Organisation</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divOrganisationDetails" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrganisationDetails" runat="server"
                                        CausesValidation="False" OnClick="lnkOrganisationDetails_Click">Organisation Details</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divOrganisationConfiguration" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrganisationConfiguration"
                                        runat="server" CausesValidation="False" OnClick="lnkOrganisationConfiguration_Click">Organisation Configuration</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divOrgAdministrators" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrgAdministrators" runat="server"
                                        CausesValidation="False" OnClick="lnkOrgAdministrators_Click">Organisation Administrators</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divOrgMailSetup" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrgMailSetup" runat="server"
                                        CausesValidation="False" OnClick="lnkOrgMailSetup_Click">Organisation Mail Setup</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divModifyLinks" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkModifyLinks" runat="server"
                                        CausesValidation="False" OnClick="lnkModifyLinks_Click">Modify Links</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divOrgImportUsers" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrgImportUsers" runat="server"
                                        CausesValidation="False" OnClick="lnkOrgImportUsers_Click">Import Users</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divBulkAssignUsers" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkBulkAssignUsers" runat="server"
                                        CausesValidation="False" OnClick="lnkBulkAssignUsers_Click">Assign Users to Unit</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divMoveUsersToUnit" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" runat="server" ID="lnkMoveUsersToUnit"
                                        CausesValidation="False" OnClick="lnkMoveUsersToUnit_Click">Move Users To Unit</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divCourseAccess" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkCourseAccess" runat="server"
                                        CausesValidation="False" OnClick="lnkCourseAccess_Click">Course Access</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divLicensing" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkLicensing" runat="server"
                                        CausesValidation="False" OnClick="lnkLicensing_Click"></Localized:LocalizedLinkButton>
                                </li>
                                <li id="divCPDProfile" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkCPDProfile" runat="server"
                                        CausesValidation="False" OnClick="lnkCPDProfile_Click"></Localized:LocalizedLinkButton>
                                </li>
                                  <li id="divCPDEvent" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkCPDEvent" runat="server" CausesValidation="False" OnClick="lnkCPDEvent_Click"></Localized:LocalizedLinkButton>
                                </li>
                                <li id="divPolicyBuilder" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkPolicyBuilder" runat="server"
                                        CausesValidation="False" OnClick="lnkPolicyBuilder_Click"></Localized:LocalizedLinkButton>
                                </li>
                                <li id="divOrganisationWelcomeScreen" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrganisationWelcomeScreen"
                                        runat="server" CausesValidation="False" OnClick="lnkOrganisationWelcomeScreen_Click">Welcome Screen</Localized:LocalizedLinkButton>
                                </li>
                            </ul>
                        </li>
                  
                        <li id="trContent" runat="server" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="lblAdminMenuCourseContent" runat="server">Course Content</Localized:LocalizedLabel></a>
                            <ul id="uiContent" runat="server">
                                <li id="divPublishContent" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkPublishContent" runat="server"
                                        CausesValidation="False" OnClick="lnkPublishContent_Click">Publish Content</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divAddCourse" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkAddCourse" runat="server"
                                        CausesValidation="False" OnClick="lnkAddCourse_Click">Add Course</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divEditCourse" runat="server">
                               
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkEditCourse" runat="server"
                                        CausesValidation="False" OnClick="lnkEditCourse_Click">Course Details</Localized:LocalizedLinkButton></li>
                            </ul>
                        </li>
                 
                        <li id="trApplication" runat="server" class='has-sub'><a href='#'>
                            <Localized:LocalizedLabel ID="lblAdminMenuConfiguration" runat="server">Configuration</Localized:LocalizedLabel></a>
                            <ul id="uiApplication" runat="server">
                                <li id="divOrgApplicationAccess" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkOrgApplicationAccess"
                                        runat="server" CausesValidation="False" OnClick="lnkOrgApplicationAccess_Click">Organisation Application Access</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divAppAuditing" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkAppAuditing" runat="server"
                                        CausesValidation="False" OnClick="lnkAppAuditing_Click">Application Auditing</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divAppDependencies" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkAppDependencies" runat="server"
                                        CausesValidation="False" OnClick="lnkAppDependencies_Click">Dependent Components</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divAppConfig" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkAppConfig" runat="server"
                                        CausesValidation="False" OnClick="lnkAppConfig_Click">Configuration Values</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divDomainName" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkDomainName" runat="server"
                                        CausesValidation="False" OnClick="lnkDomainName_Click">Organisation Domain Name</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divApplicationEmailDefault" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkAppEmailDefault" runat="server"
                                        CausesValidation="False" OnClick="lnkAppEmailDefault_Click">Application Email Default</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divLanguageTranslation" runat="server">
                                    <Localized:LocalizedLinkButton ID="lnkLanguageTranslation" class="AdminMenu" runat="server"
                                        OnClick="lnkLanguageTranslation_Click">Language Translation</Localized:LocalizedLinkButton>
                                </li>
                                <li id="divViewErrorLog" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkViewErrorLog" runat="server"
                                        CausesValidation="False" OnClick="lnkViewErrorLog_Click">View Error Log</Localized:LocalizedLinkButton></li>
                                <li id="divMailThroughput" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkMailThroughput" runat="server"
                                        CausesValidation="False" OnClick="lnkMailThroughput_Click">Mail Throughput</Localized:LocalizedLinkButton></li>
                                <li id="divTimeZone" runat="server">
                                    <Localized:LocalizedLinkButton CssClass="AdminMenu" ID="lnkTimeZone" runat="server"
                                        CausesValidation="False" OnClick="lnkTimeZone_Click"></Localized:LocalizedLinkButton>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </td>
        </tr>

	</table>
</div>
