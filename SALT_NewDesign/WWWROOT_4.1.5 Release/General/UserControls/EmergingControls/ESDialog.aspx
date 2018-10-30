<%@ Page Language="C#" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">




<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
        <title>!                                                                                                   </title>
       <script language="javascript">
        
        
            function Done() {          
                window.close();
            }
            function dialogInit() {

                var query = window.location.search.substring(1);

                var params = query.split("&p=");
                var param1 = params[1];
                param1 = param1.replace(/%20/g, " ");


                window.document.getElementById("Text1").value = param1;
                if (params[2]) window.document.title = params[2] + "                                                                                                   ";

            }
</script>

</head>
<body onload="dialogInit()" >
    <form id="form1" runat="server">
    <div align="center" style="height: 115px">
        <img alt="" src="/General/Images/exclaim.bmp" 
            style="height: 24px; width: 24px" align="left" />
            <br /><input id="Text1" align="right" readonly="readonly" 
            style="border-style: hidden; border-width: 0px; width: 300px; font-weight: bold; text-align: center;" 
            type="text" />   <br />
        <br />
        <input id="Button1" type="button" value="OK" onclick = "Done()" 
             "/></div>
        <input id="Text12" readonly="readonly" style="padding: 0px; margin: 0px; border: 0px hidden #FFFFFF; width: 330px; bottom: 6px; height: 32px;" 
    </form>
</body>
</html>
