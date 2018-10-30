<%@ Register TagPrefix="Style" TagName="Style" Src="/General/UserControls/Style.ascx"  %>
<%@ Register TagPrefix="navigation" TagName="header" Src="/General/UserControls/Navigation/Header.ascx" %>
<%@ Register TagPrefix="navigation" TagName="footer" Src="/General/UserControls/Navigation/Footer.ascx"  %>
<%@ Page language="c#" Codebehind="Help.aspx.cs" AutoEventWireup="True" Inherits="Bdw.Application.Salt.Web.HelpTextIntro" EnableViewState="false" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
    <head>
        <title id="pagTitle" runat="server"></title>
        <%
/*
BDW 
<asp:label id="lblApplicationName" runat="server" cssclass="helpApplicationName"></asp:label>
<asp:label id="lblTradeMark" runat="server" cssclass="HelpTradeMarkInlineInheritColour"></asp:label> Online Help Guide Draft 1.0
Revision History

Date	Author	Version	Change Reference
15 April 2004	Aimie Killeen	1.0	Cut to Online Help
16 April 2004	Aimie Killeen	1.1	Remove Section 3
*/
%>
        <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
        <style:style id="ucStyle" runat="server"></style:style>
        <meta content="C#" name="CODE_LANGUAGE">
        <meta content="JavaScript" name="vs_defaultClientScript">
        <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    </head>
    <body bottommargin="0" leftmargin="0" topmargin="0" rightmargin="0" ms_positioning="FlowLayout">
        <form id="Form1" method="post" runat="server">
            <table height="100%" cellspacing="0" cellpadding="0" width="100%" align="center" border="0">
                <!-- Header -->
                <tr valign="top" align="center" width="100%">
                    <td><navigation:header id="ucHeader" runat="server"></navigation:header></td>
                </tr>
                <tr valign="top" align="left" height="100%">
                    <td>
                        <Localized:LocalizedLabel id="lblPageTitle" runat="server" cssclass="pageTitle"></Localized:LocalizedLabel>
                 
                        <table cellspacing="0" cellpadding="0" width="100%" align="left" border="0">
                            <tr>
                                <td valign="top" width="295" id="tdHelpIndex" class="tdHelpIndex">
                                    <ul class="help">
                                        <li>
                                            <a class="helpTitle helpApplicationName" href="#1">
				            <asp:Literal ID="lblIntroduction1" Runat="server"></asp:Literal></a>
                                        <li>
                                            <a class="helpTitle" href="#2"><Localized:LocalizedLiteral key="Help94" id="LocalizedLiteral21" runat="server"></Localized:LocalizedLiteral></a>
                                        <li>
                                            <a class="helpTitle" href="#3"><Localized:LocalizedLiteral key="Help2" id="LocalizedLiteral0" runat="server"></Localized:LocalizedLiteral></a>
                                        <li>
                                            <a class="helpTitle" href="#4"><Localized:LocalizedLiteral key="Help3" id="LocalizedLiteral1" runat="server"></Localized:LocalizedLiteral> </a>
                                            <ul class="help">
                                                <li>
                                                    <a class="helpTitle" href="#4.1"><Localized:LocalizedLiteral key="Help31" id="LocalizedLiteral2" runat="server"></Localized:LocalizedLiteral></a>
                                                <li>
                                                    <a class="helpTitle" href="#4.2"><Localized:LocalizedLiteral key="Help32" id="LocalizedLiteral3" runat="server"></Localized:LocalizedLiteral> </a>
                                                <li>
                                                    <a class="helpTitle" href="#4.3"><Localized:LocalizedLiteral key="Help33" id="LocalizedLiteral4" runat="server"></Localized:LocalizedLiteral> </a>
                                                <li>
                                                    <a class="helpTitle" href="#4.4"><Localized:LocalizedLiteral key="Help34" id="LocalizedLiteral5" runat="server"></Localized:LocalizedLiteral> </a>
                                                <li>
                                                    <a class="helpTitle" href="#4.5"><Localized:LocalizedLiteral key="Help35" id="LocalizedLiteral6" runat="server"></Localized:LocalizedLiteral> </a>
                                                <li>
                                                    <a class="helpTitle" href="#4.6"><Localized:LocalizedLiteral key="Help36" id="LocalizedLiteral7" runat="server"></Localized:LocalizedLiteral> </a>
                                                </li>
                                            </ul>
                                        <li>
                                            <a class="helpTitle" href="#5"><nobr><Localized:LocalizedLiteral key="Help4" id="LocalizedLiteral8" runat="server"></Localized:LocalizedLiteral></nobr></a>
                                        <li>
                                            <a class="helpTitle" href="#6"><Localized:LocalizedLiteral key="Help5" id="LocalizedLiteral9" runat="server"></Localized:LocalizedLiteral></a>
                                            <ul class="help">
                                                <li>
                                                    <a class="helpTitle" href="#6.1"><Localized:LocalizedLiteral key="Help51" id="LocalizedLiteral10" runat="server"></Localized:LocalizedLiteral></a>
                                                <li>
                                                    <a class="helpTitle" href="#6.2"><Localized:LocalizedLiteral key="Help52" id="LocalizedLiteral11" runat="server"></Localized:LocalizedLiteral></a>
                                                <li>
                                                    <a class="helpTitle" href="#6.3"><Localized:LocalizedLiteral key="Help53" id="LocalizedLiteral12" runat="server"></Localized:LocalizedLiteral></a>
                                                <li>
                                                    <a class="helpTitle" href="#6.4"><Localized:LocalizedLiteral key="Help54" id="LocalizedLiteral13" runat="server"></Localized:LocalizedLiteral></a>
                                                <li>
                                                    <a class="helpTitle" href="#6.5"><Localized:LocalizedLiteral key="Help95" id="LocalizedLiteral22" runat="server"></Localized:LocalizedLiteral></a>
                                                </li>
                                            </ul>
                                        <li>
                                            <a class="helpTitle" href="#7"><Localized:LocalizedLiteral key="Help96" id="LocalizedLiteral23" runat="server"></Localized:LocalizedLiteral></a>
                                        <li>
                                            <a class="helpTitle" href="#8"><Localized:LocalizedLiteral key="Help7" id="LocalizedLiteral15" runat="server"></Localized:LocalizedLiteral></a>
                                            <ul class="help">
                                                <li>
                                                    <a class="helpTitle" href="#8.1"><Localized:LocalizedLiteral key="Help97" id="LocalizedLiteral24" runat="server"></Localized:LocalizedLiteral></a>
                                                </li>
                                            </ul>
                                        <li>
                                            <a class="helpTitle" href="#9"><Localized:LocalizedLiteral key="Help8" id="LocalizedLiteral16" runat="server"></Localized:LocalizedLiteral></a>
                                        <li>
                                            <a class="helpTitle" href="#10"><Localized:LocalizedLiteral key="Help9" id="LocalizedLiteral17" runat="server"></Localized:LocalizedLiteral></a>
                                            <ul class="help">
                                                <li>
                                                    <a class="helpTitle" href="#10.1"><Localized:LocalizedLiteral key="Help91" id="LocalizedLiteral18" runat="server"></Localized:LocalizedLiteral></a>
                                                <li>
                                                    <a class="helpTitle" href="#10.2"><Localized:LocalizedLiteral key="Help92" id="LocalizedLiteral19" runat="server"></Localized:LocalizedLiteral></a>
                                                <!--<li>
                                                    <a class="helpTitle" href="#10.3"><Localized:LocalizedLiteral key="Help93" id="LocalizedLiteral20" runat="server"></Localized:LocalizedLiteral></a>-->
                                            </ul>
                                        <li>
                                            <a class="helpTitle" href="#11"><Localized:LocalizedLiteral key="Help10" id="LocalizedLiteral26" runat="server"></Localized:LocalizedLiteral></a>
                                            <ul class="help">
                                                <li>
                                                    <a class="helpTitle" href="#11.1"><Localized:LocalizedLiteral key="Help98" id="LocalizedLiteral25" runat="server"></Localized:LocalizedLiteral></a></li>
                                            </ul>
                                        <li>
                                            <a class="helpTitle" href="#12"><Localized:LocalizedLiteral key="Help11" id="LocalizedLiteral56" runat="server"></Localized:LocalizedLiteral></a>
                                            <ul class="help">
                                                <li>
                                                    <a class="helpTitle" href="#12.1"><Localized:LocalizedLiteral key="Help111" id="LocalizedLiteral57" runat="server"></Localized:LocalizedLiteral></a></li>
                                                <li>
                                                    <a class="helpTitle" href="#12.2"><Localized:LocalizedLiteral key="Help112" id="LocalizedLiteral58" runat="server"></Localized:LocalizedLiteral></a></li>
                                            </ul>


                                        </li>
                                    </ul>
                                </td>
                                <td id="tdHelpText" runat="server" class="tdHelpText">
                                    <!-- this content is modified at runtime
                                    the text {0} is replaced with the name of the application
                                    -->
                                    <h3 Class="helpApplicationName"><asp:Literal ID="lblIntroduction2" Runat="server"></asp:Literal>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpTextIntro" runat="server"></Localized:LocalizedLiteral>
                                    
                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help94" id="Localizedliteral48" runat="server"></Localized:LocalizedLiteral><a name="2"></a></h3>
                                    <Localized:LocalizedLiteral id="litHelpText94" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help2" id="Localizedliteral27" runat="server"></Localized:LocalizedLiteral> <a name="3"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText2" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help3" id="Localizedliteral28" runat="server"></Localized:LocalizedLiteral><a name="4"></a>
                                    </h3>
                                    <h4><Localized:LocalizedLiteral key="Help31" id="Localizedliteral29" runat="server"></Localized:LocalizedLiteral><a name="4.1" id="3A"></a></h4>
                                    <Localized:LocalizedLiteral id="litHelpText31" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help32" id="Localizedliteral30" runat="server"></Localized:LocalizedLiteral><a name="4.2"></a></h4>
                                    <Localized:LocalizedLiteral id="litHelpText32" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help33" id="Localizedliteral31" runat="server"></Localized:LocalizedLiteral> <a name="4.3"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText33" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help34" id="Localizedliteral32" runat="server"></Localized:LocalizedLiteral> <a name="4.4"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText34" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help35" id="Localizedliteral33" runat="server"></Localized:LocalizedLiteral><a name="4.5"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText35" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help36" id="Localizedliteral34" runat="server"></Localized:LocalizedLiteral> <a name="4.6"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText36" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help4" id="Localizedliteral35" runat="server"></Localized:LocalizedLiteral> <a name="5"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText4" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help5" id="Localizedliteral36" runat="server"></Localized:LocalizedLiteral> <a name="6"></a>
                                    </h3>
                                    <h4><Localized:LocalizedLiteral key="Help51" id="Localizedliteral37" runat="server"></Localized:LocalizedLiteral><a name="6.1"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText51" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help52" id="Localizedliteral38" runat="server"></Localized:LocalizedLiteral> <a name="6.2"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText52" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help53" id="Localizedliteral39" runat="server"></Localized:LocalizedLiteral> <a name="6.3"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText53" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help54" id="Localizedliteral40" runat="server"></Localized:LocalizedLiteral> <a name="6.4"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText54" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help95" id="Localizedliteral49" runat="server"></Localized:LocalizedLiteral><a name="6.5"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText95" runat="server"></Localized:LocalizedLiteral>
                                    
                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help96" id="Localizedliteral50" runat="server"></Localized:LocalizedLiteral><a name="7"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText96" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help7" id="Localizedliteral42" runat="server"></Localized:LocalizedLiteral><a name="8"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText7" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help97" id="Localizedliteral51" runat="server"></Localized:LocalizedLiteral><a name="8.1"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText97" runat="server"></Localized:LocalizedLiteral>
                                    
                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help8" id="Localizedliteral43" runat="server"></Localized:LocalizedLiteral><a name="9"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText8" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help9" id="Localizedliteral44" runat="server"></Localized:LocalizedLiteral><a name="10"></a>
                                    </h3>


                                    <h3><Localized:LocalizedLiteral key="Help91" id="Localizedliteral45" runat="server"></Localized:LocalizedLiteral><a name="10.1"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText91" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help92" id="Localizedliteral46" runat="server"></Localized:LocalizedLiteral><a name="10.2"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText93" runat="server"></Localized:LocalizedLiteral>
                                    
                                    <!-- Administrative Report Description 1-->
                                    <Localized:LocalizedLiteral id="litHelpText6" runat="server"></Localized:LocalizedLiteral>

                                    <!-- Administrative Report Description 2-->
                                    <Localized:LocalizedLiteral id="litHelpText9" runat="server"></Localized:LocalizedLiteral>

                                    <Localized:LocalizedLiteral id="litHelpText92" runat="server"></Localized:LocalizedLiteral>

                                    <!--<a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a>
                                    <h4><Localized:LocalizedLiteral key="Help93" id="Localizedliteral47" runat="server"></Localized:LocalizedLiteral><a name="10.3"></a>
                                    </h4>
                                    -->
                                    



                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help10" id="Localizedliteral100" runat="server"></Localized:LocalizedLiteral> <a name="11"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText10" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help98" id="Localizedliteral52" runat="server"></Localized:LocalizedLiteral><a name="11.1"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText98" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help11" id="Localizedliteral53" runat="server"></Localized:LocalizedLiteral><a name="12"></a>
                                    </h3>
                                    <Localized:LocalizedLiteral id="litHelpText11" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help111" id="Localizedliteral54" runat="server"></Localized:LocalizedLiteral><a name="12.1"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText111" runat="server"></Localized:LocalizedLiteral>

                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h4><Localized:LocalizedLiteral key="Help112" id="Localizedliteral55" runat="server"></Localized:LocalizedLiteral><a name="12.2"></a>
                                    </h4>
                                    <Localized:LocalizedLiteral id="litHelpText112" runat="server"></Localized:LocalizedLiteral>

                                    <!--<p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                    <h3><Localized:LocalizedLiteral key="Help6" id="Localizedliteral41" runat="server"></Localized:LocalizedLiteral><a name="150"></a>
                                    </h3>
                                    -->




                                    <p><a href="#top"><Localized:LocalizedLiteral key="lnkBack" runat="server"></Localized:LocalizedLiteral></a></p>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td align="center"><navigation:footer id="ucFooter" runat="server"></navigation:footer></td>
                </tr>
            </table>
        </form>
        </A>
    </body>
</html>
