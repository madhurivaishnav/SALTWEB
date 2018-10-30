<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdaptivePlayer.aspx.cs" Inherits="Bdw.Application.Salt.Web.General.Scorm.AdaptiePlayer" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title></title>
  
    <script src="v.X.4/sscompat.js" type="text/javascript"></script>
    <script src="v.X.4/sscorlib.js" type="text/javascript"></script>
    <script src="v.X.4/ssfx.Core.js" type="text/javascript"></script>
    <script type="text/javascript" src="v.X.4/API_BASE.js"></script>
    <script type="text/javascript" src="v.X.4/API.js"></script>
    <script type="text/javascript" src="v.X.4/Controls.js"></script>
    <script type="text/javascript" src="v.X.4/Player.js"></script>
     <script type="text/javascript" src="v.X.4/APIWrapper.js"></script>
<script src="v.X.4/SCORM_API_wrapper.js" type="text/javascript"></script>

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
	  <script type ="text/javascript" >

	      var dme;
	      var pg = "";
	      var blnComplete = false;
	      var blnDebug = false;
	      document.getElementById("txtscorm").value = '/General/Scorm/AdaptiveFiles/402/2994/shared/launchpage.html';
	      var pgs = { "": "" };

	      function LMSInitialize(pVar) {
	          alert("LMSInitialize");


	          dme["Write"] = "false";
	          LMSSetValue("cmi.interactions._count", 0);
	          return "done";
	      }

	      var apiHandle = null;
	      var api = getAPIHandle();

	      var APII = top.window.placeholder_contentIFrame.API;
	      alert(APII)
	      api.LMSInitialize('Course - _Tesla Model S_ About the car');
	      function getAPIHandle() {

	          if (apiHandle == null) {

	              apiHandle = getAPI();

	          }

	          return apiHandle;

	      }

	      function getAPI() {

	          var theAPI = findAPI(window);

	          if ((theAPI == null) && (window.opener != null) && (typeof (window.opener) != "undefined")) {

	              theAPI = findAPI(window.opener);

	          }

	          if (theAPI == null) {

	              alert("Unable to find an API adapter");

	          }

	          return theAPI

	      }

	      function findAPI(win) {

	          var findAPITries = 0;

	          while ((win.API == null) && (win.parent != null) && (win.parent != win)) {

	              findAPITries++;

	              // Note: 7 is an arbitrary number, but should be more than sufficient

	              if (findAPITries > 7) {

	                  alert("Error finding API -- too deeply nested.");

	                  return null;

	              }

	              win = win.parent;

	          }

	          return win.API;

	      }



	      function LMSFinish(pNada) {
	          //alert('LMSFinish');
	          if (dme["ModuleID"] != 0 && document.getElementById("txtsessid").value != "") {
	              window.location = "/Reporting/QuizResult.aspx?QuizSessionID=" + document.getElementById("txtsessid").value;
	          }
	          else {
	              window.location = "/MyTraining.aspx";
	          }
	          return "done";
	      }


	      function LMSTerminate(pvar) {
	          //alert('LMSterminate');
	          if (dme["ModuleID"] != 0) {
	              window.location = "/MyTraining.aspx";
	          }
	      }


	      function LMSSetValue(pCMIDataModelElement, pStatus) {

	          //alert("[" + pCMIDataModelElement + "] = " + pStatus);
	          dme[pCMIDataModelElement] = pStatus;

	          if ("cmi.suspend_data" == pCMIDataModelElement) {
	              // if complete and not same page then transfer to training
	              strVars = pStatus.split(";")
	              for (i = 0; i < strVars.length; i++) {
	                  strnmval = strVars[i].split("=");
	                  if ((strnmval[0] == "VarSalt_Lesson_Status" || strnmval[0] == "Varsalt_Lesson_Status") && !blnComplete) {
	                      //debugger;
	                      if (strnmval[1] == "completed") {
	                          blnComplete = true;
	                          // redirect to my training
	                      }
	                  }
	                  break;
	              }
	          }

	          if ("salt.variables.VarCurrentPageName" == pCMIDataModelElement) {
	              // log each unique page visited then count to check all pages visited to flag completion
	              if (dme["salt.variables.VarCurrentPageName"]) {
	                  pgs[pStatus] = pStatus;
	                  if (!blnComplete) {
	                      var count = -1;
	                      for (var key in pgs) {
	                          count++;
	                      }
	                      //debugger;
	                      blnComplete = dme["salt.variables.VarPagesInChapter"] == count;
	                  }
	              }

	          }

	          if ("cmi.core.lesson_location" == pCMIDataModelElement && pStatus != "") {
	              dme["Write"] = "true";
	              pg = pStatus;
	              if (dme["ModuleID"] != 0) {
	                  sendRequest(pCMIDataModelElement, pStatus);
	              }
	          }

	          if (blnComplete) {
	              dme["cmi.core.lesson_status"] = "completed";
	          }

	          //dmeDebug();
	          return "true";

	      }


	      function LMSGetValue(pCMIDataModelElement) {

	          //alert("Getting " + pCMIDataModelElement);

	          if ("cmi.core.lesson_status" == pCMIDataModelElement && (!dme[pCMIDataModelElement])) {
	              LMSSetValue(pCMIDataModelElement, "incomplete");
	          }

	          if (pCMIDataModelElement.indexOf("_count") > 0) {
	              //debugger;
	              if (!dme[pCMIDataModelElement]) {
	                  LMSSetValue(pCMIDataModelElement, "0");
	              }
	          }

	          if (!dme[pCMIDataModelElement]) {
	              LMSSetValue(pCMIDataModelElement, "");
	          }

	          if ("cmi.interactions._count" == pCMIDataModelElement) {
	              dme[pCMIDataModelElement]++;
	          }

	          return dme[pCMIDataModelElement];

	      }


	      function LMSGetLastError() {
	          //alert("LMSGetLastError");
	          return "0";
	      }

	      function LMSCommit() {
	          if (dme["ModuleID"] != 0) {
	              dme["Write"] = "true";
	              return sendRequest();
	          }
	          else
	          { return "true"; }
	      }


	      function setupAPI(pForm) {
	          // alert("setupAPI");
	          //debugger;
	          dme = { ModuleID: document.getElementById("txtModuleID").value };
	          blnDebug = document.getElementById("txtDebug").value == "true";
	          xml2json(document.getElementById("txtXML").value)
	          blnComplete = false;


	          var query = window.location.search.substring(1);
	          var params = query.split("&");
	          var param1;
	          if (document.getElementById("txtscorm").value != "") {
	              param1 = document.getElementById("txtscorm").value;
	          }
	          else {
	              param1 = params[1];
	              param1 = param1.substring(4);
	          }

	          var lDiv = window.document.createElement("DIV");

	          lDiv.name = "API";
	          lDiv.setAttribute("id", "API");
	          lDiv.setAttribute("name", "API");
	          lDiv.style.height = '97%';
	          lDiv.style.width = '98%';
	          var browser = navigator.appName;

	          var lFrame = window.document.createElement("IFRAME");
	          lFrame.setAttribute("id", "frm1");
	          lFrame.style.width = '97%';
	          lFrame.style.height = '97%';


	          param1 = param1.replace(/%20/g, " ");

	          lFrame.setAttribute("src", param1);
	          lFrame.setAttribute("frameborder", "1");
	          lFrame.setAttribute("scrolling", "NO");
	          lFrame.setAttribute("style", "table-layout: auto;  border-collapse: collapse;  color: #000000 ; background-color: #ffffff; width: 95%; height: 95%; border: 0;");

	          lDiv.LMSTerminate = LMSTerminate;
	          lDiv.LMSInitialize = LMSInitialize;
	          lDiv.LMSSetValue = LMSSetValue;
	          lDiv.LMSGetValue = LMSGetValue;
	          lDiv.LMSFinish = LMSFinish;
	          lDiv.LMSCommit = LMSCommit;
	          lDiv.LMSGetLastError = LMSGetLastError;
	          lDiv.appendChild(lFrame);
	          form1.appendChild(lDiv);
	          form1.style.border = 0;
	          form1.style.overflow = 'visible';

	          window.close = LMSTerminate;
	      }


	      function getHttpObject() {
	          /*if (window.XMLHttpRequest) {// code for IE7+, Firefox, Chrome, Opera, Safari
	          xmlhttp = new XMLHttpRequest();
	          }
	          else {// code for IE6, IE5
	          xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
	          }Is there an event happening today. Every one is in sydney office

            return xmlhttp;*/

	          var ajaxRequest; // The variable that makes Ajax possible!

	          try {
	              // Opera 8.0+, Firefox, Safari
	              ajaxRequest = new XMLHttpRequest();
	          }
	          catch (e) {
	              // Internet Explorer Browsers
	              try {
	                  ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
	              }
	              catch (e) {
	                  try {
	                      ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
	                  }
	                  catch (e) {
	                      // Something went wrong
	                      alert("Your browser is not supported please contact helpdesk.");
	                      return false;
	                  }
	              }
	          }
	          return ajaxRequest;
	      }

	      function sendRequest(DME, val) {
	          xmlhttp = getHttpObject();


	          xmlhttp.open("POST", "/General/Scorm/Scorm12.ashx", true);
	          xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
	          xmlhttp.send(formatqstring(DME, val));


	          xmlhttp.onreadystatechange = function() {
	              if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
	                  var xmlResponse = xmlhttp.responseText;
	                  return "true";
	              }
	          }

	          return "true";
	      }


	      function formatqstring(DME, val) {

	          var querystring = "Write=" + dme["Write"];
	          querystring += "&ModuleID=" + document.getElementById("txtModuleID").value;
	          if (DME && val) {
	              querystring += "&DME=" + DME + "&value=" + val;
	          }
	          else {
	              querystring += "&SessionData=" + document.getElementById("txtsessid").value + "&xmlData=" + json2xml();
	              resetInteractions();
	          }

	          return querystring
	      }

	      function resetInteractions() {

	          if (dme["cmi.interactions._count"] > 0) {
	              for (var key in dme) {
	                  if (key.indexOf("mi.interactions.") > 0 || key.indexOf("alt.variables.var") > 0) {
	                      delete dme[key];
	                  }
	              }
	              dmeDebug();
	          }
	      }


	      function json2xml() {

	          var xml = "<xml xmlns=\"NetFrameWork\">";
	          for (var key in dme) {
	              xml += "<dme><name>" + key + "</name><value>" + dme[key] + "</value></dme>";
	          }


	          var p;
	          for (key in pgs) {
	              if (p) {
	                  p += ";" + pgs[key];
	              }
	              else {
	                  p = pgs[key];
	              }
	          }

	          xml += "<dme><name>pgarr</name><value>" + p + "</value></dme>";

	          xml += "</xml>";
	          return xml;

	      }

	      function xml2json(pxml) {
	          if (window.DOMParser) {
	              parser = new DOMParser();
	              xml = parser.parseFromString(pxml, "text/xml");
	          }
	          else // Internet Explorer
	          {
	              xml = new ActiveXObject("Microsoft.XMLDOM");
	              xml.async = false;
	              xml.loadXML(pxml);
	          }
	          if (xml.childNodes[0]) {
	              for (i = 0; i < xml.childNodes[0].childNodes.length; i++) {
	                  dme[xml.childNodes[0].childNodes[i].tagName] = xml.childNodes[0].childNodes[i].text;
	              }

	              if (dme["pgarr"]) {
	                  var pgsarr = dme["pgarr"].split(";");
	                  for (var i = 0; i < pgsarr.length; i++) {
	                      pgs[pgsarr[i]] = pgsarr[i];
	                  }
	              }
	          }
	      }

	      function dmeDebug() {
	          if (blnDebug) {
	              var strtbl = "<table border =\"1\">";
	              for (var key in dme) {
	                  strtbl += "<tr><td>" + key + "</td><td>" + dme[key] + "</td></tr>";
	              }
	              strtbl += "</table>";

	              var lDIV = document.getElementById("dbg");
	              //debugger;
	              if (!lDIV) {
	                  var lDIV = document.createElement("dbg");
	                  lDIV.id = "dbg";
	                  document.body.appendChild(lDIV);

	              }
	              lDIV.innerHTML = strtbl;
	          }
	      }
    </script>
     <script type="text/javascript">
         function InitPlayer() {
             PlayerRun();
         }

         function PlayerRun() {
             var contentDiv = document.getElementById('placeholder_contentIFrame');
             contentDiv.innerHTML = "";
             //Run.ManifestByURL('' + window.location.protocol + '//' + window.location.hostname + ':62162/General/Scorm/Content/' + getQueryVariable("CourseID") + '/' + getQueryVariable("ModuleID") + '/shared/launchpage.html', true);
             //Run.ManifestByURL('http://localhost:62162/General/Scorm/Content/405/3002/shared/launchpage.html', true);
         }

         function getQueryVariable(variable) {
             var query = window.location.search.substring(1);
             var vars = query.split("&");
             for (var i = 0; i < vars.length; i++) {
                 var pair = vars[i].split("=");
                 if (pair[0] == variable) { return pair[1]; }
             }
             return (false);
         }
    </script>
    
</head>
<body  onload = "setupAPI(this);">
 <table width="100%" height="100%" border="1" cellspacing="0" cellpadding="0">
        <tr>
            <td height="100%" valign="top">
                <table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td width="100%" height="100%" valign="top">
                            <div id="placeholder_contentIFrame" style="width: 100%; height: 100%; overflow: auto;">
                            </div>
                        </td>
                        <td valign="top" height="100%">
                            <div id="right_Border" style="width: 5px; height: 100%;">
                            </div>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    
    <%--<form id="form1" runat="server">
    <div>
    
    </div>
    </form>--%>
</body>
</html>
