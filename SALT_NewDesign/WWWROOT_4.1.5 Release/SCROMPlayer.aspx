

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<html>
<head>
    <title>SCROM Player</title>

    <script src="Lib/sscompat.js" type="text/javascript"></script>

    <script src="Lib/sscorlib.js" type="text/javascript"></script>

    <script src="Lib/ssfx.Core.js" type="text/javascript"></script>

    <script type="text/javascript" src="Lib/API_BASE.js"></script>

    <script type="text/javascript" src="Lib/API.js"></script>

    <script type="text/javascript" src="Lib/Controls.js"></script>

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
    <!--[if IE]>
	<style type="text/css">
	    html, body { overflow-y:hidden; }
	</style>
    <![endif]-->

    <script type="text/javascript">
       function InitPlayer() {
        
            //PlayerRun();
           
       }
       
       function PlayerRun(){
        var contentDiv = document.getElementById('placeholder_contentIFrame');

        contentDiv.innerHTML="";
        Run.ManifestByURL('http://localhost:51864/General/Scorm/Content/405/3002/imsmanifest.xml', true);
 //https://adaptive.saltcompliance.com/api/v1/shc/courses/2d732a5d-c888-4cba-afd6-fbd3efe9d48c/_preview/version/34?activeUser=438c93e8-373a-4ca8-b3f8-39abd7e4ddce&amp;previewOnly=true&amp;embedded=true
  //Run.ManifestByURL(''+window.location.protocol+'//'+window.location.hostname  +'/General/Scorm/Content/AdaptiveFiles/'+getQueryVariable("CourseID")+'/'+getQueryVariable("ModuleID")+'/imsmanifest.xml', true);
      
       }
       
       function getQueryVariable(variable)
        {
               var query = window.location.search.substring(1);
               var vars = query.split("&");
               for (var i=0;i<vars.length;i++) {
                       var pair = vars[i].split("=");
                       if(pair[0] == variable){return pair[1];}
               }
               return(false);
        }


    </script>

</head>
<body onload="InitPlayer()" style="background-color: #FFFFFF;">
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
    
  
</body>
</html>
