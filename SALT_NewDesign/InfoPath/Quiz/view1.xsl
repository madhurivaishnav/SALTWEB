<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:ns1="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T05:07:10" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:ns2="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-17T22:48:56" xmlns:my="http://schemas.microsoft.com/office/infopath/2003/myXSD/2005-02-22T04-03-10" xmlns:xd="http://schemas.microsoft.com/office/infopath/2003" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:xdExtension="http://schemas.microsoft.com/office/infopath/2003/xslt/extension" xmlns:xdXDocument="http://schemas.microsoft.com/office/infopath/2003/xslt/xDocument" xmlns:xdSolution="http://schemas.microsoft.com/office/infopath/2003/xslt/solution" xmlns:xdFormatting="http://schemas.microsoft.com/office/infopath/2003/xslt/formatting" xmlns:xdImage="http://schemas.microsoft.com/office/infopath/2003/xslt/xImage" xmlns:xdUtil="http://schemas.microsoft.com/office/infopath/2003/xslt/Util" xmlns:xdMath="http://schemas.microsoft.com/office/infopath/2003/xslt/Math" xmlns:xdDate="http://schemas.microsoft.com/office/infopath/2003/xslt/Date" xmlns:sig="http://www.w3.org/2000/09/xmldsig#" xmlns:xdSignatureProperties="http://schemas.microsoft.com/office/infopath/2003/SignatureProperties">
	<xsl:output method="html" indent="no"/>
	<xsl:template match="BDWInfoPathQuiz">
		<html>
			<head>
				<meta http-equiv="Content-Type" content="text/html"></meta>
				<style controlStyle="controlStyle">@media screen 			{ 			BODY{margin-left:21px;background-position:21px 0px;} 			} 		BODY{color:windowtext;background-color:window;layout-grid:none;} 		.xdListItem {display:inline-block;width:100%;vertical-align:text-top;} 		.xdListBox,.xdComboBox{margin:1px;} 		.xdInlinePicture{margin:1px; BEHAVIOR: url(#default#urn::xdPicture) } 		.xdLinkedPicture{margin:1px; BEHAVIOR: url(#default#urn::xdPicture) url(#default#urn::controls/Binder) } 		.xdSection{border:1pt solid #FFFFFF;margin:6px 0px 6px 0px;padding:1px 1px 1px 5px;} 		.xdRepeatingSection{border:1pt solid #FFFFFF;margin:6px 0px 6px 0px;padding:1px 1px 1px 5px;} 		.xdBehavior_Formatting {BEHAVIOR: url(#default#urn::controls/Binder) url(#default#Formatting);} 	 .xdBehavior_FormattingNoBUI{BEHAVIOR: url(#default#CalPopup) url(#default#urn::controls/Binder) url(#default#Formatting);} 	.xdExpressionBox{margin: 1px;padding:1px;word-wrap: break-word;text-overflow: ellipsis;overflow-x:hidden;}.xdBehavior_GhostedText,.xdBehavior_GhostedTextNoBUI{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#TextField) url(#default#GhostedText);}	.xdBehavior_GTFormatting{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#Formatting) url(#default#GhostedText);}	.xdBehavior_GTFormattingNoBUI{BEHAVIOR: url(#default#CalPopup) url(#default#urn::controls/Binder) url(#default#Formatting) url(#default#GhostedText);}	.xdBehavior_Boolean{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#BooleanHelper);}	.xdBehavior_Select{BEHAVIOR: url(#default#urn::controls/Binder) url(#default#SelectHelper);}	.xdRepeatingTable{BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word;}.xdScrollableRegion{BEHAVIOR: url(#default#ScrollableRegion);} 		.xdMaster{BEHAVIOR: url(#default#MasterHelper);} 		.xdActiveX{margin:1px; BEHAVIOR: url(#default#ActiveX);} 		.xdFileAttachment{display:inline-block;margin:1px;BEHAVIOR:url(#default#urn::xdFileAttachment);} 		.xdPageBreak{display: none;}BODY{margin-right:21px;} 		.xdTextBoxRTL{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-align:right;} 		.xdRichTextBoxRTL{display:inline-block;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow-x:hidden;word-wrap:break-word;text-overflow:ellipsis;text-align:right;font-weight:normal;font-style:normal;text-decoration:none;vertical-align:baseline;} 		.xdDTTextRTL{height:100%;width:100%;margin-left:22px;overflow:hidden;padding:0px;white-space:nowrap;} 		.xdDTButtonRTL{margin-right:-21px;height:18px;width:20px;behavior: url(#default#DTPicker);}.xdTextBox{display:inline-block;white-space:nowrap;text-overflow:ellipsis;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;text-align:left;} 		.xdRichTextBox{display:inline-block;;padding:1px;margin:1px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow-x:hidden;word-wrap:break-word;text-overflow:ellipsis;text-align:left;font-weight:normal;font-style:normal;text-decoration:none;vertical-align:baseline;} 		.xdDTPicker{;display:inline;margin:1px;margin-bottom: 2px;border: 1pt solid #dcdcdc;color:windowtext;background-color:window;overflow:hidden;} 		.xdDTText{height:100%;width:100%;margin-right:22px;overflow:hidden;padding:0px;white-space:nowrap;} 		.xdDTButton{margin-left:-21px;height:18px;width:20px;behavior: url(#default#DTPicker);} 		.xdRepeatingTable TD {VERTICAL-ALIGN: top;}</style>
				<style tableEditor="TableStyleRulesID">TABLE.xdLayout TD {
	BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none
}
TABLE.msoUcTable TD {
	BORDER-RIGHT: 1pt solid; BORDER-TOP: 1pt solid; BORDER-LEFT: 1pt solid; BORDER-BOTTOM: 1pt solid
}
TABLE {
	BEHAVIOR: url (#default#urn::tables/NDTable)
}
</style>
				<style languageStyle="languageStyle">BODY {
	FONT-SIZE: 10pt; FONT-FAMILY: Verdana
}
TABLE {
	FONT-SIZE: 10pt; FONT-FAMILY: Verdana
}
SELECT {
	FONT-SIZE: 10pt; FONT-FAMILY: Verdana
}
.optionalPlaceholder {
	PADDING-LEFT: 20px; FONT-WEIGHT: normal; FONT-SIZE: xx-small; BEHAVIOR: url(#default#xOptional); COLOR: #333333; FONT-STYLE: normal; FONT-FAMILY: Verdana; TEXT-DECORATION: none
}
.langFont {
	FONT-FAMILY: Verdana
}
</style>
				<style themeStyle="urn:office.microsoft.com:themeBlue">BODY {
	COLOR: black; BACKGROUND-COLOR: white
}
TABLE {
	BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse
}
TD {
	BORDER-LEFT-COLOR: #517dbf; BORDER-BOTTOM-COLOR: #517dbf; BORDER-TOP-COLOR: #517dbf; BORDER-RIGHT-COLOR: #517dbf
}
TH {
	BORDER-LEFT-COLOR: #517dbf; BORDER-BOTTOM-COLOR: #517dbf; COLOR: black; BORDER-TOP-COLOR: #517dbf; BACKGROUND-COLOR: #cbd8eb; BORDER-RIGHT-COLOR: #517dbf
}
.xdTableHeader {
	COLOR: black; BACKGROUND-COLOR: #ebf0f9
}
P {
	MARGIN-TOP: 0px
}
H1 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H2 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H3 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H4 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #1e3c7b
}
H5 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #517dbf
}
H6 {
	MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px; COLOR: #ebf0f9
}
.primaryVeryDark {
	COLOR: #ebf0f9; BACKGROUND-COLOR: #1e3c7b
}
.primaryDark {
	COLOR: white; BACKGROUND-COLOR: #517dbf
}
.primaryMedium {
	COLOR: black; BACKGROUND-COLOR: #cbd8eb
}
.primaryLight {
	COLOR: black; BACKGROUND-COLOR: #ebf0f9
}
.accentDark {
	COLOR: white; BACKGROUND-COLOR: #517dbf
}
.accentLight {
	COLOR: black; BACKGROUND-COLOR: #ebf0f9
}
</style>
			</head>
			<body>
				<div>
					<table class="msoUcTable" style="TABLE-LAYOUT: fixed; WIDTH: 755px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 127px"></col>
							<col style="WIDTH: 230px"></col>
							<col style="WIDTH: 137px"></col>
							<col style="WIDTH: 261px"></col>
						</colgroup>
						<tbody>
							<tr style="MIN-HEIGHT: 46px">
								<td colSpan="4" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #c0c0c0">
									<div align="center">
										<font size="5">Quiz Content</font>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 25px">
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>ID:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL1" xd:xctname="PlainText" xd:binding="Summary/@ID" style="WIDTH: 100%">
											<xsl:value-of select="Summary/@ID"/>
										</span>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Upload Type:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><select class="xdComboBox xdBehavior_Select" title="" size="1" xd:CtrlId="CTRL2" xd:xctname="DropDown" xd:binding="Summary/UploadType" xd:boundProp="value" style="WIDTH: 130px">
											<xsl:attribute name="value">
												<xsl:value-of select="Summary/UploadType"/>
											</xsl:attribute>
											<option value="update">
												<xsl:if test="Summary/UploadType=&quot;update&quot;">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>update</option>
											<option value="correction">
												<xsl:if test="Summary/UploadType=&quot;correction&quot;">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>correction</option>
										</select>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 25px">
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Name:</div>
								</td>
								<td colSpan="3" style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL3" xd:xctname="PlainText" xd:binding="Summary/Title" style="WIDTH: 80%">
											<xsl:value-of select="Summary/Title"/>
										</span>
									</div>
								</td>
							</tr>
							<tr>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Created By:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL114" xd:xctname="ExpressionBox" xd:binding="Summary/CreatedBy" style="WIDTH: 100%">
											<xsl:value-of select="Summary/CreatedBy"/>
										</span>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div>Last Modified By:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL116" xd:xctname="ExpressionBox" xd:binding="Summary/LastModifiedBy" style="WIDTH: 100%">
											<xsl:value-of select="Summary/LastModifiedBy"/>
										</span>
									</div>
								</td>
							</tr>
							<tr style="MIN-HEIGHT: 25px">
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>Created Date:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL113" xd:xctname="ExpressionBox" xd:binding="Summary/CreatedDate" style="WIDTH: 100%">
											<xsl:value-of select="Summary/CreatedDate"/>
										</span>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>Last Modified Date:</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt; BORDER-LEFT: #000000 1pt; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL115" xd:xctname="ExpressionBox" xd:binding="Summary/LastModifiedDate" style="WIDTH: 100%">
											<xsl:value-of select="Summary/LastModifiedDate"/>
										</span>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 757px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 245px"></col>
							<col style="WIDTH: 512px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr style="MIN-HEIGHT: 1in">
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>
										<table class="xdRepeatingTable msoUcTable xdMaster" title="" style="TABLE-LAYOUT: fixed; WIDTH: 239px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL1_5" xd:masterID="CTRL1_5">
											<colgroup>
												<col style="WIDTH: 239px"></col>
											</colgroup>
											<tbody class="xdTableHeader">
												<tr>
													<td style="BORDER-RIGHT: #cbd8eb 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<strong>
															<font size="3">Introduction</font>
														</strong>
													</td>
												</tr>
											</tbody><tbody xd:xctname="repeatingtable" xd:masterName="Introduction_Master">
												<xsl:for-each select="Introduction/Page">
													<tr style="MIN-HEIGHT: 27px">
														<td style="BORDER-RIGHT: #cbd8eb 1pt; PADDING-RIGHT: 1px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #cbd8eb 1pt; PADDING-TOP: 1px; BORDER-BOTTOM: #cbd8eb 1pt solid">
															<font face="Verdana" size="1"><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL49" xd:xctname="ExpressionBox" tabIndex="-1" xd:disableEditing="yes" style="OVERFLOW-Y: hidden; WIDTH: 100%; WHITE-SPACE: nowrap; WORD-WRAP: normal">
																	<xsl:value-of select="Title"/>
																</span>
															</font>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
										<div class="optionalPlaceholder" xd:xmlToEdit="Page_4" tabIndex="" xd:action="xCollection::insert" style="WIDTH: 239px">Insert a page</div>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #000000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; BORDER-LEFT: #000000 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #ebf0f9">
									<div><xsl:if test="function-available('xdXDocument:GetDOM')">
											<xsl:variable name="masterPosCTRL5" select="xdXDocument:GetNamedNodeProperty(/BDWInfoPathQuiz/Introduction, 'CTRL1_5', 1)"/>
											<xsl:apply-templates select="Introduction/Page [ (position() = $masterPosCTRL5) ] " mode="_1"/>
										</xsl:if>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 757px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 245px"></col>
							<col style="WIDTH: 512px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr style="MIN-HEIGHT: 1in">
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>
										<table class="xdRepeatingTable msoUcTable xdMaster" title="" style="TABLE-LAYOUT: fixed; WIDTH: 240px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL215" xd:masterID="CTRL215">
											<colgroup>
												<col style="WIDTH: 201px"></col>
												<col style="WIDTH: 39px"></col>
											</colgroup>
											<tbody class="xdTableHeader">
												<tr>
													<td style="BORDER-RIGHT: #cbd8eb 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<strong>
															<font size="3">Questions:<select class="xdComboBox xdBehavior_Select" title="" size="1" xd:CtrlId="CTRL264" xd:xctname="DropDown" xd:binding="Questions/@PageFilter" xd:boundProp="value" tabIndex="0" style="FONT-SIZE: xx-small; WIDTH: 101px">
																	<xsl:attribute name="value">
																		<xsl:value-of select="Questions/@PageFilter"/>
																	</xsl:attribute>
																	<option value="0">
																		<xsl:if test="Questions/@PageFilter=&quot;0&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>All Questions</option>
																	<option value="1">
																		<xsl:if test="Questions/@PageFilter=&quot;1&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>1 - 10</option>
																	<option value="11">
																		<xsl:if test="Questions/@PageFilter=&quot;11&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>11 - 20</option>
																	<option value="21">
																		<xsl:if test="Questions/@PageFilter=&quot;21&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>21 - 30</option>
																	<option value="31">
																		<xsl:if test="Questions/@PageFilter=&quot;31&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>31 - 40</option>
																	<option value="41">
																		<xsl:if test="Questions/@PageFilter=&quot;41&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>41 - 50</option>
																	<option value="51">
																		<xsl:if test="Questions/@PageFilter=&quot;51&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>51 - 60</option>
																	<option value="61">
																		<xsl:if test="Questions/@PageFilter=&quot;61&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>61 - 70</option>
																	<option value="71">
																		<xsl:if test="Questions/@PageFilter=&quot;71&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>71 - 80</option>
																	<option value="81">
																		<xsl:if test="Questions/@PageFilter=&quot;81&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>81 - 90</option>
																	<option value="91">
																		<xsl:if test="Questions/@PageFilter=&quot;91&quot;">
																			<xsl:attribute name="selected">selected</xsl:attribute>
																		</xsl:if>91 - 100</option>
																</select>
															</font>
														</strong>
													</td>
													<td style="BORDER-RIGHT: #cbd8eb 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<div>
															<strong>
																<font size="3"></font>
															</strong> </div>
													</td>
												</tr>
											</tbody><tbody xd:xctname="repeatingtable" xd:masterName="Questions_Master">
												<xsl:if test="function-available('xdXDocument:GetDOM')">
													<xsl:variable name="filterParentHasNewRowsCTRL215" select="xdXDocument:GetNamedNodeProperty(Questions/Page/.., &quot;filterHasNewRows&quot;, &quot;false&quot;)"/>
													<xsl:variable name="filterParentVersionCTRL215" select="xdXDocument:GetNamedNodeProperty(Questions/Page/.., &quot;parentFilterVersion&quot;, &quot;0&quot;)"/>
													<xsl:for-each select="Questions/Page [ (../@PageFilter = 0 or position() &gt;= ../@PageFilter and position() &lt; ../@PageFilter + 10)  or ($filterParentHasNewRowsCTRL215 = &quot;true&quot; and xdXDocument:GetNamedNodeProperty(., &quot;filterVersion&quot;, &quot;0&quot;) &gt; $filterParentVersionCTRL215)  ] ">
														<tr style="MIN-HEIGHT: 27px">
															<td style="BORDER-RIGHT: #cbd8eb 1pt; PADDING-RIGHT: 1px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #cbd8eb 1pt; PADDING-TOP: 1px; BORDER-BOTTOM: #cbd8eb 1pt solid">
																<font face="Verdana" size="1"><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL216" xd:xctname="ExpressionBox" xd:binding="substring(normalize-space(PageElements/PageElement/Question/Description), 1, 40)" tabIndex="-1" xd:disableEditing="yes" style="OVERFLOW-Y: hidden; WIDTH: 100%; WHITE-SPACE: nowrap; WORD-WRAP: normal">
																		<xsl:value-of select="substring(normalize-space(PageElements/PageElement/Question/Description), 1, 40)"/>
																	</span>
																</font>
															</td>
															<td style="BORDER-RIGHT: #cbd8eb 1pt; PADDING-RIGHT: 1px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #cbd8eb 1pt; PADDING-TOP: 1px; BORDER-BOTTOM: #cbd8eb 1pt solid">
																<div>
																	<font face="Verdana" size="1">
																		<font face="Verdana" size="1"><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="5" xd:CtrlId="btnQuestion_MoveUp" xd:xctname="Button">
																				<xsl:choose>
																					<xsl:when test="count(preceding-sibling::Page) = 0">
																						<xsl:attribute name="disabled">true</xsl:attribute>
																					</xsl:when>
																				</xsl:choose>
																			</input>
																		</font><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="6" xd:CtrlId="btnQuestion_MoveDown" xd:xctname="Button">
																			<xsl:choose>
																				<xsl:when test="count(following-sibling::Page) = 0">
																					<xsl:attribute name="disabled">true</xsl:attribute>
																				</xsl:when>
																			</xsl:choose>
																		</input>
																	</font>
																</div>
															</td>
														</tr>
													</xsl:for-each>
												</xsl:if>
											</tbody>
										</table>
										<div class="optionalPlaceholder" xd:xmlToEdit="Page_121" tabIndex="" xd:action="xCollection::insert" style="WIDTH: 240px">Insert a question</div>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #000000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; BORDER-LEFT: #000000 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div><xsl:if test="function-available('xdXDocument:GetDOM')">
											<xsl:variable name="masterPosCTRL217" select="xdXDocument:GetNamedNodeProperty(/BDWInfoPathQuiz/Questions, 'CTRL215', 1)"/>
											<xsl:apply-templates select="Questions/Page [ (position() = $masterPosCTRL217) ] " mode="_65"/>
										</xsl:if>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
				<div>
					<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 757px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
						<colgroup>
							<col style="WIDTH: 245px"></col>
							<col style="WIDTH: 512px"></col>
						</colgroup>
						<tbody vAlign="top">
							<tr style="MIN-HEIGHT: 1.021in">
								<td style="BORDER-RIGHT: #000000 1pt solid; BORDER-TOP: #000000 1pt solid; BORDER-LEFT: #000000 1pt solid; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #eae8e4">
									<div>
										<table class="xdRepeatingTable msoUcTable xdMaster" title="" style="TABLE-LAYOUT: fixed; WIDTH: 239px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL117" xd:masterID="CTRL117">
											<colgroup>
												<col style="WIDTH: 239px"></col>
											</colgroup>
											<tbody class="xdTableHeader">
												<tr>
													<td style="BORDER-RIGHT: #cbd8eb 1pt; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt; BORDER-BOTTOM: #cbd8eb 1pt solid; BACKGROUND-COLOR: #c0c0c0">
														<strong>
															<font size="3">Complete:</font>
														</strong>
													</td>
												</tr>
											</tbody><tbody xd:xctname="repeatingtable" xd:masterName="Complete_Master">
												<xsl:for-each select="Complete/Page">
													<tr style="MIN-HEIGHT: 27px">
														<td style="BORDER-RIGHT: #cbd8eb 1pt; PADDING-RIGHT: 1px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 1px; VERTICAL-ALIGN: middle; BORDER-LEFT: #cbd8eb 1pt; PADDING-TOP: 1px; BORDER-BOTTOM: #cbd8eb 1pt solid">
															<font face="Verdana" size="1"><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL118" xd:xctname="ExpressionBox" tabIndex="-1" xd:disableEditing="yes" style="OVERFLOW-Y: hidden; WIDTH: 100%; WHITE-SPACE: nowrap; WORD-WRAP: normal">
																	<xsl:value-of select="Title"/>
																</span>
															</font>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
										<div class="optionalPlaceholder" xd:xmlToEdit="Page_68" tabIndex="" xd:action="xCollection::insert" style="WIDTH: 239px">Insert a page</div>
									</div>
								</td>
								<td style="BORDER-RIGHT: #000000 1pt solid; PADDING-RIGHT: 1px; BORDER-TOP: #000000 1pt solid; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; BORDER-LEFT: #000000 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #000000 1pt solid; BACKGROUND-COLOR: #ebf0f9">
									<div><xsl:if test="function-available('xdXDocument:GetDOM')">
											<xsl:variable name="masterPosCTRL119" select="xdXDocument:GetNamedNodeProperty(/BDWInfoPathQuiz/Complete, 'CTRL117', 1)"/>
											<xsl:apply-templates select="Complete/Page [ (position() = $masterPosCTRL119) ] " mode="_34"/>
										</xsl:if>
									</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div> </div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="Page" mode="_1">
		<div class="xdRepeatingSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px; BACKGROUND-COLOR: #eae8e4" align="left" xd:CtrlId="CTRL5" xd:xctname="RepeatingSection" xd:linkedToMaster="CTRL1_5">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 507px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 507px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 23px">
							<td style="PADDING-RIGHT: 1px; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BACKGROUND-COLOR: #c0c0c0; BORDER-BOTTOM-STYLE: none">
								<div>
									<strong><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL283" xd:xctname="ExpressionBox" xd:binding="concat(&quot;Page &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)" style="WIDTH: 177px; HEIGHT: 20px">
											<xsl:value-of select="concat(&quot;Page &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)"/>
										</span>
									</strong>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>
									<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 500px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
										<colgroup>
											<col style="WIDTH: 138px"></col>
											<col style="WIDTH: 84px"></col>
											<col style="WIDTH: 278px"></col>
										</colgroup>
										<tbody vAlign="top">
											<tr style="MIN-HEIGHT: 25px">
												<td style="BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-RIGHT-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div>Page Title:</div>
												</td>
												<td colSpan="2" style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL6" xd:xctname="PlainText" xd:binding="Title" style="WIDTH: 100%">
															<xsl:value-of select="Title"/>
														</span>
													</div>
												</td>
											</tr>
											<tr style="MIN-HEIGHT: 24px">
												<td style="BORDER-RIGHT: #000000 1pt; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div>Status:</div>
												</td>
												<td style="BORDER-RIGHT: #808080 6pt; BORDER-LEFT: #000000 1pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" value="on" name="{generate-id(@IsActive)}" xd:CtrlId="CTRL7" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="true">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;true&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Active  </div>
												</td>
												<td style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" value="on" name="{generate-id(@IsActive)}" xd:CtrlId="CTRL8" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="false">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;false&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Inactive</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<strong>Page Contents:</strong>
							</td>
						</tr>
						<tr style="MIN-HEIGHT: 170px">
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:apply-templates select="PageElements" mode="_8"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="PageElements" mode="_8">
		<div class="xdSection xdRepeating" title="" style="PADDING-LEFT: 1px; MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL24" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdRepeatingTable msoUcTable" title="" style="TABLE-LAYOUT: fixed; WIDTH: 486px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL25">
					<colgroup>
						<col style="WIDTH: 486px"></col>
					</colgroup><tbody xd:xctname="RepeatingTable">
						<xsl:for-each select="PageElement">
							<tr>
								<td style="BORDER-RIGHT: #cbd8eb 1pt solid; PADDING-RIGHT: 0px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-LEFT: #cbd8eb 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #cbd8eb 1pt solid">
									<div>
										<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 484px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
											<colgroup>
												<col style="WIDTH: 363px"></col>
												<col style="WIDTH: 121px"></col>
											</colgroup>
											<tbody vAlign="top">
												<tr>
													<td style="BORDER-RIGHT: medium none; PADDING-RIGHT: 0px; BORDER-TOP: medium none; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-LEFT: medium none; PADDING-TOP: 0px; BORDER-BOTTOM: medium none">
														<font face="Verdana" size="2">
															<div align="left"><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL262" xd:xctname="ExpressionBox" xd:binding="&quot;Spacer&quot;" tabIndex="-1" xd:disableEditing="yes">
																	<xsl:attribute name="style">WIDTH: 186px;<xsl:choose>
																			<xsl:when test="count(*) != 0">DISPLAY: none</xsl:when>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:value-of select="&quot;Spacer&quot;"/>
																</span>
															</div>
														</font>
													</td>
													<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
														<div align="right">
															<font face="Verdana" size="2">
																<font face="Verdana" size="1">
																	<font face="Verdana" size="1"><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 44px; COLOR: #ff0000; LINE-HEIGHT: 10px; FONT-FAMILY: Arial; HEIGHT: 16px" type="button" size="46" value="Delete" xd:CtrlId="btnIntroductionPageElement_Delete" xd:xctname="Button">
																			<xsl:choose>
																				<xsl:when test="count(../PageElement) = 1">
																					<xsl:attribute name="disabled">true</xsl:attribute>
																				</xsl:when>
																			</xsl:choose>
																		</input><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="5" xd:CtrlId="btnIntroductionPageElement_MoveUp" xd:xctname="Button">
																			<xsl:choose>
																				<xsl:when test="count(preceding-sibling::PageElement) = 0">
																					<xsl:attribute name="disabled">true</xsl:attribute>
																				</xsl:when>
																			</xsl:choose>
																		</input>
																	</font>
																</font><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="6" xd:CtrlId="btnIntroductionPageElement_MoveDown" xd:xctname="Button">
																	<xsl:choose>
																		<xsl:when test="count(following-sibling::PageElement) = 0">
																			<xsl:attribute name="disabled">true</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																</input>
															</font>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div>
										<div class="xdSection xdRepeating" style="BORDER-RIGHT: #ffffff 1pt; BORDER-TOP: #ffffff 1pt; MARGIN-BOTTOM: 6px; BORDER-LEFT: #ffffff 1pt; WIDTH: 100%; BORDER-BOTTOM: #ffffff 1pt; HEIGHT: auto" xd:xctname="choicegroup" xd:ref=".">
											<div><xsl:apply-templates select="TextGraphic" mode="_20"/>
											</div>
											<div><xsl:apply-templates select="TextBox" mode="_19"/>
											</div>
											<div><xsl:apply-templates select="Graphic" mode="_22"/>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
				<div class="optionalPlaceholder" xd:xmlToEdit="PageElement_12" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 486px">Insert page element</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TextGraphic" mode="_20">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL52" xd:xctname="choiceterm">
			<div>Text and Graphic</div>
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 465px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 64px"></col>
						<col style="WIDTH: 401px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>
									<div>Text: </div>
								</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><span class="xdRichTextBox" hideFocus="1" title="" xd:CtrlId="CTRL53" xd:xctname="RichText" xd:binding="Description" style="MARGIN-BOTTOM: 5px; WIDTH: 100%; HEIGHT: 166px">
										<xsl:copy-of select="Description/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Picture:</div>
							</td>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:apply-templates select="Picture" mode="_21"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_21">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL54" xd:xctname="Section">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 388px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 253px"></col>
						<col style="WIDTH: 135px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:if test="function-available('xdImage:getImageUrl')">
										<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" xd:CtrlId="CTRL55" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="xd:inline" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
									</xsl:if>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Alt Text:<span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL56" xd:xctname="PlainText" xd:binding="AltText" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>Align:</div>
								<div><select class="xdComboBox xdBehavior_Select" title="" size="1" xd:CtrlId="CTRL57" xd:xctname="DropDown" xd:binding="Align" xd:boundProp="value" style="WIDTH: 100%">
										<xsl:attribute name="value">
											<xsl:value-of select="Align"/>
										</xsl:attribute>
										<option value="Left">
											<xsl:if test="Align=&quot;Left&quot;">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>Left</option>
										<option value="Right">
											<xsl:if test="Align=&quot;Right&quot;">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>Right</option>
									</select>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TextBox" mode="_19">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL50" xd:xctname="choiceterm">
			<div>Text Box</div>
			<div><span class="xdRichTextBox" hideFocus="1" title="" xd:CtrlId="CTRL51" xd:xctname="RichText" xd:binding="Description" style="MARGIN-BOTTOM: 5px; WIDTH: 100%; HEIGHT: 159px">
					<xsl:copy-of select="Description/node()"/>
				</span>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Graphic" mode="_22">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%; HEIGHT: 10px" align="left" xd:CtrlId="CTRL58" xd:xctname="choiceterm">
			<div>Graphic</div>
			<div><xsl:apply-templates select="Picture" mode="_23"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_23">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL59" xd:xctname="Section">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 459px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 305px"></col>
						<col style="WIDTH: 154px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr style="MIN-HEIGHT: 42px">
							<td style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:if test="function-available('xdImage:getImageUrl')">
										<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" xd:CtrlId="CTRL60" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="xd:inline" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
									</xsl:if>
								</div>
							</td>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>Alt Text:</div>
								<div><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL61" xd:xctname="PlainText" xd:binding="AltText" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Page" mode="_65">
		<div class="xdRepeatingSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL217" xd:xctname="RepeatingSection" xd:linkedToMaster="CTRL215">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 506px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 506px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 1px; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BACKGROUND-COLOR: #c0c0c0; BORDER-BOTTOM-STYLE: none">
								<div>
									<strong><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL194" xd:xctname="ExpressionBox" xd:binding="concat(&quot;Question &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)" style="WIDTH: 183px; HEIGHT: 21px">
											<xsl:value-of select="concat(&quot;Question &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)"/>
										</span>
									</strong>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>
									<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 500px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
										<colgroup>
											<col style="WIDTH: 138px"></col>
											<col style="WIDTH: 84px"></col>
											<col style="WIDTH: 278px"></col>
										</colgroup>
										<tbody vAlign="top">
											<tr style="MIN-HEIGHT: 24px">
												<td style="BORDER-RIGHT: #000000 1pt; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div>Status:</div>
												</td>
												<td style="BORDER-RIGHT: #808080 6pt; BORDER-LEFT: #000000 1pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" value="on" name="{generate-id(@IsActive)}" xd:CtrlId="CTRL219" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="true">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;true&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Active  </div>
												</td>
												<td style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" value="on" name="{generate-id(@IsActive)}" xd:CtrlId="CTRL220" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="false">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;false&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Inactive</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
							</td>
						</tr>
						<tr style="MIN-HEIGHT: 170px">
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:apply-templates select="PageElements" mode="_66"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="PageElements" mode="_66">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 492px; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL223" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdRepeatingTable msoUcTable" title="" style="TABLE-LAYOUT: fixed; WIDTH: 486px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL199">
					<colgroup>
						<col style="WIDTH: 486px"></col>
					</colgroup><tbody xd:xctname="repeatingtable">
						<xsl:for-each select="PageElement">
							<tr>
								<td style="BORDER-RIGHT: #cbd8eb 1pt solid; PADDING-RIGHT: 0px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-LEFT: #cbd8eb 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #cbd8eb 1pt solid">
									<div>
										<div class="xdSection xdRepeating" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" xd:xctname="choicegroup" xd:ref=".">
											<div><xsl:apply-templates select="Question" mode="_85"/>
											</div>
										</div>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Question" mode="_85">
		<div class="xdSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px" align="left" xd:CtrlId="CTRL248" xd:xctname="choiceterm" tabIndex="-1">
			<div>Question Text: <span class="xdRichTextBox" hideFocus="1" title="" contentEditable="true" xd:CtrlId="CTRL249" xd:xctname="RichText" xd:binding="Description" tabIndex="0" style="WIDTH: 100%; WHITE-SPACE: normal; HEIGHT: 135px">
					<xsl:copy-of select="Description/node()"/>
				</span>
			</div>
			<div><xsl:apply-templates select="Answers" mode="_86"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Answers" mode="_86">
		<div class="xdSection xdRepeating" title="" style="PADDING-LEFT: 1px; MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL250" xd:xctname="Section" tabIndex="-1">
			<div>Answers:</div>
			<div>
				<table class="xdRepeatingTable msoUcTable" title="" style="TABLE-LAYOUT: fixed; WIDTH: 453px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL255">
					<colgroup>
						<col style="WIDTH: 396px"></col>
						<col style="WIDTH: 57px"></col>
					</colgroup>
					<tbody class="xdTableHeader">
						<tr>
							<td style="BORDER-RIGHT: #808080 6pt; BORDER-TOP: #808080 6pt; BORDER-LEFT: #808080 6pt; BORDER-BOTTOM: #808080 6pt">
								<div>Answer Text</div>
							</td>
							<td style="BORDER-RIGHT: #517dbf 1pt; BORDER-TOP: #808080 6pt; BORDER-LEFT: #808080 6pt; BORDER-BOTTOM: #808080 6pt">
								<div>Correct</div>
							</td>
						</tr>
					</tbody><tbody xd:xctname="RepeatingTable">
						<xsl:for-each select="Answer">
							<tr>
								<td style="BORDER-RIGHT: #808080 6pt; BORDER-TOP: #808080 6pt; BORDER-LEFT: #808080 6pt; BORDER-BOTTOM: #517dbf 1pt"><span class="xdRichTextBox" hideFocus="1" title="" contentEditable="true" xd:CtrlId="CTRL258" xd:xctname="RichText" xd:binding="Description" tabIndex="0" style="WIDTH: 100%; WHITE-SPACE: normal; HEIGHT: 50px">
										<xsl:copy-of select="Description/node()"/>
									</span>
								</td>
								<td style="BORDER-RIGHT: #517dbf 1pt; BORDER-TOP: #808080 6pt; BORDER-LEFT: #808080 6pt; BORDER-BOTTOM: #517dbf 1pt">
									<div align="center"><input class="xdBehavior_Boolean" title="" type="checkbox" xd:CtrlId="CTRL257" xd:xctname="CheckBox" xd:binding="@Correct" xd:boundProp="xd:value" tabIndex="0" xd:onValue="true" xd:offValue="false">
											<xsl:attribute name="xd:value">
												<xsl:value-of select="@Correct"/>
											</xsl:attribute>
											<xsl:if test="@Correct=&quot;true&quot;">
												<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
											</xsl:if>
										</input>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
				<div class="optionalPlaceholder" xd:xmlToEdit="Answer_135" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 453px">Insert an answer</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Page" mode="_34">
		<div class="xdRepeatingSection xdRepeating" title="" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; WIDTH: 100%; PADDING-TOP: 0px; BACKGROUND-COLOR: #eae8e4" align="left" xd:CtrlId="CTRL119" xd:xctname="RepeatingSection" xd:linkedToMaster="CTRL117">
			<div>
				<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 506px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
					<colgroup>
						<col style="WIDTH: 506px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="PADDING-RIGHT: 1px; PADDING-LEFT: 1px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-TOP-STYLE: none; PADDING-TOP: 0px; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BACKGROUND-COLOR: #c0c0c0; BORDER-BOTTOM-STYLE: none">
								<div>
									<strong><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL92" xd:xctname="ExpressionBox" xd:binding="concat(&quot;Page &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)" style="WIDTH: 169px; HEIGHT: 20px">
											<xsl:value-of select="concat(&quot;Page &quot;, count(preceding-sibling::Page) + 1, &quot; Details:&quot;)"/>
										</span>
									</strong>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div>
									<table class="xdFormLayout xdLayout" style="TABLE-LAYOUT: fixed; WIDTH: 500px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1">
										<colgroup>
											<col style="WIDTH: 138px"></col>
											<col style="WIDTH: 84px"></col>
											<col style="WIDTH: 278px"></col>
										</colgroup>
										<tbody vAlign="top">
											<tr style="MIN-HEIGHT: 25px">
												<td style="BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-RIGHT-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div>Page Title:</div>
												</td>
												<td colSpan="2" style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-TOP: #cbd8eb 1pt solid; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
													<div><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL120" xd:xctname="PlainText" xd:binding="Title" style="WIDTH: 100%">
															<xsl:value-of select="Title"/>
														</span>
													</div>
												</td>
											</tr>
											<tr style="MIN-HEIGHT: 24px">
												<td style="BORDER-RIGHT: #000000 1pt; BORDER-LEFT: #cbd8eb 1pt solid; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div>Status:</div>
												</td>
												<td style="BORDER-RIGHT: #808080 6pt; BORDER-LEFT: #000000 1pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" value="on" name="{generate-id(@IsActive)}" xd:CtrlId="CTRL121" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="true">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;true&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Active  </div>
												</td>
												<td style="BORDER-RIGHT: #cbd8eb 1pt solid; BORDER-LEFT: #808080 6pt; BORDER-TOP-STYLE: none; BORDER-BOTTOM: #cbd8eb 1pt solid">
													<div><input class="xdBehavior_Boolean" title="" type="radio" value="on" name="{generate-id(@IsActive)}" xd:CtrlId="CTRL221" xd:xctname="OptionButton" xd:binding="@IsActive" xd:boundProp="xd:value" xd:onValue="false">
															<xsl:attribute name="xd:value">
																<xsl:value-of select="@IsActive"/>
															</xsl:attribute>
															<xsl:if test="@IsActive=&quot;false&quot;">
																<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
															</xsl:if>
														</input>Inactive</div>
												</td>
											</tr>
										</tbody>
									</table>
								</div>
								<strong>Page Contents:</strong>
							</td>
						</tr>
						<tr>
							<td style="BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none">
								<div><xsl:apply-templates select="PageElements" mode="_35"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="PageElements" mode="_35">
		<div class="xdSection xdRepeating" title="" style="PADDING-LEFT: 1px; MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL123" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdRepeatingTable msoUcTable" title="" style="TABLE-LAYOUT: fixed; WIDTH: 486px; BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word; BORDER-BOTTOM-STYLE: none" border="1" xd:CtrlId="CTRL97">
					<colgroup>
						<col style="WIDTH: 486px"></col>
					</colgroup><tbody xd:xctname="repeatingtable">
						<xsl:for-each select="PageElement">
							<tr>
								<td style="BORDER-RIGHT: #cbd8eb 1pt solid; PADDING-RIGHT: 0px; BORDER-TOP: #cbd8eb 1pt solid; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-LEFT: #cbd8eb 1pt solid; PADDING-TOP: 0px; BORDER-BOTTOM: #cbd8eb 1pt solid">
									<div>
										<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 484px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
											<colgroup>
												<col style="WIDTH: 373px"></col>
												<col style="WIDTH: 111px"></col>
											</colgroup>
											<tbody vAlign="top">
												<tr>
													<td style="BORDER-RIGHT: medium none; PADDING-RIGHT: 0px; BORDER-TOP: medium none; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; VERTICAL-ALIGN: top; BORDER-LEFT: medium none; PADDING-TOP: 0px; BORDER-BOTTOM: medium none">
														<div>
															<font face="Verdana" size="2"><span class="xdExpressionBox xdDataBindingUI" title="" xd:CtrlId="CTRL267" xd:xctname="ExpressionBox" xd:binding="&quot;Spacer&quot;" tabIndex="-1" xd:disableEditing="yes">
																	<xsl:attribute name="style">WIDTH: 186px;<xsl:choose>
																			<xsl:when test="count(*) != 0">DISPLAY: none</xsl:when>
																		</xsl:choose>
																	</xsl:attribute>
																	<xsl:value-of select="&quot;Spacer&quot;"/>
																</span>
															</font>
														</div>
													</td>
													<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
														<div align="right">
															<font face="Verdana" size="2">
																<font face="Verdana" size="2">
																	<font face="Verdana" size="1">
																		<font face="Verdana" size="1"><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 44px; COLOR: #ff0000; LINE-HEIGHT: 10px; FONT-FAMILY: Arial; HEIGHT: 16px" type="button" size="46" value="Delete" xd:CtrlId="btnCompletePageElement_Delete" xd:xctname="Button">
																				<xsl:choose>
																					<xsl:when test="count(../PageElement) = 1">
																						<xsl:attribute name="disabled">true</xsl:attribute>
																					</xsl:when>
																				</xsl:choose>
																			</input><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="5" xd:CtrlId="btnCompletePageElement_MoveUp" xd:xctname="Button">
																				<xsl:choose>
																					<xsl:when test="count(preceding-sibling::PageElement) = 0">
																						<xsl:attribute name="disabled">true</xsl:attribute>
																					</xsl:when>
																				</xsl:choose>
																			</input>
																		</font>
																	</font>
																</font><input class="langFont" title="" style="FONT-SIZE: xx-small; WIDTH: 16px; LINE-HEIGHT: 5px; FONT-FAMILY: Webdings; HEIGHT: 16px" type="button" value="6" xd:CtrlId="btnCompletePageElement_MoveDown" xd:xctname="Button">
																	<xsl:choose>
																		<xsl:when test="count(following-sibling::PageElement) = 0">
																			<xsl:attribute name="disabled">true</xsl:attribute>
																		</xsl:when>
																	</xsl:choose>
																</input>
															</font>
														</div>
													</td>
												</tr>
											</tbody>
										</table>
									</div>
									<div>
										<div class="xdSection xdRepeating" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" xd:xctname="choicegroup" xd:ref=".">
											<div/>
											<div/>
											<div><xsl:apply-templates select="TextGraphic" mode="_91"/>
											</div>
											<div><xsl:apply-templates select="TextBox" mode="_90"/>
											</div><xsl:apply-templates select="Graphic" mode="_96"/><xsl:apply-templates select="SubmitAnswers" mode="_95"/>
										</div>
									</div>
								</td>
							</tr>
						</xsl:for-each>
					</tbody>
				</table>
				<div class="optionalPlaceholder" xd:xmlToEdit="PageElement_77" tabIndex="0" xd:action="xCollection::insert" style="WIDTH: 486px">Insert page element</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TextGraphic" mode="_91">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL293" xd:xctname="choiceterm" tabIndex="-1">
			<div>Text and Graphic</div>
			<div>
				<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 462px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
					<colgroup>
						<col style="WIDTH: 63px"></col>
						<col style="WIDTH: 399px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2">Text:</font>
								</div>
							</td>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2"></font><span class="xdRichTextBox" hideFocus="1" title="" xd:CtrlId="CTRL303" xd:xctname="RichText" xd:binding="Description" tabIndex="0" style="WIDTH: 100%; HEIGHT: 153px">
										<xsl:copy-of select="Description/node()"/>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2">Picture:</font>
								</div>
							</td>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div><xsl:apply-templates select="Picture" mode="_92"/>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_92">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL294" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 384px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
					<colgroup>
						<col style="WIDTH: 248px"></col>
						<col style="WIDTH: 136px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2"><xsl:if test="function-available('xdImage:getImageUrl')">
											<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" xd:CtrlId="CTRL304" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="" tabIndex="0" tabStop="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
										</xsl:if>
									</font>
								</div>
							</td>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2">Alt Text:</font>
								</div>
								<div><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL305" xd:xctname="PlainText" xd:binding="AltText" tabIndex="0" style="WIDTH: 100%">
										<xsl:value-of select="AltText"/>
									</span>Align: <select class="xdComboBox xdBehavior_Select" title="" size="1" xd:CtrlId="CTRL307" xd:xctname="DropDown" xd:binding="Align" xd:boundProp="value" tabIndex="0" style="WIDTH: 100%">
										<xsl:attribute name="value">
											<xsl:value-of select="Align"/>
										</xsl:attribute>
										<option value="Left">
											<xsl:if test="Align=&quot;Left&quot;">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>Left</option>
										<option value="Right">
											<xsl:if test="Align=&quot;Right&quot;">
												<xsl:attribute name="selected">selected</xsl:attribute>
											</xsl:if>Right</option>
									</select>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="TextBox" mode="_90">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL291" xd:xctname="choiceterm" tabIndex="-1">
			<div>Text box</div>
			<div><span class="xdRichTextBox" hideFocus="1" title="" xd:CtrlId="CTRL292" xd:xctname="RichText" xd:binding="Description" tabIndex="0" style="WIDTH: 100%; HEIGHT: 162px">
					<xsl:copy-of select="Description/node()"/>
				</span>
			</div>
			<div> </div>
		</div>
	</xsl:template>
	<xsl:template match="Graphic" mode="_96">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL298" xd:xctname="choiceterm" tabIndex="-1">
			<div><xsl:apply-templates select="Picture" mode="_97"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="Picture" mode="_97">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL299" xd:xctname="Section" tabIndex="-1">
			<div>
				<table class="xdLayout" style="BORDER-RIGHT: medium none; TABLE-LAYOUT: fixed; BORDER-TOP: medium none; BORDER-LEFT: medium none; WIDTH: 452px; BORDER-BOTTOM: medium none; BORDER-COLLAPSE: collapse; WORD-WRAP: break-word" borderColor="buttontext" border="1">
					<colgroup>
						<col style="WIDTH: 299px"></col>
						<col style="WIDTH: 153px"></col>
					</colgroup>
					<tbody vAlign="top">
						<tr>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2"><xsl:if test="function-available('xdImage:getImageUrl')">
											<img class="xdInlinePicture" hideFocus="1" alt="Click here to insert a picture" xd:CtrlId="CTRL300" xd:xctname="InlineImage" xd:binding="Image" xd:boundProp="" tabIndex="0" tabStop="true" Linked="true" xd:inline="Image" src="{xdImage:getImageUrl(Image)}"/>
										</xsl:if>
									</font>
								</div>
							</td>
							<td style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none">
								<div>
									<font face="Verdana" size="2">Alt Text: </font>
								</div>
								<div>
									<font face="Verdana" size="2"><span class="xdTextBox" hideFocus="1" title="" xd:CtrlId="CTRL301" xd:xctname="PlainText" xd:binding="AltText" tabIndex="0" style="WIDTH: 100%">
											<xsl:value-of select="AltText"/>
										</span>
									</font>
								</div>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="SubmitAnswers" mode="_95">
		<div class="xdSection xdRepeating" title="" style="MARGIN-BOTTOM: 6px; WIDTH: 100%" align="left" xd:CtrlId="CTRL297" xd:xctname="choiceterm" tabIndex="-1">
			<div> </div>
			<div>Submit Answers Button</div>
			<div> </div>
		</div>
	</xsl:template>
</xsl:stylesheet>
