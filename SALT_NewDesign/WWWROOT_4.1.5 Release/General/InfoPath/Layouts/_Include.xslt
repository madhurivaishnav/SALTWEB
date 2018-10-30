<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<xsl:param name = "PageID" select = "''"></xsl:param>
	<!-- Lesson parameters -->
	<xsl:param name = "PageIndex" select = "''"></xsl:param>
	<xsl:param name = "PageCount" select = "''"></xsl:param>
	<!-- Quiz parameters -->
	<xsl:param name = "QuestionIndex" select = "''"></xsl:param>
	<xsl:param name = "QuestionCount" select = "''"></xsl:param>
	<xsl:param name = "SelectedAnswer" select = "''"></xsl:param>
	<xsl:param name = "Preview" select = "''"></xsl:param>
	
	<!-- Language translation params -->
	<xsl:param name = "QuestionText" select = "''"></xsl:param>
	<xsl:param name = "OfText" select = "''"></xsl:param>
	<xsl:param name = "HomeText" select = "''"></xsl:param>
	<xsl:param name = "QuickFactsText" select = "''"></xsl:param>
	
	<xsl:param name = "PageText" select = "''"></xsl:param>
	<xsl:param name = "ExitPreviewText" select = "''"></xsl:param>
	<xsl:param name = "ExitText" select = "''"></xsl:param>
	<xsl:param name = "NextText" select = "''"></xsl:param>
	<xsl:param name = "PreviousText" select = "''"></xsl:param>
	<xsl:param name = "DisclaimerText" select = "''"></xsl:param>
	<xsl:param name = "PreviewModeText" select = "''"></xsl:param>
	<xsl:param name = "NextAltText" select = "''"></xsl:param>
	<xsl:param name = "PreviousAltText" select = "''"></xsl:param>
    
    <!-- Page and PageElement layout are specified by each layout xslt file -->
    <xsl:template match="TextBox|Graphic|FreeTextQA|MultiChoiceQA|TextGraphic|ExtraInfo|EndLesson|NumberOfQuestions|MeetThePlayer|SubmitAnswers|TOC|Question|ShowAllPlayers">
		<xsl:value-of select="." disable-output-escaping="yes"/>
    </xsl:template>

	<!-- Navigation Elements -->    
     <xsl:template name="PageHeader">
        <table class="PageHeader" border="0" cellpadding="0" cellspacing="0">
            <tr>
                <td class="PageHeaderTitleImage">
                    <xsl:call-template name="Space"/>
                </td>
                <td class="PageHeaderTitle" nowrap="true">
                    <xsl:value-of select="/*/Summary/Title"/>
                </td>
            </tr>
        </table>
     </xsl:template>
     
     <xsl:template name="PageTitle">
    	<div class="PageTitle">
			<xsl:choose>
				<xsl:when test="PageElement/Question"><xsl:value-of select="$QuestionText"/>&#160;<xsl:value-of select="$QuestionIndex"/>&#160;<xsl:value-of select="$OfText"/>&#160;<xsl:value-of select="$QuestionCount"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="../Title"/></xsl:otherwise>
			</xsl:choose>
			<br/><br/>
        </div>
	</xsl:template>
     
  
    <xsl:template name="ButtonHome">
        <div class="Navigation_Button_General">
            <a href="javascript:__doPostBack('Home_Click','')"><xsl:value-of select="$HomeText"/></a>
        </div>
    </xsl:template>
    
    <xsl:template name="ButtonQuickFacts">
        <div class="Navigation_Button_General">
            <xsl:element name="a">
            <xsl:attribute name="href">javascript: void window.open('qfs.html')</xsl:attribute>
                <xsl:value-of select="$QuickFactsText"/>
            </xsl:element>
        </div>
    </xsl:template>

    <xsl:template name="ButtonExitLesson">
        <div class="Navigation_Button_General">
            <xsl:choose>
                <xsl:when test="$Preview='true'">
                    <a href="javascript:window.close();"><xsl:value-of select="$ExitPreviewText"/></a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="javascript:__doPostBack('Exit_Click','');"><xsl:value-of select="$ExitText"/></a>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template name="ButtonExitQuiz">
        <div class="Navigation_Button_General">
            <xsl:choose>
                <xsl:when test="$Preview='true'">
                    <a href="javascript:window.close();"><xsl:value-of select="$ExitPreviewText"/></a>
                </xsl:when>
                <xsl:otherwise>
                    <a href="javascript:confirmExit()"><xsl:value-of select="$ExitText"/></a>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>
    
    
    <xsl:template name="ButtonPrevious">
		<!-- If the page is the not first page, show the Previous button  -->
		<xsl:if test="count(//Page[@ID=$PageID]/preceding::Page)>0">
			<div id="divPrevious">
				<a id="btnPrevious" href="javascript:__doPostBack('Previous_Click','');">
				    <img src="/General/Images/InfoPath/Previous_button.gif" border="0" alt="{$PreviousAltText}"/>
				</a>
			</div>
		</xsl:if>
    </xsl:template>

<xsl:template name="ButtonNext">
	<!-- If the page is not the last page, show the Next button  -->
	<xsl:if test="count(//Page[@ID=$PageID]/following::Page)>0">
		<div id="divNext">
			<!-- If the page is a question, hide the Next button, otherwise show the button -->
			<xsl:attribute name="class">
			<xsl:choose>
				<xsl:when test="//Page[@ID=$PageID]/PageElements/PageElement/Question">Navigation_Button_General_Invisible</xsl:when>
				<xsl:otherwise>Navigation_Button_General</xsl:otherwise>
			</xsl:choose>
			</xsl:attribute>
			<a id="btnNext" href="javascript:__doPostBack('Next_Click','');">
				<img src="/General/Images/InfoPath/Next_button.gif" border="0" alt="{$NextAltText}"/>
			</a>
		</div>
	</xsl:if>
</xsl:template>

    <xsl:template name="PageCount">
	    <xsl:value-of select="$PageText"/>&#160;<xsl:value-of select="$PageIndex+1"/>&#160;<xsl:value-of select="$OfText"/>&#160;<xsl:value-of select="$PageCount"/>
    </xsl:template>

    <xsl:template name="Copyright">
		<div class="Copyright">
			<xsl:text disable-output-escaping="yes"><![CDATA[&copy;]]></xsl:text>2013 GRC Solutions
		</div>
    </xsl:template>

    <xsl:template name="Disclaimer">
		<div class="Navigation_Button_General">
			<a href="/Disclaimer.html" target="_blank"><xsl:value-of select="$DisclaimerText"/></a>
		</div>
    </xsl:template>
     
    <xsl:template name="ButtonSpacer">
        <xsl:choose>
            <xsl:when test="$Preview='true'">
                <div class="PreviewModeWarning"><xsl:value-of select="$PreviewModeText"/></div>
            </xsl:when>
            <xsl:otherwise>&#160;</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="Space">
        <xsl:text disable-output-escaping="yes">
            <![CDATA[&nbsp;]]>
        </xsl:text>
    </xsl:template>

    
</xsl:stylesheet>