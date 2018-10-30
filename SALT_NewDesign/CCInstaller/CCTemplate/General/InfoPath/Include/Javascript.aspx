//This must be placed on each page where you want to use the client-side resource manager
var ResourceManager = new RM();
function RM()
{
	this.list = new Array();
};
RM.prototype.AddString = function(key, value)
{
	this.list[key] = value;
};
RM.prototype.GetString = function(key)
{
	var result = this.list[key];  
	for (var i = 1; i < arguments.length; ++i)
	{
		result = result.replace("{" + (i-1) + "}", arguments[i]);
	}
	return result;
};


//Rollover images
var nextButton = new Image();
var nextActiveButton = new Image();
var prevButton = new Image();
var prevActiveButton = new Image();
var MTP = new Image();
var ActiveMTP = new Image();
var optA = new Image();
var activeOptA = new Image();
var optB = new Image();
var activeOptB = new Image();
var optC = new Image();
var activeOptC = new Image();
var optD = new Image();
var activeOptD = new Image();
var optE = new Image();
var activeOptE = new Image();
var SubmitQAns = new Image();
var activeSubmitQAns = new Image();
var Example = new Image();
var activeExample = new Image();
var closeImg = new Image();
var activeCloseImg = new Image();
var hintImg = new Image();
var activeHintImg = new Image();
var CaseStudyImg = new Image();
var ActiveCaseStudyImg = new Image();
var CheckAns = new Image();
var ActiveCheckAns = new Image();

//Load rollover images
nextButton = "/General/Images/InfoPath/CC_Next.gif";
nextActiveButton= "/General/Images/InfoPath/CC_ActiveNext.gif";
prevButton = "/General/Images/InfoPath/CC_Back.gif";
prevActiveButton= "/General/Images/InfoPath/CC_ActiveBack.gif";
MTP = "/General/Images/InfoPath/CC_MTP.gif";
ActiveMTP = "/General/Images/InfoPath/CC_ActiveMTP.gif";
optA = "/General/Images/InfoPath/CC_OptA.gif";
activeOptA = "/General/Images/InfoPath/CC_ActiveOptA.gif";
optB = "/General/Images/InfoPath/CC_OptB.gif";
activeOptB = "/General/Images/InfoPath/CC_ActiveOptB.gif";
optC = "/General/Images/InfoPath/CC_OptC.gif";
activeOptC = "/General/Images/InfoPath/CC_ActiveOptC.gif";
optD = "/General/Images/InfoPath/CC_OptD.gif";
activeOptD = "/General/Images/InfoPath/CC_ActiveOptD.gif";
optE = "/General/Images/InfoPath/CC_OptE.gif";
activeOptE = "/General/Images/InfoPath/CC_ActiveOptE.gif";
SubmitQAns = "/General/Images/InfoPath/CC_SubmitQuiz.gif";
activeSubmitQAns = "/General/Images/InfoPath/CC_ActiveSubmitQuiz.gif";
Example = "/General/Images/InfoPath/CC_Example.gif";
activeExample = "/General/Images/InfoPath/CC_ActiveExample.gif";
hintImg = "/General/Images/InfoPath/CC_Hint.gif";
activeHintImg = "/General/Images/InfoPath/CC_ActiveHint.gif";
closeImg = "/General/Images/InfoPath/CC_Close.gif";
activeCloseImg = "/General/Images/InfoPath/CC_ActiveClose.gif";
CaseStudyImg = "/General/Images/InfoPath/CC_CaseStudy.gif";
ActiveCaseStudyImg = "/General/Images/InfoPath/CC_ActiveCaseStudy.gif";
CheckAns = "/General/Images/InfoPath/CC_Checkanswer.gif"; 
ActiveCheckAns = "/General/Images/InfoPath/CC_ActiveCheckanswer.gif";

//Window onload event

window.onload=function()
{
	var divContentLeft = document.getElementById("divLegalContentLeft");
	var divContentMiddle = document.getElementById("divLegalContentMiddle");	
	var divContentRight = document.getElementById("divLegalContentRight");
	
	if (divContentLeft != null)
	{
		var inHTML = divContentLeft.innerHTML;
	
		inHTML = inHTML.replace(/ExtraInfoExtraVisible/g,"ExtraInfoExtraHidden");						
		divContentLeft.innerHTML = inHTML;		
	}

	if (divContentMiddle != null)
	{
		var inHTML = divContentMiddle.innerHTML;
		
		inHTML = inHTML.replace(/ExtraInfoExtraVisible/g,"ExtraInfoExtraHidden");						
		divContentMiddle.innerHTML = inHTML;		
	}
	
	if (divContentRight != null)
	{
		var inHTML = divContentRight.innerHTML;

		inHTML = inHTML.replace(/ExtraInfoLinkOther/g,"ExtraInfoLinkOtherHidden");						
		inHTML = inHTML.replace(/ExtraInfo_Heading/g,"ExtraInfo_Heading_Hidden");						
		inHTML = inHTML.replace(/ExtraInfo_Link/g,"ExtraInfo_LinkHidden");
		
		divContentRight.innerHTML = inHTML;		

		//alert(tdExtraInfo.innerHTML);
	}
		
}

function confirmExit()
{
    if (confirm (ResourceManager.GetString("ConfirmExit")))
    {
        __doPostBack('Exit_Click','');
    }
}

function ShowMeetThePlayer(obj)
{
	var tbl;
	var oImgVal = eval("document.all.PID" + obj.id.substr(1,obj.id.length) + ".value");
	if (oImgVal.length > 1)
	{
		oImgVal = "<img src='" + oImgVal + "'>";
	}
	
	var oHeadVal = eval("document.all.PNAME" + obj.id.substr(1,obj.id.length) + ".value");
	var oDescVal = eval("document.all.PDESC" + obj.id.substr(1,obj.id.length) + ".innerHTML");
	
	tbl = "<table width='100%' height='100%' border='0' align='center' cellpadding='1' cellspacing='1'>" +
			"<tr>" +
				"<td id='tdMeetThePlayerHeader' colspan='2'>HEAD</td>" +
			"</tr>" +
			"<tr>" +
				"<td id='tdMeetThePlayerIMG'>IMAGE</td>" +
				"<td id='tdMeetThePlayerDET'>DESC</td>" +
			"</tr>" +
		"</table>";
	
	
	document.all.tblShowMsgPlayer.innerHTML = tbl.replace('IMAGE',oImgVal).replace('HEAD',oHeadVal).replace('DESC',oDescVal);
	document.all.OptionContent_ShowPlayer.className = "ShowMeetThePlayer";
	document.all.tblShowMsg.className = "FormatMeetThePlayerTable";
	document.all.tdMeetThePlayerHeader.className = "MeetThePlayerHeader";
	document.all.tdMeetThePlayerIMG.className = "MeetThePlayerIMG";
	document.all.tdMeetThePlayerDET.className = "MeetThePlayerDESC";
}

function setPageHeight()
{
	var lngHeight = 0;
	var lngOffset = 230;
	var lngMenuHeight = 0;
	var strHeight;
	
	lngHeight = document.body.clientHeight;
	
	if(lngHeight < 320 + lngOffset){
		lngMenuHeight = 320
	} else {
		lngMenuHeight = lngHeight - lngOffset
	}
	
	strHeight = lngMenuHeight + "px";
	
	// Use lngMenuHeight to set the height of the div element.
	document.getElementById("Main_Table").style.height = strHeight;
	
}

var lastPlayer;
var lastAllPlayer;
var lastMultiQAFeedback;
var lastSelRadio = null;

//Script for question
function SelectAnswer(answer)
{
    // check the box
    var stringID = "Answer_" + answer;
    var lblID = "Label_" + answer;
    var count = document.all.Answer.length;
    var i = 0;
    
    for (i=1;i<=count;i++)
    {
		stringID = "Answer_" + i;
		lblID = "Label_" + i;
		
		objAnswer = document.getElementById(stringID);
		objBtn = document.getElementById("divQuizNext");
		objLabel = document.getElementById(lblID);
		
		if (i == answer)
		{
			if (objAnswer != null)
			{
				objAnswer.checked = true;
								
				if (objBtn != null)
					objBtn.className = "ButtonQuizNextVisible";				
					
				if (objLabel != null)
				{
					objLabel.className = "Question_Label_On";				
				}
			}
		}
		else
		{
			if (objAnswer != null)
			{
				objAnswer.checked = false;					
			}
			
			if (objLabel != null)
			{
				objLabel.className = "Question_Label_Off";				
			}			
		}
    }            
}
function EnableNextQuestion()
{   
    objNextButton =  document.getElementById("divNext");
    objNextButton.className = "Navigation_Button_General";
}

function TogglePopup(linkID)
{
    // show the popup
    objDescription = document.getElementById("Content_" + linkID);
    if (objDescription != null)
    {
        if (objDescription.className=="ExtraInfo_Show")
        {
            objDescription.className="ExtraInfo_Hide";
        }
        else
        {
            objDescription.className="ExtraInfo_Show";
        }
    }
}

function HideShowMessage(objName)
{
	obj = document.getElementById(objName);
	
	if (obj != null)
		obj.className = "ExtraInfo_Hide_Option";
	else
	{
		obj = document.getElementById("OptionContent_Result");
		if (obj != null)
			obj.className = "ExtraInfo_Hide_Option";
	}

	obj = document.getElementById("OptionContent_ShowPlayer");
	if (obj != null)
		obj.className = "ExtraInfo_Hide_Option";		
			
}

function ShowPopupOption(result,linkId)
{
    // show the popup
    objDescription = document.getElementById("OptionContent_" + linkId);
    objShowMsg = document.getElementById("tblShowMsg");
	objShowDialog = document.getElementById("OptionContent_Result");
	
    if (objDescription != null)
    {		
		if (objShowMsg != null)
			objShowMsg.innerHTML = objDescription.innerHTML;
		
		if (result == 'CORRECT')	
			objShowDialog.className = "ExtraInfo_Show_Option_Correct";
        else
			objShowDialog.className = "ExtraInfo_Show_Option_Wrong";
    }
}

function ShowPlayer(GUID)
{
    HideLastPlayer();
    
    objPlayer = document.getElementById(GUID);
    if (objPlayer != null)
    {
        if (objPlayer.className=="MeetThePlayer_Player_Show")
        {
            objPlayer.className="MeetThePlayer_Player_Hide";
        }
        else
        {
            objPlayer.className="MeetThePlayer_Player_Show";
            lastPlayer = GUID;
        }
    }
    
}

function HideLastPlayer()
{
    // hide the last player
    objLastPlayer = document.getElementById(lastPlayer);
    if (objLastPlayer != null)
    {
        objLastPlayer.className="MeetThePlayer_Player_Hide";
    }
}

function HidePlayer (GUID)
{
    // hide the player
    objPlayer = document.getElementById(GUID);
    if (objPlayer != null)
    {
        objPlayer.className="MeetThePlayer_Player_Hide";
    }
    lastPlayer=null;
}

function ShowPlayer_All(GUID)
{
    HideLastPlayer_All();
    
    objPlayer = document.getElementById(GUID);
    if (objPlayer != null)
    {
        if (objPlayer.className=="ShowAllPlayers_Player_Show")
        {
            objPlayer.className="ShowAllPlayers_Player_Hide";
        }
        else
        {
            objPlayer.className="ShowAllPlayers_Player_Show";
            lastAllPlayer = GUID;
        }
    }
}

function HideLastPlayer_All()
{
    // hide the last player
    objLastPlayer = document.getElementById(lastAllPlayer);
    if (objLastPlayer != null)
    {
        objLastPlayer.className="ShowAllPlayers_Player_Hide";
    }
}

function trimAll(sString)
{
	while (sString.substring(0,1) == ' ')
	{
		sString = sString.substring(1, sString.length);
	}
	while (sString.substring(sString.length-1, sString.length) == ' ')
	{
		sString = sString.substring(0,sString.length-1);
	}
	
	return sString;
}

function HideFreeTxtFeedback(id)
{
	var obj = document.getElementById(id);
	if (obj != null)
		obj.className = "FreeTextQA_FeedbackButton_Hide";
}

function HidePlayer_All (GUID)
{
    // hide the player
    objPlayer = document.getElementById(GUID);
    if (objPlayer != null)
    {
        objPlayer.className="ShowAllPlayers_Player_Hide";
    }
    lastAllPlayer=null;
}
function GiveFeedback(answerButton, feedbackTextGUID)
{
    // Hide the button
    //answerButton.className = "FreeTextQA_FeedbackButton_Hide";
    
    // Show the answer
    objFeedback = document.getElementById(feedbackTextGUID);
    objFeedback.className = "FreeTextQA_Feedback_Show";
}

function ShowAnswer(element, correct)
{
    objAnswer = document.getElementById(element);        
    if (objAnswer != null)
    {
		if (lastMultiQAFeedback != null && lastMultiQAFeedback != objAnswer)
		{
			objLastAnswer = document.getElementById(lastMultiQAFeedback);
			if (objLastAnswer != null)
				objLastAnswer.className = "MultiChoiceQA_AnswerFeedback_Hide";
		}
		
        if (correct=="true")
        {
            objAnswer.className = "MultiChoiceQA_AnswerFeedback_Correct";
        }
        else
        {
            objAnswer.className = "MultiChoiceQA_AnswerFeedback_Incorrect";
        }
    }
    
    lastMultiQAFeedback = element;
}
