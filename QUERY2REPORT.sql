



  CREATE OR REPLACE PACKAGE "QUERY2REPORT" as 
 
g_SelectEnc constant varchar2(200) := 'Xd8plyFTzMM9986H2S1cqXKEx+G7lfC/pL70GLHRRIhNlGYCKIM/DQ=='; 

g_crlf constant varchar2(2) := chr(13)||chr(10); 

 
type tab_string is table of VARCHAR2(32000); 
type tab_integer is table of PLS_INTEGER; 
type t_coltype_tables is table of t_coltype_table; 


 

 

f_text CONSTANT NUMBER := 0; 
 

f_html CONSTANT NUMBER := 1; 
 

f_mht CONSTANT NUMBER := 2; 
 

f_xml CONSTANT NUMBER := 3; 
 

f_rtf CONSTANT NUMBER := 4; 
 

f_ooxml CONSTANT NUMBER := 5; 
 

g_dwld_transformed CONSTANT NUMBER := 0; 
 

g_dwld_xml CONSTANT NUMBER := 1; 
 

IIlIl0 CONSTANT NUMBER := 5; 
 

g_dwld_suorce CONSTANT NUMBER := 2; 
 

g_dwld_xslt CONSTANT NUMBER := 3; 
 

g_dwld_second_xslt CONSTANT NUMBER := 4; 
 


 


 

 
OIlIl1 constant varchar2(16) := 'TRIALTRIALTRIALT'; 
 

function BlockXOR(IIlIl1 RAW, OIlIlI RAW) 
return RAW; 
 
 
 
 
 
function html2str ( line in varchar2 ) return varchar2; 
 
 
function RemoveSpecialChars (p_inputstr varchar2) 
return varchar2; 
 
function IIlIll( 
  OIll00 varchar2, 
  IIll00 varchar2 default '#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~' 
) 
return varchar2; 
 
 
function OIll01(IIll0I varchar2, OIll0l varchar2) 
return varchar2; 
 
procedure SetLicenceKey(p_licence_key varchar2, p_coded varchar2, IIll0l varchar2); 
 
procedure OIll10( 
  IIll11            IN  varchar2, 
  p_mime                 in  VARCHAR2 default 'application/octet' 
); 
 
 
PROCEDURE OIll1I( 
  pio_clob        IN OUT NOCOPY CLOB 
); 
 
procedure DownloadBlob( 
    IIl1Il IN NUMBER, 
    OIll1l IN OUT BLOB, 
    P_FILENAME VARCHAR2, 
    IIllI0 boolean default true, 
    OIllI1 varchar2 default 'application/octet' 
); 
 
 
procedure DownloadConvertOutput 
( 
IIl1Il        number 
,OIllII   BLOB 
,p_file_name   VARCHAR2 
,p_mime         VARCHAR2 default 'application/octet' 
,IIllIl       boolean default false 
,p_blob_csid    number default NLS_CHARSET_ID('UTF8') 
,IIlll0 boolean default false 
,p_convertblob_param varchar2 default null 
,OIlll1    varchar2 default V('APP_USER') 
,IIlllI NUMBER default 0 
); 
 
 
 
function OIllll 
( 
  IIllll  IN varchar2 
) 
return t_coltype_table; 
 
 
 
Procedure XslTransformAndDownload 
( 
p_Xml                   IN OUT CLOB, 
p_xsltStaticFile        IN  varchar2, 
IIl1I0               IN number, 
OIl11I           IN varchar2, 
p_filename              in  VARCHAR2, 
p_mime                  in  VARCHAR2 default 'application/octet', 
p_format                IN  number default null, 
p_templateStaticFile    in  VARCHAR2 default null, 
p_external_params       IN  varchar2 default null, 
p_second_XsltStaticFile  IN  varchar2 default null, 
p_second_external_params IN  varchar2 default null, 
p_convertblob_param      IN  varchar2 default null, 
ll0000              IN  number   default null, 
Ol0000      IN  number   default null, 
OIlll1               IN  varchar2 default V('APP_USER'), 
IIlllI      IN  number default 0 
); 
 
 
 
Procedure XslTransformAndDownloadXMLID 
( 
Il0001   IN  number, 
p_xsltStaticFile  IN  varchar2, 
IIl1I0         IN number, 
OIl11I     IN varchar2, 
p_filename      in  VARCHAR2, 
p_mime           in  VARCHAR2 default 'application/octet', 
p_format                IN  number default null, 
p_templateStaticFile    in  VARCHAR2 default null, 
p_external_params IN    varchar2 default null, 
p_second_XsltStaticFile  IN  varchar2 default null, 
p_second_external_params IN  varchar2 default null, 
p_convertblob_param IN  varchar2 default null, 
ll0000         IN  number   default null, 
Ol0000      IN  number   default null, 
OIlll1               IN  varchar2 default V('APP_USER'), 
IIlllI      IN  number default 0 
); 
 
 
 
Procedure ll0001 
( 
Il0001      IN  number, 
p_xsltStaticFile        IN  varchar2, 
IIl1I0               IN number, 
OIl11I           IN varchar2, 
p_filename              in  VARCHAR2, 
p_mime                  in  VARCHAR2 default 'application/octet', 
p_format                IN  number default null, 
p_templateStaticFile    in  VARCHAR2 default null, 
p_external_params       IN  varchar2 default null, 
p_second_XsltStaticFile  IN  varchar2 default null, 
p_second_external_params IN  varchar2 default null, 
p_convertblob_param      IN  varchar2 default null, 
ll0000              IN  number   default null 
); 
 
 
 
 
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
Ol000I        in  varchar2  default null, 
p_second_external_params IN  varchar2 default null, 
p_convertblob_param      IN  varchar2 default null 
); 

$if CCOMPILING.g_utl_file_privilege $then  
 
procedure O100I11 
( 
p_xmlDir                IN    varchar2, 
p_xmlFile               IN    varchar2, 
p_xsltDir                IN    varchar2, 
p_xsltFile               IN    varchar2, 
p_xsltReplacedFile       IN    varchar2, 
IIl1Il                IN    number, 
IIl1I0               IN    number, 
OIl11I           IN    varchar2, 
p_format                IN    number,  
po_error                OUT   boolean, 
p_templateDir                IN    varchar2, 
p_templateFile               IN    varchar2, 
p_templateReplacedFile       IN    varchar2, 
p_outDir                IN    varchar2, 
p_outFile               IN    varchar2, 
p_external_params       IN    varchar2 default null 
);  
$end
 
procedure Il000I 
( 
  ll000l    IN varchar2 
  ,IIllll     IN varchar2 
  ,Ol000l     IN t_coltype_table 
  ,pi_maxRows         IN PLS_INTEGER 
  ,Il0010 IN OUT tab_string 
  ,ll0010  IN OUT tab_string 
  ,Ol0011  IN OUT t_coltype_tables 
  ,Il0011        IN OUT tab_integer 
); 
 
function ll001I 
( 
  pi_regionAttrs in tab_string 
  ,pi_selectQueries   IN tab_string 
  ,Ol000l     IN t_coltype_tables 
  ,Ol001I        in tab_integer 
 
) return clob; 
 
 
procedure OIll10( 
  p_xsltStaticFile          IN varchar2, 
  p_second_XsltStaticFile   IN varchar2 default null, 
  
  
  p_dwld_type               in number, 
  p_mime                    in VARCHAR2 default 'application/octet' 
); 
 
function Il001l( 
  IIl1I0 number, 
  pi_regionAttrs tab_string 
) 
return varchar2; 
 
procedure ll001l( 
  p_filename varchar2, 
  p_xml clob 
); 
 
function GetTemplateMatches(p_xslt CLOB) 
return tab_string; 
 
function GetTemplateNames(p_xslt CLOB) 
return tab_string; 
 
function Ol00I0( 
  Il00I0 varchar2, 
  IIll00 varchar2 default ' _#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~' 
) 
return varchar2; 
 

 

 
 
function XslTransform 
( 
p_Xml               IN    CLOB, 
p_Xslt              IN    CLOB, 
p_format            IN    number, 
po_error            OUT   boolean, 
p_template          IN    CLOB default null, 
p_external_params   IN    varchar2 default null 
) 
return BLOB; 

$if CCOMPILING.g_utl_file_privilege $then  
 
Procedure XslTransform 
( 
p_xmlDir                IN   VARCHAR2, 
p_xmlFname              IN   VARCHAR2, 
p_xsltDir               IN    varchar2, 
p_xsltFile              IN    varchar2, 
p_outDir                IN    VARCHAR2, 
p_outFname              IN    VARCHAR2, 
P_NLS_CHARSET           IN VARCHAR2 default null, 
p_format                IN number  default F_TEXT, 
p_TemplateDir           IN  VARCHAR2 default null, 
p_TemplateFile          IN  VARCHAR2 default null, 
p_external_params       IN    varchar2 default null 
); 
$end
 
 
procedure Query2DownloadReport 
( 
  p_xsltStaticFile          IN varchar2, 
  p_filename                in VARCHAR2, 
  pi_regionAttrs            in tab_string, 
  pi_selectQueries          IN tab_string, 
  pi_maxRows                IN tab_integer, 
  IIl1I0                 IN number default V('APP_PAGE_ID'), 
  p_dwld_type               in number default g_dwld_transformed, 
  p_mime                    in VARCHAR2 default 'application/octet', 
  p_format                  IN number default null, 
  p_templateStaticFile    in  VARCHAR2 default null, 
  p_external_params         IN varchar2 default null, 
  p_second_XsltStaticFile   IN varchar2 default null, 
  p_second_external_params  IN varchar2 default null, 
  p_convertblob_param       IN varchar2 default null 
); 
 
 
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
  ,IIl1I0          IN number default V('APP_PAGE_ID') 
  ,p_format                IN  number default null 
  ,p_templateStaticFile    in  VARCHAR2 default null 
  ,p_external_params       IN  varchar2 default null 
  ,p_second_XsltStaticFile  IN  varchar2 default null 
  ,p_second_external_params IN  varchar2 default null, 
  p_convertblob_param       IN varchar2 default null 
); 
 
 
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
  ,IIl1I0                 IN number default V('APP_PAGE_ID') 
  ,p_format                IN    number default null 
  ,p_templateStaticFile    in  VARCHAR2 default null 
  ,p_external_params       IN    varchar2 default null 
  ,p_second_XsltStaticFile  IN  varchar2 default null 
  ,p_second_external_params IN  varchar2 default null, 
  p_convertblob_param       IN varchar2 default null 
); 
 
 
 
 

 

 
 
function Query2ClobReport 
( 
  p_Xslt                    IN CLOB, 
  pi_regionAttrs            in tab_string, 
  pi_selectQueries          IN tab_string, 
  pi_maxRows                IN tab_integer, 
  p_format                  IN number default null, 
  po_error                  OUT boolean, 
  p_Template                IN CLOB default null, 
  p_external_params         IN varchar2 default null, 
  p_second_Xslt             IN CLOB default null, 
  p_second_external_params  IN varchar2 default null, 
  po_xml                    OUT CLOB 
) 
return BLOB; 
 
 
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
  ,po_error                  OUT boolean 
  ,p_Template             IN CLOB default null 
  ,p_external_params      IN  varchar2 default null 
  ,p_second_Xslt          IN CLOB default null 
  ,p_second_external_params IN  varchar2 default null 
  ,po_xml                   OUT CLOB 
) 
return BLOB; 
 
 
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
  ,po_error                  OUT boolean 
  ,p_Template            IN CLOB default null 
  ,p_external_params     IN varchar2 default null 
  ,p_second_Xslt             IN CLOB default null 
  ,p_second_external_params IN  varchar2 default null 
  ,po_Xml                   OUT CLOB 
) 
return BLOB; 
 

 

 
 
procedure Template2XSLT( 
  Ol00I1     IN OUT NOCOPY BLOB, 
  p_format      number, 
  p_nls_charset varchar2, 
  p_partsToTransform varchar2 default null 
); 
 
 
procedure Template2XSLT( 
  Ol00I1 IN OUT NOCOPY CLOB, 
  p_format  IN number, 
  p_partsToTransform IN VARCHAR2 
); 

$if CCOMPILING.g_utl_file_privilege $then  
 
procedure Template2XSLT( 
  p_format number, 
  Il00II varchar2, 
  ll00II varchar2, 
  p_xsltDir varchar2, 
  p_xsltFile varchar2, 
  p_nls_charset varchar2, 
  p_partsToTransform varchar2 default null 
); 
 
 
procedure RefreshStaticFile( 
  p_ws varchar2, 
  p_static_Filename varchar2, 
  p_filedir varchar2, 
  p_filename varchar2 
); 
$end
 
 
procedure RefreshStaticFile( 
  p_ws varchar2, 
  p_static_Filename varchar2, 
  p_clob clob, 
  p_clob_csid    number 
); 

 
 
procedure XSLT2Document( 
  Ol00Il IN OUT NOCOPY CLOB, 
  Il00Il varchar2, 
  ll00l0 tab_string, 
  Ol00l0 tab_string, 
  Il00l1 varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||g_crlf, 
  ll00l1 varchar2 default '&lt;', 
  Ol00lI varchar2 default '&gt;' 
); 

$if CCOMPILING.g_utl_file_privilege $then   
 
procedure XSLT2Document( 
  p_xsltDir          IN  VARCHAR2, 
  Il00lI        IN  VARCHAR2, 
  ll00ll         IN  varchar2, 
  Ol00ll        IN  varchar2, 
  Il00Il varchar2, 
  ll00l0 tab_string, 
  Ol00l0 tab_string, 
  Il00l1 varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||g_crlf, 
  ll00l1 varchar2 default '&lt;', 
  Ol00lI varchar2 default '&gt;' 
); 
$end
 
end QUERY2REPORT;

/
