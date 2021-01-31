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
<xsl:param name="margintop" select="1417"/>  <!--page margins-->
<xsl:param name="marginright" select="1417"/> 
<xsl:param name="marginbottom" select="1417"/> 
<xsl:param name="marginleft" select="1417"/> 
<xsl:param name="headerfromtop" select="708"/>  <!--header margin-->
<xsl:param name="footerfrombottom" select="708"/> <!--footer margin--> 

<!--default colors and fonts-->
<xsl:param name="def_firstrowfontcolor" select="'000000'"/> <!--First row font color (default black)--> 
<xsl:param name="def_firstrowfont" select="'Calibri'"/> <!--table header font-->
<xsl:param name="def_firstrowfontsize" select="24"/> <!--table header font size 12-->

<xsl:param name="def_rowfontcolor" select="'000000'"/> <!--Row font color (default black)--> 
<xsl:param name="def_rowthemecolor"/> <!--Row background Word marker color (default is empty => no background). See next lines for possible values!--> 
<xsl:param name="def_rowfont" select="'Calibri'"/> <!--Row font (default Calibri)--> 
<xsl:param name="def_rowfontsize" select="22"/> <!--Row font size (default 11)--> 
<xsl:param name="pagebreak_for_region" select="1"/> <!--If multiple APEX regions are in single document separate it with page breaks-->
<!--end of default colors and fonts-->
<!--Word marker colors: Possible values are: 
    yellow FFFF99
    green  99FF99
    blue   99CCFF  
	red    FF7755	
	darkGreen 006400,
	darkMagenta 8b008b,
	magenta ff00ff,
	darkRed 8B0000,
	darkYellow CDCD00,
	lightGray D3D3D3,
	darkGray 303030,
	black 000000,
	cyan 00FFFF,
	darkBlue 0000EE,
	darkCyan 008B8B
-->
<!--APEX color
orange FFDD44 (not MS Word Marker color)
-->


			 	
<!--page width-->
<xsl:variable name="pagewidth"> 
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="#PAGE_WIDTH#"/>
			<xsl:with-param name="unit" select="'#UNITS#'"/>
			<xsl:with-param name="default_value" select="$def_pagewidth"/>
		</xsl:call-template>
</xsl:variable>

<!--page orientation landscape or portrait-->
<xsl:variable name="orient"> 
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#ORIENTATION#'"/>
			<xsl:with-param name="unit" select="'or'"/>
			<xsl:with-param name="default_value" select="$def_orient"/>
		</xsl:call-template>
</xsl:variable>	
	
<!--page height-->	
<xsl:variable name="pageheight"> 
	<xsl:call-template name="ms_units_with_default">
		<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
		<xsl:with-param name="val" select="#PAGE_HEIGHT#"/>
		<xsl:with-param name="unit" select="'#UNITS#'"/>
		<xsl:with-param name="default_value" select="$def_pageheight"/>
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
	
	<xsl:variable name="rowthemecolor"> <!--table row background color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#BODY_HIGHLIGHT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_rowthemecolor"/>
		</xsl:call-template>
	</xsl:variable>
<!--end of table body fonts and colors-->
	
	<xsl:variable name="firstrowfontcolor"> <!--table header font color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_FONT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<xsl:with-param name="default_value" select="$def_firstrowfontcolor"/>
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
	
	<xsl:variable name="firstrowthemecolor"> <!--table row background color-->
		<xsl:call-template name="ms_units_with_default">
			<xsl:with-param name="use_print_settings1" select="$use_print_settings"/>
			<xsl:with-param name="val" select="'#HEADER_HIGHLIGHT_COLOR#'"/>
			<xsl:with-param name="unit" select="'cl'"/>
			<!--xsl:with-param name="default_value" select="$def_firstrowthemecolor"/-->
		</xsl:call-template>
	</xsl:variable>


<xsl:preserve-space elements="*"/>
<xsl:template match="/">
		
<xsl:processing-instruction name="mso-application">progid="Word.Document"</xsl:processing-instruction>

<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
  <pkg:part pkg:name="/word/document.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml">
    <pkg:xmlData>
      <w:document xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 wp14">
        <w:body>
        	<!--render data (ROWSET nodes) here-->
        	<xsl:apply-templates select="//DOCUMENT/ROWSET"/>
        	
        	<xsl:if test="$use_print_settings=1">
	          <w:sectPr w:rsidR="00002B63">
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
	<!--Title and subtitle-->
	<!--Title of document-->
	<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
	<w:pPr>
	<w:pStyle w:val="Title"/>
	<w:divId w:val="1183738353"/>
	</w:pPr>
	<w:r>
	<w:t>
		<!--Document title is APEX region name-->
		<xsl:value-of select="@name"/>
	</w:t>
	</w:r>
	</w:p>
	<!--Subtitle is renderd in case of IR as name of IR-->
	<xsl:if test="@IR_name != ''">
		<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50">
		<w:pPr>
		<w:pStyle w:val="Subtitle"/>
		</w:pPr>
		<w:r>
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
		<w:r>
		<w:tab/>
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
	

  <!--Render word list from data in XML-->
	<xsl:for-each select="ROW">
		<xsl:choose>
			<!--This is breakrow, end list of previous break group, list info from break cols (= common info of break group), then start new list -->
			<xsl:when test="@breakrow=1">
				<!--list info from break cols (= common info of break group)-->
				<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
					<w:pPr>
					<w:pStyle w:val="Heading1"/>
					<w:rPr>
					</w:rPr>
					</w:pPr>
					<w:r w:rsidR="00B13FF7">
					<w:rPr>
					</w:rPr>
					<w:t>
						<xsl:for-each select="*">	
							<xsl:if test="@break_on_col">
								<xsl:value-of select="."/>
							</xsl:if>
						</xsl:for-each>
					</w:t>
					</w:r>
					<w:bookmarkStart w:id="0" w:name="_GoBack"/>
					<w:bookmarkEnd w:id="0"/>
				</w:p>
			</xsl:when>
			
			<xsl:when test="@breakrow=2"> 
				<!--Grand total caption-->
				<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
					<w:pPr>
					<w:pStyle w:val="Heading1"/>
					<w:rPr>
					</w:rPr>
					</w:pPr>
					<w:r w:rsidR="00B13FF7">
					<w:rPr>
					</w:rPr>
					<w:t>
						<xsl:value-of select="$GrandTotalText"/>
					</w:t>
					</w:r>
					<w:bookmarkStart w:id="0" w:name="_GoBack"/>
					<w:bookmarkEnd w:id="0"/>
				</w:p>
				
				<!--render list line-->
				<xsl:for-each select="*">
				    <xsl:call-template name="list-header-value"/> 	
				</xsl:for-each>
			</xsl:when>	<!--@breakrow=2"-->
			
			<!--render aggregation line-->
			<xsl:when test="@aggregation">
				<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00F80F50" w:rsidP="00570139">
					<!--Heading3 style text "Summary"-->
					<w:pPr>
						<w:pStyle w:val="Heading3"/>
					</w:pPr>
					<w:r>
						<w:t>Summary</w:t>
					</w:r>
				</w:p>
				
				<!--render list line-->
				<xsl:for-each select="*">
				    <xsl:call-template name="list-header-value"/>
				</xsl:for-each>
			</xsl:when>
			<!--not aggregation, ordinary list line-->
			<xsl:otherwise>
				<!--Empty paragraph-->
				<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00BB61A6" w:rsidRDefault="00BB61A6" w:rsidP="00BB61A6">
					<w:pPr>
						<w:pStyle w:val="NoSpacing"/>
					</w:pPr>
					<w:bookmarkStart w:id="0" w:name="_GoBack"/>
					<w:bookmarkEnd w:id="0"/>
				</w:p>		      
				<xsl:for-each select="*">
				    <xsl:call-template name="list-header-value"/> 					
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:for-each>
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


<!--render one list line header value pair, format - header: value, header in bold. e.g. Name: John-->
<xsl:template name="list-header-value"> 
	<!--dont include break cols into list, break cols are in heading before each break group list-->
	<xsl:if test="not(@break_on_col)">								
		<xsl:variable name="rowfontcolor_cur">
			<xsl:choose>
				<xsl:when test="@highlight_font_color">
					<xsl:value-of select="@highlight_font_color"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rowfontcolor"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
					
		<xsl:variable name="highlight_bkg_color_cur">
			<xsl:choose>
				<xsl:when test="@text_highlight_color">
					<xsl:value-of select="@text_highlight_color"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$rowthemecolor"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
								
		<xsl:if test="text()">
			<w:p xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" w:rsidR="00002B63" w:rsidRDefault="00570139" w:rsidP="00570139">
			<w:pPr>
			  <w:pStyle w:val="NoSpacing"/>
			</w:pPr>
			
			<!--if there is aggregation function, render name of aggregation function first, e.g. SUM Income: 20-->
			<xsl:if test="@aggr_function">
				<w:r>
					<w:rPr>
					<w:rFonts w:ascii="{$firstrowfont}" w:hAnsi="{$firstrowfont}" w:cs="{$firstrowfont}"/>		
						#HEADER_FONT_WEIGHT#	
						<w:color w:val="{$firstrowfontcolor}"/>
						<w:sz w:val="{$firstrowfontsize}"/>
						<w:szCs w:val="{$firstrowfontsize}"/>
						<xsl:if test = "$firstrowthemecolor and string-length($firstrowthemecolor) &gt; 0">
							<w:highlight w:val="{$firstrowthemecolor}"/>
						</xsl:if>
					</w:rPr>
					<w:t xml:space="preserve">
						<xsl:value-of select="@aggr_function"/>
						<xsl:text> </xsl:text>
					</w:t>
				</w:r>
			</xsl:if>
			
			<!--if there is no aggregation function, render just header and value like Income: 5-->
			<w:r w:rsidR="00F80F50">
				<w:rPr>
					<w:rFonts w:ascii="{$firstrowfont}" w:hAnsi="{$firstrowfont}" w:cs="{$firstrowfont}"/>		
						#HEADER_FONT_WEIGHT#	
						<w:color w:val="{$firstrowfontcolor}"/>
						<w:sz w:val="{$firstrowfontsize}"/>
						<w:szCs w:val="{$firstrowfontsize}"/>
						<xsl:if test = "$firstrowthemecolor and string-length($firstrowthemecolor) &gt; 0">
							<w:highlight w:val="{$firstrowthemecolor}"/>
						</xsl:if>
				</w:rPr>
				<w:t xml:space="preserve">
					<xsl:value-of select="@FULL_NAME"/>
					<xsl:text>: </xsl:text> 
				</w:t>
			</w:r>
			<w:r w:rsidR="00F80F50">
				<w:rPr>
					<w:rFonts w:ascii="{$rowfont}" w:hAnsi="{$rowfont}" w:cs="{$rowfont}"/>		
						#BODY_FONT_WEIGHT#	
						<w:color w:val="{$rowfontcolor_cur}"/>
						<w:sz w:val="{$rowfontsize}"/>
						<w:szCs w:val="{$rowfontsize}"/>
						<xsl:if test = "$highlight_bkg_color_cur and string-length($highlight_bkg_color_cur) &gt; 0">
							<w:highlight w:val="{$highlight_bkg_color_cur}"/>
						</xsl:if>
				 </w:rPr>			
				<w:t xml:space="preserve"><xsl:value-of select="."/></w:t>
			</w:r>
		  </w:p>          
		</xsl:if>
	</xsl:if>								
</xsl:template>


<!--template for render breakrow header. Here is data from breakrow columns.-->
<xsl:template name="breakrow_header">
	<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" w:rsidP="00B13FF7" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:pStyle w:val="Heading1"/>
		<w:rPr>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidR="00B13FF7">
		<w:rPr>
		</w:rPr>
		<w:t>
			<xsl:for-each select="*">	
				<xsl:if test="@break_on_col">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</w:t>
		</w:r>
		<w:bookmarkStart w:id="0" w:name="_GoBack"/>
		<w:bookmarkEnd w:id="0"/>
	</w:p>
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

</xsl:stylesheet>
