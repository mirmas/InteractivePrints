--------------------------------------------------------
--  DDL for Package PAK_XSLTPROCESSOR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PAK_XSLTPROCESSOR" AS
  
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

  function Transform
  (
    p_Xml               IN    CLOB,
    p_template          IN    CLOB,
    p_external_params   IN    varchar2 default null,
    po_error            OUT   varchar2
  ) return BLOB;

$if CCOMPILING.g_utl_file_privilege $then
  --testing function--
  procedure WriteResponseToFile(
    p_url varchar2,
    p_xmlDir varchar2,
    p_xmlFile varchar2,
    p_xsltDir varchar2,
    p_xsltFile varchar2,
    p_outputDir varchar2,
    p_outputFile varchar2,
    p_zipedB64encoded boolean default false,
    p_xslParams varchar2 default null,
    P_NLS_CHARSET varchar2 default 'AL32UTF8'
  );
$end

/*
FUNCTION XSLTransformServlet (
    P_URL IN  varchar2,
    P_XML    IN BLOB,
    P_XSLT       IN CLOB,
    p_zipedB64encoded boolean default false,
    p_xslParams varchar2 default null

) RETURN BLOB;
*/

END PAK_XSLTPROCESSOR;

/
