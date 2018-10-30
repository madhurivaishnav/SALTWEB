<%@ Control Language="c#" AutoEventWireup="True" Codebehind="ReportCriteria.ascx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.ReportCriteria" TargetSchema="http://schemas.microsoft.com/intellisense/ie5"%>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<script language="javascript">
<!--
function Expand ()
{
    divCriteriaVisible.style.display="block";
    divCriteriaHidden.style.display="none";
}
function Collapse ()
{
    divCriteriaVisible.style.display="none";
    divCriteriaHidden.style.display="block";
}
-->
</script>
<div id="divCriteriaVisible" style="display:none;">
<asp:table id="tblCriteriaExpanded" runat="server" width="100%" borderwidth="0" gridlines="Horizontal" cellspacing="0">
        <asp:tablerow cssclass="tablerowtop">
            <asp:tablecell width="100%" columnspan="2">
                <img align="absmiddle" Src="/General/Images/Navigation/down.gif" alt="Collapse Criteria" onclick="Collapse();" border="0">
                &nbsp;&nbsp;<Localized:LocalizedLiteral id="litClick" runat="server"></Localized:LocalizedLiteral>
            </asp:tablecell>

        </asp:tablerow>
</asp:table>
</div>
<div id="divCriteriaHidden">
<asp:table id="tblCriteriaCompressed" runat="server" width="100%" borderwidth="0" gridlines="Horizontal" cellspacing="0">
        <asp:tablerow cssclass="tablerowtop">
            <asp:tablecell width="100%" verticalalign="Top" columnspan="2">
                <img  align="absmiddle" Src="/General/Images/Navigation/right.gif" alt="Collapse Criteria" border="0" onclick="Expand();">
                &nbsp;&nbsp;<Localized:LocalizedLiteral id="litExpand" runat="server"></Localized:LocalizedLiteral>
            </asp:tablecell>
        </asp:tablerow>
</asp:table>
</div>