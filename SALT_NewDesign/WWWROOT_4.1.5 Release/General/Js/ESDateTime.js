// JScript source code

function verifyDate(NVCday, NVCmonth, NVCyear, NVClocalizedMessage, WindowTitle) {
                if (!NVCday) alert("syntax error: Control not found '" + NVCday + "'");
                if (!NVCmonth) alert("syntax error: Control not found '" + NVCmonth + "'");
                if (!NVCyear) alert("syntax error: Control not found '" + NVCyear + "'");
                if ((NVCday.value != "") && (NVCmonth.value != "") && (NVCyear.value != "")) {
                    var d = new Date(NVCyear.value, NVCmonth.value - 1, NVCday.value);
                    if (d.getDate() != NVCday.value) {
                        //alert(NVCday.value + "/" + NVCmonth.value + "/" + NVCyear.value + " is not a valid date");
                        //alert(NVClocalizedMessage.value);
                        if (navigator.appName == "Microsoft Internet Explorer") {
                            var WinSettings = "unadorned:yes;status:no;center:yes;resizable:no;dialogHeight:115px;dialogWidth:355px"
                        }
                        else {
                            var WinSettings = "unadorned:yes;status:no;center:yes;resizable:no;dialogHeight:165px;dialogWidth:355px"
                        }
                        if (NVClocalizedMessage.value == "")  var MyArgs = window.showModalDialog("/General/UserControls/EmergingControls/ESDialog.aspx?&p=" + NVCday.value + "/" + NVCmonth.value + "/" + NVCyear.value + " ??????"  + "&p=" + WindowTitle.value, MyArgs, WinSettings);
                        if (NVClocalizedMessage.value != "") var MyArgs = window.showModalDialog("/General/UserControls/EmergingControls/ESDialog.aspx?&p=" + NVCday.value + "/" + NVCmonth.value + "/" + NVCyear.value + " " + NVClocalizedMessage.value + "&p=" + WindowTitle.value, MyArgs, WinSettings);

                    }
                }
            }
       
