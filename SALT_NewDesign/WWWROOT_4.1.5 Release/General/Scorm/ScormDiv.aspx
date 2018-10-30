<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ScormDiv.aspx.cs" Inherits="Bdw.Application.Salt.Web.General.Scorm.ScormDiv"
    ValidateRequest="false" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
    <title runat="server" id="pagTitle"></title>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR">
    <meta content="C#" name="CODE_LANGUAGE">
    <meta content="JavaScript" name="vs_defaultClientScript">
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
   <script src="/../General/Js/ie9-js.js" type="text/javascript"></script>

    <script src="v.X.4/sscompat.js" type="text/javascript"></script>

    <script src="v.X.4/sscorlib.js" type="text/javascript"></script>

    <script src="v.X.4/ssfx.Core.js" type="text/javascript"></script>

    <script type="text/javascript" src="v.X.4/API_BASE.js"></script>

    <script type="text/javascript" src="v.X.4/API.js"></script>

    <script type="text/javascript" src="v.X.4/Controls.js"></script>

    <script type="text/javascript" src="v.X.4/Player.js"></script>

    <script type="text/javascript" src="v.X.4/APIWrapper.js"></script>

    <script src="v.X.4/SCORM_API_wrapper.js" type="text/javascript"></script>
     <script src="v.X.4/scofunctions.js" type="text/javascript"></script>
    <style type="text/css">
    </style>
    <script type="text/javascript">
        var dme;
        var pg = "";
        var blnComplete = false;
        var blnDebug = true;
        var count = 0;
        //document.getElementById("txtscorm").value = '/General/Scorm/AdaptiveFiles/402/2994/shared/launchpage.html';
        var pgs = { "": "" };
        function LMSInitialize(pVar) {
            dme["Write"] = "true";
            LMSSetValue("cmi.interactions._count", 0);
            dmeDebug();
            return "done";
        }
//        function displayLog(textToDisplay) {
//            var loggerWindow = document.getElementById("logDisplay");
//            var item = document.createElement("div");
//            item.innerText = textToDisplay;
//            loggerWindow.appendChild(item);
//        }
        function LMSFinish(pNada) {
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

       
//            if ("cmi.core.lesson_status" == pCMIDataModelElement && pStatus == "incomplete") {
//                var test = sendRequest(pCMIDataModelElement, pStatus);
//                alert(test);
//            } 
            if (pCMIDataModelElement == "cmi.core.score.raw") {

                // alert("[" + pCMIDataModelElement + "] = " + pStatus);
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
                    //  alert(dme["cmi.core.lesson_status"]);
                    if (blnComplete) {
                        dme["cmi.core.lesson_status"] = "completed";
                    }
                    if (pStatus == 100) {//alert(parameter_2);
                        if (dme["ModuleID"] != 0) {
                            dme["Write"] = "true";
                            var x = document.getElementById("txtinput");
                            setTimeout(function(){ x.value = "*" }, 5000);
                            return sendRequest();
                        }
                        else
                        { return "true"; }

                    }
                    //dmeDebug();
                    return "true";
                }
            
            else {
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
                        // displayLog("LMSSetValue: " + varname + "=" + varvalue);
                        break;
                    }
                    //displayLog("LMSSetValue: " + varname + "=" + varvalue);
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
            xml2json(document.getElementById("txtXML").value);
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
            lDiv.style.height = '100%';
            lDiv.style.width = '100%';
            
            var browser = navigator.appName;

            var lFrame = window.document.createElement("IFRAME");
            lFrame.setAttribute("id", "frm1");
            lFrame.style.width = '100%';
            lFrame.style.height = '100%';
            param1 = param1.replace(/%20/g, " ");

            lFrame.setAttribute("src", param1);
            lFrame.setAttribute("frameborder", "1");
            lFrame.setAttribute("scrolling", "YES");
            lFrame.setAttribute("style", "table-layout: auto;  border-collapse: collapse;  color: #000000 ; overflowbackground-color: #ffffff; width: 100%; height: 100%; border: 0; ");

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

            API.LMSInitialize = LMSInitialize;
            API.LMSSetValue = LMSSetValue;
            API.LMSGetValue = LMSGetValue;
            API.LMSFinish = LMSFinish;
            API.LMSCommit = LMSCommit;
            API.LMSGetLastError = LMSGetLastError;
            API.LMSGetDiagnostic = LMSGetDiagnostic;
            API.LMSGetErrorString = LMSGetErrorString;
            
            
            
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
            var x = document.getElementById("txtinput");
            setTimeout(function(){ x.value = "." }, 5000);
            xmlhttp = getHttpObject();
            xmlhttp.open("POST", "/General/Scorm/Scorm12.ashx", true);
            xmlhttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            xmlhttp.send(formatqstring(DME, val));

            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    var xmlResponse = xmlhttp.responseText;
                    //alert(xmlResponse);
                    return "true";
                }
            }
            return "true";
        }
        function formatqstring(DME, val) {
            var x = document.getElementById("txtinput");
            setTimeout(function(){ x.value = "-" }, 5000);
            var querystring = "Write=" + dme["Write"];
            querystring += "&ModuleID=" + document.getElementById("txtModuleID").value;
            if (DME && val) {
                querystring += "&DME=" + DME + "&value=" + val + "&xmlData=" + json2xml();
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
            var AdaptiveScore = 0;
            AdaptiveScore = LMSGetValue("cmi.core.score.raw");
            
            var xml = "<xml xmlns=\"NetFrameWork\">";
            for (var key in dme) {
                if (AdaptiveScore > 0) {
                    if (key == "cmi.core.lesson_score") {
                        xml += "<dme><name>" + key + "</name><value>" + AdaptiveScore + "</value></dme>";
                    }
                    else {
                        xml += "<dme><name>" + key + "</name><value>" + dme[key] + "</value></dme>";
                    }
                }
                else {
                    xml += "<dme><name>" + key + "</name><value>" + dme[key] + "</value></dme>";
                }
            }
            //alert(xml);


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
                    

                    //dme[xml.childNodes[0].childNodes[i].tagName] = xml.childNodes[0].childNodes[i].text;
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


        function formatqstringAdaptive(DME, val) {
            //            alert("formatqstringAdaptive");
            var querystring = "Write=" + dme["Write"];
            querystring += "&ModuleID=" + document.getElementById("txtModuleID").value;
            if (DME && val) {
                querystring += "&DME=" + DME + "&value=" + val;
            }
            else {
                querystring += "&SessionData=" + document.getElementById("txtsessid").value + "&xmlData=" + json2xmlAdaptive();
                resetInteractions();
            }

            return querystring
        }
        function json2xmlAdaptive() {
            // alert("json2xmlAdaptive");
            var xml = "<xml xmlns=\"NetFrameWork\">";
            for (var key in dme) {
                xml += "<dme><name>" + key + "</name><value>" + dme[key] + "</value></dme>";
                //alert(xml);
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

        function LMSInitialize(parameter) {//alert("LMS Intialized");
            // LMSSetValue("cmi.interactions._count", 0);
            // alert("LMSInitialize: parameter=" + parameter);
            dme["Write"] = "true";
            LMSSetValue("cmi.interactions._count", 0);
          
            //return "done";
            return "true";
        }
        function LMSCommit(parameter) {
            //               alert("LMSCommit parameter=" + parameter);
            //                if (dme["ModuleID"] != 0) {
            //                    dme["Write"] = "false";
            //                    return sendRequest();
            //                }
            //                else
            //                { return "true"; }
            return "true";
        }
//        function LMSFinish(parameter) {
//            alert("LMSFinish lesson_status=" + LMSGetValue("cmi.core.lesson_status")+" salt.variables.VarRunningPageCount "+LMSGetValue("cmi.core.VarRunningPageCount")+" salt.variables.VarPagesInChapter "+LMSGetValue("cmi.core.VarPagesInChapter")+" salt.variables.VarPageInChapter "+LMSGetValue("cmi.core.VarPageInChapter"));

//            return "true";
//        }
//        function LMSGetLastError() {
//            //alert("LMSGetLastError");
//            return "0";
//        }
        function LMSGetErrorString() {
            //alert("LMSGetErrorString");
            return "";
        }
        function LMSGetDiagnostic() {
            //alert("LMSGetDiagnostic");
            return "";
        }
    </script>

</head>
<body style="height: 98%; margin:0px;padding:0px;" onload="setupAPI(this);">
    <form id="form1" runat="server" style="width: 100%; height: 100%; overflow: hidden;">
    <asp:TextBox ID="txtModuleID" Height="0px" Width="0px" runat="server" BorderStyle="None"></asp:TextBox>
    <asp:TextBox ID="txtXML" runat="server" Height="0px" Width="0px" BorderStyle="None"></asp:TextBox>
    <asp:TextBox ID="txtDebug" runat="server" Height="0px" Width="0px" BorderStyle="None"></asp:TextBox>
    <asp:TextBox ID="txtscorm" runat="server" Height="0px" Width="0px" BorderStyle="None"></asp:TextBox>
    <asp:TextBox ID="txtsessid" runat="server" Height="0px" Width="0px" BorderStyle="None"></asp:TextBox>
    <asp:TextBox ID="txtinput" runat="server" BorderStyle="None"  ForeColor="White"></asp:TextBox>
    <div style="position: absolute; top: 10px; right: 10%;">
        <a id="btnExit" runat="server" href="/mytraining.aspx" style="display: block; width: 70px; height: 20px; background: #4E9CAF; padding: 5px; text-align: center; font-family:Arial; border-radius: 5px; color: white; font-weight: bold;">Exit</a>
       <%-- <asp:LinkButton ID="btnexitall" runat="server" CssClass="btnexitall" Text="Exit" Visible="false" style="display:none;"
            OnClick="btnexitall_Click"></asp:LinkButton>--%>
    </div>
    </form>
</body>
</html>
