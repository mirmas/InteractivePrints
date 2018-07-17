--------------------------------------------------------
--  DDL for Package PAK_XSLT_REPLACESTR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PAK_XSLT_REPLACESTR" AS


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
