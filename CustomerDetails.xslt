<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" version="1.0"/>
<xsl:template match="/">


<xsl:processing-instruction name="mso-application">progid="Word.Document"</xsl:processing-instruction>

<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">
  <pkg:part pkg:name="/word/document.xml" pkg:contentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml">
    <pkg:xmlData>
      <w:document xmlns:wpc="http://schemas.microsoft.com/office/word/2010/wordprocessingCanvas" xmlns:cx="http://schemas.microsoft.com/office/drawing/2014/chartex" xmlns:cx1="http://schemas.microsoft.com/office/drawing/2015/9/8/chartex" xmlns:cx2="http://schemas.microsoft.com/office/drawing/2015/10/21/chartex" xmlns:cx3="http://schemas.microsoft.com/office/drawing/2016/5/9/chartex" xmlns:cx4="http://schemas.microsoft.com/office/drawing/2016/5/10/chartex" xmlns:cx5="http://schemas.microsoft.com/office/drawing/2016/5/11/chartex" xmlns:cx6="http://schemas.microsoft.com/office/drawing/2016/5/12/chartex" xmlns:cx7="http://schemas.microsoft.com/office/drawing/2016/5/13/chartex" xmlns:cx8="http://schemas.microsoft.com/office/drawing/2016/5/14/chartex" xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" xmlns:aink="http://schemas.microsoft.com/office/drawing/2016/ink" xmlns:am3d="http://schemas.microsoft.com/office/drawing/2017/model3d" xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:m="http://schemas.openxmlformats.org/officeDocument/2006/math" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:wp14="http://schemas.microsoft.com/office/word/2010/wordprocessingDrawing" xmlns:wp="http://schemas.openxmlformats.org/drawingml/2006/wordprocessingDrawing" xmlns:w10="urn:schemas-microsoft-com:office:word" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:w14="http://schemas.microsoft.com/office/word/2010/wordml" xmlns:w15="http://schemas.microsoft.com/office/word/2012/wordml" xmlns:w16cid="http://schemas.microsoft.com/office/word/2016/wordml/cid" xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" xmlns:wpg="http://schemas.microsoft.com/office/word/2010/wordprocessingGroup" xmlns:wpi="http://schemas.microsoft.com/office/word/2010/wordprocessingInk" xmlns:wne="http://schemas.microsoft.com/office/word/2006/wordml" xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape" mc:Ignorable="w14 w15 w16se w16cid wp14">
        <w:body>
          <w:p w:rsidR="00726B44" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">First Name: </w:t>
            </w:r>
            <w:r w:rsidRPr="007B773B">
              <w:t xml:space="preserve">#P7_CUST_FIRST_NAME#</w:t>
            </w:r>
            <w:bookmarkStart w:id="0" w:name="_GoBack"/>
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve"> Last Name: </w:t>
            </w:r>
            <w:bookmarkEnd w:id="0"/>
            <w:r>
              <w:t xml:space="preserve">#P7_CUST_LAST_NAME#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">Street Address: </w:t>
            </w:r>
            <w:r>
              <w:t>#P7_CUST_STREET_ADDRESS1#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">Line 2: </w:t>
            </w:r>
            <w:r>
              <w:t>#P7_CUST_STREET_ADDRESS2#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">City: </w:t>
            </w:r>
            <w:r>
              <w:t xml:space="preserve">#P7_CUST_CITY#</w:t>
            </w:r>
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve"> Zip Code: </w:t>
            </w:r>
            <w:r>
              <w:t>#P7_CUST_POSTAL_CODE#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
          	<w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve"> State: </w:t>
            </w:r>
            <w:r>
              <w:t>#P7_CUST_STATE#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">Credit Limit: </w:t>
            </w:r>
            <w:r>
              <w:t>#P7_CREDIT_LIMIT#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">Phone Number: </w:t>
            </w:r>
            <w:r>
              <w:t xml:space="preserve">#P7_PHONE_NUMBER1#</w:t>
            </w:r>
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve"> Alternate Number: </w:t>
            </w:r>
            <w:r>
              <w:t>#P7_PHONE_NUMBER2#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t>Email: </w:t>
            </w:r>
            <w:r>
              <w:t xml:space="preserve">#P7_CUST_EMAIL#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">URL: </w:t>
            </w:r>
            <w:r>
              <w:t xml:space="preserve">#P7_URL#</w:t>
            </w:r>
          </w:p>
          <w:p w:rsidR="007B773B" w:rsidRDefault="007B773B">
            <w:r w:rsidRPr="007B773B">
              <w:rPr>
                <w:b/>
              </w:rPr>
              <w:t xml:space="preserve">Tags: </w:t>
            </w:r>
            <w:r>
              <w:t xml:space="preserve">#P7_TAGS#</w:t>
            </w:r>
          </w:p>
          <w:sectPr w:rsidR="007B773B">
            <w:pgSz w:w="11906" w:h="16838"/>
            <w:pgMar w:top="1417" w:right="1417" w:bottom="1417" w:left="1417" w:header="708" w:footer="708" w:gutter="0"/>
            <w:cols w:space="708"/>
            <w:docGrid w:linePitch="360"/>
          </w:sectPr>
        </w:body>
      </w:document>
    </pkg:xmlData>
  </pkg:part>
</pkg:package>

</xsl:template>
</xsl:stylesheet>
