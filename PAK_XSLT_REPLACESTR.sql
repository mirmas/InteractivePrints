
CREATE OR REPLACE PACKAGE "PAK_XSLT_REPLACESTR" AS

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

/** replace replacement strings (format #STRING#) with APEX items values and values from Print Attributes dialog
  *
  * @param p_Xslt input XSLT or static OOXML tempalte
  * @param p_app_id application ID from where Print Settings are read
  * @param p_page_id page ID from where Print Settings are read
  * @param p_region_name region name from where Print Settings are read
  * @param p_format Format of target document. Parameter is here for future use, now MS OOXML is assumed
  * @param p_fileext File extension. E.g. xslx, docx
  */
 PROCEDURE SmartReplaceReportAttr(
  p_xslt IN OUT NOCOPY CLOB,
  p_app_id number,
  p_page_id number,
  p_region_name varchar2,
  p_format number,
  p_fileext varchar2
);



END PAK_XSLT_REPLACESTR;

/
