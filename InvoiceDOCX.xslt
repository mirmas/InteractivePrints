<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0"/>
<xsl:param name="Subtitle" select="'Subtitle'"/>
<xsl:param name="boldValue" select="'Title'"/>
<xsl:param name="orient" select="'landscape'"/> <!--page orientation landscape or portrait-->
<xsl:param name="margintop" select="1417"/>  <!--page margins-->
<xsl:param name="marginright" select="1417"/> 
<xsl:param name="marginbottom" select="1417"/> 
<xsl:param name="marginleft" select="1417"/> 
<xsl:param name="headerfromtop" select="708"/>  <!--header margin-->
<xsl:param name="footerfrombottom" select="708"/> <!--footer margin--> 
<xsl:param name="tablestyle" select="'TableGrid8'"/> <!--Table style defined in styles part--> 
<xsl:param name="firstrowfontcolor" select="'FFFFFF'"/> <!--First row font color (default white)--> 
<xsl:param name="firstrowthemecolor" select="'background1'"/> <!--First row background color (default deep blue)--> 
<xsl:param name="rowfontcolor" select="'365F91'"/> <!--Row font color (default light blue)--> 
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
          <w:sectPr w:rsidR="00170E74" w:rsidRPr="00455D06">
            <w:pgSz w:w="11906" w:h="16838" w:orient="{$orient}"/>
            <w:pgMar w:top="{$margintop}" w:right="{$marginright}" w:bottom="{$marginbottom}" w:left="{$marginleft}" w:header="{$headerfromtop}" w:footer="{$footerfrombottom}" w:gutter="0"/>
            <w:cols w:space="708"/>
            <w:docGrid w:linePitch="360"/>
          </w:sectPr>
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
			<xsl:text> </xsl:text>
			<xsl:value-of select="@IR_name"/>
		</w:t>
		</w:r>
		<w:r w:rsidR="00996A33" w:rsidRPr="00455D06">
		<w:rPr>
		<!--w:lang w:val="en-US"/-->
		</w:rPr>
		<w:t xml:space="preserve"> </w:t>
		</w:r>
	</w:p>
	<w:p w:rsidR="00023B61" w:rsidRPr="00023B61" w:rsidRDefault="00023B61" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
	<w:pPr>
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	</w:pPr>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve">Customer Info: </w:t>
	</w:r>
	<w:r>
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve"> </w:t>
	</w:r>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:noProof/>
	</w:rPr>
	<w:t>#P29_CUSTOMER_INFO1#</w:t>
	</w:r>
	</w:p>
	<w:p w:rsidR="00023B61" w:rsidRPr="00023B61" w:rsidRDefault="00023B61" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
	<w:pPr>
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	</w:pPr>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve">Order Date: </w:t>
	</w:r>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve">#P29_ORDER_TIMESTAMP#</w:t>
	</w:r>
	</w:p>
	<w:p w:rsidR="002E4C8F" w:rsidRPr="00023B61" w:rsidRDefault="00023B61" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
	<w:pPr>
	<w:rPr>
	<w:noProof/>
	</w:rPr>
	</w:pPr>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve">Total: </w:t>
	</w:r>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:noProof/>
	</w:rPr>
	<w:t>#P29_ORDER_TOTAL#</w:t>
	</w:r>
	</w:p>
	<w:p w:rsidR="00023B61" w:rsidRPr="00023B61" w:rsidRDefault="00023B61" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
	<w:pPr>
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	</w:pPr>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve">Sales Rep: </w:t>
	</w:r>
	<w:r>
	<w:rPr>
	<w:b/>
	<w:noProof/>
	</w:rPr>
	<w:t xml:space="preserve"> </w:t>
	</w:r>
	<w:bookmarkStart w:id="0" w:name="_GoBack"/>
	<w:bookmarkEnd w:id="0"/>
	<w:r w:rsidRPr="00023B61">
	<w:rPr>
	<w:noProof/>
	</w:rPr>
	<w:t>#P29_USER_NAME#</w:t>
	</w:r>
	</w:p>

	<!--w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:pStyle w:val="Subtitle"/>
		<w:rPr>
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00455D06">
		<w:rPr>
		</w:rPr>
		<w:t><xsl:value-of select="$Subtitle"/></w:t>
		</w:r>
	</w:p-->
	<w:p w:rsidR="002E4C8F" w:rsidRPr="00455D06" w:rsidRDefault="00996A33" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<w:pPr>
		<w:rPr>
		<!--w:lang w:val="en-US"/-->
		</w:rPr>
		</w:pPr>
		<w:r w:rsidRPr="00455D06">
		<w:rPr>
		<!--w:lang w:val="en-US"/-->
		</w:rPr>
		<w:t> </w:t>
		</w:r>
	</w:p>
		<xsl:for-each select="ROW">
	 		<xsl:variable name="rowpos" select="position()"/>
	 		<xsl:variable name="lastrow" select="last()"/>
			<xsl:choose>
				<xsl:when test="@breakrow=1"> <!--This is breakrow, end table of previous break group, list info from break cols (= common info of break group), then start new table -->
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
				<xsl:otherwise> <!--not break row-->
					<xsl:if test="$rowpos = 1"> <!--If first Region row then start new table-->
						<xsl:call-template name="start-table"> 
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
						<xsl:for-each select="*"> 
							<!--dont include break cols into table, break cols are in heading before each break group table-->
							<xsl:if test="not(name()=$break_on_col1)">
							<xsl:if test="not(name()=$break_on_col2)">
							<xsl:if test="not(name()=$break_on_col3)">
							<xsl:if test="not(name()=$break_on_col4)">
							<xsl:if test="not(name()=$break_on_col5)">
							<xsl:if test="not(name()=$break_on_col6)">		
							<xsl:if test="not(name()='Product_Image')">		
							<xsl:if test="not(name()='Display_Id')">		
								<w:tc>
								<w:tcPr>
								<w:tcW w:w="1600" w:type="dxa"/>
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
										<xsl:when test="$rowpos=$lastrow and position()=1">
											<w:rPr>
											<w:b/>
											<w:color w:val="{$rowfontcolor}"/>
											</w:rPr>
											<xsl:text>TOTAL</xsl:text>
										</xsl:when>
										<xsl:when test="name()=$boldValue">
											<w:rPr>
											<w:b/>
											<w:color w:val="{$rowfontcolor}"/>
											</w:rPr>
											<xsl:value-of select="."/>
										</xsl:when>
										<xsl:when test="@aggr_function = 'SUM'">
											<w:rPr>
											<w:b/>
											<w:color w:val="{$rowfontcolor}"/>
											</w:rPr>
											<!--xsl:value-of select="@aggr_function"/-->
											<!--xsl:text>: </xsl:text-->
											<xsl:value-of select="."/>
										</xsl:when>
										<xsl:otherwise>
											<w:rPr>
											<w:color w:val="{$rowfontcolor}"/>
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
							</xsl:if>
							</xsl:if>
						</xsl:for-each>
					</w:tr>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	<xsl:call-template name="end_table"/>
</xsl:template>


<xsl:template name="table-header-col"> 
	<xsl:param name="col_name"/>
	<xsl:param name="col_name_show"/>
	<xsl:param name="break_on_col1"/>
	<xsl:param name="break_on_col2"/>
	<xsl:param name="break_on_col3"/>
	<xsl:param name="break_on_col4"/>
	<xsl:param name="break_on_col5"/>
	<xsl:param name="break_on_col6"/>

	<xsl:if test="not($col_name=$break_on_col1)">
	<xsl:if test="not($col_name=$break_on_col2)">
	<xsl:if test="not($col_name=$break_on_col3)">
	<xsl:if test="not($col_name=$break_on_col4)">
	<xsl:if test="not($col_name=$break_on_col5)">
	<xsl:if test="not($col_name=$break_on_col6)">
	<xsl:if test="not($col_name='Product_Image')">		
	<xsl:if test="not($col_name='Display_Id')">		
		<w:tc xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
			<w:tcPr>
			<w:tcW w:w="1600" w:type="dxa"/>
			</w:tcPr>
			<w:p w:rsidR="003C23EC" w:rsidRPr="00DF4B83" w:rsidRDefault="00245AEA">
			<w:pPr>
			<w:spacing w:after="0" w:line="240" w:lineRule="auto"/>
			<w:rPr>
			<w:color w:val="{$firstrowfontcolor}" w:themeColor="{$firstrowthemecolor}"/>
			<!--w:lang w:val="en-US"/-->
			</w:rPr>
			</w:pPr>
			<w:r w:rsidRPr="00DF4B83">
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
	</xsl:if>
	</xsl:if>																
</xsl:template>

<xsl:template name="table-header-cols"> 
	<xsl:param name="position"/>
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
		<w:tblW w:w="0" w:type="auto"/>
		<w:tblLook w:val="04A0" w:firstRow="1" w:lastRow="0" w:firstColumn="0" w:lastColumn="0" w:noHBand="0" w:noVBand="1"/>
	</w:tblPr>
	
	<w:tblGrid xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
		<xsl:for-each select="*">
			<xsl:if test="name()!=$break_on_col1"> 
			<xsl:if test="name()!=$break_on_col2">
			<xsl:if test="name()!=$break_on_col3"> 
			<xsl:if test="name()!=$break_on_col4"> 
			<xsl:if test="name()!=$break_on_col5"> 
			<xsl:if test="name()!=$break_on_col6">
			<xsl:if test="name()!='Product_Image'">		
			<xsl:if test="name()!='Display_Id'">			  
				<w:gridCol w:w="1400"/>
			</xsl:if>
			</xsl:if> 
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
		<xsl:call-template name="table-header-cols"> 
			<xsl:with-param name="position"><xsl:value-of select="position()"/></xsl:with-param>
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

</xsl:stylesheet>

