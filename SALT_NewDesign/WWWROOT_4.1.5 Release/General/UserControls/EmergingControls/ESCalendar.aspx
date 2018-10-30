<%@ Page language="c#" AutoEventWireup="true" CodeBehind="ESCalendar.aspx.cs" Inherits="Bdw.Application.Salt.Web.General.UserControls.EmergingControls.ESCalendar" %>
<%@ Register TagPrefix="Localized" Namespace="Localization" Assembly="Localization" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
    <HEAD>
        <base target = "_self"/>
        <title>Select a Date and press "Select" .                            </title>
        <script language="javascript">
        
        
            function Done() {
                
                
                if (window.opener) {//In Safari all nested modal dialogs have no dialogArguements and window.returnValue is ignored
                    var query = window.location.search.substring(1);
                    var params = query.split("&p="); //so the name of the controls on the parent form are sent in the querystring separated by "&p="
                    //alert(params[3]);
                    //alert(window.opener.document.getElementById(params[3]));
                    var dropdownlistYr = window.opener.document.getElementById(params[3]);
                    dropdownlistYr.value = form1.txtYr.value;
                    var dropdownlistMth = window.opener.document.getElementById(params[2]);
                    dropdownlistMth.value = form1.txtMth.value;
                    var dropdownlistDay = window.opener.document.getElementById(params[1]);
                    dropdownlistDay.value = form1.txtDay.value;
                }
                else { //IE or FireFox so send result back in returnValue
                    
                    var ParmA = form1.txtDay.value;
                    var ParmB = form1.txtMth.value;
                    var ParmC = form1.txtYr.value;
                    var MyArgs = new Array(ParmA, ParmB, ParmC);
                   
                    window.returnValue = MyArgs; 
                }
                 
                window.close();
            }


            function CalInit() {
                //var ParmA = "Aparm";
                //var ParmB = "Bparm";
                //var ParmC = "Cparm";
                //var MyArgs = new Array(ParmA, ParmB, ParmC);
                //alert(MyArgs);
                //MyArgs = window.dialogArguments; //In Safari all nested calls have no dialogArguements and window.returnValue is ignored
                //MyArgs = window.opener; //In Safari all nested calls have no dialogArguements so no returnvalue is possible
                //alert(window.opener.document.getElementById("cboQCompletionYear").value);
                //pDayParam = MyArgs[0].toString();

                //pMthParam = MyArgs[1].toString();

                //pYrParam = MyArgs[2].toString();
                window.document.getElementById("Button1").value = window.document.getElementById("TextBox1").value;
                window.document.title = window.document.getElementById("TextBox2").value;

            }






        </script>
        <style type="text/css">
            #DayParam
            {
                width: 36px;
            }
            #MthParam
            {
                width: 46px;
            }
            #YrParam
            {
                width: 35px;
            }
            #Button1
            {
                width: 87px;
            }
            #bbbbb
            {
                width: 106px;
            }
            #form1
            {
                width: 261px;
                height: 209px;
                margin-bottom: 1px;
            }
        </style>
    </HEAD>
    <body   onload="CalInit()"> 
        <form id="form1" runat="server" visible="True" >

        <asp:Panel ID="Panel1" runat="server" Height="200px" Width="273px" 
            HorizontalAlign="Center">
            
        

           
            <asp:Calendar ID="Calendar2" runat="server" SelectedDate="2199-12-30" 
            VisibleDate="2199-12-30" onprerender="Calendar2_Init1" 
            onselectionchanged="Calendar2_SelectionChanged" BorderStyle="Solid" 
                Width="270px"></asp:Calendar>
            

            <asp:Panel ID="Panel2" runat="server" 
                Width="25px" Height="8px" Visible="True" BorderStyle="None" 
                HorizontalAlign="Left">
            
            <asp:TextBox ID="txtYr" runat="server" Height="1px" Width="1px" 
                CausesValidation="True" Enabled="False" BorderStyle="None" 
                    EnableTheming="False"></asp:TextBox>
        
            <asp:TextBox ID="txtMth" runat="server" Visible="true" Height="1px" Width="1px" 
                Enabled="False" BorderStyle="None" EnableTheming="False"></asp:TextBox>
                
       
            <asp:TextBox ID="txtDay" runat="server" Visible="true" Height="1px" Width="1px" 
                Enabled="False" BorderStyle="None"></asp:TextBox>
                
             <asp:TextBox ID="TextBox1" runat="server" Visible="true" Height="1px" Width="1px" 
                Enabled="False" BorderStyle="None" EnableTheming="False"></asp:TextBox>
                
             <asp:TextBox ID="TextBox2" runat="server" Visible="true" Height="1px" Width="1px" 
                Enabled="False" BorderStyle="None" EnableTheming="False"></asp:TextBox>
       

                
            </asp:Panel>
            

 
    <asp:Panel ID="Panel3" runat="server" HorizontalAlign="Center">
           <input ID="Button1" type="button" value="Select" onclick="Done()" 
                align="left" dir="ltr"/> 

                </asp:Panel>
        </asp:Panel>
       
        </form>
        

    </body>
</HTML>
