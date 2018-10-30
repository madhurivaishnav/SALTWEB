/**************************************************
Trivantis (http://www.trivantis.com)
**************************************************/

TTPr.StartInteractions = function( pg )
{
  var intPage = this.findTestPage( pg );
  if( intPage >= 0 && this.arRTPages[intPage].startInteractions() )
    return intPage;

  return -1;
}

TTPr.SetInteraction = function( vn, qidx )
{
  if( qidx >= 0 )
    this.arRTPages[qidx].setInteraction( vn );
}

TTPr.HandleInteractions = function( res, cid, sid, lid, sv, incqt ) 
{ 
  var i;

  for( i = 0; i < this.arRTPages.length; i++ )
    this.arRTPages[i].handleInteractions( res, cid, sid, lid, sv, incqt );

  return;
}

TPPr.startInteractions = function()
{
  if( this.arQues.length == 1 )
  {
    this.dateInt = new Date();
    this.lIntST = this.dateInt.getTime();
    this.lIntET = 0;
    return true;
  }
  else
  {
    this.dateInt = null;
    this.lIntST = 0;
    this.lIntET = 0;
    return false;
  }
}

TPPr.setInteraction = function( vn )
{
  if( this.lIntST > 0 )
  {
    if( this.arQues.length == 1 &&
        this.arQues[0].varName == vn )
    {
      var lEnd = new Date().getTime();

      this.lIntET += (lEnd - this.lIntST);
      this.lIntST = lEnd;
    }
  }
}

TPPr.handleInteractions = function( res, cid, sid, lid, sv, incqt )
{
  var i;

  for( i = 0; i < this.arQues.length; i++ )
  {
    this.arQues[i].handleInteractions( res, cid, sid, lid, this.lIntET, this.dateInt, sv, incqt );
    this.lIntET = 0;
  }
  
  return;
}

function intDateForm( dt, sv )
{
  var res = "" + dt.getFullYear();
  var sep = sv ? "-" : "/";

  res += sep;
  var tmp = dt.getMonth() + 1;
  if( tmp < 10 )
    res += "0";
  res += tmp + sep;
  tmp = dt.getDate();
  if( tmp < 10 )
    res += "0";
  res += tmp;
  return res;
}

function intTimeForm( dt, bDt )
{
  var res = "";
  var sep = ":";
  var tmp;

  if( bDt )
    tmp = dt.getHours();
  else
  {
    tmp = parseInt(dt/3600000, 10);
    dt -= tmp * 3600000;
  }
  if( tmp < 10 )
    res += "0";
  res += tmp + sep;
  if( bDt )
    tmp = dt.getMinutes();
  else
  {
    tmp = parseInt(dt/60000, 10);
    dt -= tmp * 60000;
  }
  if( tmp < 10 )
    res += "0";
  res += tmp + sep;
  if( bDt )
    tmp = dt.getSeconds();
  else
    tmp = parseInt(dt/1000, 10);
  if( tmp < 10 )
    res += "0";
  res += tmp;
    
  return res;
}

var letArr = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";

function limitEscape( str )
{
  var tmp;
  while( 1 )
  {
    tmp = unescape(HtmlEscape(str));
    if( tmp.length > 255 )
      str = str.substring( 0, str.length-1 );
    else
      break;
  }
  return str;
}

TQPr.handleInteractions = function( res, cid, sid, lid, el, di, sv, incqt )
{
  if( this.type == UNK ) return res.str;
  
  var strID = null;
  var strIDSave = null;
  var strTimeID	= null;
  var strType = null;
  var strCorrect = null;
  var strAnswer = null;
  var strResult = null;
  var strLatency = null;
  var dateString = null;
  var timeString = null;
  var strTempAnswer = null;
  var strTempCorrect = null;
  var strTemp = null;
  var strTempCurr = null;
  var posStart = 0;
  var posEnd = 0;
  var bGradeable;
  var maxNum = 1;
  var numChoices = 0;
  var loc = 0;
  var loc2 = 0;
  var i;
  var numC;
  var numA;
  var bGradeInd = false;
  var iResult;
  var now = new Date();
  var lTime = now.getTime();
  var subIdx;
  var bChSel = false;
  var bChCor = false;

  if( (this.type == MT || this.type == DD || this.type == MC || this.type == HS) && this.bGradeInd )
  {
    if(this.type == MC || this.type == HS)
      maxNum = this.arChoices.length;
    else
    {
      for( loc = this.corrAns.indexOf( ',' ); loc != -1; loc = this.corrAns.indexOf( ',', loc+1) )
        maxNum++;
    }

    bGradeInd = true;

    el /= maxNum;
  }

  strID     = this.name + "_";
  strIDSave = strID.replace(/ /g, '_');
  strID     = strIDSave.replace(/'/g, '_' );
  strIDSave = strID.replace(/"/g, '_');

  strTimeID = lTime;

  for( subIdx = 0; subIdx < maxNum; subIdx++ )
  {
    strID = strIDSave;
    bGradeable = true;

    switch( this.type )
    {
      case TF:
        strType     = "true-false";
        if( sv >= 2004 )
        {
          strCorrect = this.corrAns.toLowerCase();
          strAnswer  = this.strOurAns.toLowerCase();
        }
        else
        {
          strCorrect  = this.corrAns;
          strAnswer   = this.strOurAns;
        }
        strID += this.id;
        break;

      case LK:
      case OR:
        if( this.type == OR )
          strType = "sequencing";
        else
          strType     = "likert";
        strCorrect  = "n/a";
        strAnswer   = this.strOurAns;
        strID      += this.id;
        break;
        
      case MC:
      case HS:
        strType = "choice";

        if( ( this.bAllowMult || this.type == OR )  && sv == 0 )
        {
          strCorrect  = "{";
          strAnswer   = "{";
        }
        else
        {
          strCorrect  = "";
          strAnswer   = "";
        }

        numChoices = 1;
        for( loc = this.choices.indexOf( '|' ); loc != -1; loc = this.choices.indexOf( '|', loc+1) )
          numChoices++;

        strTempAnswer  = addDelimeter( this.arChoices, this.strOurAns, "|||");
        strTempCorrect = addDelimeter( this.arChoices, this.corrAns, "|||");
   

        if( this.type == OR )
        {
          for( j = 0; j < numChoices; j++ )
          {
            posEnd = strTempAnswer.indexOf( ',', posStart+1 );
            if( posEnd != -1 )
              strTempCurr = strTempAnswer.substring( posStart, posEnd+1 );
            else
              strTempCurr = "";
            
            loc = 0;
            for( i = 0; i < numChoices; i++ )
            {
              loc2 = this.choices.indexOf( '|', loc );
              if( loc2 >= 0 )
                strTemp = "|||" + this.choices.substring( loc, loc2 ) + "|||";
              else
                strTemp = "|||" + this.choices.substring( loc ) + "|||";

              if( strTemp == strTempCurr )
              {
                if( strAnswer.length > 0 )
                {
                  if( sv >= 2004 )
                    strAnswer += "[,]";
                  else
                    strAnswer += ",";
                }

                strAnswer += letArr.charAt(i);
                break;
              }
              loc = loc2 + 1;
            }
            
            posStart = posEnd;
          }
        }
        else
        {
          if( bGradeInd && (this.type == MC || this.type == HS) )
          {
            bChSel = IsChoiceSelected( this.arChoices[subIdx], this.strOurAns );
            bChCor = this.isCorrectSub( this.arChoices[subIdx] );
            if( bChSel )
              strAnswer += letArr.charAt(subIdx);
            else
              strAnswer += "";
            if( bChCor )
              strCorrect += letArr.charAt(subIdx);
          }
          else
          {
            loc = 0;
            for( i = 0; i < numChoices; i++ )
            {
              loc2 = this.choices.indexOf( '|', loc );
              if( loc2 >= 0 )
                strTemp = "|||" + this.choices.substring( loc, loc2 ) + "|||";
              else
                strTemp = "|||" + this.choices.substring( loc ) + "|||";
  
              if( strTempCorrect.indexOf( strTemp ) >= 0 )
              {
                if( strCorrect.length > 0 )
                {
                  if( this.bAllowMult && sv >= 2004 )
                    strCorrect += "[,]";
                  else
                    strCorrect += ",";
                }
                strCorrect += letArr.charAt(i);
              }
  
              if( strTempAnswer.indexOf( strTemp ) >= 0 )
              {
                if( strAnswer.length > 0 )
                {
                  if( ( this.bAllowMult || this.type == OR ) && sv >= 2004 )
                    strAnswer += "[,]";
                  else
                    strAnswer += ",";
                }
  
                strAnswer += letArr.charAt(i);
              }
              loc = loc2 + 1;
            }
          }
        }

        if( ( this.bAllowMult || this.type == OR ) && sv == 0)
        {
          strCorrect += "}";
          strAnswer += "}";
        }

        if( bGradeInd && (this.type == MC || this.type == HS) )
          strID += this.id + "-" + ( subIdx + 1 );
        else
          strID += this.id;
        break;

      case FB:
        strType = "fill-in";
        loc = this.corrAns.indexOf( '|' );
        if( loc >= 0 )
          strCorrect = this.corrAns.substring( 0, loc );
        else
          strCorrect = this.corrAns;
        strAnswer = this.strOurAns;
        strID += this.id;
        break;

      case SA:
      case ES:
        strType = "fill-in";
        strCorrect = "n/a";
        strAnswer = this.strOurAns;
        strID += this.id;
        bGradeable = false;
        break;

      case MT:
      case DD:
        strType = "matching";
        strAnswer = "";

        strTempAnswer = ",";
        strTempAnswer += this.strOurAns;

        if( bGradeInd )
        {
          strCorrect = ( subIdx + 1 );
          if( sv >= 2004 )
            strCorrect += "[.]";
          else
            strCorrect += ".";
          strCorrect += letArr.charAt(subIdx);

          strTemp = "," + ( subIdx + 1 ) + "-";
          loc = strTempAnswer.indexOf( strTemp );
          if( loc >= 0 )
          {
            strTemp = strTempAnswer.substring( loc + strTemp.length );
            loc     = strTemp.indexOf( "," );
            if( loc >= 0 )
              strTemp = strTemp.substring( 0, loc );


            strAnswer = ( subIdx + 1 );
            if( sv >= 2004 )
              strAnswer += "[.]";
            else
              strAnswer += ".";
            strAnswer += letArr.charAt((parseInt(strTemp, 10)-1));


          }
          else if ( sv >= 2004 )
            strAnswer = "0[.]0";
          strID += this.id + "-" + ( subIdx + 1 );
        }
        else
        {
          if( sv > 0 )
            strCorrect = "";
          else
            strCorrect = "{";

          numChoices = 1;
          for( loc = this.choices.indexOf( '|' ); loc != -1; loc = this.choices.indexOf( '|', loc+1) )
            numChoices++;

          numA = 0;
          for( index = 0; index < numChoices; index++ )
          {
            if( index > 0 )
            {
              if( sv >= 2004 )
                strCorrect += "[,]";
              else
                strCorrect += ",";
            }

            strTemp = ( index + 1 );
            if( sv >= 2004 )
              strTemp += "[.]";
            else
              strTemp += ".";
            strTemp += letArr.charAt(index);

            strCorrect += strTemp;

            strTemp = "," + ( index + 1 ) + "-";
            loc = strTempAnswer.indexOf( strTemp );
            if( loc >= 0 )
            {
              strTemp = strTempAnswer.substring( loc + strTemp.length );
              loc     = strTemp.indexOf( "," );
              if( loc >= 0 )
                strTemp = strTemp.substring( 0, loc );

              var letter = letArr.charAt(parseInt(strTemp, 10)-1);
              strTemp = index + 1;
              if( sv >= 2004 )
                strTemp += "[.]";
              else
                strTemp += ".";
              strTemp += letter;
            }
            else 
            {
              if( sv >= 2004 )
                strTemp = "0[.]0";
              else
                strTemp = "";
            }

            if( numA == 0 )
            {
              if( sv == 0 )
                strAnswer = "{";
              else
                strAnswer = "";
            }
            else
            {
              if( sv >= 2004 )
                strAnswer += "[,]";
              else
                strAnswer += ",";
            }

            strAnswer += strTemp;


            numA++;
          }

          if( sv == 0 )
          {
            strCorrect += "}";
            if( numA > 0 )
              strAnswer += "}";
          }
 
          strID += this.id;
        }
        break;

      default:
        strType     = "";
        strCorrect  = "";
        strAnswer   = "";
        break;
    }
    
    if( this.bSurvey )
    {
      if( this.type == TF )
      {
        if( sv >= 2004 )
          strCorrect = "true";
        else
          strCorrect = "t";
      }
      else if( this.type == MC || this.type == HS )
        strCorrect = "a";
      else
        strCorrect = "n/a";
      bGradeable = false;
    }

    strID += "_";
    strID += strTimeID;

    if( bGradeable )
    {
      if( bGradeInd ) 
      {
        if( this.type == MC || this.type == HS )
        {
          if( (bChSel && bChCor) || (!bChSel && !bChCor) )
            iResult = 1;
          else
            iResult = 0;
        }
        else
        {
          strTemp = GetMatchingPairStr( subIdx, this.strOurAns );

          iResult = this.isCorrect( subIdx, strTemp );
        }
      }
      else
        iResult = this.isCorrect();

      if( iResult != 0 )
        strResult = "correct";
      else
      {
        if( sv >= 2004 )
          strResult = "incorrect";
        else
          strResult = "wrong";
      }
    }
    else
      strResult = "neutral";

    if( di != null )
    { 
      if( sv >= 2004 )
      {
        timeString = intDateForm( di, 1 );
        timeString += "T";
        timeString += intTimeForm( di, 1 );
      }
      else
        timeString = intTimeForm( di, 1 );
      dateString = intDateForm( di, 0 );
    }
    else
    {
      var nowDateString = intDateForm( now, 0 );
      var nowTimeString;

      if( sv >= 2004 )
      {
        nowTimeString = intDateForm( now, 1 );
        nowTimeString += "T";
        nowTimeString += intTimeForm( now, 1 );
      }
      else
        nowTimeString = intTimeForm( now, 1 );
      timeString = nowTimeString;
      dateString = nowDateString;
    }

    if( di == null )
      strLatency = "";
    else
      strLatency = intTimeForm( el, 0 );
    
	if(bGradeInd && strCorrect.length == 0)
	  strCorrect = "";
    else if( strCorrect == null || strCorrect.length == 0 )
	  strCorrect = "n/a";
	    
    if( sv >= 2004 &&
       (this.type == MT || this.type == DD))
      ;
    else
      strCorrect = limitEscape( strCorrect );
      
    strCorrect = unescape( HtmlEscape( strCorrect ) );
    strCorrect = convJS( strCorrect );
    
    if( strAnswer != null && strAnswer.length > 0)
    {
      if( sv >= 2004 &&
         (this.type == MT || this.type == DD))
        ;
      else
        strAnswer = limitEscape( strAnswer );
        
      strAnswer = unescape( HtmlEscape( strAnswer ) );
      strAnswer = convJS( strAnswer );
    }
    
    strTemp = null;
    if( incqt )
    {
      strTemp = this.text;
      if( strTemp != null && strTemp.length > 0)
      {
        strTemp = unescape( HtmlEscape( strTemp ) );
        strTemp = convJS( strTemp );
      }
    }
    
    strResult = unescape( HtmlEscape( strResult ) );

    if( sv > 0 ) {

	  var strQuestion = this.text;
      putSCORMInteractions( strID, null, timeString, strType, strCorrect, this.weight, strAnswer, strResult, strLatency, strTemp, strQuestion );
    } else {
      if( res.str.length == 0 )
      {
        res.add( "\"course_id\",\"student_id\",\"lesson_id\",\"date\",\"time\",\"interaction_id\",\"objective_id\",\"type_interaction\",\"correct_response\",\"student_response\",\"result\",\"weighting\",\"latency\"" );
        if( incqt )
          res.add( ",\"text\"" );
        res.add( "\n" );
      }
      res.add( "\"" + cid + "\"," );
      res.add( "\"" + sid + "\"," );
      res.add( "\"" + lid + "\"," );
      res.add( "\"" + dateString + "\"," );
      res.add( "\"" + timeString + "\"," );
      res.add( "\"" + strID + "\"," );
      res.add( "\"" + "\"," );
      res.add( "\"" + strType + "\"," );
      res.add( "\"" + strCorrect + "\"," );
      res.add( "\"" + strAnswer + "\"," );
      res.add( "\"" + strResult + "\"," );
      res.add( "\"" + this.weight + "\"," );
      res.add( "\"" + strLatency + "\""  );
      if( incqt )
        res.add( ",\"" + strTemp + "\"" );
      res.add( "\n" );
    }
  }

  return res.str;
}
