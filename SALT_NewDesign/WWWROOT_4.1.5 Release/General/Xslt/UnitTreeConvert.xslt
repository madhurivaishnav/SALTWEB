<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" indent="no" encoding="utf-8" omit-xml-declaration="yes"/> 
  <xsl:template match="/NewDataSet">
	<TreeView>
      <xsl:apply-templates select="//Table[not(@ParentUnitID)]">
		<xsl:sort select="@Name" data-type="text" order="ascending"/>
      </xsl:apply-templates>
    </TreeView>  
  </xsl:template>

  <xsl:template match="Table">
		<xsl:variable name="UnitID" select="@UnitID"/>
		<TreeNode>
			<xsl:attribute name="Text"><xsl:value-of select="@Name"/></xsl:attribute>
			<xsl:attribute name="Value"><xsl:value-of select="@UnitID"/></xsl:attribute>
			<xsl:if test="@Disabled=1">
					<xsl:attribute name="Disabled">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="@Selected=1">
					<xsl:attribute name="Selected">true</xsl:attribute>
			</xsl:if>
			<xsl:if test="@Expanded=1">
					<xsl:attribute name="Expanded">true</xsl:attribute>
			</xsl:if>

		    <xsl:apply-templates select="//Table[@ParentUnitID=$UnitID]">
				<xsl:sort select="@Name" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</TreeNode>
  </xsl:template>
</xsl:stylesheet>
