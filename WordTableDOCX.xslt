<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0"/>
<xsl:param name="use_print_settings" select="1"/> <!--If 1 use settings from APEX Print Attributes dialog-->
<xsl:param name="invoice_header" select="0"/> <!--If 1 activate header for invoice (SDA Page ID 29)-->
<xsl:param name="Subtitle" select="'Subtitle'"/>
<xsl:param name="GrandTotalText" select="'GRAND TOTAL:'"/>
<xsl:param name="boldValue" select="'Title'"/>
<xsl:param name="def_orient" select="'portrait'"/> <!--page def_orientation landscape or portrait-->
<xsl:param name="def_pagewidth" select="11906"/> <!--page width for A4 format-->
<xsl:param name="def_pageheight" select="16838"/> <!--page height for A4 format-->
<xsl:param name="margintop" select="1417"/>  <!--page margins (2,5 cm)-->
<xsl:param name="marginright" select="1417"/> 
<xsl:param name="marginbottom" select="1417"/> 
<xsl:param name="marginleft" select="1417"/> 
<xsl:param name="headerfromtop" select="708"/>  <!--header margin (1,25 cm)-->
<xsl:param name="footerfrombottom" select="708"/> <!--footer margin (1,25 cm)--> 
<xsl:param name="tablestyle" select="'TableGrid8'"/> <!--Table style defined in styles part--> 

<!--default colors and fonts-->
<xsl:param name="def_firstrowfontcolor" select="'000000'"/> <!--First row font color (default black)--> 
<xsl:param name="def_firstrowthemecolor" select="'FFFFFF'"/> <!--First row background color (default white)--> 
<xsl:param name="def_firstrowfont" select="'Calibri'"/> <!--table header font-->
<xsl:param name="def_firstrowfontsize" select="24"/> <!--table header font size 12-->

<xsl:param name="def_rowfontcolor" select="'000000'"/> <!--Row font color (default black)--> 
<xsl:param name="def_rowthemecolor" select="'FFFFFF'"/> <!--Row background color (default white)--> 
<xsl:param name="def_rowfont" select="'Calibri'"/> <!--Row font (default Calibri)--> 
<xsl:param name="def_rowfontsize" select="22"/> <!--Row font size (default 11)--> 
<xsl:param name="pagebreak_for_region" select="1"/> <!--If multiple APEX regions are in single document separate it with page breaks-->
<!--end of default colors and fonts-->

<xsl:variable name="pagewidth"> <!--page width-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="#PAGE_WIDTH#"/>
			<xsl:with-param name="unit" select="'#UNITS#'"/>
			<xsl:with-param name="default_value" select="$def_pagewidth"/>
		</xsl:call-template>
</xsl:variable>

<xsl:variable name="orient"> <!--page orientation landscape or portrait-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#ORIENTATION#'"/>
			<xsl:with-param name="unit" select="'or'"/>
			<xsl:with-param name="default_value" select="$def_orient"/>
		</xsl:call-template>
</xsl:variable>	
	
<xsl:variable name="pageheight"> <!--page height-->
	<xsl:call-template name="ms_units_with_default">
		<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
		<xsl:with-param name="val" select="#PAGE_HEIGHT#"/>
		<xsl:with-param name="unit" select="'#UNITS#'"/>
		<xsl:with-param name="default_value" select="$def_pageheight"/>
	</xsl:call-template>
</xsl:variable>
	
<xsl:variable name="tablewidth"> <!--table width-->
		<xsl:value-of select = "number($pagewidth) - number($marginright) - number($marginleft)"/>
</xsl:variable>	

<xsl:preserve-space elements="*"/>
<xsl:template match="/">

<xsl:processing-instruction name="mso-application">progid="Word.Document"</xsl:processing-instruction>
	
	
<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
  <pkg:part pkg:name="/word/document.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml">
    <pkg:xmlData>
      <w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">
        <w:body>
        	<xsl:apply-templates select="//DOCUMENT/ROWSET"/>
          <w:p w:rsidR="00170E74" w:rsidRPr="00455D06" w:rsidRDefault="00170E74">
            <w:pPr>
              <w:rPr>
                <!--w:lang w:val="en-US"/-->
              </w:rPr>
            </w:pPr>
          </w:p>
          <xsl:if test="$use_print_settings=1">
	          <w:sectPr w:rsidR="00170E74" w:rsidRPr="00455D06">
	          	<w:headerReference w:type="even" r:id="rId7"/> <!--header1-->
							<w:headerReference w:type="default" r:id="rId8"/> <!--header2-->
							<w:headerReference w:type="first" r:id="rId9"/> <!--header3-->
							<w:footerReference w:type="even" r:id="rId10"/> <!--footer1-->
							<w:footerReference w:type="default" r:id="rId11"/> <!--footer2-->
							<w:footerReference w:type="first" r:id="rId12"/> <!--footer3-->
	            <w:pgSz w:w="{$pagewidth}" w:h="{$pageheight}" w:orient="{$orient}"/>
	            <w:pgMar w:top="{$margintop}" w:right="{$marginright}" w:bottom="{$marginbottom}" w:left="{$marginleft}" w:header="{$headerfromtop}" w:footer="{$footerfrombottom}" w:gutter="0"/>
	            <w:cols w:space="708"/>
	            <w:docGrid w:linePitch="360"/>
	          </w:sectPr>
          </xsl:if>
        </w:body>
      </w:document>
    </pkg:xmlData>
  </pkg:part>
</pkg:package>

</xsl:template>

<xsl:template match="ROWSET">
	<xsl:variable name="break_on_col1">
		<xsl:value-of select="@break_on_col1"/>
	</xsl:variable>
	<xsl:variable name="break_on_col2">
		<xsl:value-of select="@break_on_col2"/>
	</xsl:variable>
	<xsl:variable name="break_on_col3">
		<xsl:value-of select="@break_on_col3"/>
	</xsl:variable>
	<xsl:variable name="break_on_col4">
		<xsl:value-of select="@break_on_col4"/>
	</xsl:variable>
	<xsl:variable name="break_on_col5">
		<xsl:value-of select="@break_on_col5"/>
	</xsl:variable>
	<xsl:variable name="break_on_col6">
		<xsl:value-of select="@break_on_col6"/>
	</xsl:variable>
	<xsl:variable name="col1_name">
		<xsl:value-of select="name(ROW[1]/*[1])"/>
	</xsl:variable>
	<xsl:variable name="col2_name">
		<xsl:value-of select="name(ROW[1]/*[2])"/>
	</xsl:variable>
	<xsl:variable name="col3_name">
		<xsl:value-of select="name(ROW[1]/*[3])"/>
	</xsl:variable>
	<xsl:variable name="col4_name">
		<xsl:value-of select="name(ROW[1]/*[4])"/>
	</xsl:variable>
	<xsl:variable name="col5_name">
		<xsl:value-of select="name(ROW[1]/*[5])"/>
	</xsl:variable>
	<xsl:variable name="col6_name">
		<xsl:value-of select="name(ROW[1]/*[6])"/>
	</xsl:variable>
	<xsl:variable name="col7_name">
		<xsl:value-of select="name(ROW[1]/*[7])"/>
	</xsl:variable>
	<xsl:variable name="col8_name">
		<xsl:value-of select="name(ROW[1]/*[8])"/>
	</xsl:variable>
	<xsl:variable name="col9_name">
		<xsl:value-of select="name(ROW[1]/*[9])"/>
	</xsl:variable>
	<xsl:variable name="col10_name">
		<xsl:value-of select="name(ROW[1]/*[10])"/>
	</xsl:variable>
	<xsl:variable name="col11_name">
		<xsl:value-of select="name(ROW[1]/*[11])"/>
	</xsl:variable>
	<xsl:variable name="col12_name">
		<xsl:value-of select="name(ROW[1]/*[12])"/>
	</xsl:variable>
	<xsl:variable name="col13_name">
		<xsl:value-of select="name(ROW[1]/*[13])"/>
	</xsl:variable>
	<xsl:variable name="col14_name">
		<xsl:value-of select="name(ROW[1]/*[14])"/>
	</xsl:variable>
	<xsl:variable name="col15_name">
		<xsl:value-of select="name(ROW[1]/*[15])"/>
	</xsl:variable>
	<xsl:variable name="col16_name">
		<xsl:value-of select="name(ROW[1]/*[16])"/>
	</xsl:variable>
	<xsl:variable name="col17_name">
		<xsl:value-of select="name(ROW[1]/*[17])"/>
	</xsl:variable>
	<xsl:variable name="col18_name">
		<xsl:value-of select="name(ROW[1]/*[18])"/>
	</xsl:variable>
	<xsl:variable name="col19_name">
		<xsl:value-of select="name(ROW[1]/*[19])"/>
	</xsl:variable>
	<xsl:variable name="col20_name">
		<xsl:value-of select="name(ROW[1]/*[20])"/>
	</xsl:variable>
	
	<xsl:variable name="col1_fullname">
		<xsl:value-of select="ROW[1]/*[1]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col2_fullname">
		<xsl:value-of select="ROW[1]/*[2]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col3_fullname">
		<xsl:value-of select="ROW[1]/*[3]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col4_fullname">
		<xsl:value-of select="ROW[1]/*[4]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col5_fullname">
		<xsl:value-of select="ROW[1]/*[5]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col6_fullname">
		<xsl:value-of select="ROW[1]/*[6]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col7_fullname">
		<xsl:value-of select="ROW[1]/*[7]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col8_fullname">
		<xsl:value-of select="ROW[1]/*[8]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col9_fullname">
		<xsl:value-of select="ROW[1]/*[9]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col10_fullname">
		<xsl:value-of select="ROW[1]/*[10]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col11_fullname">
		<xsl:value-of select="ROW[1]/*[11]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col12_fullname">
		<xsl:value-of select="ROW[1]/*[12]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col13_fullname">
		<xsl:value-of select="ROW[1]/*[13]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col14_fullname">
		<xsl:value-of select="ROW[1]/*[14]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col15_fullname">
		<xsl:value-of select="ROW[1]/*[15]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col16_fullname">
		<xsl:value-of select="ROW[1]/*[16]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col17_fullname">
		<xsl:value-of select="ROW[1]/*[17]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col18_fullname">
		<xsl:value-of select="ROW[1]/*[18]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col19_fullname">
		<xsl:value-of select="ROW[1]/*[19]/@FULL_NAME"/>
	</xsl:variable>
	<xsl:variable name="col20_fullname">
		<xsl:value-of select="ROW[1]/*[20]/@FULL_NAME"/>
	</xsl:variable>
	
	
	<xsl:variable name="col1_name_show">
		<xsl:call-template name="colname-header">
			<xsl:with-param name="colname"><xsl:value-of select="$col1_name"/></xsl:with-param>
			<xsl:with-param name="fullname"><xsl:value-of select="$col1_fullname"/></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col2_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col2_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col3_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col3_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col4_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col4_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col5_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col5_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col6_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col6_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col7_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col7_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col8_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col8_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col9_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col9_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col10_name_show">
		<xsl:call-template name="colname-header">
			<xsl:with-param name="colname"><xsl:value-of select="$col10_name"/></xsl:with-param>
			<xsl:with-param name="fullname"><xsl:value-of select="$col10_fullname"/></xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col11_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col11_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col12_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col12_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col13_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col13_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col14_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col14_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col15_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col15_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col16_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col16_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col17_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col17_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col18_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col18_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col19_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col19_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="col20_name_show">
		<xsl:call-template name="colname-header">
						<xsl:with-param name="colname"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="fullname"><xsl:value-of select="$col20_fullname"/></xsl:with-param>
					</xsl:call-template>
	</xsl:variable>
	
	<!--table body fonts and colors-->
	<xsl:variable name="rowfontcolor"> <!--table row font color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_FONT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_rowfontcolor"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rowthemecolor"> <!--table row background color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_BG_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_rowthemecolor"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rowfont"> <!--table row font-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_FONT_FAMILY#'"/>
			<xsl:with-param name="unit" select="'ft'"/>
			<xsl:with-param name="default_value" select="$def_rowfont"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="rowfontsize"> <!--table row font size-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_FONT_SIZE#'"/>
			<xsl:with-param name="unit" select="'fs'"/>
			<xsl:with-param name="default_value" select="$def_rowfontsize"/>
		</xsl:call-template>
	</xsl:variable>
	<!--end of table body fonts and colors-->
	
	<!--add titles and  word table-->
	<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00245AEA" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:pStyle w:val="Title"/>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<!--w:lang w:val="en-US"/-->
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00455D06">
		<w:rPr>
		<!--w:lang w:val="en-US"/-->
		</w:rPr>
		<w:t>
			<xsl:value-of select="@name"/>
			<!--xsl:text> </xsl:text>
			<xsl:value-of select="@IR_name"/-->
		</w:t>
		</w:r>
		<w:r w:rsidR="00996A33" w:rsidRPr="00455D06">
		<w:rPr>
		<!--w:lang w:val="en-US"/-->
		</w:rPr>
		<w:t xml:space="preserve"> </w:t>
		</w:r>
	</w:p>
	<xsl:if test="@IR_name != ''">
		<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
			<w:pPr>
			<w:pStyle w:val="Subtitle"/>
			<w:rPr>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			</w:pPr>
			<w:r w:rsidRPr="00455D06">
			<w:rPr>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			<w:t><xsl:value-of select="@IR_name"/></w:t>
			</w:r>
		</w:p>
	</xsl:if>
	<!--Invoice addition-->
	<xsl:if test="$invoice_header = '1'">  
	  <w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r>
		<w:t xml:space="preserve">Order Number </w:t>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_ORDER_ID#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r>
		<w:t xml:space="preserve">Customer Info </w:t>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_CUSTOMER_INFO_WORD#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Order Date </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_ORDER_TIMESTAMP#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Order Total </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_ORDER_TOTAL#</w:t>
		</w:r>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		<w:rPr>
		<w:b/>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Sales Rep </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r w:rsidRPr="00564B3A">
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_USER_NAME#</w:t>
		</w:r>
		<w:bookmarkStart w:id="0" w:name="_GoBack"/>
		<w:bookmarkEnd w:id="0"/>
		</w:p>
		<w:p w:rsidR="00564B3A" w:rsidRPr="00564B3A" w:rsidRDefault="00564B3A" w:rsidP="00564B3A" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:divId w:val="2006741715"/>
		</w:pPr>
		<w:r w:rsidRPr="00564B3A">
		<w:t xml:space="preserve">Tags </w:t>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r>
		<w:tab/>
		</w:r>
		<w:r>
		<w:rPr>
		<w:b/>
		</w:rPr>
		<w:t>#P29_TAGS#</w:t>
		</w:r>
		</w:p>
  <!--End of Invoice addition-->
  </xsl:if>
	  
		<xsl:for-each select="ROW">
	 		<xsl:variable name="rowpos" select="position()"/>
	 		<xsl:variable name="last" select="last()"/>
			<xsl:choose>
				<xsl:when test="@breakrow = 1"> <!--This is breakrow, end table of previous break group, list info from break cols (= common info of break group), then start new table -->
					<xsl:if test="$rowpos &gt; 1">
						<xsl:call-template name="end_table"/> <!--End table of previous break group-->
					</xsl:if>
					<xsl:call-template name="breakrow_header"> <!--list info from break cols (= common info of break group)-->
						<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
						<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
						<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
						<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
						<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
						<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
					</xsl:call-template>
					
					<xsl:call-template name="start-table"> <!--start new table -->
						<xsl:with-param name="tablewidth" select="$tablewidth"/>
						<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
						<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
						<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
						<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
						<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
						<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
						<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
						<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
						<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
						<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
						<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
						<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
						<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
						<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
						<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
						<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
						<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
						<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
						<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
						<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
						<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
						<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
						<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
						<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
						<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
						<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
						<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
						<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
					</xsl:call-template>
				
				</xsl:when> <!-- end of: This is breakrow-->
				<xsl:when test="@breakrow = 2"> <!--This is grand total row, end table of previous break group, then start new table -->
					<xsl:if test="$rowpos &gt; 1">
						<xsl:call-template name="end_table"/> <!--End table of previous break group-->
					</xsl:if>
					<!--Grand total caption-->
					<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
						<w:pPr>
						<w:pStyle w:val="Heading1"/>
						<w:rPr>
						<!--w:lang w:val="en-US"/-->
						</w:rPr>
						</w:pPr>
						<w:r w:rsidR="00B13FF7">
						<w:rPr>
						<!--w:lang w:val="en-US"/-->
						</w:rPr>
						<w:t>
							<xsl:value-of select="$GrandTotalText"/>
						</w:t>
						</w:r>
						<w:bookmarkStart w:id="0" w:name="_GoBack"/>
						<w:bookmarkEnd w:id="0"/>
					</w:p>
					
					<xsl:call-template name="start-table"> <!--start new table -->
						<xsl:with-param name="tablewidth" select="$tablewidth"/>
						<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
						<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
						<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
						<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
						<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
						<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
						<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
						<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
						<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
						<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
						<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
						<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
						<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
						<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
						<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
						<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
						<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
						<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
						<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
						<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
						<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
						<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
						<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
						<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
						<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
						<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
						<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
						<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
						<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
						<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
						<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
						<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
						<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
						<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
						<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
						<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
						<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
						<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
						<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
						<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
						<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
						<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
						<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
						<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
						<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
						<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
					</xsl:call-template>
					
					<!--construct table row-->
					<w:tr w:rsidR="00245AEA" w:rsidRPr="00455D06" w:rsidTr="00DF4B83" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
						<xsl:for-each select="*"> 
							<!--dont include break cols into table, break cols are in heading before each break group table-->
							<xsl:if test="not(name()=$break_on_col1)">
							<xsl:if test="not(name()=$break_on_col2)">
							<xsl:if test="not(name()=$break_on_col3)">
							<xsl:if test="not(name()=$break_on_col4)">
							<xsl:if test="not(name()=$break_on_col5)">
							<xsl:if test="not(name()=$break_on_col6)">		
						
								<w:tc>
								<w:tcPr>
								<w:tcW w:w="5000" w:type="dxa"/>
								<w:shd w:val="clear" w:color="auto" w:fill="{$rowthemecolor}"/>
								</w:tcPr>
								<w:p w:rsidR="00245AEA" w:rsidRPr="00455D06" w:rsidRDefault="00245AEA" w:rsidP="008F5CD0">
								<w:pPr>
								<w:spacing w:after="0" w:line="240" w:lineRule="auto"/>
								<w:rPr>
								<!--w:lang w:val="en-US"/-->
								</w:rPr>
								</w:pPr>
								<w:r w:rsidRPr="00455D06">
								<!--w:lang w:val="en-US"/-->
								<w:t>
									<xsl:if test="@aggr_function">
										<w:rPr>
										<w:rFonts w:ascii="{$rowfont}" w:hAnsi="{$rowfont}" w:cs="{$rowfont}"/>		
										<w:b/>
										<w:color w:val="{$rowfontcolor}"/>
										<w:sz w:val="{$rowfontsize}"/>
										<w:szCs w:val="{$rowfontsize}"/>
										</w:rPr>
										<xsl:value-of select="@aggr_function"/>
										<xsl:text>: </xsl:text>
										<xsl:value-of select="."/>
									</xsl:if>
								</w:t>
								</w:r>
								</w:p>
								</w:tc>
							</xsl:if>
							</xsl:if>
							</xsl:if>
							</xsl:if>
							</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</w:tr>
				
				</xsl:when> <!-- end of: This is breakrow-->
				<xsl:otherwise> <!--not break row-->
					<xsl:if test="$rowpos = 1"> <!--If first Region row then start new table-->
						<xsl:call-template name="start-table"> 
							<xsl:with-param name="tablewidth" select="$tablewidth"/>   
							<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
							<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
							<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
							<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
							<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
							<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
							<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
							<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
							<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
							<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
							<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
							<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
							<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
							<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
							<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
							<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
							<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
							<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
							<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
							<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
							<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
							<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
							<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
							<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
							<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
							<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
							<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
							<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
							<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
							<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
							<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
							<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
							<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
							<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
							<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
							<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
							<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
							<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
							<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
							<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
							<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
							<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
							<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
							<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
							<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
							<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
						</xsl:call-template>
					</xsl:if> <!--End of: If first Region row then of corse start new table-->
		
					<!--construct table row-->
					<w:tr w:rsidR="00245AEA" w:rsidRPr="00455D06" w:rsidTr="00DF4B83" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
						<xsl:variable name="highlight_col" select="@highlight_col"/>
						<xsl:variable name="highlight_cell" select="@highlight_cell"/>
						<xsl:variable name="highlight_bkg_color" select="@highlight_bkg_color"/>
						<xsl:variable name="highlight_font_color" select="@highlight_font_color"/>
							
						<xsl:for-each select="*"> 
							<!--dont include break cols into table, break cols are in heading before each break group table-->
							<xsl:if test="not(name()=$break_on_col1)">
							<xsl:if test="not(name()=$break_on_col2)">
							<xsl:if test="not(name()=$break_on_col3)">
							<xsl:if test="not(name()=$break_on_col4)">
							<xsl:if test="not(name()=$break_on_col5)">
							<xsl:if test="not(name()=$break_on_col6)">
								
							<xsl:variable name="rowfontcolor_cur">
									<xsl:choose>
										<xsl:when test="($highlight_cell='false' or name()=$highlight_col) and $highlight_font_color">
											<xsl:value-of select="$highlight_font_color"/>
										</xsl:when>
										<xsl:otherwise>
									  	<xsl:value-of select="$rowfontcolor"/>
									  </xsl:otherwise>
								  </xsl:choose>
							</xsl:variable>
										
							<xsl:variable name="highlight_bkg_color_cur">
								<xsl:choose>
									<xsl:when test="($highlight_cell='false' or name()=$highlight_col) and $highlight_bkg_color">
										<xsl:value-of select="$highlight_bkg_color"/>
									</xsl:when>
									<xsl:otherwise>
									 	<xsl:value-of select="$rowthemecolor"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
						
								<w:tc>
								<w:tcPr>
								<w:tcW w:w="5000" w:type="dxa"/>
								<w:shd w:val="clear" w:color="auto" w:fill="{$highlight_bkg_color_cur}"/>
								</w:tcPr>
								<w:p w:rsidR="00245AEA" w:rsidRPr="00455D06" w:rsidRDefault="00245AEA" w:rsidP="008F5CD0">
								<w:pPr>
								<w:spacing w:after="0" w:line="240" w:lineRule="auto"/>
								<w:rPr>
								<!--w:lang w:val="en-US"/-->
								</w:rPr>
								</w:pPr>
								<w:r w:rsidRPr="00455D06">
								<!--w:lang w:val="en-US"/-->
								<w:t>
									<xsl:choose>
										<xsl:when test="name()=$boldValue">
											<w:rPr>
											<w:rFonts w:ascii="{$rowfont}" w:hAnsi="{$rowfont}" w:cs="{$rowfont}"/>	
											<w:b/>
											<w:color w:val="{$rowfontcolor_cur}"/>
											<w:sz w:val="{$rowfontsize}"/>
											<w:szCs w:val="{$rowfontsize}"/>
											</w:rPr>
											<xsl:value-of select="."/>
										</xsl:when>
										<xsl:when test="@aggr_function">
											<w:rPr>
											<w:rFonts w:ascii="{$rowfont}" w:hAnsi="{$rowfont}" w:cs="{$rowfont}"/>		
											<w:b/>
											<w:color w:val="{$rowfontcolor_cur}"/>
											<w:sz w:val="{$rowfontsize}"/>
											<w:szCs w:val="{$rowfontsize}"/>
											</w:rPr>
											<xsl:value-of select="@aggr_function"/>
											<xsl:text>: </xsl:text>
											<xsl:value-of select="."/>
										</xsl:when>
										<xsl:otherwise>
											<w:rPr>
											<w:rFonts w:ascii="{$rowfont}" w:hAnsi="{$rowfont}" w:cs="{$rowfont}"/>		
											#BODY_FONT_WEIGHT#	
											<w:color w:val="{$rowfontcolor_cur}"/>
											<w:sz w:val="{$rowfontsize}"/>
											<w:szCs w:val="{$rowfontsize}"/>
											</w:rPr>
											<xsl:value-of select="."/>
										</xsl:otherwise>
									</xsl:choose>
								</w:t>
								</w:r>
								</w:p>
								</w:tc>
							</xsl:if>
							</xsl:if>
							</xsl:if>
							</xsl:if>
							</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</w:tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	<xsl:call-template name="end_table"/>
	<xsl:if test="position() != last()">
		<xsl:if test ="$pagebreak_for_region = 1">
			<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
				<w:r w:rsidRPr="00455D06">
					<w:br w:type="page"/>
				</w:r>
			</w:p>
		</xsl:if>
	  <xsl:if test ="$pagebreak_for_region = 0">
			<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
				<w:r w:rsidRPr="00455D06">
				<w:t> </w:t>
				</w:r>
			</w:p>
		</xsl:if>
	</xsl:if>
</xsl:template>


<xsl:template name="table-header-col"> 
	<xsl:param name="col_name"/>
	<xsl:param name="col_width"/>
	<xsl:param name="col_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	
	<!--colors and fonts of header-->
	<xsl:variable name="firstrowfontcolor"> <!--table header font color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfontcolor"/>
		</xsl:call-template>
	</xsl:variable>

  <xsl:variable name="firstrowthemecolor"> <!--table header background color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_BG_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_firstrowthemecolor"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="firstrowfont"> <!--table header font-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_FAMILY#'"/>
			<xsl:with-param name="unit" select="'ft'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfont"/>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="firstrowfontsize"> <!--table header font size-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_SIZE#'"/>
			<xsl:with-param name="unit" select="'fs'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfontsize"/>
		</xsl:call-template>
	</xsl:variable>
	<!--end of colors and fonts of header-->
	
	<xsl:if test="not($col_name=$break_on_col1)">
	<xsl:if test="not($col_name=$break_on_col2)">
	<xsl:if test="not($col_name=$break_on_col3)">
	<xsl:if test="not($col_name=$break_on_col4)">
	<xsl:if test="not($col_name=$break_on_col5)">
	<xsl:if test="not($col_name=$break_on_col6)">
		<w:tc xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
			<w:tcPr>
			<w:tcW w:w="{$col_width}" w:type="dxa"/>
			<w:shd w:val="clear" w:color="auto" w:fill="{$firstrowthemecolor}"/>
			</w:tcPr>
			<w:p w:rsidR="003C23EC" w:rsidRPr="00DF4B83" w:rsidRDefault="00245AEA">
			<w:r w:rsidRPr="00DF4B83">
			<w:pPr>
			<w:spacing w:after="0" w:line="240" w:lineRule="auto"/>
			<w:rPr>
			<w:color w:val="{$firstrowfontcolor}"/>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			</w:pPr>
			<w:rPr>
			<w:color w:val="{$firstrowfontcolor}"/>
			</w:rPr>
			<w:rPr>
				<w:rFonts w:ascii="{$firstrowfont}" w:hAnsi="{$firstrowfont}" w:cs="{$firstrowfont}"/>
				#HEADER_FONT_WEIGHT# <!--bold, normal-->
				<w:color w:val="{$firstrowfontcolor}"/>
				<w:sz w:val="{$firstrowfontsize}"/>
				<w:szCs w:val="{$firstrowfontsize}"/>
			</w:rPr>
			<w:t>
				<xsl:value-of select="$col_name_show"/>
			</w:t>
			</w:r>
			</w:p>
		</w:tc>
	</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>
	</xsl:if>								
</xsl:template>

<xsl:template name="table-header-cols"> 
	<xsl:param name="position"/>
	<xsl:param name="col_width"/>
	<xsl:param name="col1_name"/>
	<xsl:param name="col2_name"/>
	<xsl:param name="col3_name"/>
	<xsl:param name="col4_name"/>
	<xsl:param name="col5_name"/>
	<xsl:param name="col6_name"/>
	<xsl:param name="col7_name"/>
	<xsl:param name="col8_name"/>
	<xsl:param name="col9_name"/>
	<xsl:param name="col10_name"/>
	<xsl:param name="col11_name"/>
	<xsl:param name="col12_name"/>
	<xsl:param name="col13_name"/>
	<xsl:param name="col14_name"/>
	<xsl:param name="col15_name"/>
	<xsl:param name="col16_name"/>
	<xsl:param name="col17_name"/>
	<xsl:param name="col18_name"/>
	<xsl:param name="col19_name"/>
	<xsl:param name="col20_name"/>
	<xsl:param name="col1_name_show"/>
	<xsl:param name="col2_name_show"/>
	<xsl:param name="col3_name_show"/>
	<xsl:param name="col4_name_show"/>
	<xsl:param name="col5_name_show"/>
	<xsl:param name="col6_name_show"/>
	<xsl:param name="col7_name_show"/>
	<xsl:param name="col8_name_show"/>
	<xsl:param name="col9_name_show"/>
	<xsl:param name="col10_name_show"/>
	<xsl:param name="col11_name_show"/>
	<xsl:param name="col12_name_show"/>
	<xsl:param name="col13_name_show"/>
	<xsl:param name="col14_name_show"/>
	<xsl:param name="col15_name_show"/>
	<xsl:param name="col16_name_show"/>
	<xsl:param name="col17_name_show"/>
	<xsl:param name="col18_name_show"/>
	<xsl:param name="col19_name_show"/>
	<xsl:param name="col20_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	<xsl:if test="$position = 1">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 2">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 3">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 4">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 5">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 6">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 7">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 8">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 9">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 10">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 11">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 12">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 13">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 14">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 15">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 16">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 17">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 18">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 19">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	<xsl:if test="$position = 20">
		<xsl:call-template name="table-header-col">
			<xsl:with-param name="col_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
			<xsl:with-param name="col_width"><xsl:value-of select="$col_width"/></xsl:with-param>
			<xsl:with-param name="col_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
</xsl:template>

<xsl:template name="start-table">
	<xsl:param name="tablewidth"/>
	<xsl:param name="col1_name"/>
	<xsl:param name="col2_name"/>
	<xsl:param name="col3_name"/>
	<xsl:param name="col4_name"/>
	<xsl:param name="col5_name"/>
	<xsl:param name="col6_name"/>
	<xsl:param name="col7_name"/>
	<xsl:param name="col8_name"/>
	<xsl:param name="col9_name"/>
	<xsl:param name="col10_name"/>
	<xsl:param name="col11_name"/>
	<xsl:param name="col12_name"/>
	<xsl:param name="col13_name"/>
	<xsl:param name="col14_name"/>
	<xsl:param name="col15_name"/>
	<xsl:param name="col16_name"/>
	<xsl:param name="col17_name"/>
	<xsl:param name="col18_name"/>
	<xsl:param name="col19_name"/>
	<xsl:param name="col20_name"/>
	<xsl:param name="col1_name_show"/>
	<xsl:param name="col2_name_show"/>
	<xsl:param name="col3_name_show"/>
	<xsl:param name="col4_name_show"/>
	<xsl:param name="col5_name_show"/>
	<xsl:param name="col6_name_show"/>
	<xsl:param name="col7_name_show"/>
	<xsl:param name="col8_name_show"/>
	<xsl:param name="col9_name_show"/>
	<xsl:param name="col10_name_show"/>
	<xsl:param name="col11_name_show"/>
	<xsl:param name="col12_name_show"/>
	<xsl:param name="col13_name_show"/>
	<xsl:param name="col14_name_show"/>
	<xsl:param name="col15_name_show"/>
	<xsl:param name="col16_name_show"/>
	<xsl:param name="col17_name_show"/>
	<xsl:param name="col18_name_show"/>
	<xsl:param name="col19_name_show"/>
	<xsl:param name="col20_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	
	<xsl:text disable-output-escaping="yes">
		<![CDATA[<w:tbl>]]>
	</xsl:text>
	
	<w:tblPr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:tblStyle w:val="{$tablestyle}"/>
		<w:tblW w:w="{$tablewidth}" w:type="auto"/>
		<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
	</w:tblPr>
	
	<xsl:variable name="num_of_cols">
		<xsl:value-of select="count(*[name()!=$break_on_col1 and name()!=$break_on_col2 and name()!=$break_on_col3 and name()!=$break_on_col4 and name()!=$break_on_col5 and name()!=$break_on_col6])"/>
	</xsl:variable>
	
	<w:tblGrid xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<xsl:for-each select="*">
			<xsl:variable name="col_width">
				<xsl:call-template name="column_width"> 
					<xsl:with-param name="tablewidth" select="$tablewidth"/>
					<xsl:with-param name="col_width_pc" select="@COLUMN_WIDTH"/> <!--column width in percentages of table width-->
					<xsl:with-param name="num_of_cols" select="$num_of_cols"/>
				</xsl:call-template> 
			</xsl:variable>
			
			<xsl:if test="name()!=$break_on_col1"> 
			<xsl:if test="name()!=$break_on_col2">
			<xsl:if test="name()!=$break_on_col3"> 
			<xsl:if test="name()!=$break_on_col4"> 
			<xsl:if test="name()!=$break_on_col5"> 
			<xsl:if test="name()!=$break_on_col6">  
				<w:gridCol w:w="{$col_width}"/>
			</xsl:if>
			</xsl:if> 
			</xsl:if> 
			</xsl:if> 
			</xsl:if> 
			</xsl:if>  
		</xsl:for-each> 
	</w:tblGrid>
		
	<w:tr w:rsidR="00245AEA" w:rsidRPr="00455D06" w:rsidTr="00DF4B83" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
	  <xsl:for-each select="*"> 	  
		  <xsl:variable name="col_width">
					<xsl:call-template name="column_width"> 
						<xsl:with-param name="tablewidth" select="$tablewidth"/>
						<xsl:with-param name="col_width_pc" select="@COLUMN_WIDTH"/> <!--column width in percentages of table width-->
						<xsl:with-param name="num_of_cols" select="$num_of_cols"/>
					</xsl:call-template> 
				</xsl:variable>	
		<xsl:call-template name="table-header-cols"> 
			<xsl:with-param name="position"><xsl:value-of select="position()"/></xsl:with-param>
			<xsl:with-param name="col_width" select="$col_width"/>
				
			<xsl:with-param name="col1_name"><xsl:value-of select="$col1_name"/></xsl:with-param>
			<xsl:with-param name="col2_name"><xsl:value-of select="$col2_name"/></xsl:with-param>
			<xsl:with-param name="col3_name"><xsl:value-of select="$col3_name"/></xsl:with-param>
			<xsl:with-param name="col4_name"><xsl:value-of select="$col4_name"/></xsl:with-param>
			<xsl:with-param name="col5_name"><xsl:value-of select="$col5_name"/></xsl:with-param>
			<xsl:with-param name="col6_name"><xsl:value-of select="$col6_name"/></xsl:with-param>
			<xsl:with-param name="col7_name"><xsl:value-of select="$col7_name"/></xsl:with-param>
			<xsl:with-param name="col8_name"><xsl:value-of select="$col8_name"/></xsl:with-param>
			<xsl:with-param name="col9_name"><xsl:value-of select="$col9_name"/></xsl:with-param>
			<xsl:with-param name="col10_name"><xsl:value-of select="$col10_name"/></xsl:with-param>
			<xsl:with-param name="col11_name"><xsl:value-of select="$col11_name"/></xsl:with-param>
			<xsl:with-param name="col12_name"><xsl:value-of select="$col12_name"/></xsl:with-param>
			<xsl:with-param name="col13_name"><xsl:value-of select="$col13_name"/></xsl:with-param>
			<xsl:with-param name="col14_name"><xsl:value-of select="$col14_name"/></xsl:with-param>
			<xsl:with-param name="col15_name"><xsl:value-of select="$col15_name"/></xsl:with-param>
			<xsl:with-param name="col16_name"><xsl:value-of select="$col16_name"/></xsl:with-param>
			<xsl:with-param name="col17_name"><xsl:value-of select="$col17_name"/></xsl:with-param>
			<xsl:with-param name="col18_name"><xsl:value-of select="$col18_name"/></xsl:with-param>
			<xsl:with-param name="col19_name"><xsl:value-of select="$col19_name"/></xsl:with-param>
			<xsl:with-param name="col20_name"><xsl:value-of select="$col20_name"/></xsl:with-param>
			
			<xsl:with-param name="col1_name_show"><xsl:value-of select="$col1_name_show"/></xsl:with-param>
			<xsl:with-param name="col2_name_show"><xsl:value-of select="$col2_name_show"/></xsl:with-param>
			<xsl:with-param name="col3_name_show"><xsl:value-of select="$col3_name_show"/></xsl:with-param>
			<xsl:with-param name="col4_name_show"><xsl:value-of select="$col4_name_show"/></xsl:with-param>
			<xsl:with-param name="col5_name_show"><xsl:value-of select="$col5_name_show"/></xsl:with-param>
			<xsl:with-param name="col6_name_show"><xsl:value-of select="$col6_name_show"/></xsl:with-param>
			<xsl:with-param name="col7_name_show"><xsl:value-of select="$col7_name_show"/></xsl:with-param>
			<xsl:with-param name="col8_name_show"><xsl:value-of select="$col8_name_show"/></xsl:with-param>
			<xsl:with-param name="col9_name_show"><xsl:value-of select="$col9_name_show"/></xsl:with-param>
			<xsl:with-param name="col10_name_show"><xsl:value-of select="$col10_name_show"/></xsl:with-param>
			<xsl:with-param name="col11_name_show"><xsl:value-of select="$col11_name_show"/></xsl:with-param>
			<xsl:with-param name="col12_name_show"><xsl:value-of select="$col12_name_show"/></xsl:with-param>
			<xsl:with-param name="col13_name_show"><xsl:value-of select="$col13_name_show"/></xsl:with-param>
			<xsl:with-param name="col14_name_show"><xsl:value-of select="$col14_name_show"/></xsl:with-param>
			<xsl:with-param name="col15_name_show"><xsl:value-of select="$col15_name_show"/></xsl:with-param>
			<xsl:with-param name="col16_name_show"><xsl:value-of select="$col16_name_show"/></xsl:with-param>
			<xsl:with-param name="col17_name_show"><xsl:value-of select="$col17_name_show"/></xsl:with-param>
			<xsl:with-param name="col18_name_show"><xsl:value-of select="$col18_name_show"/></xsl:with-param>
			<xsl:with-param name="col19_name_show"><xsl:value-of select="$col19_name_show"/></xsl:with-param>
			<xsl:with-param name="col20_name_show"><xsl:value-of select="$col20_name_show"/></xsl:with-param>
			
			<xsl:with-param name="break_on_col1"><xsl:value-of select="$break_on_col1"/></xsl:with-param>
			<xsl:with-param name="break_on_col2"><xsl:value-of select="$break_on_col2"/></xsl:with-param>
			<xsl:with-param name="break_on_col3"><xsl:value-of select="$break_on_col3"/></xsl:with-param>
			<xsl:with-param name="break_on_col4"><xsl:value-of select="$break_on_col4"/></xsl:with-param>
			<xsl:with-param name="break_on_col5"><xsl:value-of select="$break_on_col5"/></xsl:with-param>
			<xsl:with-param name="break_on_col6"><xsl:value-of select="$break_on_col6"/></xsl:with-param>
		</xsl:call-template>
	  </xsl:for-each>
	</w:tr>
</xsl:template>

<xsl:template name="end_table">
	<xsl:text disable-output-escaping="yes">
		<![CDATA[</w:tbl>]]>
	</xsl:text>
</xsl:template>

<xsl:template name="breakrow_header">
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>
	<xsl:if test="@breakrow=1">
		<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
			<w:pPr>
			<w:pStyle w:val="Heading1"/>
			<w:rPr>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			</w:pPr>
			<w:r w:rsidR="00B13FF7">
			<w:rPr>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			<w:t>
				<xsl:for-each select="*">	
					<xsl:if test="name()=$break_on_col1">
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col2">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col3">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col4">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col5">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
					<xsl:if test="name()=$break_on_col6">
						<xsl:text>, </xsl:text>
						<xsl:value-of select="."/>
					</xsl:if>
				</xsl:for-each>
			</w:t>
			</w:r>
			<w:bookmarkStart w:id="0" w:name="_GoBack"/>
			<w:bookmarkEnd w:id="0"/>
		</w:p>
	</xsl:if>
</xsl:template>

<xsl:template name="replace-substring">
	<xsl:param name="original"/>
	<xsl:param name="substring"/>
	<xsl:param name="replacement" select="''"/>
	<xsl:variable name="first">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:value-of select="substring-before($original, $substring)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="middle">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:value-of select="$replacement"/>
			</xsl:when>
			<xsl:otherwise>
			<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="last">
		<xsl:choose>
			<xsl:when test="contains($original, $substring)">
				<xsl:choose>
					<xsl:when test="contains(substring-after($original, $substring), $substring)">
						<xsl:call-template name="replace-substring">
							<xsl:with-param name="original">
								<xsl:value-of select="substring-after($original, $substring)"/>
							</xsl:with-param>
							<xsl:with-param name="substring">
								<xsl:value-of select="$substring"/>
							</xsl:with-param>
							<xsl:with-param name="replacement">
								<xsl:value-of select="$replacement"/>
							</xsl:with-param>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="substring-after($original, $substring)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text></xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:value-of select="concat($first, $middle, $last)"/>
</xsl:template>

<xsl:template name="colname-header">
	<xsl:param name="colname"/>
	<xsl:param name="fullname"/>
	<!--xsl:value-of select="$colname"/-->
	<xsl:variable name="colname_">
		<xsl:call-template name="replace-substring">
			<xsl:with-param name="original">
				<xsl:value-of select="$colname"/>
			</xsl:with-param>
			<xsl:with-param name="substring">_x005F_</xsl:with-param>
			<xsl:with-param name="replacement">_</xsl:with-param>
		</xsl:call-template>
	</xsl:variable>
	
	<xsl:variable name="colname_show">
		<xsl:choose> 
			<xsl:when test="$fullname">
				<xsl:value-of select="$fullname"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$colname_"/>
			</xsl:otherwise>
		</xsl:choose> 
	</xsl:variable>
	
	<xsl:call-template name="replace-substring">
		<xsl:with-param name="original">
			<xsl:call-template name="replace-substring">
				<xsl:with-param name="original">
					<xsl:call-template name="replace-substring">
						<xsl:with-param name="original">
							<xsl:value-of select="$colname_show"/>
						</xsl:with-param>
						<xsl:with-param name="substring">_</xsl:with-param>
						<xsl:with-param name="replacement"><xsl:text> </xsl:text></xsl:with-param>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="substring">x26</xsl:with-param>
				<xsl:with-param name="replacement"><![CDATA[&]]></xsl:with-param>
			</xsl:call-template>
		</xsl:with-param>
		<xsl:with-param name="substring">x2e</xsl:with-param>
		<xsl:with-param name="replacement">.</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<!--template used for converting measures to MS OOXML mesaure units-->
<xsl:template name="ms_units">
	<xsl:param name="val"/>
	<xsl:param name="unit"/>
	
	<xsl:choose>
		<!--number values first-->
		<xsl:when test="$unit='dx'"> <!--MS OOXML mesaure unit-->
			<xsl:value-of select="round(number($val))"/>	
		</xsl:when>
		<xsl:when test="$unit='pt'"> <!--point, pixel-->
			<xsl:value-of select="round(number($val) * 20)"/>	
		</xsl:when>
		<xsl:when test="$unit='in'"> <!--inch-->
			<xsl:value-of select="round(number($val) * 1440)"/>	
		</xsl:when>
		<xsl:when test="$unit='mm'"> <!--milimeter-->
			<xsl:value-of select="round(number($val) * 56.69291338)"/>	
		</xsl:when>
		<xsl:when test="$unit='cm'"> <!--centimeter-->
			<xsl:value-of select="round(number($val) * 566.9291338)"/>	
		</xsl:when>
		<xsl:when test="$unit='fs'"> <!--font size-->
			<xsl:value-of select="number($val)"/>	
		</xsl:when>
		<xsl:when test="$unit='pc'"> <!--percent-->
			<xsl:value-of select="round(number($val) * 50)"/>	
		</xsl:when>
		<xsl:when test="$unit='or'"> <!--orientation-->
			<xsl:choose>
				<xsl:when test="$val='VERTICAL'">
					<xsl:text>portrait</xsl:text>
				</xsl:when>	
				<xsl:when test="$val='HORIZONTAL'">
					<xsl:text>landscape</xsl:text>
				</xsl:when>	
			</xsl:choose>
		</xsl:when>
		<!--text values-->
		<xsl:otherwise>	
			<xsl:value-of select="$val"/>	
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--Use default. Must be in MS OOXML mesaure unit-->
<xsl:template name="ms_units_with_default">
	<xsl:param name="use_print_settings1"/>
	<xsl:param name="val"/>
	<xsl:param name="unit"/>
	<xsl:param name="default_value"/>
	
	<xsl:choose>
		<xsl:when test="$val='' or $use_print_settings1='0'">  
			<xsl:value-of select="$default_value"/>	
		</xsl:when>
		<xsl:otherwise>	
			<xsl:call-template name="ms_units">
				<xsl:with-param name="val" select="$val"/>
				<xsl:with-param name="unit" select="$unit"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>	

<!--Template to calculate table column in MS OOXML mesaure units-->
<xsl:template name="column_width">
	<xsl:param name="tablewidth"/>
	<xsl:param name="col_width_pc"/> <!--column width in percentages of table width-->
	<xsl:param name="num_of_cols"/>
	<xsl:choose>
		<xsl:when test="$col_width_pc='' or $col_width_pc=0 or string-length($col_width_pc)=0"> 
			<xsl:value-of select="floor(number($tablewidth) div number($num_of_cols))"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="floor((number($tablewidth) * number($col_width_pc)) div 100)"/> 		
		</xsl:otherwise>
	</xsl:choose>
	
</xsl:template>	



</xsl:stylesheet>

