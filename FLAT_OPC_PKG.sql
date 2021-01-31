
CREATE OR REPLACE PACKAGE FLAT_OPC_PKG AS

-- Interactive Prints using the following MIT License:
  --
  -- The MIT License (MIT)
  --
  -- Copyright (c) 2021 Mirmas IC
  --
  -- Permission is hereby granted, free of charge, to any person obtaining a copy
  -- of this software and associated documentation files (the "Software"), to deal
  -- in the Software without restriction, including without limitation the rights
  -- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  -- copies of the Software, and to permit persons to whom the Software is
  -- furnished to do so, subject to the following conditions:
  --
  -- The above copyright notice and this permission notice shall be included in all
  -- copies or substantial portions of the Software.
  --
  -- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  -- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  -- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  -- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  -- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  -- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  -- SOFTWARE.

/*

  Purpose:      Package converts between Office Open XML and Flat OPC files or BLOBs

  Remarks:      by Miro Manoglav, Mirmas IC see http://www.mirmas.si --TODO add blog

                OOXML introduction: http://msdn.microsoft.com/en-us/library/aa338205%28v=office.12%29.aspx
                Flat OPC format: http://blogs.msdn.com/b/ericwhite/archive/2008/09/29/the-flat-opc-format.aspx

  Who     Date        Description
  ------  ----------  --------------------------------
  ???     12.06.2014  Created

  */

/** Convert OOXML format (DOCX, XLSX, PPTX) to Flat OPC XML.
  * If specified, converts base64 encoded embeeded DOCX or XLSX content to FlatOPC.
  * @param p_OOXML Open XML blob
  * @param p_filetype DOCX, XLSX or PPTX
  * @param po_parts Output file names of all OOXML parts separated with comma.
  * @param p_unzip_embeedeings If set to true, converts base64 encoded embeeded DOCX and XLSX content to Flat OPC.
  * In that case FLAT OPC is more suitable for XSLT processing but cannot be opened with Word or PowerPoint. Excel doesn't support Flat OPC format.
  * If set to false, it lefts base64 encoded embeeded content unchanged. That way you can open the file with Word or PowerPoint.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  * @return Flat OPC XML
  */
  function OOXML2FlatOPC(
    p_OOXML BLOB,
    p_filetype varchar2,
    po_parts OUT varchar2,
    p_unzip_embeedeings boolean := false,
    p_encoding varchar2 := null
  )
  return CLOB;

$if CCOMPILING.g_utl_file_privilege $then
/** Convert OOXML file (DOCX, XLSX, PPTX) to Flat OPC XML file.
  * If specified, converts base64 encoded embeeded content to FlatOPC.
  * @param p_OOXMLDir Oracle server directory with Open XML file.
  * @param p_OOXMLFile Open XML file name.
  * @param p_FlatOPCDir Oracle server directory with Flat OPC file.
  * @param p_FlatOPCFile Flat OPC file name.
  * @param p_unzip_embeedeings If set to true, converts base64 encoded embeeded DOCX and XLSX content to Flat OPC.
  * In that case FLAT OPC is more suitable for XSLT processing but cannot be opened with Word or PowerPoint. Excel doesn't support Flat OPC format.
  * If set to false, it lefts base64 encoded embeeded content unchanged. That way you can open the file with Word or PowerPoint.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  */
  procedure OOXML2FlatOPC(
    p_OOXMLDir  varchar2,
    p_OOXMLFile varchar2,
    p_FlatOPCDir  varchar2,
    p_FlatOPCFile varchar2,
	po_parts OUT varchar2,
    p_unzip_embeedeings boolean := false,
    p_encoding varchar2 := null
  );
$end

/** Convert Flat OPC XML CLOB to OOXML BLOB (DOCX, XLSX, PPTX).
  * You should set parameter p_staticParts to non null values only if you really need to compose
  * final OOXML from two Flat OPC CLOBs. Custom scenario would be producing FlatOPC CLOB with XSLT (dynamic parts) and add the rest of the OOXML parts
  * from p_staticParts CLOB.
  * @param p_FlatOPC Flat OPC clob, on output FLAT OPC with base64 encoded embeeded DOCX and XLSX content that can be opened with Word or Power Point. Excel doesn't support Flat OPC format.
  * If input CLOB doesn't contain any embeeded DOCX and XLSX content output CLOB is equal to input CLOB.
  * @param p_staticParts Flat OPC CLOB with static OOXML parts.
  * These should be parts (dynamic parts) of p_FlatOPC CLOB. The rest of the parts will be included from p_staticParts CLOB.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  * @return OOXML BLOB
  */
  function FlatOPC2OOXMLEx(
    pio_FlatOPC IN OUT NOCOPY CLOB,
    pio_staticParts IN OUT NOCOPY CLOB,
    p_encoding varchar2 default null
  )
  return BLOB;

/** Convert Flat OPC XML CLOB to OOXML BLOB (DOCX, XLSX, PPTX).
  * You should set parameter p_staticParts to non null values only if you really need to compose
  * final OOXML from two Flat OPC CLOBs. Custom scenario would be producing FlatOPC CLOB with XSLT (dynamic parts) and add the rest of the OOXML parts
  * from p_staticParts CLOB.
  * @param p_FlatOPC Flat OPC clob.
  * @param p_staticParts Flat OPC CLOB with static OOXML parts.
  * These should be parts (dynamic parts) of p_FlatOPC CLOB. The rest of the parts will be included from p_staticParts CLOB.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  * @return OOXML BLOB
  */
  function FlatOPC2OOXML(
    p_FlatOPC CLOB,
    p_staticParts CLOB default null,
    p_encoding varchar2 default null
  )
  return BLOB;

  function ReadAttribute(p_Xml CLOB, p_offset number, p_attrname varchar2)
  return varchar2;

$if CCOMPILING.g_utl_file_privilege $then
/** Convert Flat OPC XML file to OOXML file (DOCX, XLSX, PPTX). Optionaly can also write "valid" FLAT OPC file with
  * base64 encoded embeeded DOCX and XLSX content that can be opened with Word or Power Point. Excel doesn't support Flat OPC format.
  * You should set parameters p_staticPartsDir, p_staticPartsFile to non null values only if you really need to compose
  * final OOXML from two Flat OPC files. Custom scenario would be producing FlatOPCFile with XSLT (dynamic parts) and add the rest of the OOXML parts
  * from p_staticPartsFile file.
  * @param p_FlatOPCDir Oracle server directory with Flat OPC file.
  * @param p_FlatOPCFile Flat OPC file name.
  * @param p_OOXMLDir Oracle server directory with Open XML file.
  * @param p_OOXMLFile Open XML file name.
  * @param p_FlatOPCValidDir Oracle server directory with "valid" Flat OPC file. File can be opened with Word or Power Point.
  * @param p_FlatOPCValidFile "Valid" flat OPC file name. File can be opened with Word or Power Point.
  * @param p_staticPartsDir Oracle server directory with Flat OPC file with static OOXML parts.
  * @param p_staticPartsFile Flat OPC name of file with static OOXML parts.
  * These should be parts (dynamic parts) of p_FlatOPCFile file. The rest of the parts will be included from p_staticPartsFile.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  */
  procedure FlatOPC2OOXML(
    p_FlatOPCDir  varchar2,
    p_FlatOPCFile varchar2,
    p_OOXMLDir  varchar2 := null,
    p_OOXMLFile varchar2 := null,
    p_FlatOPCValidDir  varchar2 := null,
    p_FlatOPCValidFile varchar2 := null,
    p_staticPartsDir varchar2 := null,
    p_staticPartsFile varchar2 := null,
    p_encoding varchar2 := null
  );
$end

/** Exclude only parts for transformation
  * @param pio_FlatOPC Flat OPC clob, on output FLAT OPC with parts for XSL transformation only.
  * @param p_partsToTransform XSL Transformed parts of po_OOXML separated with comma.
  */
  procedure FlatOPCTransfromedOnly(
    pio_FlatOPC IN OUT CLOB,
    p_partsToTransform varchar2
  );

/** Add p_second_FlatOPC to p_FlatOPC part by part and returns merged Flat OPC.
  * @param p_FlatOPC Clob with first Flat OPC. First Flat OPC will be copied into returned CLOB as a whole.
  * @param p_second_FlatOPC Clob with second Flat OPC. Parts that don't already exist in p_FlatOPC will be copied to returned CLOB.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  * @return merged Flat OPC.
  */
  function MergeFlatOPC(
    p_FlatOPC             IN CLOB,
    p_second_FlatOPC      IN CLOB,
    p_encoding            varchar2 default null
  ) return CLOB;

$if CCOMPILING.g_utl_file_privilege $then
/** Add file p_second_FlatOPCDir/File to file p_FlatOPCDir/File part by part and returns merged Flat OPC in file p_merged_FlatOPCDir/File.
  * @param p_FlatOPCDir Location of first Flat OPC. First Flat OPC will be copied into returned file p_merged_FlatOPCDir/File as a whole.
  * @param p_FlatOPCFile Filename of first Flat OPC. First Flat OPC will be copied into returned file p_merged_FlatOPCDir/File as a whole.
  * @param p_second_FlatOPCDir Location of second Flat OPC. Parts that don't already exist in p_FlatOPCDir/File will be copied to returned file p_merged_FlatOPCDir/File.
  * @param p_second_FlatOPCFile Filename of second Flat OPC. Parts that don't already exist in p_FlatOPCDir/File will be copied to returned file p_merged_FlatOPCDir/File.
  * @param p_merged_FlatOPCDir Location of returned (merged) Flat OPC.
  * @param p_merged_FlatOPCFile Filename of returned (merged) Flat OPC.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  */
  procedure MergeFlatOPC(
    p_FlatOPCDir              varchar2,
    p_FlatOPCFile             varchar2,
    p_second_FlatOPCDir       varchar2,
    p_second_FlatOPCFile      varchar2,
    p_merged_FlatOPCDir       varchar2,
    p_merged_FlatOPCFile      varchar2,
    p_encoding                varchar2 default null
  ) ;
$end

------------testi pobriši
Procedure ZipEmbeedings(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
);

Procedure UnzipEmbeedings(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
);


END FLAT_OPC_PKG;

/
