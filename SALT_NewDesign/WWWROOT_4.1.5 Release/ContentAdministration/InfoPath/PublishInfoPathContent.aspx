<%@ Page Language="c#" CodeBehind="PublishInfoPathContent.aspx.cs" AutoEventWireup="True"
    Inherits="Bdw.Application.Salt.Web.ContentAdministration.InfoPath.PublishInfoPathContent" %>

<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx" %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="adminMenu" Src="/General/UserControls/Navigation/AdminMenu.ascx" %>
<%@ Register TagPrefix="cc1" Namespace="Uws.Framework.WebControl" Assembly="Uws.Framework.WebControl" %>
<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!doctype html public "-//w3c//dtd html 4.0 transitional//en" >
<html>
<head>
    <title id="pagTitle" runat="server"></title>
    <Style:style id="ucStyle" runat="server">
    </Style:style>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR"/>
    <meta content="C#" name="CODE_LANGUAGE"/>
    <meta content="JavaScript" name="vs_defaultClientScript"/>
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />


</head>
<body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
    <form id="frmCourse" method="post" runat="server">
    <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center"
        border="0">
        <!-- Header -->
        <tr valign="top" align="center" width="100%">
            <td valign="top" align="center" width="100%" colspan="2">
                <navigation:header id="ucHeader" runat="server">
                </navigation:header>
            </td>
        </tr>
        <tr valign="top" align="left" height="100%">
            <!-- Left Navigation -->
            <td class="AdminMenuContainer">
                <navigation:adminmenu id="ucAdminMenu" runat="server">
                </navigation:adminmenu>
            </td>
            <!-- Body/Content -->
            <td class="DataContainer">
                <Localized:LocalizedLabel ID="lblPageTitle" runat="server" CssClass="pageTitle">Publish Content</Localized:LocalizedLabel><br />
                <table width="80%" border="0">
                    <asp:Panel ID="pUpload" runat="server">
                        <tbody>
                            <tr>
                                <td class="formLabel">
                                    <Localized:LocalizedLabel ID="lblTypeNewContent" runat="server"></Localized:LocalizedLabel>&nbsp;
                                </td>
                                <td>
                                    <Localized:LocalizedRadioButton ID="radLesson" runat="server" Text="Lesson" GroupName="radType"
                                        Checked="True"></Localized:LocalizedRadioButton>
                                    <Localized:LocalizedRadioButton ID="radQuiz" runat="server" Text="Quiz" GroupName="radType">
                                    </Localized:LocalizedRadioButton>
                                </td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                                    <Localized:LocalizedLabel ID="lblSelectInfoPath" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td>
                                    <input class="browseButton" id="inputFile" type="file" name="inputFile" runat="server">
                                    <Localized:LocalizedRequiredFieldValidator ID="rfvFile" runat="server" ErrorMessage="<br/>Select a file to upload"
                                        ControlToValidate="inputFile"></Localized:LocalizedRequiredFieldValidator>
                                </td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                                    <Localized:LocalizedLabel ID="lblFactSheet" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td>
                                    <input class="browseButton" id="inputQfs" type="file" name="inputFile" runat="server">
                                </td>
                            </tr>
                            <tr>
                                <td class="formLabel">
                                    <Localized:LocalizedLabel ID="lblUpload" runat="server"></Localized:LocalizedLabel>
                                </td>
                                <td>
                                    <Localized:LocalizedButton ID="btnUpload" runat="server" Text="Upload" OnClick="btnUpload_Click">
                                    </Localized:LocalizedButton><br>
                                    <asp:Label ID="lblUploadMessage" runat="server"></asp:Label>
                                </td>
                            </tr>
                            <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>
                    <asp:Panel ID="pLayout" runat="server" Visible="False">
                        <tr>
                            <td class="formLabel">
                                <Localized:LocalizedLabel ID="lblContentStyle" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td>
                                <asp:ListBox ID="lstStyle" runat="server" Width="200" Rows="1"></asp:ListBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="formLabel" style="height: 1px">
                                <Localized:LocalizedLabel ID="lblDefaultLayout" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td style="height: 1px">
                                <asp:ListBox ID="lstDefaultLayout" runat="server" Width="200" Rows="1"></asp:ListBox>
                            </td>
                        </tr>
                        <tr>
                            <td class="formLabel">
                                <Localized:LocalizedLabel ID="lblPageLevelLayout" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td>
                                <br>
                                <asp:DataGrid ID="dgrPages" runat="server" Width="100%" AutoGenerateColumns="False"
                                    AllowPaging="False" AllowSorting="True">
                                    <AlternatingItemStyle CssClass="tablerow1"></AlternatingItemStyle>
                                    <ItemStyle CssClass="tablerow2"></ItemStyle>
                                    <HeaderStyle CssClass="tablerowtop"></HeaderStyle>
                                    <Columns>
                                        <asp:TemplateColumn HeaderText="Page Level Override">
                                            <ItemTemplate>
                                                <asp:ListBox runat="server" ID="lstPageLayout" Rows="1"></asp:ListBox>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn Visible="False">
                                            <ItemTemplate>
                                                <asp:Literal ID="litPageID" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "ID")%>'>
                                                </asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Page Title">
                                            <ItemTemplate>
                                                <%# DataBinder.Eval(Container.DataItem, "Title")%>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:TemplateColumn HeaderText="Page Type">
                                            <ItemTemplate>
                                                <asp:Literal ID="litPageType" runat="server" Text='<%# DataBinder.Eval(Container.DataItem, "PageType")%>'>
                                                </asp:Literal>
                                            </ItemTemplate>
                                        </asp:TemplateColumn>
                                    </Columns>
                                </asp:DataGrid>
                                <Localized:LocalizedLabel ID="lblNote" runat="server"></Localized:LocalizedLabel>
                            </td>
                        </tr>
                        <tr>
                            <td class="formLabel">
                                <Localized:LocalizedLabel ID="lblPreview" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td>
                                <Localized:LocalizedButton ID="btnPreviewContent" runat="server" CssClass="generateButton"
                                    Text="Build Preview" OnClick="btnPreviewContent_Click"></Localized:LocalizedButton>&nbsp;&nbsp;&nbsp;
                                <asp:Label ID="lblPreviewMessage" runat="server"></asp:Label>&nbsp;&nbsp;&nbsp;
                                <Localized:LocalizedHyperLink ID="lnkPreview" runat="server" Visible="False" Target="_blank">Preview Content</Localized:LocalizedHyperLink>
                            </td>
                        </tr>
                        <tr>
                            <td class="formLabel">
                                <br>
                                <Localized:LocalizedLabel ID="lblPublish" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td>
                                <Localized:LocalizedButton ID="btnPublishContent" runat="server" CssClass="generateButton"
                                    Text="Publish Content" OnClick="btnPublishContent_Click"></Localized:LocalizedButton>
                            </td>
                        </tr>
                    </asp:Panel>
                    <asp:Panel ID="pGenerated" runat="server" Visible="False">
                        <tr>
                            <td class="formLabel">
                                <asp:Label ID="LabelCourse" runat="server"></asp:Label>                                
                                <Localized:LocalizedLabel ID="lblPublishedTo" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td>
                                <asp:Label ID="lblGeneratePath" runat="server"></asp:Label>
                            </td>
                        </tr>
                    </asp:Panel>
                     <asp:Panel ID="pScorm" runat="server" Visible="False">
                        <tr>
                            <td class="formLabel">                            
                                <Localized:LocalizedLabel ID="lblWhichSCO" runat="server"></Localized:LocalizedLabel>
                            </td>
                            <td>
                                <asp:listbox id="lstSCOs" runat="server" datatextfield="title" datavaluefield="launchpoint" selectionmode="Single"   autopostback = "True"  OnSelectedIndexChanged="loadLink"></asp:listbox>
                            </td>
                        </tr>
                        <tr>
                                <asp:button ID="btnGenerate" runat="server" CssClass="generateButton"
                                    Text="Publish Content" OnClick="btnPublishSCOs_Click"></asp:button>
                                <Localized:LocalizedHyperLink ID="lnkScormPreview" runat="server" Visible="False" Target="_blank">Preview Content</Localized:LocalizedHyperLink>
                                                                
                        </tr> 
                        <tr> 
                            <br \>                            
                            <asp:Label ID="lblScormPublishError" runat="server"></asp:Label>  
                        </tr>                       
                    </asp:Panel>
                     <asp:Panel ID="pQFS" runat="server" Visible="False">
                        <tr>
                            <td>
                                <asp:listbox id="lbxQFS" runat="server" datatextfield="title" datavaluefield="QFS" selectionmode="Single" ></asp:listbox>
                                <asp:listbox id="lbxQuiz" runat="server" datatextfield="title" datavaluefield="Quiz" selectionmode="Single" ></asp:listbox>
                            </td>
                        </tr>
                    </asp:Panel>
               </table>
            </td>
        </tr>
        <!-- Footer -->
        <tr valign="bottom" align="center">
            <td valign="middle" align="center" colspan="2">
                <navigation:footer id="ucFooter" runat="server">
                </navigation:footer>
            </td>
        </tr>
        </TBODY></table>
    </form>
</body>
</html>
