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


function confirmExit()
{
    if (confirm (ResourceManager.GetString("ConfirmExit")))
    {
        __doPostBack('Exit_Click','');
    }
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

//Script for question
function SelectAnswer(answer)
{
    // check the box
    var stringID = "Answer_" + answer;
    objAnswer = document.getElementById(stringID);
    if (objAnswer != null)
    {
        objAnswer.checked=true;
        EnableNextQuestion();
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
    answerButton.className = "FreeTextQA_FeedbackButton_Hide";
    
    // Show the answer
    objFeedback = document.getElementById(feedbackTextGUID);
    objFeedback.className = "FreeTextQA_Feedback_Show";
}

function ShowAnswer(element, correct)
{
    if (lastMultiQAFeedback!=element)
    {
        // hide the player
        objAnswer = document.getElementById(element);
        if (objAnswer != null)
        {
            if (correct=="true")
            {
                objAnswer.className = "MultiChoiceQA_AnswerFeedback_Correct";
            }
            else
            {
                objAnswer.className = "MultiChoiceQA_AnswerFeedback_Incorrect";
            }
        }
        
        // hide the last answer
        objLastAnswer = document.getElementById(lastMultiQAFeedback);
        if (objLastAnswer != null)
        {
            objLastAnswer.className = "MultiChoiceQA_AnswerFeedback_Hide";
        }
        lastMultiQAFeedback = element;
    }
}
