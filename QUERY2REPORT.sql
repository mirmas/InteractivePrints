CREATE OR REPLACE PACKAGE "QUERY2REPORT" as

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


g_SelectEnc constant varchar2(200) := 'Xd8plyFTzMM9986H2S1cqXKEx+G7lfC/pL70GLHRRIhNlGYCKIM/DQ==';
--public, users can change------
g_crlf constant varchar2(2) := chr(13)||chr(10);
--end of public-----------------

type tab_string is table of VARCHAR2(32000);
type tab_integer is table of PLS_INTEGER;
type t_coltype_tables is table of t_coltype_table;
--type tab_report_types IS TABLE OF VARCHAR2(30) INDEX BY VARCHAR2(64);
--glb_charset constant VARCHAR2(50) := 'EE8MSWIN1250';

-----------------------------------------public constants-------------------

--Posible p_format value for Query2DownloadReport procedures and Query2ClobReport functions. Expected format is text. Must be set if we want to download Starter XSLT.
f_text CONSTANT NUMBER := 0;

--Posible p_format value for Query2DownloadReport procedures and Query2ClobReport functions. Expected format is HTML. Must be set if we want to download Starter XSLT.
f_html CONSTANT NUMBER := 1;

--Posible p_format value for Query2DownloadReport procedures and Query2ClobReport functions. Expected format MHT (Single file Web page) must be set. Must be set if we want to download Starter XSLT.
f_mht CONSTANT NUMBER := 2;

--Posible p_format value for Query2DownloadReport procedures and Query2ClobReport functions. Expected format is XML. Must be set if we want to download Starter XSLT.
f_xml CONSTANT NUMBER := 3;

--Posible p_format value for Query2DownloadReport procedures and Query2ClobReport functions. Expected format is RTF. Must be set if we want to download Starter XSLT.
f_rtf CONSTANT NUMBER := 4;

--Posible p_format value for Query2DownloadReport procedures and Query2ClobReport functions. Expected format is DOCX or XLSX. Must be set if we want to download Starter XSLT.
f_ooxml CONSTANT NUMBER := 5;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download final output document. Default value, everything else is more debugging tool
g_dwld_transformed CONSTANT NUMBER := 0;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download temporary XML.
g_dwld_xml CONSTANT NUMBER := 1;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download temporary XML and copy it into XSLT Project Manager.
g_dwld_xml_copyto_xpm CONSTANT NUMBER := 5;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download report query.
g_dwld_suorce CONSTANT NUMBER := 2;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download first XSLT.
g_dwld_xslt CONSTANT NUMBER := 3;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download second XSLT.
g_dwld_second_xslt CONSTANT NUMBER := 4;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download building block file. Building block file must be preivously uploaded as static file in APEX application.
--g_dwld_bb CONSTANT NUMBER := 5;

--Posible p_dwld_type value for Query2DownloadReport procedures. Set if you want to download starter XSLT. Building block file must be preivously uploaded as static file in APEX application. Parameter p_format must be set.
--g_dwld_starter_xslt CONSTANT NUMBER := 6;

--------------------------------------------------------------------end of public constants---------------------------------------------------------------

g_trial constant varchar2(16) := 'TRIALTRIALTRIALT';

--Ne wrapaj!!
function BlockXOR(p_raw RAW, p_key RAW)
return RAW;


/*
procedure xmlRemoveElement(
  pio_xml           IN OUT NOCOPY CLOB,
  p_element         IN VARCHAR2
) ;
*/

/*Extracts strings from HTML and separate them by space */
function html2str ( line in varchar2 ) return varchar2;

/* Remove special chars which caused ORA-31061: XDB error: special char to escaped char conversion failed. */
/*
function RemoveSpecialChars (p_inputstr varchar2)
return varchar2;
*/

function ConvertColName2XmlName(
  p_colname varchar2,
  p_chars varchar2 default '#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2;

/**Decrypts PL/SQL code
*
* @param p_plsql PLSQL Block.
* @param p_lk Valid Licence key
* @return decrypted PLSQL block
*/
function DecPlSql(p_plsql varchar2, p_lk varchar2)
return varchar2;

procedure SetLicenceKey(p_licence_key varchar2, p_coded varchar2, p_dbidwsid varchar2);

procedure DownloadStaticFile(
  p_staticFile            IN  varchar2,
  p_mime                 in  VARCHAR2 default 'application/octet'
);

/** Delete null elements REGION_AGGREGATES and REGION_HIGHLIGHTS and then replace
* not null elements REGION_AGGREGATES and REGION_HIGHLIGHTS to attributes in XML pio_clob.
*
* @param pio_clob XML to convert
*/
/*
PROCEDURE xmlConvert(
  pio_clob        IN OUT NOCOPY CLOB,
  p_filename      IN VARCHAR2,
  pi_regionAttrs  in tab_string,
  pi_reportTypes  IN OUT t_coltype_tables
);
*/

procedure DownloadBlob(
    P_APP_ID IN NUMBER,
    P_BLOB IN OUT BLOB,
    P_FILENAME VARCHAR2,
    P_TEMPORARY boolean default true,
    P_MIMETYPE varchar2 default 'application/octet'
);


procedure DownloadConvertOutput
(
P_APP_ID        number
,p_document   BLOB
,p_file_name   VARCHAR2
,p_mime         VARCHAR2 default 'application/octet'
,p_error       VARCHAR2 default null
,p_blob_csid    number default NLS_CHARSET_ID('UTF8')
,p_convertblob boolean default false
,p_convertblob_param varchar2 default null
,P_APP_USER    varchar2 default V('APP_USER')
,P_RUN_IN_BACKGROUND NUMBER default 0
);





/*IzraÄTuna Excel oznako stolpca, 1=A, 2=B,...,26=Z, 27=AA, 28=AB,..., 54=BB,..*/
function ExcelCol(p_position number)
return varchar2;

/**sestavi tabelo iz selekta (ne iz APEX reporta), FORMAT_MASK in FULL_NAME je column name brez vezajev*/
function ReportTypesElementTab
(
  pi_selectQuery  IN varchar2
)
return t_coltype_table;

/** returns otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_Xml input XML
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_TemplateFile Filename of Template uploaded inro static files (in Flat OPC format) from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * @param p_log_level Log level in job.
  * See format notes at p_external_params parameter.
  */

function XslTransform
(
p_Xml                   IN OUT CLOB,
p_xsltStaticFile        IN  varchar2,
p_page_id               IN number,
p_region_name           IN varchar2,
p_filename              in  VARCHAR2,
pi_regionAttrs          in tab_string,
pi_reportTypes          IN OUT t_coltype_tables,
--p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params       IN  varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
--p_convertblob_param      IN  varchar2 default null,
p_log_level              IN  number   default null,
p_security_group_id      IN  number   default null --,
--p_app_user               IN  varchar2 default V('APP_USER'),
--p_run_in_background      IN  number default 0
) return BLOB;
/** Download with otput or do some other action defined in ConvertBlob procedure with otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_Xml input XML
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure.
  * See format notes at p_external_params parameter.
  */

Procedure XslTransformAndDownload
(
p_Xml                   IN OUT CLOB,
p_xsltStaticFile        IN  varchar2,
p_page_id               IN number,
p_region_name           IN varchar2,
p_filename              in  VARCHAR2,
pi_regionAttrs          in tab_string,
pi_reportTypes          IN OUT t_coltype_tables,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params       IN  varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null,
p_log_level              IN  number   default null,
p_security_group_id      IN  number   default null,
p_app_user               IN  varchar2 default V('APP_USER'),
p_run_in_background      IN  number default 0
);


/** Download with otput or do some other action defined in ConvertBlob procedure with otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_id_temporary_xml ID of input XML in temporary_xml table
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure.
  * See format notes at p_external_params parameter.
  */
Procedure XslTransformAndDownloadXMLID
(
p_id_temporary_xml   IN  number,
p_xsltStaticFile  IN  varchar2,
p_page_id         IN number,
p_region_name     IN varchar2,
p_filename      in  VARCHAR2,
p_regionAttrs          in VARCHAR2,
p_reportTypes          IN VARCHAR2,
p_mime           in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params IN    varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param IN  varchar2 default null,
p_log_level         IN  number   default null,
p_security_group_id      IN  number   default null,
p_app_user               IN  varchar2 default V('APP_USER'),
p_run_in_background      IN  number default 0
);

/** Execute below procedure as job with DBMS_SCHEDULER package
  *
  * @param p_id_temporary_xml ID of input XML from temporary_xml table
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure.
  * @param p_log_level Log level in job.
  * See format notes at p_external_params parameter.
  */

Procedure XslTransformAndDownloadJob
(
p_id_temporary_xml      IN  number,
p_xsltStaticFile        IN  varchar2,
p_page_id               IN number,
p_region_name           IN varchar2,
p_filename              in  VARCHAR2,
p_regionAttrs          in tab_string,
p_reportTypes          IN t_coltype_tables,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_templateStaticFile    in  VARCHAR2 default null,
p_external_params       IN  varchar2 default null,
p_second_XsltStaticFile  IN  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null,
p_log_level              IN  number   default null
);



/** Download otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_XmlStaticFile input XML in APEX Static File
  * @param p_Xslt First XSLT CLOB
  * @param p_filename Filename of downloaded output
  * @param p_XSLT_file_csid Character set ID of first XSLT
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt Second XSLT CLOB applied after p_Xslt
  * @param p_second_XSLT_file_csid Character set ID of second XSLT
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  */
Procedure XslTransformAndDownload
(
p_Xml                   IN  CLOB,
p_Xslt                  IN  BLOB,
p_filename              in  VARCHAR2,
p_XSLT_CS               in  varchar2  default null,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_template              IN  BLOB  default null,
p_template_CS           IN  varchar2 default null,
p_external_params       IN  varchar2 default null,
p_second_Xslt           IN  BLOB default null,
p_second_XSLT_CS        in  varchar2  default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null
);




$if CCOMPILING.g_utl_file_privilege $then
/** File version of XSLT transformation. Replacements from Print Settings dialog are made in XSLT prior to transformation.
  *
  * @param p_XmlDir Oracle Directory of input XML
  * @param p_XmlFile filename of input XML
  * @param p_XsltDir Oracle Directory of input XSLT
  * @param p_XsltFile filename of input XSLT
  * @param p_XsltReplacedFile filename of XSLT with replacements from Print Settings dialog are made in XSLT prior to transformation. Location of file is p_XsltDir.
  * @param p_app_id application ID from where Print Settings are read,
  * @param p_page_id page ID from where Print Settings are read,
  * @param p_region_name region name from where Print Settings are read,
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_error Outputs false if there is a problem on print server side.
  * @param p_templateDir Oracle Directory of static OOXML template,
  * @param p_templateFile Filename of static OOXML template,
  * @param p_outDir Oracle Directory of output file,
  * @param p_outFile Filename of output file,
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  */
procedure XslTransformApex
(
p_xmlDir                IN    varchar2,
p_xmlFile               IN    varchar2,
p_xsltDir                IN    varchar2,
p_xsltFile               IN    varchar2,
p_xsltReplacedFile       IN    varchar2,
p_app_id                IN    number,
p_page_id               IN    number,
p_region_name           IN    varchar2,
p_format                IN    number,  --default F_TEXT,
po_error                OUT   VARCHAR2,
p_templateDir                IN    varchar2 default null,
p_templateFile               IN    varchar2 default null,
p_templateReplacedFile       IN    varchar2 default null,
p_outDir                IN    varchar2,
p_outFile               IN    varchar2,
p_external_params       IN    varchar2 default null
);
$end

procedure AddQuery
(
  pi_regionAttr    IN varchar2
  ,pi_selectQuery     IN varchar2
  ,pi_reportTypes     IN t_coltype_table
  ,pi_maxRows         IN PLS_INTEGER
  ,pio_regionAttrs IN OUT tab_string
  ,pio_selectQueries  IN OUT tab_string
  ,pio_reportTypes  IN OUT t_coltype_tables
  ,pio_maxRows        IN OUT tab_integer
);

function Query2Xml
(
  pi_regionAttrs in tab_string
  ,pi_selectQueries   IN tab_string
  ,pi_reportTypes     IN OUT t_coltype_tables
  ,pi_max_rows        in tab_integer

) return clob;

/** Downloads one of the static files or starter XSLT depend on p_dwld_type
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_dwld_type What to download: XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_BBFile Building block file
  * @param p_BB_no_esc_sc Applied only when p_format is F_TEXT. If true then not escape XML special characters.
  * You should escape special XML (<,>," and &) characters if Building block file is in RTF format.
  * You should not escape special characters if Building block file is in MHT format.
  */
procedure DownloadStaticFile(
  p_xsltStaticFile          IN varchar2,
  p_second_XsltStaticFile   IN varchar2 default null,
  --p_BBFile                  IN varchar2 default null,
  --p_BB_no_esc_sc            IN boolean default false,
  p_dwld_type               in number,
  p_mime                    in VARCHAR2 default 'application/octet'
);

function XMLOrSourceFilename(
  p_page_id number,
  pi_regionAttrs tab_string
)
return varchar2;

procedure Insert_XPM_XML(
  p_filename varchar2,
  p_xml clob
);

function GetTemplateMatches(p_xslt CLOB)
return tab_string;

function GetTemplateNames(p_xslt CLOB)
return tab_string;

function ConvertXmlName2ColName(
  p_xmlname varchar2,
  p_chars varchar2 default ' _#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2;

-------------------------------------------------------PUBLIC procedures and functions-------------------------------------------------------------------------------------------------

-------------------------------------------------------PUBLIC Query2DownloadReport procedures--------------------------------------------

/** Return otput of XSLT transformation (working function)
  *
  * @param p_Xml input XML
  * @param p_Xslt XSLT transformation
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to g_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
  * @param p_template  Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_Xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
function XslTransform
(
p_Xml               IN    CLOB,
p_Xslt              IN    CLOB,
p_format            IN    number,
po_error            OUT   VARCHAR2,
p_template          IN    CLOB default null,
p_external_params   IN    varchar2 default null
)
return BLOB;




$if CCOMPILING.g_utl_file_privilege $then
/** Return otput of XSLT transformation
  *
  * @param p_xmlDir ORA Directory of input XML
  * @param p_xmlFname filename of input XML
  * @param p_xsltDir ORA Directory of XSLT file
  * @param p_xsltFile Filename of XSLT file
  * @param p_outDir ORA Directory of output file
  * @param p_outFname Filename of output file
  * @param P_NLS_CHARSET Charset of XSLT file (e.g. 'EE8MSWIN1250' for windows-1250)
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
Procedure XslTransform
(
p_xmlDir                IN   VARCHAR2,
p_xmlFname              IN   VARCHAR2,
p_xsltDir               IN    varchar2,
p_xsltFname             IN    varchar2,
p_outDir                IN    VARCHAR2,
p_outFname              IN    VARCHAR2,
P_NLS_CHARSET           IN VARCHAR2 default null,
p_format                IN number  default F_TEXT,
p_TemplateDir           IN  VARCHAR2 default null,
p_TemplateFile          IN  VARCHAR2 default null,
p_external_params       IN    varchar2 default null
);
$end


/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in root/Region element
  * with attributes pi_regionAttrs(N).
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param pi_regionAttrs Set of Region elements attributes
  * @param pi_selectQueries Set of selects from which we build temporary XML
  * @param pi_maxRows Set of max rows limits of fetching rows for build temporary XML
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure
  */
procedure Query2DownloadReport
(
  p_xsltStaticFile          IN varchar2,
  p_filename                in VARCHAR2,
  pi_regionAttrs            in tab_string,
  pi_selectQueries          IN tab_string,
  pi_maxRows                IN tab_integer,
  p_page_id                 IN number default V('APP_PAGE_ID'),
  p_dwld_type               in number default g_dwld_transformed,
  p_mime                    in VARCHAR2 default 'application/octet',
  p_format                  IN number default null,
  p_templateStaticFile    in  VARCHAR2 default null,
  p_external_params         IN varchar2 default null,
  p_second_XsltStaticFile   IN varchar2 default null,
  p_second_external_params  IN varchar2 default null,
  p_convertblob_param       IN varchar2 default null
);

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in root/Region element
  * with attributes pi_regionAttrN.
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param pi_regionattr1 First Region element attributes.
  * @param pi_selectQuery1 First select from which we build temporary XML. Fetched result set is embeeded in first Region element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionattr2 Second Region element attributes.
  * @param pi_selectQuery2 Second select from which we build temporary XML. Fetched result set is embeeded in second Region element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionattr3 Third Region element attributes.
  * @param pi_selectQuery3 Third select from which we build temporary XML. Fetched result set is embeeded in third Region element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionattr4 Fourth Region element attributes.
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. Fetched result set is embeeded in fourth Region element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionattr5 Fifth Region element attributes.
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. Fetched result set is embeeded in fifth Region element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure
  */
procedure Query2DownloadReport
(
  p_xsltStaticFile  IN varchar2,
  p_filename    in VARCHAR2,
  p_dwld_type     in  number default g_dwld_transformed,
  p_mime in VARCHAR2 default 'application/octet',
   pi_regionattr1    IN varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionattr2 varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionattr3    IN varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionattr4    in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionattr5    in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_page_id          IN number default V('APP_PAGE_ID')
  ,p_format                IN  number default null
  ,p_templateStaticFile    in  VARCHAR2 default null
  ,p_external_params       IN  varchar2 default null
  ,p_second_XsltStaticFile  IN  varchar2 default null
  ,p_second_external_params IN  varchar2 default null,
  p_convertblob_param       IN varchar2 default null
);

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in root/Region element
  * with attributes pi_regionAttrN.
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param pi_regionattr1 First Region element attributes.
  * @param pi_selectQuery1 First select from which we build temporary XML. Fetched result set is embeeded in first Region element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionattr2 Second Region element attributes.
  * @param pi_selectQuery2 Second select from which we build temporary XML. Fetched result set is embeeded in second Region element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionattr3 Third Region element attributes.
  * @param pi_selectQuery3 Third select from which we build temporary XML. Fetched result set is embeeded in third Region element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionattr4 Fourth Region element attributes.
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. Fetched result set is embeeded in fourth Region element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionattr5 Fifth Region element attributes.
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. Fetched result set is embeeded in fifth Region element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure
  */
procedure Query2DownloadReport
(
  p_xsltStaticFile  IN varchar2,
  p_filename    in VARCHAR2,
  p_dwld_type     in  number default g_dwld_transformed,
  p_mime in VARCHAR2 default 'application/octet',
  pi_regionattr1     IN varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionattr2    IN varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionattr3    in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionattr4 in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionattr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_page_id                 IN number default V('APP_PAGE_ID')
  ,p_format                IN    number default null
  ,p_templateStaticFile    in  VARCHAR2 default null
  ,p_external_params       IN    varchar2 default null
  ,p_second_XsltStaticFile  IN  varchar2 default null
  ,p_second_external_params IN  varchar2 default null,
  p_convertblob_param       IN varchar2 default null
);




------------End of public Query2DownloadReport procedures----------------------------------------------------------

------------PUBLIC Query2CLOBReport functions - can be executed outside APEX enviroment----------------------------------------------------------

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in root/Region element
  * with attributes pi_regionAttrs(N).
  * One (p_Xslt) or two (p_Xslt, p_second_Xslt) XSLT transformations
  * are applied to temporary XML to return tarnsformed output. Temporary XML is output parameter.
  * This function can be executed outside APEX enviroment
  *
  * @param p_Xslt CLOB with first XSLT
  * @param pi_regionAttrs Set of Region elements attributes
  * @param pi_selectQueries Set of selects from which we build temporary XML
  * @param pi_maxRows Set of max rows limits of fetching rows for build temporary XML
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt CLOB with XSLT applied after first XSLT (p_Xslt)
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @po_Xml Temporary XML is output parameter.
  * @return Final document - Result of one or two XSLT applied.
  */
function Query2ClobReport
(
  p_Xslt                    IN CLOB,
  pi_regionAttrs            in tab_string,
  pi_selectQueries          IN tab_string,
  pi_maxRows                IN tab_integer,
  p_format                  IN number default null,
  po_error                  OUT VARCHAR2,
  p_Template                IN CLOB default null,
  p_external_params         IN varchar2 default null,
  p_second_Xslt             IN CLOB default null,
  p_second_external_params  IN varchar2 default null,
  po_xml                    OUT CLOB
)
return BLOB;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in root/Region element
  * with attributes pi_regionAttrN.
  * One (p_Xslt) or two (p_Xslt, p_second_Xslt) XSLT transformations
  * are applied to temporary XML.
  * This function can be executed outside APEX enviroment.
  *
  * @param p_Xslt CLOB with first XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param pi_regionattr1 First Region element attributes.
  * @param pi_selectQuery1 First select from which we build temporary XML. Fetched result set is embeeded in first Region element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionattr2 Second Region element attributes..
  * @param pi_selectQuery2 Second select from which we build temporary XML. Fetched result set is embeeded in second Region element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionattr3 Third Region element attributes.
  * @param pi_selectQuery3 Third select from which we build temporary XML. Fetched result set is embeeded in third Region element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionattr4 Fourth Region element attributes.
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. Fetched result set is embeeded in fourth Region element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionattr5 Fifth Region element attributes.
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. Fetched result set is embeeded in fifth Region element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt CLOB with XSLT applied after first XSLT (p_Xslt)
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @po_Xml Temporary XML is output parameter.
  * @return Final document - Result of one or two XSLT on temporary XML.
  */
function Query2ClobReport
(
  p_Xslt              IN CLOB,
   pi_regionattr1    in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionattr2    IN varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionattr3    in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionattr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionattr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_format               IN number default null
  ,po_error                  OUT VARCHAR2
  ,p_Template             IN CLOB default null
  ,p_external_params      IN  varchar2 default null
  ,p_second_Xslt          IN CLOB default null
  ,p_second_external_params IN  varchar2 default null
  ,po_xml                   OUT CLOB
)
return BLOB;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in root/Region element
  * with attributes pi_regionAttrN.
  * One (p_Xslt) or two (p_Xslt, p_second_Xslt) XSLT transformations
  * are applied to temporary XML.
  * This function can be executed outside APEX enviroment.
  *
  * @param p_Xslt CLOB with first XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param pi_regionattr1 First Region element attributes.
  * @param pi_selectQuery1 First select from which we build temporary XML. Fetched result set is embeeded in first Region element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionattr2 Second Region element attributes..
  * @param pi_selectQuery2 Second select from which we build temporary XML. Fetched result set is embeeded in second Region element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionattr3 Third Region element attributes.
  * @param pi_selectQuery3 Third select from which we build temporary XML. Fetched result set is embeeded in third Region element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionattr4 Fourth Region element attributes.
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. Fetched result set is embeeded in fourth Region element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionattr5 Fifth Region element attributes.
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. Fetched result set is embeeded in fifth Region element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt CLOB with XSLT applied after first XSLT (p_Xslt)
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @po_Xml Temporary XML is output parameter.
  * @return Final document - Result of one or two XSLT on temporary XML.
  */
function Query2ClobReport
(
  p_Xslt            IN CLOB,
  pi_regionattr1    in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionattr2    in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionattr3    in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionattr4    in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionattr5    in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_format              IN number default null
  ,po_error                  OUT VARCHAR2
  ,p_Template            IN CLOB default null
  ,p_external_params     IN varchar2 default null
  ,p_second_Xslt             IN CLOB default null
  ,p_second_external_params IN  varchar2 default null
  ,po_Xml                   OUT CLOB
)
return BLOB;

------------End of public Query2ClobReport functions - can run outside APEX enviroment----------------------------------------------------------

-----------PUBLIC Template2XSLT and RefreshStaticFile procedures ------------------------------------------------------------

/** Create starter XSLT transformation from template depend on template format.
  * Starter XSLT transformation means that if you apply starter XSLT to custom input XML
  * you will get the original template. No input XML data will be included in
  * starter XSLT output.
  * @param pio_templ On input BLOB represetning template, on output starter XSLT
  * @param p_format Basic format of template f_text=0; f_html=1; f_mht=2; f_xml=3; f_rtf=4; f_ooxml=5;
  * @param p_partsToTransform XSL Transformed parts of po_OOXML separated with comma. Actual only if p_format is set to g_ooxml.
  * @param p_nls_charset Oracle NLS string representing template file encoding.
  * For example p_nls_charset should be 'EE8MSWIN1250' if HTML file uses windows 1250 character set.
*/
procedure Template2XSLT(
  pio_templ     IN OUT NOCOPY BLOB,
  p_format      number,
  p_nls_charset varchar2,
  p_partsToTransform varchar2 default null
);

/** Create starter XSLT transformation from template depend on template format.
  * Starter XSLT transformation means that if you apply starter XSLT to custom input XML
  * you will get the original template. No input XML data will be included in
  * starter XSLT output.
  * @param pio_templ On input CLOB represetning template on output starter XSLT.
  * @param p_format Basic format of template f_text=0; f_html=1; f_mht=2; f_xml=3; f_rtf=4;
  * For example p_nls_charset should be 'EE8MSWIN1250' if HTML file uses windows 1250 character set.
  * @param p_partsToTransform XSL Transformed parts of po_OOXML separated with comma. Actual only if p_format is set to g_ooxml.
*/
procedure Template2XSLT(
  pio_templ IN OUT NOCOPY CLOB,
  p_format  IN number,
  p_partsToTransform IN VARCHAR2
);


$if CCOMPILING.g_utl_file_privilege $then
/** Create starter XSLT transformation from template depend on template format.
  * Starter XSLT transformation means that if you apply starter XSLT to custom input XML
  * you will get the original template. No input XML data will be included in
  * starter XSLT output.
  * @param p_format Basic format of template f_text=0; f_html=1; f_mht=2; f_xml=3; f_rtf=4;
  * @param p_templDir Oracle directory - location of template file
  * @param p_templFile Filename of template
  * @param p_xsltDir Oracle directory - location of starter XSLT file
  * @param p_xsltFile Filename of starter XSLT
  * @param p_nls_charset Oracle NLS string representing template file encoding.
  * For example p_nls_charset should be 'EE8MSWIN1250' if HTML file uses windows 1250 character set.
  * @param p_partsToTransform XSL Transformed parts of po_OOXML separated with comma. Actual only if p_format is set to g_ooxml.
*/
procedure Template2XSLT(
  p_format number,
  p_templDir varchar2,
  p_templFile varchar2,
  p_xsltDir varchar2,
  p_xsltFile varchar2,
  p_nls_charset varchar2,
  p_partsToTransform varchar2 default null
);

/** Refresh static file content (blob column) with content of file on disk - without annoying Application Builder delete and upload
* @param p_ws Workspace of static file
* @param p_static_Filename Name of static file loaded in workspace/app
* @param p_filedir Location (ORA directory) of file with new content
* @param p_filename Filename of file with new content
*/
procedure RefreshStaticFile(
  p_ws varchar2,
  p_static_Filename varchar2,
  p_filedir varchar2,
  p_filename varchar2
);
$end

/** Refresh static file content (blob column) with content of file on disk - without annoying Application Builder delete and upload
* @param p_ws Workspace of static file
* @param p_static_Filename Name of static file loaded in workspace/app
* @param p_clob CLOB with content of file
* @param p_clob_csid Oracle NLS CHARSET ID of CLOB
*/
procedure RefreshStaticFile(
  p_ws varchar2,
  p_static_Filename varchar2,
  p_clob clob,
  p_clob_csid    number
);


/** Create (Office) document from XSLT main template. This template starts with <xsl:template match="/">
  * @param pio_xslt On input CLOB representing XSLT on output document.
  * @param p_match_templates Select attributes of <xsl:apply-templates> elements which will be replaced with actual template code in main XSLT template
  * @param p_name_templates Name attributes of <xsl:call-template> elements which will be replaced with actual template code in main XSLT template
  * @param p_replace_otag Opening XSLT tag <xsl: will be replaced with p_replace_otag.
  * @param p_replace_ctag Closing XSLT tag > will be replaced with p_replace_ctag.
  */
procedure XSLT2Document(
  pio_xslt IN OUT NOCOPY CLOB,
  p_basic_format_name varchar2,
  p_match_templates tab_string,
  p_name_templates tab_string,
  p_xml_procinstr varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||g_crlf,
  p_replace_otag varchar2 default '&lt;',
  p_replace_ctag varchar2 default '&gt;'
);

$if CCOMPILING.g_utl_file_privilege $then
/** Create (Office) document from XSLT.
  * @param p_xsltDir Location (ORA directory) of XSLT
  * @param p_xsltFname XSLT filename
  * @param p_docDir Output document location (ORA directory)
  * @param p_docFname Output document filename
  * @param p_match_templates Select attributes of <xsl:apply-templates> elements which will be replaced with actual template code in main XSLT template
  * @param p_name_templates Name attributes of <xsl:call-template> elements which will be replaced with actual template code in main XSLT template
  * @param p_replace_otag Opening XSLT tag <xsl: will be replaced with p_replace_otag.
  * @param p_replace_ctag Closing XSLT tag > will be replaced with p_replace_ctag.
  */
procedure XSLT2Document(
  p_xsltDir          IN  VARCHAR2,
  p_xsltFname        IN  VARCHAR2,
  p_docDir         IN  varchar2,
  p_docFname        IN  varchar2,
  p_basic_format_name varchar2,
  p_match_templates tab_string,
  p_name_templates tab_string,
  p_xml_procinstr varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||g_crlf,
  p_replace_otag varchar2 default '&lt;',
  p_replace_ctag varchar2 default '&gt;'
);
$end

end QUERY2REPORT;
/
