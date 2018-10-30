<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
    <xsl:output indent="yes" />
    <xsl:include href="PageElement_MultiChoiceQA.xsl" />
    <xsl:include href="PageElement_FreeTextQA.xsl" />
    <xsl:include href="PageElement_Graphic.xsl" />
    <xsl:include href="PageElement_EndLesson.xsl" />
    <xsl:include href="PageElement_ShowAllPlayers.xsl" />
    <xsl:include href="PageElement_MeetThePlayer.xsl" />
    <xsl:include href="PageElement_TextGraphic.xsl" />
    <xsl:include href="PageElement_ExtraInfo.xsl" />
    <xsl:include href="PageElement_TextBox.xsl" />
    <xsl:include href="PageElement_Question.xsl" />
    <xsl:include href="PageElement_SubmitAnswers.xsl" />
    
    <xsl:template match="/BDWInfoPathLesson|/BDWInfoPathQuiz">
        <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format">
            
            <!-- Setup Layout -->
            <fo:layout-master-set>
                <fo:simple-page-master master-name="A4" page-height="29.7cm" page-width="21cm" margin-top="1cm" margin-bottom="1cm" margin-left="1cm" margin-right="1cm">
                    <fo:region-body />
                </fo:simple-page-master>
            </fo:layout-master-set>
            
            <!-- Table of Contents -->
            <xsl:call-template name="ContentSummary" />
            <xsl:call-template name="TableOfContents" />
            
            <!-- Pages/Page or Question/Page or Intro/Page etc -->
            <xsl:for-each select="*/Page">
                <xsl:call-template name="PageDetail" />
            </xsl:for-each>
        </fo:root>
    </xsl:template>
    
    <xsl:template name="ContentSummary">
        <fo:page-sequence master-reference="A4">
            <fo:flow flow-name="xsl-region-body" font-family="sans-serif" font-size="12pt">
                <fo:table border="solid black" table-layout="fixed" width="18cm">
                    <fo:table-column column-width="8cm"/>
                    <fo:table-column column-width="10cm"/>

                    <fo:table-header text-align="center" font-weight="bold" background-color="silver">
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-right="solid black" border-left="solid black" number-columns-spanned="2">
                                <fo:block>Content Summary</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <!--Title-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Title</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/Title/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        
                        <!--ContentType-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>ContentType By</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/ContentType/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        
                        <!--UploadType-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Upload Type</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/UploadType/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        
                        <!--CreatedBy-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Created By</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/CreatedBy/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <!--CreatedDate-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Created On (yyyy-mm-ddThh:mm:ss)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/CreatedDate/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <!--LastModifiedBy-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Last Modified By</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/LastModifiedBy/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                        <!--LastModifiedDate-->
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Last Modified On (yyyy-mm-ddThh:mm:ss)</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>
                                    <xsl:value-of select="Summary/LastModifiedDate/." />
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    
    <xsl:template name="TableOfContents">
        <fo:page-sequence master-reference="A4">
            <fo:flow flow-name="xsl-region-body" font-family="sans-serif" font-size="12pt">
                <fo:table border="solid black" table-layout="fixed">
                    <fo:table-column column-width="2cm"/>
                    <fo:table-column column-width="14cm"/>
                    <fo:table-column column-width="2cm"/>

                    <fo:table-header text-align="center" font-weight="bold" background-color="silver">
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-right="solid black" number-columns-spanned="3">
                                <fo:block>Table of Contents</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-header text-align="center" font-weight="bold" background-color="silver">
                        <fo:table-row border-bottom="solid black">
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Page</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Title</fo:block>
                            </fo:table-cell>
                            <fo:table-cell padding="1mm" border-left="solid black">
                                <fo:block>Is Active</fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-header>
                    <fo:table-body>
                        <!-- Pages/Page or Question/Page or Intro/Page etc -->
                        <xsl:for-each select="*/Page">
                            <xsl:call-template name="TableOfContentsEntry" />
                        </xsl:for-each>
                    </fo:table-body>
                </fo:table>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <xsl:template name="TableOfContentsEntry">
        <fo:table-row border-bottom="solid black">
            <fo:table-cell padding="1mm" border-left="solid black">
                <fo:block>
                    <xsl:value-of select="@ID" />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="1mm" border-left="solid black">
                <fo:block>
                    <xsl:value-of select="Title" />
                    <xsl:value-of select="PageElements/PageElement[1]/Question/Description/." />
                </fo:block>
            </fo:table-cell>
            <fo:table-cell padding="1mm" border-left="solid black" text-align="center">
                <fo:block>
                    <xsl:value-of select="@IsActive" />
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template name="PageDetail">
        <fo:page-sequence master-reference="A4">
            <fo:flow flow-name="xsl-region-body" font-family="sans-serif" font-size="12pt">
                <!-- Page Title -->
                <fo:block font-weight="bold" color="#0000aa" text-decoration="underline" font-size="14pt">
                    <xsl:value-of select="@ID" /> - <xsl:value-of select="Title" />
                </fo:block>
                <!-- Page Contents -->
                <fo:block font-weight="normal">
                    <xsl:for-each select="PageElements/PageElement">
                        <xsl:call-template name="Elements" />
                    </xsl:for-each>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    <xsl:template name="Elements">
        <fo:block>
            <xsl:for-each select="TextBox">
                <xsl:call-template name="PageElement_TextBox" />
            </xsl:for-each>
           
            <xsl:for-each select="TextGraphic">
                <xsl:call-template name="PageElement_TextGraphic" />
            </xsl:for-each>
            <xsl:for-each select="MultiChoiceQA">
                <xsl:call-template name="PageElement_MultiChoiceQA" />
            </xsl:for-each>
            
            <xsl:for-each select="FreeTextQA">
                <xsl:call-template name="PageElement_FreeTextQA" />
            </xsl:for-each>
            <xsl:for-each select="Graphic">
                <xsl:call-template name="PageElement_Graphic" />
            </xsl:for-each>
            <xsl:for-each select="ExtraInfo">
                <xsl:call-template name="PageElement_ExtraInfo" />
            </xsl:for-each>
            <xsl:for-each select="ShowAllPlayers">
                <xsl:call-template name="PageElement_ShowAllPlayers" />
            </xsl:for-each>
            <xsl:for-each select="MeetThePlayer">
                <xsl:call-template name="PageElement_MeetThePlayer" />
            </xsl:for-each>
             <xsl:for-each select="Question">
                <xsl:call-template name="PageElement_Question" />
            </xsl:for-each>
            <xsl:for-each select="EndLesson">
                <xsl:call-template name="PageElement_EndLesson" />
            </xsl:for-each>
            <xsl:for-each select="SubmitAnswers">
                <xsl:call-template name="PageElement_SubmitAnswers" />
            </xsl:for-each>
            <!---->
        </fo:block>
    </xsl:template>
</xsl:stylesheet>
