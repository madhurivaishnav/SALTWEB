@echo off
copy "C:\Projects\Salt\InfopathToWord\GO.BAT" "C:\Projects\Salt\InfopathToWord\bin\Release\"
copy "C:\Projects\Salt\InfopathToWord\Lesson.Xml" "C:\Projects\Salt\InfopathToWord\bin\Release\"
copy "C:\Projects\Salt\InfopathToWord\XSL\Transform.Xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_MultiChoiceQA.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_FreeTextQA.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_EndLesson.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_ShowAllPlayers.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_Graphic.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_TextGraphic.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_ExtraInfo.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_TextBox.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_MeetThePlayer.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_Question.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL
copy "C:\Projects\Salt\InfopathToWord\XSL\PageElement_SubmitAnswers.xsl" "C:\Projects\Salt\InfopathToWord\bin\Release\"XSL



 


if errorlevel 1 goto CSharpReportError
goto CSharpEnd
:CSharpReportError
echo Project error: A tool returned an error code from the build event
exit 1
:CSharpEnd