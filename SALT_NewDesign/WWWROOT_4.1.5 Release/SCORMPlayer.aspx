<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SCORMPlayer.aspx.cs" Inherits="Bdw.Application.Salt.Web.SCORMPlayer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
     <title>SCROM Player</title>
  
	<script src="Lib/sscompat.js" type="text/javascript"></script> 
	<script src="Lib/sscorlib.js" type="text/javascript"></script>  
	<script src="Lib/ssfx.Core.js" type="text/javascript"></script> 
 
	<script type="text/javascript" src="Lib/API_BASE.js"></script>    
        <script type="text/javascript" src="Lib/API.js"></script>  
        

        <script type="text/javascript" src="Lib/Controls.js"></script>        
	<script type="text/javascript" src="Lib/LocalStorage.js"></script>
	<script type="text/javascript" src="Lib/Player.js"></script>
  <style type="text/css">
		* { margin: 0px; }
        html, body, iframe { height:100%; }
		html, body { /*overflow-y:hidden;*/ font-family:Helvetica, "Helvetica Neue", Arial; font-size:12px; color:#000000;}
		iframe { display:block; width:100%; }

		html, body, iframe , a, img, table, tbody, tr, td, table td, table th {
		    border : 0px none;
            padding: 0px; 
		}
		
				                                 

		a:link { color: #0000FF; }
		a:visited { color: #0000FF; }
		a:hover { color: #000080; }
		a:active { color: #0000FF; }

		#btnExit {margin-left:5px;}
		#btnAbandon {margin-left:5px;}
		#btnSuspendAll {margin-left:5px;}
	</style>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
    <script type="text/javascript">

    

//        function InitPlayer() {
//       
//                    var settings = {
//                    "async": true,
//                    "crossDomain": true,
//                    "url": "https://adaptive.saltcompliance.com/api/v1/shc/learn.jsonp?doorId=dd5a3f37-36e8-44b8-8f79-95a0cb388177&scormPackageId=903dbfd2-39b3-412b-857c-07477f1aa8ae&secret=15yCNdluE8V8RE6u_BtY3QH8ji53&lmsUserId=1jkl11&callback=asda111",
//                    "method": "POST",
//                    "headers": {
//                        "content-type": "application/x-www-form-urlencoded"
        //                                         },

//                                     }
//// alert(settings);
////$.ajax(settings).done(function (response) {
////  alert(response);
////});
//                                }
                    
//        var API = {};

//        (function($) {
//            $(document).ready(setupScormApi());

//            function setupScormApi() {
//                API.LMSInitialize = LMSInitialize;
//                API.LMSGetValue = LMSGetValue;
//                API.LMSSetValue = LMSSetValue;
//                API.LMSCommit = LMSCommit;
//                API.LMSFinish = LMSFinish;
//                API.LMSGetLastError = LMSGetLastError;
//                API.LMSGetDiagnostic = LMSGetDiagnostic;
//                API.LMSGetErrorString = LMSGetErrorString;
//                
//                window.open("http://localhost:51864/General/Scorm/Content/406/3004/shared/launchpage.html", "popupname", "resizable,scrollbars,status");

//            }
//            function LMSInitialize(initializeInput) {

//                displayLog("LMSInitialize: " + initializeInput);

//                // alert(initializeInput);
//                return true;
//            }
//            function LMSGetValue(varname) {
//                displayLog("LMSGetValue: " + varname);
//                return "";
//            }
//            function LMSSetValue(varname, varvalue) {
//                displayLog("LMSSetValue: " + varname + "=" + varvalue);
//                return "";
//            }
//            function LMSCommit(commitInput) {
//                displayLog("LMSCommit: " + commitInput);
//                return true;
//            }
//            function LMSFinish(finishInput) {
//                displayLog("LMSFinish: " + finishInput);
//                return true;
//            }
//            function LMSGetLastError() {
//                displayLog("LMSGetLastError: ");
//                return 0;
//            }
//            function LMSGetDiagnostic(errorCode) {
//                displayLog("LMSGetDiagnostic: " + errorCode);
//                return "";
//            }
//            function LMSGetErrorString(errorCode) {
//                displayLog("LMSGetErrorString: " + errorCode);
//                return "";
//            }
//            function displayLog(textToDisplay) {
//                var loggerWindow = document.getElementById("logDisplay");
//                var item = document.createElement("div");

//                item.innerText = textToDisplay;

//                loggerWindow.appendChild(item);

//            }



//        })(jQuery);


    </script>


</head>
<body   onload="InitPlayer()"  style="background-color: #FFFFFF;">

   <script type="text/javascript">
    function InitPlayer() {
            PlayerConfiguration.Debug = true;
            PlayerConfiguration.StorageSupport = true;

            PlayerConfiguration.TreeMinusIcon = "Img/minus.gif";
            PlayerConfiguration.TreePlusIcon = "Img/plus.gif";
            PlayerConfiguration.TreeLeafIcon = "Img/leaf.gif";
            PlayerConfiguration.TreeActiveIcon = "Img/select.gif";

            PlayerConfiguration.BtnPreviousLabel = "Previous";
            PlayerConfiguration.BtnContinueLabel = "Continue";
            PlayerConfiguration.BtnExitLabel = "Exit";
            PlayerConfiguration.BtnExitAllLabel = "Exit All";
            PlayerConfiguration.BtnAbandonLabel = "Abandon";
            PlayerConfiguration.BtnAbandonAllLabel = "Abandon All";
            PlayerConfiguration.BtnSuspendAllLabel = "Suspend All";



//            $.ajax({
//                type: "GET",
//                url: "https://adaptive.saltcompliance.com/api/v1/shc/learn.jsonp?",
//                data: "{'lmsUserId': 'Test1','callback':'callrl'}",
//                contentType: "application/json;charset=utf-8",
//                dataType: "json",
//                success: "succsess",
//                error: function(ts) { alert("ts.responseText") }

//            });
          
            
            PlayerRun();

//            var root = 'https://adaptive.saltcompliance.com';
//            $.ajax({
//                dataType: "json",
//                url: url,
//                data: data,
//                success: success
//            });
        }

        function PlayerRun() {
            var contentDiv = document.getElementById('placeholder_contentIFrame');
            contentDiv.innerHTML = "";
            //Run.ManifestByURL('http://demo.saltcompliance.com/General/Scorm/Content/421/3060/imsmanifest.xml', true);
            Run.ManifestByURL('http://localhost:51864/General/Scorm/Content/430/3103/imsmanifest.xml', true);
        }</script>

    <table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
    <tr>
      <td valign="top">
        <table border="0" cellspacing="0" cellpadding="0" width="100%">
         <tr>
            <td width="200" valign="top"><img src="images/scormpool_s.jpg" style="padding-left:5px;" width="127" height="51" border="0" alt="SCORMPOOL"/></td>
  	        <td valign="bottom"><div id="placeholder_navigationContainer" style="padding-top:5px;padding-bottom:5px;"></div></td>
         </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td height="100%" valign="top">
       <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
          <td valign="top" height="100%" style="padding-left:5px;"><div id="placeholder_treeContainer" style="width:200px;height:100%;overflow:auto;"></div></td>
          <td width="100%" height="100%" valign="top"><div id="placeholder_contentIFrame" style="width:100%;height:100%;overflow:auto;-webkit-overflow-scrolling:touch;"></div></td>
          <td valign="top" height="100%">
            <div id="right_Border" style="width:5px;height:100%;"></div>
          </td>
        </tr>
       </table>
      </td>
    </tr>
    <tr>
      <td style="font-size:10px;padding-left:5px;">SCORM player v1.07</td>
    </tr>
  </table>

            <%--  <div id="logDisplay">
    </div>--%>
          <%-- <form id="form1" runat="server">
    <div>
    
    </div>
    </form>--%>








</body>
</html>
