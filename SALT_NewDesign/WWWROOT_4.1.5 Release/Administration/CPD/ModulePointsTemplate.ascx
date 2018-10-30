<%@ Control Language="C#" %>
<asp:TextBox ID="txtModulePoints" Runat="server" Text='<%# DataBinder.Eval(((System.Web.UI.WebControls.DataGridItem)Container).DataItem, "Points") %>' Width="50"></asp:TextBox>
