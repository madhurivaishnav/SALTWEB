// Version Beta 1
// Created by Tim Kindberg
// Trivantis CDS 

/*// OPTIONS
var SpeedMultiplier = 100; //ms - higher number = slower transitions, relative to lectora transition speed setting

var FlyRightDistance = 200; //px
var FlyLeftDistance = 200; //px
var FlyTopDistance = 200; //px
var FlyBottomDistance = 200; //px

var MoveToEase = "easeOutQuad";
var FadeInEase = "easeOutQuad";
var FadeOutEase = "easeOutQuad";
var FlyInRightEase = "easeOutQuad";
var FlyOutRightEase = "easeOutQuad";
var FlyInLeftEase = "easeOutQuad";
var FlyOutLeftEase = "easeOutQuad";
var FlyInTopEase = "easeOutQuad";
var FlyOutTopEase = "easeOutQuad";
var FlyInBottomEase = "easeOutQuad";
var FlyOutBottomEase = "easeOutQuad";
var FlyInTopRightEase = "easeOutQuad";
var FlyOutTopRightEase = "easeOutQuad";
var FlyInTopLeftEase = "easeOutQuad";
var FlyOutTopLeftEase = "easeOutQuad";
var FlyInBottomRightEase = "easeOutQuad";
var FlyOutBottomRightEase = "easeOutQuad";
var FlyInBottomLeftEase = "easeOutQuad";
var FlyOutBottomLeftEase = "easeOutQuad";
var WipeDownInEase = "easeOutQuad";
var WipeDownOutEase = "easeOutQuad";*/

/**
 * Create a fake console api, mimicing Firebug.
*/
(function(global) {
    var noop = function(){};
    if ( !global['console'] ) {
        global.console = {
            log : noop,
            debug : noop,
            info : noop,
            warn : noop,
            error : noop,
            assert : noop,
            clear : noop,
            dir : noop,
            dirxml : noop,
            trace : noop,
            group : noop,
            groupCollapsed : noop,
            groupEnd : noop,
            time: noop,
            timeEnd: noop,
            profile: noop,
            profileEnd: noop,
            count: noop,
            exception: noop,
            table: noop
        }
    }
})(window);

/*Transition Numbers:*/
{
	var TRANS_BOX_IN=	        0,
		TRANS_BOX_OUT=	            1,
		TRANS_CIRCLE_IN=	        2,
		TRANS_CIRCLE_OUT=	        3,
		TRANS_WIPE_UP=	            4,
		TRANS_WIPE_DOWN=            5,
		TRANS_WIPE_RIGHT=	        6,
		TRANS_WIPE_LEFT=	        7,
		TRANS_BLINDS_VERTICAL=	    8,
		TRANS_BLINDS_HORIZONTAL=    9,
		TRANS_CHECKER_ACROSS=	    10,
		TRANS_CHECKER_DOWN=	        11,
		TRANS_DISSOLVE=	            12,
		TRANS_SPLITIN_VERTICAL=	    13,
		TRANS_SPLITOUT_VERTICAL=	14,
		TRANS_SPLITIN_HORIZONTAL=	15,
		TRANS_SPLITOUT_HORIZONTAL=	16,
		TRANS_STRIPS_DOWNLEFT=	    17,
		TRANS_STRIPS_UPLEFT=	    18,
		TRANS_STRIPS_DOWNRIGHT=	    19,
		TRANS_STRIPS_UPRIGHT=	    20,
		TRANS_HORIZONTAL_BARS=	    21,
		TRANS_VERTICAL_BARS=	    22,
		TRANS_FLY_TOP=	            23,
		TRANS_FLY_TOPRIGHT=	        24,
		TRANS_FLY_RIGHT=	        25,
		TRANS_FLY_BOTTOMRIGHT=	    26,
		TRANS_FLY_BOTTOM=	        27,
		TRANS_FLY_BOTTOMLEFT=	    28,
		TRANS_FLY_LEFT=	            29,
		TRANS_FLY_TOPLEFT_AND_MOVETO=30,
		TRANS_RANDOM_EFFECT=	    31,
		TRANS_RANDOM_NOFLY_EFFECT=	32,
		TRANS_APPEAR=               33;
}

var myTransFn = ObjLayer.prototype.doTrans;
var myGrowToFn = ObjLayer.prototype.growTo;

ObjLayer.prototype.growTo = function(ew,eh,amt,spd,fn,po) {

	var thisLyrObj = this;
	var thisObj =  $("#" + this.id);

	// growTo seems to use amt for the duration var
	dur = amt * SpeedMultiplier;

	thisObj.animate({
		width:ew,
		height:eh
	}, {
		duration:dur,
		easing:SizeToEase,
		step: function(now, fx) {
			var newW = po.w;
			var newH = po.h;

			if(fx.prop == "width"){
				newW = now;
			}else if(fx.prop == "height"){
				newH = now;
			}
			po.sizeTo(newW, newH);
		},
		queue:false,
		complete:executeCallbackFn
	});

	function executeCallbackFn(){
		if (fn) {
			fn = fn.replace(/\\/g, "")
			var myFn = new Function(fn);
			myFn();
		}
	}
}

ObjLayer.prototype.doTrans = function(tOut,tNum,dur,fn,ol,ot,fl,ft,fr,fb,il){

    var thisLyrObj = this;
    var thisObj =  $("#" + this.id);
    var transIn = tOut == 0;
	var moveToDur = dur * MoveToSpeedMultiplier;
	console.log(dur, MoveToSpeedMultiplier, moveToDur, MoveToEase);

	dur = dur * SpeedMultiplier;

    if (!thisLyrObj.origLeft) thisLyrObj.origLeft = parseInt(thisObj.css("left"));
    if (!thisLyrObj.origTop) thisLyrObj.origTop = parseInt(thisObj.css("top"));

    // Show the Layer Object but then hide it with Jquery so we can show it in a custom way
    if (transIn){
        thisLyrObj.show();
        thisObj.hide();
    }

	//tNum = null;
    switch(tNum){


        // DISSOLVE BECOMES FADE
        case TRANS_DISSOLVE:
        {
            if (transIn) {
                thisObj.fadeIn(dur, FadeInEase, transInComplete);
            }
            else {
                thisObj.fadeOut(dur, FadeOutEase, transOutComplete);
            }
            break;
        }


	    case TRANS_FLY_RIGHT:
	    {
		    if (transIn) {
			    thisObj.animate({
				    left: thisLyrObj.origLeft + FlyRightDistance
			    }, 0);
			    thisObj.animate({
				    opacity:"show",
				    left:thisLyrObj.origLeft
			    }, dur, FlyInRightEase, transInComplete);
		    }
		    else {
			    thisObj.animate({
				    opacity:"hide",
				    left:thisLyrObj.origLeft + FlyRightDistance
			    }, dur, FlyOutRightEase, transOutComplete);
		    }
		    break;
	    }


	    case TRANS_FLY_LEFT:
        {
            if (transIn) {
                thisObj.animate({
                    left: thisLyrObj.origLeft - FlyLeftDistance
                }, 0);
                thisObj.animate({
                    opacity:"show",
                    left:thisLyrObj.origLeft
                }, dur, FlyInLeftEase, transInComplete);
            }
            else {
                thisObj.animate({
                    opacity:"hide",
                    left:thisLyrObj.origLeft - FlyLeftDistance
                }, dur, FlyOutLeftEase, transOutComplete);
            }
            break;
        }


	    case TRANS_FLY_BOTTOM:
        {
            if (transIn) {
                thisObj.animate({
                    top: thisLyrObj.origTop + FlyBottomDistance
                }, 0);
                thisObj.animate({
                    opacity:"show",
                    top:thisLyrObj.origTop
                }, dur, FlyInBottomEase, transInComplete);
            }
            else {
                thisObj.animate({
                    opacity:"hide",
                    top:thisLyrObj.origTop + FlyBottomDistance
                }, dur, FlyOutBottomEase, transOutComplete);
            }
            break;
        }


	    case TRANS_FLY_TOP:
        {
            if (transIn) {
                thisObj.animate({
                    top: thisLyrObj.origTop - FlyTopDistance
                }, 0);
                thisObj.animate({
                    opacity:"show",
                    top:thisLyrObj.origTop
                }, dur, FlyInTopEase, transInComplete);
            }
            else {
                thisObj.animate({
                    opacity:"hide",
                    top:thisLyrObj.origTop - FlyTopDistance
                }, dur, FlyOutTopEase, transOutComplete);
            }
            break;
        }


	    case TRANS_FLY_TOPRIGHT:
        {
	        if (transIn) {
		        thisObj.animate({
			        top: thisLyrObj.origTop - FlyTopDistance,
			        left: thisLyrObj.origLeft + FlyRightDistance
		        }, 0);
		        thisObj.animate({
			        opacity:"show",
			        top:thisLyrObj.origTop,
			        left:thisLyrObj.origLeft
		        }, dur, FlyInTopRightEase, transInComplete);
	        }
	        else {
		        thisObj.animate({
			        opacity:"hide",
			        top:thisLyrObj.origTop - FlyTopDistance,
			        left:thisLyrObj.origLeft + FlyRightDistance
		        }, dur, FlyOutTopRightEase, transOutComplete);
	        }
	        break;
        }


	    case TRANS_FLY_TOPLEFT_AND_MOVETO:
        {
	        if(fr > 0 || fb > 0){
		        // FLY TOPLEFT
		        if (transIn) {
			        thisObj.animate({
				        top: thisLyrObj.origTop - FlyTopDistance,
				        left: thisLyrObj.origLeft - FlyLeftDistance
			        }, 0);
			        thisObj.animate({
				        opacity:"show",
				        top:thisLyrObj.origTop,
				        left:thisLyrObj.origLeft
			        }, dur, FlyInTopLeftEase, transInComplete);
		        }
		        else {
			        thisObj.animate({
				        opacity:"hide",
				        top:thisLyrObj.origTop - FlyTopDistance,
				        left:thisLyrObj.origLeft - FlyLeftDistance
			        }, dur, FlyOutTopLeftEase, transOutComplete);
		        }
	        }else{
		        // MOVE TO
		        thisObj.animate({
			        top:ft,
			        left:fl
		        }, {
			        duration:moveToDur,
			        easing:MoveToEase,
			        complete:executeCallbackFn,
			        queue:false
		        });
	        }
	        break;
        }


	    case TRANS_FLY_BOTTOMRIGHT:
        {
	        if (transIn) {
		        thisObj.animate({
			        top: thisLyrObj.origTop + FlyBottomDistance,
			        left: thisLyrObj.origLeft + FlyRightDistance
		        }, 0);
		        thisObj.animate({
			        opacity:"show",
			        top:thisLyrObj.origTop,
			        left:thisLyrObj.origLeft
		        }, dur, FlyInBottomRightEase, transInComplete);
	        }
	        else {
		        thisObj.animate({
			        opacity:"hide",
			        top:thisLyrObj.origTop + FlyBottomDistance,
			        left:thisLyrObj.origLeft + FlyRightDistance
		        }, dur, FlyOutBottomRightEase, transOutComplete);
	        }
	        break;
        }


	    case TRANS_FLY_BOTTOMLEFT:
        {
	        if (transIn) {
		        thisObj.animate({
			        top: thisLyrObj.origTop + FlyBottomDistance,
			        left: thisLyrObj.origLeft - FlyLeftDistance
		        }, 0);
		        thisObj.animate({
			        opacity:"show",
			        top:thisLyrObj.origTop,
			        left:thisLyrObj.origLeft
		        }, dur, FlyInBottomLeftEase, transInComplete);
	        }
	        else {
		        thisObj.animate({
			        opacity:"hide",
			        top:thisLyrObj.origTop + FlyBottomDistance,
			        left:thisLyrObj.origLeft - FlyLeftDistance
		        }, dur, FlyOutBottomLeftEase, transOutComplete);
	        }
	        break;
        }

	    case TRANS_WIPE_DOWN:
	    {
		    if (transIn) {
			    thisObj.slideDown(dur, WipeDownInEase, transInComplete);
		    }
		    else {
			    thisObj.slideUp(dur, WipeDownOutEase, transOutComplete);
		    }
		    break;
	    }


	    default:
        {
            // Default to regular transition execution
            myTransFn.apply(thisLyrObj, arguments);
        }
    }

    // Have to set the visibility to hidden whenever a transition out is completed
    function transInComplete(){
	    if (fn) {
		    //eval(fn);
		    fn = fn.replace(/\\/g, "")
		    var myFn = new Function(fn);
		    myFn();
	    }
    }

    // Have to set the visibility to hidden whenever a transition out is completed
    function transOutComplete(){

        if( thisLyrObj.styObj ) {
	        thisLyrObj.styObj.visibility = (is.ns4)? "hide" : "hidden";
        }

        thisObj.animate({
            top: thisLyrObj.origTop,
            left: thisLyrObj.origLeft
        }, 0);

	    executeCallbackFn();
    }
	function executeCallbackFn(){
		if (fn) {
			fn = fn.replace(/\\/g, "")
			var myFn = new Function(fn);
			myFn();
			//eval(fn);
		}
	}
}

