--------------------------------------------------------
--  DDL for Package Body PAK_BLOB_UTIL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PAK_BLOB_UTIL" AS

/** Converts whole BLOB to CLOB
  *
  * @param p_blob BLOB to convert
  * @param p_file_charset BLOB charset. Use Oracle format. E.g 'EEMSWIN1250' instead of 'windows-1250'
  * @return CLOB
  */
function BLOB2CLOB
(
  p_blob  BLOB
  ,p_clob_csid number default NLS_CHARSET_ID('UTF8')
) return CLOB
as

l_length NUMBER;
l_Clob CLOB;
l_warning NUMBER;
l_lang_context number default 0;
l_src_offset number default 1;
l_dest_offset number default 1;

begin
  --convert blob to clob
  dbms_lob.createtemporary(l_Clob, false);

  DBMS_LOB.CONVERTTOCLOB(
   l_Clob,
   p_Blob,
   DBMS_LOB.LOBMAXSIZE,
   l_dest_offset,
   l_src_offset,
   nvl(p_clob_csid, NLS_CHARSET_ID('UTF8')),
   l_lang_context,
   l_warning
  );

  return l_Clob;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'BLOB2CLOB',
    P_SQLERRM => sqlerrm
  );
  raise;
end BLOB2CLOB;

/** Converts XMLType to CLOB
  *
  * @param p_xml xml to convert
  * @param p_clob_csid BLOB encoding charset ID E.g. NLS_CHARSET_ID('EE8MSWIN1250') for windows-1250
  * @return CLOB
  */
function XML2CLOB
(
p_xml  SYS.XMLType,
p_clob_csid number default NLS_CHARSET_ID('UTF8')
) return CLOB
as
begin
  return BLOB2CLOB(p_xml.getBlobVal(p_clob_csid), p_clob_csid) ;
end;

/** Converts whole CLOB to BLOB
  *
  * @param p_clob CLOB to convert
  * @param p_file_charset CLOB charset
  * @return CLOB
  */
function CLOB2BLOB
(
  p_clob  CLOB,
  p_clob_csid number default NLS_CHARSET_ID('UTF8')
) return BLOB
as

l_blob BLOB;
l_warning NUMBER;
l_lang_context number default 0;
--l_blob_csid number default 0;
l_src_offset number default 1;
l_dest_offset number default 1;

begin
  DBMS_LOB.CREATETEMPORARY(l_blob, true);

  DBMS_LOB.OPEN (l_blob, DBMS_LOB.LOB_READWRITE);

  DBMS_LOB.CONVERTTOBLOB(
    l_blob,
    p_clob,
    DBMS_LOB.LOBMAXSIZE,
    l_src_offset,
    l_dest_offset,
    nvl(p_clob_csid, NLS_CHARSET_ID('UTF8')),
    l_lang_context,
    l_warning
  );
  return l_blob;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'CLOB2BLOB',
    P_SQLERRM => sqlerrm
  );
  raise;
end CLOB2BLOB;


/** Return APEX static file as BLOB 
  * 
  * @param p_xsltStaticFile Filename of APEX static file with XSLT 
  * @param po_file_csid Oracle character set ID 
  * @return APEX static file as BLOB 
  */ 
function StaticFile2BLOB 
( 
  p_xsltStaticFile  IN    varchar2, 
  po_file_csid      OUT   number 
) return BLOB 
as 
 
--l_StaticFile_clob   CLOB; 
l_StaticFile_blob   BLOB; 
l_length NUMBER; 
/* 
l_binBlob BLOB; 
l_warning NUMBER; 
l_lang_context number default 0; 
--l_blob_csid number default 0; 
l_src_offset number default 1; 
l_dest_offset number default 1; 
*/ 
l_file_charset varchar2(50); 
l_apex_ver varchar2(10); 
 
begin 
  pak_xslt_log.WriteLog( 
    'Starting XSLTStaticFile: ->'||p_xsltStaticFile||'<-', 
    p_procedure => 'StaticFile2BLOB' 
  ); 
 
  if p_xsltStaticFile is null then 
    return null; 
  end if; 
 
  SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1) 
  into l_apex_ver 
  FROM apex_release; 
 
  pak_xslt_log.WriteLog( 
    'apex version: '||l_apex_ver||' wwv_flow.get_sgid '||wwv_flow.get_sgid, 
    p_procedure => 'StaticFile2BLOB' 
  ); 
 
  select blob_content, file_charset
  into l_StaticFile_blob, l_file_charset 
  from wwv_flow_files where ID = 
  (	
    select max(ID) from wwv_flow_files 
  	where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1') and
    FLOW_ID in (APEX_APPLICATION.G_FLOW_ID, 0) and  
  	filename = p_xsltStaticFile 
  );
 
  pak_xslt_log.WriteLog( 
    'XSLTStaticFile get BLOB: '||p_xsltStaticFile||' l_file_charset: '||l_file_charset, 
    p_procedure => 'StaticFile2BLOB' 
  ); 
 
  po_file_csid := nls_charset_id(nvl(utl_i18n.map_charset(l_file_charset, 0, 1 ),'UTF8')); 
 
  return l_StaticFile_blob; 
 
exception 
  when no_data_found then
      pak_xslt_log.WriteLog( 
       'File '||p_xsltStaticFile||' missing. Install it to workspace or application static files!', 
        p_log_type => pak_xslt_log.g_error, 
        p_procedure => 'StaticFile2BLOB'
      ); 
      raise_application_error(-20001, 'File '||p_xsltStaticFile||' missing. Install it to workspace or application static files!');
  when others then 
  pak_xslt_log.WriteLog( 
    'Error '||p_xsltStaticFile, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'StaticFile2BLOB', 
    P_SQLERRM => sqlerrm 
  ); 
  raise; 
end StaticFile2BLOB; 
 
 
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
) return CLOB 
as 
 
--l_StaticFile_clob   CLOB; 
l_StaticFile_blob   BLOB; 
l_length NUMBER; 
/* 
l_binBlob BLOB; 
l_warning NUMBER; 
l_lang_context number default 0; 
--l_blob_csid number default 0; 
l_src_offset number default 1; 
l_dest_offset number default 1; 
*/ 
l_file_charset varchar2(50); 
l_apex_ver varchar2(10); 
 
begin 
  pak_xslt_log.WriteLog( 
    'Starting XSLTStaticFile: ->'||p_xsltStaticFile||'<-', 
    p_procedure => 'StaticFile2CLOB' 
  ); 
 
  if p_xsltStaticFile is null then 
    return null; 
  end if; 
 
  SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1) 
  into l_apex_ver 
  FROM apex_release; 
 
  pak_xslt_log.WriteLog( 
    'apex version: '||l_apex_ver||' wwv_flow.get_sgid '||wwv_flow.get_sgid, 
    p_procedure => 'StaticFile2CLOB' 
  ); 
 
  select blob_content, file_charset
  into l_StaticFile_blob, l_file_charset 
  from wwv_flow_files where ID = 
  (	
    select max(ID) from wwv_flow_files 
  	where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1') and
    FLOW_ID in (APEX_APPLICATION.G_FLOW_ID, 0) and  
  	filename = p_xsltStaticFile 
  );
 
  pak_xslt_log.WriteLog( 
    'XSLTStaticFile get BLOB: '||p_xsltStaticFile||' l_file_charset: '||l_file_charset, 
    p_procedure => 'StaticFile2CLOB' 
  ); 
 
  po_file_csid := nls_charset_id(nvl(utl_i18n.map_charset(l_file_charset, 0, 1 ),'UTF8')); 
 
  return Blob2Clob(l_StaticFile_blob, po_file_csid); 
 
exception 
  when no_data_found then
      pak_xslt_log.WriteLog( 
       'File '||p_xsltStaticFile||' missing. Install it to workspace or application static files!', 
        p_log_type => pak_xslt_log.g_error, 
        p_procedure => 'StaticFile2CLOB'
      ); 
      raise_application_error(-20001, 'File '||p_xsltStaticFile||' missing. Install it to workspace or application static files!');
      
  when others then 
  pak_xslt_log.WriteLog( 
    'Error '||p_xsltStaticFile, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'StaticFile2CLOB', 
    P_SQLERRM => sqlerrm 
  ); 
  raise; 
end StaticFile2CLOB; 

$if CCOMPILING.g_utl_file_privilege $then

function FileSize(
    P_DIRECTORY VARCHAR2,
    P_FILENAME VARCHAR2
  ) return integer
  AS
   l_file_loc BFILE;
   l_file_length number;

  BEGIN
     l_file_loc := BFILENAME(P_DIRECTORY, P_FILENAME);
     if l_file_loc is not null then
      l_file_length := dbms_lob.getlength(l_file_loc);
     end if;

    return l_file_length;

  exception
    when others then
    pak_xslt_log.WriteLog('Error on filesize of '||P_DIRECTORY||'\'||P_FILENAME, p_log_type => pak_xslt_log.g_error, p_procedure => 'FileSize', p_sqlerrm => sqlerrm );
    raise;
END FileSize;

function GetBlob(
    P_DIRECTORY VARCHAR2,
    P_FILENAME VARCHAR2
  ) return BLOB
  AS
  l_dest_offset INTEGER default 1;
  l_src_offset INTEGER default 1;
  L_FILEBLOB BLOB;
  l_file_loc BFILE;
  BEGIN
     if FileSize(P_DIRECTORY, P_FILENAME) = 0 then
        return null;
     end if;
     DBMS_LOB.CREATETEMPORARY(L_FILEBLOB, false);
     l_file_loc := BFILENAME(P_DIRECTORY, P_FILENAME);
     DBMS_LOB.OPEN(l_file_loc);
     DBMS_LOB.OPEN(L_FILEBLOB, DBMS_LOB.LOB_READWRITE);

     DBMS_LOB.LOADFROMFILE (
     L_FILEBLOB,
     l_file_loc,
     DBMS_LOB.LOBMAXSIZE
    );

    DBMS_LOB.CLOSE(L_FILEBLOB);
    DBMS_LOB.CLOSE(l_file_loc);

    return L_FILEBLOB;
  exception
    when others then
    pak_xslt_log.WriteLog('Error reading BLOB from file '||P_DIRECTORY||'\'||P_FILENAME, p_log_type => pak_xslt_log.g_error, p_procedure => 'GetBlob', p_sqlerrm => sqlerrm );
     raise;
  END GetBlob;

/** Writes BLOB to file
  *
  * @param P_DIRECTORY ORA directory
  * @param P_FILENAME filename
  * @param p_blob BLOB to write
  */
PROCEDURE Blob2File
(
  P_DIRECTORY      IN VARCHAR2,
  P_FILENAME       IN VARCHAR2,
  p_blob           IN BLOB
)
IS
  c_amount         BINARY_INTEGER := 32767;
  l_buffer         RAW(32767);
  l_clobLen        PLS_INTEGER;
  l_fHandler       utl_file.file_type;
  l_pos            PLS_INTEGER    := 1;

BEGIN

  l_clobLen  := DBMS_LOB.GETLENGTH(p_blob);
  l_fHandler := UTL_FILE.FOPEN(P_DIRECTORY, P_FILENAME, 'wb', 32767);

  LOOP
    DBMS_LOB.READ(p_blob, c_amount, l_pos, l_buffer);
    UTL_FILE.PUT_RAW(l_fHandler, l_buffer, true);
    l_pos := l_pos + c_amount;
  END LOOP;

  UTL_FILE.FCLOSE(l_fHandler);
EXCEPTION
WHEN NO_DATA_FOUND THEN
  UTL_FILE.FCLOSE(l_fHandler);

WHEN OTHERS THEN
  if utl_file.is_open(l_fHandler) then
    UTL_FILE.FCLOSE(l_fHandler);
  end if;

  pak_xslt_log.WriteLog(
    'Error writing BLOB to: '||P_DIRECTORY||'\'||P_FILENAME,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Blob2File',
    p_sqlerrm => sqlerrm
  );
  raise;
END;


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
  ) return NCLOB
  AS
  l_dest_offset INTEGER default 1;
  l_src_offset INTEGER default 1;
  L_FILECLOB CLOB;
  l_file_loc BFILE;
  l_src_csid number; --?
  l_lang_context number default 0;
  l_warning varchar2(200);
  BEGIN
     if P_DIRECTORY is null and P_FILENAME is null then
      return null;
     end if;
     DBMS_LOB.CREATETEMPORARY(L_FILECLOB, false);
     l_file_loc := BFILENAME(P_DIRECTORY, P_FILENAME);
     DBMS_LOB.OPEN(l_file_loc);
     DBMS_LOB.OPEN(L_FILECLOB, DBMS_LOB.LOB_READWRITE);

     DBMS_LOB.LOADCLOBFROMFILE (
       L_FILECLOB,
       l_file_loc,
       DBMS_LOB.LOBMAXSIZE,
       l_dest_offset,
       l_src_offset,
       nvl(NLS_CHARSET_ID(P_NLS_CHARSET),0),
       l_lang_context,
       l_warning
       );

    DBMS_LOB.CLOSE(L_FILECLOB);
    DBMS_LOB.CLOSE(l_file_loc);

    return L_FILECLOB;
  exception
    when others then
    pak_xslt_log.WriteLog(
      'Error when reading CLOBa from '||P_DIRECTORY||'\'||P_FILENAME,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'Read2Clob',
      p_sqlerrm => sqlerrm
    );
    raise;
  END Read2Clob;
  
$end

procedure clobReplace(
  pio_xml IN OUT NOCOPY CLOB,
  p_start_offset number,
  p_end_offset number,
  p_replace_with varchar2
)
as
l_temp CLOB;
begin
  dbms_lob.createtemporary(l_temp, false);
  if p_start_offset > 1 then
    dbms_lob.copy(l_temp, pio_xml, p_start_offset - 1);
  end if;
  dbms_lob.writeappend(l_temp, length(p_replace_with), p_replace_with);
  if p_end_offset < dbms_lob.getlength(pio_xml) then
    dbms_lob.copy(l_temp, pio_xml, dbms_lob.getlength(pio_xml) - p_end_offset, dbms_lob.getlength(l_temp)+1, p_end_offset + 1);
  end if;
  pio_xml := l_temp;
  dbms_lob.freetemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'clobReplace 3',
    p_sqlerrm => sqlerrm
  );
end;

procedure clobReplace(
  pio_xml IN OUT NOCOPY CLOB,
  p_start_offset number,
  p_end_offset number,
  p_replace_with CLOB
)
as
l_temp CLOB;
begin
  dbms_lob.createtemporary(l_temp, false);
  if p_start_offset > 1 then
    dbms_lob.copy(l_temp, pio_xml, p_start_offset - 1);
  end if;
  dbms_lob.copy(l_temp, p_replace_with, dbms_lob.getlength(p_replace_with), dbms_lob.getlength(l_temp)+1, 1);
  if p_end_offset < dbms_lob.getlength(pio_xml) then
    dbms_lob.copy(l_temp, pio_xml, dbms_lob.getlength(pio_xml) - p_end_offset, dbms_lob.getlength(l_temp)+1, p_end_offset + 1);
  end if;
  pio_xml := l_temp;
  dbms_lob.freetemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'clobReplace 4',
    p_sqlerrm => sqlerrm
  );
end;



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
)
as
n  number default 1;
l_buffer varchar2(32000);
l_amount constant number := 20000;
l_replaced_offset number default 1;
l_size_changed number default 0;
l_more_than_one boolean;
l_start number default p_startOffset;
l_end number default p_startOffset;
l_end1 number default p_startOffset;
l_whatsize number;
l_start_time PLS_INTEGER := dbms_utility.get_time();
l_temp clob;
begin
  dbms_lob.createtemporary(l_temp, false);
  pio_endOffset := nvl(pio_endOffset, dbms_lob.getlength(pio_clob));
  loop
    l_size_changed := 0;
    l_start := dbms_lob.instr(pio_clob, p_what, l_end);
    /*
     pak_xslt_log.WriteLog(
      ' l_start '||to_char(l_start),
      p_procedure => 'clobReplace');
    */
    exit when nvl(l_start, 0) = 0 or l_start > pio_endOffset;
    l_end := l_start + length(p_what);
    l_more_than_one := false;
    loop
      l_end1 := dbms_lob.instr(pio_clob, p_what, l_end);
      exit when nvl(l_end1, 0) = 0;
      l_end1 := l_end1 + length(p_what);
      exit when l_end1 - l_start > l_amount or l_end1 > pio_endOffset;
      l_end := l_end1;
      l_more_than_one := true;
      /*
      pak_xslt_log.WriteLog(
      ' l_whatsize '||to_char(l_end - l_start),
      p_procedure => 'clobReplace');
      */
    end loop;
    if not l_more_than_one then
      l_buffer := p_with;
      l_whatsize := nvl(length(p_what),0);
    else
      l_whatsize := l_end - l_start;
      dbms_lob.read(pio_clob, l_whatsize, l_start, l_buffer);
    end if;
    l_buffer := replace(l_buffer, p_what, p_with);
    l_size_changed := l_size_changed + nvl(length(l_buffer), 0) - l_whatsize;

    pak_xslt_log.WriteLog(
      ' Size changed for '||to_char(nvl(length(l_buffer), 0) - l_whatsize)||' l_whatsize: '||to_char(l_whatsize),
      p_procedure => 'clobReplace');

    l_temp:=pio_clob;
    dbms_lob.copy(pio_clob,
                  l_temp,
                  dbms_lob.getlength(l_temp),
                  l_start + nvl(length(l_buffer),0),
                  l_start + l_whatsize );
    --dbms_xslprocessor.clob2file(pio_clob, 'XMLDIR', 'debug4.xml');

    if nvl(length(l_buffer),0) > 0 then
      dbms_lob.write( pio_clob, nvl(length(l_buffer),0), l_start, l_buffer );
    end if;
    if ( l_size_changed < 0 )
    then
      pak_xslt_log.WriteLog(
        ' trim for '||l_size_changed,
        p_procedure => 'clobReplace');
      dbms_lob.trim( pio_clob, dbms_lob.getlength(pio_clob) + l_size_changed);
    end if;
    pio_endoffset := pio_endoffset + l_size_changed;
    l_end := l_start + nvl(length(l_buffer),0);
    /*
    pak_xslt_log.WriteLog(
      ' New end '||l_end,
      p_procedure => 'clobReplace');
      */
  end loop;
  --dbms_xslprocessor.clob2file(pio_clob, 'XMLDIR', 'debug5.xml');

  dbms_lob.freetemporary(l_temp);
  pak_xslt_log.WriteLog(
      ' clobReplace '||p_what||' with '||p_with||' finished. ',
      p_procedure => 'clobReplace',
      p_start_time => l_start_time
  );
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'clobReplace',
      p_sqlerrm => sqlerrm
    );
    raise;
end;

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
)
as
n  number default 1;
l_buffer varchar2(32000);
l_amount constant number := 25000;
l_replaced_offset number default 1;
l_size_changed number default 0;
l_more_than_one boolean;
l_start number default 1;
l_end number default 1;
l_end1 number default 1;
l_whatsize number;
l_start_time PLS_INTEGER := dbms_utility.get_time();
l_temp clob;
begin
  dbms_lob.createtemporary(l_temp, false);
  loop
    l_size_changed := 0;
    l_start := dbms_lob.instr(pio_clob, p_what, l_end);
    /*
     pak_xslt_log.WriteLog(
      ' l_start '||to_char(l_start),
      p_procedure => 'clobReplaceAll');
    */
    exit when nvl(l_start, 0) = 0;
    l_end := l_start + length(p_what);--èe najde p_what na koncu je l_end èez
    l_more_than_one := false;
    loop
      l_end1 := dbms_lob.instr(pio_clob, p_what, l_end);
      exit when nvl(l_end1, 0) = 0;
      l_end1 := l_end1 + length(p_what);
      exit when l_end1 -l_start > l_amount;
      l_end := l_end1;
      l_more_than_one := true;
      /*
      pak_xslt_log.WriteLog(
      ' l_whatsize '||to_char(l_end - l_start),
      p_procedure => 'clobReplaceAll');
      */
    end loop;
    if not l_more_than_one then
      l_buffer := p_what; --p_with;
      l_whatsize := nvl(length(p_what),0);
    else
      l_whatsize := l_end - l_start;
      dbms_lob.read(pio_clob, l_whatsize, l_start, l_buffer);
    end if;
    --read to buffer of maximum possible size then replace in buffer
    l_buffer := replace(l_buffer, p_what, p_with);
    l_size_changed := l_size_changed + nvl(length(l_buffer), 0) - l_whatsize;

    pak_xslt_log.WriteLog(
      ' Size changed for '||to_char(nvl(length(l_buffer), 0) - l_whatsize)||' l_whatsize: '||to_char(l_whatsize),
      p_procedure => 'clobReplaceAll');

    --write buffer back to CLOB
    if l_start + l_whatsize <= dbms_lob.getlength(pio_clob) then
      l_temp:=pio_clob;
      dbms_lob.copy(pio_clob,
                    l_temp,
                    dbms_lob.getlength(l_temp),
                    l_start + nvl(length(l_buffer),0),
                    l_start + l_whatsize );
      --dbms_xslprocessor.clob2file(pio_clob, 'XMLDIR', 'debug4.xml');
    end if;

    if nvl(length(l_buffer),0) > 0 then
      dbms_lob.write( pio_clob, nvl(length(l_buffer),0), l_start, l_buffer );
    end if;
    if ( l_size_changed < 0 ) --If size is smaller than trim CLOB
    then
      pak_xslt_log.WriteLog(
        ' trim for '||l_size_changed,
        p_procedure => 'clobReplaceAll');
      dbms_lob.trim( pio_clob, dbms_lob.getlength(pio_clob) + l_size_changed);
    end if;
    l_end := l_start + nvl(length(l_buffer),0);
    /*
    pak_xslt_log.WriteLog(
      ' New end '||l_end,
      p_procedure => 'clobReplaceAll');
      */
  end loop;
  --dbms_xslprocessor.clob2file(pio_clob, 'XMLDIR', 'debug5.xml');

  dbms_lob.freetemporary(l_temp);
  pak_xslt_log.WriteLog(
      ' clobReplaceAll '||p_what||' with '||p_with||' finished. ',
      p_procedure => 'clobReplaceAll',
      p_start_time => l_start_time
  );
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'clobReplaceAll',
      p_sqlerrm => sqlerrm
    );
    raise;
end clobReplaceAll;

function base64_decode(
    p_file in clob
  )
  return blob is
   c_blocksize        constant pls_integer := 32000;
   l_temp             CLOB;
   l_result           blob := empty_blob();
   l_pos              number := 1;
   l_amount           number;
   l_sbuf             varchar2(32767);
   l_buffer           raw(32767);
   l_rbuf             raw(32767);
   l_length           pls_integer;

  begin
   dbms_lob.createTemporary(l_result, true, dbms_lob.CALL);
   dbms_lob.createTemporary(l_temp, false);
   l_length  := dbms_lob.getLength(p_file);

   --Remove line breaks from Base 64
   while l_pos <= l_length loop
    l_amount := c_blocksize;
    dbms_lob.read(p_file, l_amount, l_pos, l_sbuf);
    l_sbuf := replace(replace(l_sbuf, chr(13)),chr(10));
    dbms_lob.writeappend(l_temp, length(l_sbuf), l_sbuf);
    l_pos    := l_pos + c_blocksize;
   end loop;

   --Do decoding
   l_pos := 1;
   l_length  := dbms_lob.getLength(l_temp);
   while l_pos <= l_length loop
    l_amount := c_blocksize;
    dbms_lob.read(l_temp, l_amount, l_pos, l_sbuf);
    l_rbuf   := utl_raw.cast_to_raw(l_sbuf);
    l_buffer := utl_encode.base64_decode(l_rbuf);

    dbms_lob.writeappend(l_result,
                         utl_raw.length(l_buffer),
                         l_buffer);

    l_pos    := l_pos + c_blocksize;
   end loop;
   return l_result;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'pak_blob_util.base64_decode'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end base64_decode;

  --base64 encode
  function base64_encode(p_binary BLOB)
  return CLOB
  as
  l_clob CLOB;
  l_step PLS_INTEGER := 12000; -- make sure you set a multiple of 3 not higher than 24573
  begin
    FOR i IN 0 .. TRUNC((DBMS_LOB.getlength(p_binary) - 1 )/l_step) LOOP
      l_clob := l_clob || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(DBMS_LOB.substr(p_binary, l_step, i * l_step + 1)));
    END LOOP;
  RETURN l_clob;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'pak_blob_util.base64_encode'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end base64_encode;

END PAK_BLOB_UTIL;

/
