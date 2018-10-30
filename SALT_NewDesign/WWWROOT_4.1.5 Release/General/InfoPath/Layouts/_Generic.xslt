<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" omit-xml-declaration="yes" indent="yes"/>
	<!-- Generic layout stylesheet -->
    <xsl:template name="GenericLessonLayout">
        <table class="Main_Table" id="Main_Table" align="center" cellpadding="0" cellspacing="0" border="0">
                <tr class="Main_Table_Top_Row">
                    <td valign="top">
                        <xsl:call-template name="GenericLessonHeader"/>
                    </td>
                </tr>
                <tr class="Main_Table_Content_Row">
                    <td valign="top">
						<xsl:apply-templates select="//Page[@ID=$PageID]" />
                    </td>
                </tr>
                <tr>
                    <td class="Main_Table_Navigation">
                        <xsl:call-template name="GenericLessonFooter"/>
                    </td>
               </tr>
         </table>
    </xsl:template>

    <xsl:template name="GenericQuizLayout">
        <table class="Main_Table" id="Main_Table" align="center" cellpadding="0" cellspacing="0" border="0">
                <tr class="Main_Table_Top_Row">
                    <td valign="top">
                        <xsl:call-template name="GenericQuizHeader"/>
                    </td>
                </tr>
                <tr class="Main_Table_Content_Row">
                    <td valign="top">
						<xsl:apply-templates select="//Page[@ID=$PageID]" />
                    </td>
                </tr>
                <tr>
                    <td class="Main_Table_Navigation">
                        <xsl:call-template name="GenericQuizFooter"/>
                    </td>
               </tr>
         </table>
    </xsl:template>
    
    
    <!-- Headers  -->
    <xsl:template name="GenericLessonHeader"> 
		<!-- Page Header -->
		<xsl:call-template name="PageHeader"/>			
        <!-- Navigation Section -->
        <table class="TopNavBar" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td width="20px" align="center" nowrap="true">
                    <xsl:call-template name="Space"/>
                </td>
                <td nowrap="true" class="PageCount">
                    <xsl:call-template name="PageCount"/>
                </td>
                <td width="100%" align="center">
                    <xsl:call-template name="ButtonSpacer"/>
                </td>
                <td class="ButtonHome">
                    <xsl:call-template name="ButtonHome"/>
                </td>
                <td class="ButtonQuickFacts">
                    <xsl:call-template name="ButtonQuickFacts"/>
                </td>
                <td class="ButtonDisclaimer">
                    <xsl:call-template name="Disclaimer"/>
                </td>
                 
                <td class="ButtonExit">
                    <xsl:call-template name="ButtonExitLesson"/>
                </td>
            </tr>
        </table>
    </xsl:template>
    
    <xsl:template name="GenericQuizHeader">   
		<!-- Page Header -->
		<xsl:call-template name="PageHeader"/>				
        <!-- Navigation Section -->
        <table class="TopNavBar" cellpadding="0" cellspacing="0" border="0">
            <tr>
                <td width="100%" align="center">
                    <xsl:call-template name="ButtonSpacer"/>
                </td>
                <td class="ButtonHome">
                    <xsl:call-template name="ButtonHome"/>
                </td>
                <td class="ButtonDisclaimer">
                    <xsl:call-template name="Disclaimer"/>
                </td>
                <td class="ButtonExit">
                    <xsl:call-template name="ButtonExitQuiz"/>
                </td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template name="GenericLessonFooter"> 
        <!-- Navigation Section -->
        <table width="100%" cellpadding="0" cellspacing="0">
			<tr>
			    <td width="80%" align="center"> 
					<xsl:call-template name="Copyright"/>
				</td>
				<td width="10%" align="left">
				    <xsl:call-template name="ButtonPrevious"/>
				</td>
				<td width="10%" align="right">
				    <xsl:call-template name="ButtonNext"/>
				</td>
			</tr>
		</table>
    </xsl:template>

    <xsl:template name="GenericQuizFooter"> 
        <!-- Navigation Section -->
        <table width="100%" cellpadding="0" cellspacing="0">
		<tr>
			<tr>
			    <td width="80%" align="center"> 
					<xsl:call-template name="Copyright"/>
				</td>
				<td width="10%" align="left">
				    <xsl:call-template name="ButtonPrevious"/>
				</td>
				<td width="10%" align="right">
				    <xsl:call-template name="ButtonNext"/>
				</td>
			</tr>
		</tr>
		</table>
    </xsl:template>
</xsl:stylesheet>

  