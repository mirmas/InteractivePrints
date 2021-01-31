
CREATE OR REPLACE PACKAGE "PAK_BLOB_UTIL" AS

-- Interactive Prints  using the following MIT License:
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
  
/** Converts whole BLOB to CLOB
  *
  * @param p_blob BLOB to convert
  * @param p_clob_csid BLOB encoding charset ID E.g. NLS_CHARSET_ID('EE8MSWIN1250') for windows-1250
  * @return CLOB
  */
function BLOB2CLOB
(
p_blob  BLOB,
p_clob_csid number default NLS_CHARSET_ID('AL32UTF8')
) return CLOB;
/** Converts XMLType to CLOB
  *
  * @param p_xml xml to convert
  * @param p_clob_csid BLOB encoding charset ID E.g. NLS_CHARSET_ID('EE8MSWIN1250') for windows-1250
  * @return CLOB
  */
function XML2CLOB
(
p_xml  SYS.XMLType,
p_clob_csid number default NLS_CHARSET_ID('AL32UTF8')
) return CLOB;
/** Converts whole CLOB to BLOB
  *
  * @param p_clob CLOB to convert
  * @param p_clob_csid BLOB encoding charset ID E.g. NLS_CHARSET_ID('EE8MSWIN1250') for windows-1250
  * @return CLOB
  */
function CLOB2BLOB
(
  p_clob  CLOB,
  p_clob_csid number default NLS_CHARSET_ID('AL32UTF8')
) return BLOB;
/** Reads BLOB from file
  *
  * @param P_DIRECTORY ORA directory
  * @param P_FILENAME filename
  * @return BLOB
  */
function GetBlob(
    P_DIRECTORY VARCHAR2,
    P_FILENAME VARCHAR2
) return BLOB;
/** Writes BLOB to file
  *
  * @param P_DIRECTORY ORA directory
  * @param P_FILENAME filename
  * @param p_blob BLOB to write
  */
$IF CCOMPILING.g_utl_file_privilege $THEN    
PROCEDURE Blob2File
(
  P_DIRECTORY      IN VARCHAR2,
  P_FILENAME       IN VARCHAR2,
  p_blob           IN BLOB
);
$END
/**Read to NCLOB content of the file
  *
  * @param P_DIRECTORY location of file (Oracle directory)
  * @param P_FILENAME  filename
  * @param P_NLS_CHARSET National Langauage Support charset (EE8MSWIN1250,AL32UTF8,WE8MSWIN1252,WE8ISO8859P2)
  * @return NCLOB
  */
function Read2Clob(
    P_DIRECTORY VARCHAR2,
    P_FILENAME VARCHAR2,
    P_NLS_CHARSET VARCHAR2 default null--'EE8MSWIN1250' --'AL32UTF8', 'WE8MSWIN1252'   WE8ISO8859P2
) return NCLOB;
/** Replaces part of CLOB pio_xml between p_start_offset and p_end_offset with string p_replace_with
  *
  * @param pio_xml input output CLOB
  * @param p_start_offset starting offset of piece to replace
  * @param p_end_offset ending offset of piece to replace
  * @param p_replace_with String to replace with
  */
procedure clobReplace(
  pio_xml IN OUT NOCOPY CLOB,
  p_start_offset number,
  p_end_offset number,
  p_replace_with varchar2
);
/** Replaces part of CLOB pio_xml between p_start_offset and p_end_offset with CLOB p_replace_with
  *
  * @param pio_xml input output CLOB
  * @param p_start_offset starting offset of piece to replace
  * @param p_end_offset ending offset of piece to replace
  * @param p_replace_with CLOB to replace with
  */
procedure clobReplace(
  pio_xml IN OUT NOCOPY CLOB,
  p_start_offset number,
  p_end_offset number,
  p_replace_with CLOB
);
/** CLOB version of PL/SQL string function replace
*
* @param pio_clob CLOB where replacement will be made
* @param p_what String to replace
* @param p_with Replacment string
*/
procedure clobReplaceAll(
  pio_clob          IN OUT nocopy CLOB,
  p_what            IN VARCHAR2,
  p_with            IN VARCHAR2
);
/** CLOB version of PL/SQL string function replace but works only from p_startOffset to pio_endOffset.
* Also changes pio_endOffset for the changed length of whole CLOB.
*
* @param pio_clob CLOB where replacement will be made
* @param p_what String to replace
* @param p_with Replacment string
* @param p_startOffset start of replacing
* @param pio_endOffset end of replacing
*/
PROCEDURE clobReplace(
  pio_clob          IN OUT NOCOPY CLOB,
  p_what          IN VARCHAR2,
  p_with          IN VARCHAR2,
  p_startOffset   IN NUMBER default 1,
  pio_endOffset     IN OUT NUMBER
);
/** Return APEX static file as CLOB
*
* @param p_xsltStaticFile Filename of APEX static file with XSLT
* @param po_file_csid Oracle character set ID
* @return APEX static file as CLOB
*/
function StaticFile2BLOB
(
  p_xsltStaticFile  IN    varchar2,
  po_file_csid      OUT   number
) return BLOB;
/** Return APEX static file as CLOB
*
* @param p_xsltStaticFile Filename of APEX static file with XSLT
* @param po_file_csid Oracle character set ID
* @return APEX static file as CLOB
*/
function StaticFile2CLOB
(
  p_xsltStaticFile  IN    varchar2,
  po_file_csid      OUT   number
) return CLOB;
/**Base64 encode BLOB, return as CLOB
*
* @param p_binary Input BLOB
* @return base64 encoded BLOB as CLOB
*/
function base64_encode(p_binary BLOB)
return CLOB;
/**decode base64 encoded CLOB, return as BLOB
*
* @param p_binary Input BLOB
* @return base64 encoded BLOB as CLOB
*/
function base64_decode(
  p_file in clob
)
return blob;
END PAK_BLOB_UTIL;
/
