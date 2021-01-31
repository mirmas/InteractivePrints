CREATE OR REPLACE PACKAGE BODY "QUERY2REPORT" as

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


--error_xml_processing EXCEPTION;
--PRAGMA EXCEPTION_INIT(error_xml_processing, -19202);





-------------------------CRYPTO PART-------------------------------
g_key constant varchar2(100) := 'L+6d771+m5m4K274TYj2w3dntYOK7weoT151DTxW0o8=';







g_control_string constant varchar2(4) := '5EC1';
------------------------------------------------------------------

--'<?xml version="1.0" encoding="'||p_encoding||'"?>'|| g_crlf||
g_start_xslt_html constant varchar2(400):=
  '<?xml version="1.0" encoding="utf-8"?>'|| g_crlf||
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'|| g_crlf||
  '<xsl:output method="html"/>'||g_crlf||
    '<xsl:template match="/">'|| g_crlf|| g_crlf;






g_start_xslt_text constant varchar2(400):=
  '<?xml version="1.0" encoding="utf-8"?>'|| g_crlf||
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'|| g_crlf||
  '<xsl:output method="text"/>'||g_crlf||
    '<xsl:template match="/">'|| g_crlf|| g_crlf;






g_end_xslt constant varchar2(200):=
  g_crlf||'</xsl:template>'||g_crlf||
                '</xsl:stylesheet>'||g_crlf;

g_startStr_txt_no_esc constant varchar2(200):= g_crlf||'<xsl:text disable-output-escaping="yes">'||g_crlf||'<![CDATA[';
g_endStr_txt_no_esc constant varchar2(200):=  ']]>'||g_crlf||'</xsl:text>'||g_crlf;

g_startStr_txt_no_esc_lb constant varchar2(200):= '<xsl:text disable-output-escaping="yes"><![CDATA[';
g_endStr_txt_no_esc_lb constant varchar2(200):=  ']]></xsl:text>';






g_startStr_txt constant varchar2(200):= '<xsl:text>';
g_endStr_txt constant varchar2(200):=  '</xsl:text>'||g_crlf;

TYPE rowset_interval IS VARRAY(2) OF PLS_INTEGER;
TYPE rowset_intervals IS VARRAY(5) OF rowset_interval;

--------------------------------------------CRYPTO PART-----------------------------------------------
function md5hash (p_input in varchar2)
return varchar2
is
begin
 return upper(dbms_obfuscation_toolkit.md5(
          input => utl_i18n.string_to_raw(p_input)));
end md5hash;

function GetKey
return raw
is
l_ret raw(200);

cursor c_curp is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE' and name = 'QUERY2REPORT' order by line;

cursor c_curb is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE BODY' and name = 'QUERY2REPORT' order by line;

cursor c_cur1p is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE' and name = 'APEXREP2REPORT' order by line;

cursor c_cur1b is
select replace(replace(trim(text),chr(10)),chr(13)) text from user_source
where type='PACKAGE BODY' and name = 'APEXREP2REPORT' order by line;

begin
 for r_curb in c_curb loop
  if length(r_curb.text) > 0 then
    l_ret := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(l_ret,UTL_I18N.STRING_TO_RAW(r_curb.text,  'AL32UTF8')));
  end if;
 end loop;

 for r_curp in c_curp loop
  if length(r_curp.text) > 0 and nvl(instr(lower(r_curp.text), 'g_selectenc constant varchar2'), 0)=0 then
    l_ret := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(l_ret,UTL_I18N.STRING_TO_RAW(trim(r_curp.text),  'AL32UTF8')));
  end if;
 end loop;

 for r_cur1b in c_cur1b loop
  if length(r_cur1b.text) > 0 then
    l_ret := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(l_ret,UTL_I18N.STRING_TO_RAW(r_cur1b.text,  'AL32UTF8')));
  end if;
 end loop;

 for r_cur1p in c_cur1p loop
  if nvl(instr(lower(r_cur1p.text), 'g_views_granted constant boolean'), 0)=0 and length(r_cur1p.text)>0 then
    l_ret := dbms_obfuscation_toolkit.md5(input => utl_raw.concat(l_ret,UTL_I18N.STRING_TO_RAW(r_cur1p.text,  'AL32UTF8')));
  end if;
 end loop;


 return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'GetKey', p_sqlerrm => sqlerrm );
  raise;
end GetKey;

--Ne wrapaj!!
function BlockXOR(p_raw RAW, p_key RAW)
return RAW
as
l_blockkey RAW(32000);
l_rawsize number;
l_keysize number;
begin
  l_rawsize := utl_raw.length(p_raw);
  l_keysize := utl_raw.length(p_key);
  while l_rawsize > 0 loop
    if l_rawsize >= l_keysize then
      l_blockkey:=utl_raw.concat(l_blockkey, p_key);
    else
      l_blockkey:=utl_raw.concat(l_blockkey, utl_raw.substr(p_key, 1, l_rawsize));
    end if;
    l_rawsize := l_rawsize - l_keysize;
  end loop;
  return utl_raw.bit_xor(p_raw, l_blockkey);
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'BlockXOR', p_sqlerrm => sqlerrm );
  raise;
end;


function IsValidLicenceKey(p_lk varchar2)
return boolean
as
l_validate varchar2(20);
l_hash varchar2(32);
l_control_string varchar2(4);
begin
   if p_lk = g_trial then
     return true;
   end if;
   l_validate := trim(replace(upper(p_lk),'-',''));
   l_control_string := substr(l_validate,17,4);
   l_hash := md5hash(substr(l_validate,1,16)||g_key);
   return substr(l_hash, 5, 1)||substr(l_hash, 16, 1)||substr(l_hash, 30, 1)||substr(l_hash, 13, 1) = nvl(l_control_string,' ');
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'IsValidLicenceKey', p_sqlerrm => sqlerrm );
  return false;
end IsValidLicenceKey;

-------------DES3 verzija----------
/**Decrypts PL/SQL code
*
* @param p_plsql PLSQL Block.
* @param p_lk Valid Licence key
* @return encrypted PLSQL block
*/
function DecPlSql(p_plsql varchar2, p_lk varchar2)
return varchar2 AS
l_key_bytes_raw  RAW(16); --stores 128-bit encryption key
l_key2_raw  RAW(16);
BEGIN
  if p_lk is null then
    l_key_bytes_raw := GetKey;
  else
    if not isvalidlicencekey(p_lk) then
      pak_xslt_log.WriteLog( 'INV'||p_lk, p_log_type => pak_xslt_log.g_error,
      p_procedure => 'DecPlSql', p_sqlerrm => sqlerrm );
      return null;
    end if;

    l_key_bytes_raw := UTL_I18N.STRING_TO_RAW (substr(p_lk,1,16),  'AL32UTF8');
    l_key2_raw := UTL_I18N.STRING_TO_RAW (substr(g_key,1,16),  'AL32UTF8');
    l_key_bytes_raw := BlockXOR(l_key_bytes_raw, l_key2_raw);
  end if;
  return
  UTL_I18N.RAW_TO_CHAR(
    DBMS_OBFUSCATION_TOOLKIT.DES3DECRYPT
    (
       input => UTL_ENCODE.BASE64_DECODE(UTL_I18N.STRING_TO_RAW(p_plsql,  'AL32UTF8')),
       key => l_key_bytes_raw
    ),
    'AL32UTF8'
  );
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'DecPlSql', p_sqlerrm => sqlerrm );
  raise;
END DecPlSql;

/*
function CheckDBIDWSID
return boolean AS
l_key_bytes_raw  RAW(16); --stores 128-bit encryption key
l_key2_raw  RAW(16);
l_dec_dbidwsid varchar2(4000);
l_type_id varchar2(3);
l_ids varchar2(4000);
l_exists number;
l_id number;
l_lk varchar2(4000);
l_dbidwsid varchar2(4000);
cursor c_ws is select workspace_id from apex_workspaces;
BEGIN
  select SWKEY, DBIDWSID into l_lk, l_dbidwsid from xsltswkey;
  if not isvalidlicencekey(l_lk) then
    pak_xslt_log.WriteLog( 'INV'||l_lk, p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DecPlSql', p_sqlerrm => sqlerrm );
    return false;
  end if;

  l_key_bytes_raw := UTL_I18N.STRING_TO_RAW (substr(l_lk,1,16),  'AL32UTF8');
  l_key2_raw := UTL_I18N.STRING_TO_RAW (substr(g_key,1,16),  'AL32UTF8');
  l_key_bytes_raw := BlockXOR(l_key_bytes_raw, l_key2_raw);

  l_dec_dbidwsid :=
  trim(UTL_I18N.RAW_TO_CHAR(
    DBMS_OBFUSCATION_TOOLKIT.DES3DECRYPT
    (
       input => UTL_ENCODE.BASE64_DECODE(UTL_I18N.STRING_TO_RAW(l_dbidwsid,  'AL32UTF8')),
       key => l_key_bytes_raw
    ),
    'AL32UTF8'
  ));
  l_type_id := substr(l_dec_dbidwsid,1,3);
  l_ids := substr(l_dec_dbidwsid,4);


  select count(*) into l_exists
  from all_objects where upper(owner) = 'SYS' and upper(object_name) = 'V_$DATABASE' and OBJECT_TYPE = 'VIEW';

  if l_type_id = 'DB:' and l_exists = 1 then
    EXECUTE IMMEDIATE 'select DBID from SYS.V_$DATABASE' into l_id;
    if instr(','||l_ids||',', ','||to_char(l_id)||',') > 0 then
      return true;
    end if;
  elsif l_type_id = 'WS:' then
    for r_ws in c_ws loop
      if instr(','||l_ids||',', ','||to_char(r_ws.workspace_id)||',') > 0 then
        return true;
      end if;
    end loop;
  end if;

  return false;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'CheckDBIDWSID', p_sqlerrm => sqlerrm );
  return false;
END CheckDBIDWSID;

function CheckDBIDWSID01 return number
as
begin
  if CheckDBIDWSID then
    return 1;
  else
    return 0;
  end if;
end;
*/

procedure SetLicenceKey(p_licence_key varchar2, p_coded varchar2, p_dbidwsid varchar2)
as
l_licence_key varchar2(20);
l_count number;
begin
  select count(*) into l_count from xsltswkey;
  if l_count = 1 then
    select swkey into l_licence_key from xsltswkey;
  end if;
  if not isvalidlicencekey(p_licence_key) or nvl(l_licence_key,' ') = g_trial or l_count = 0 then
    delete from xsltswkey;
    insert into xsltswkey(swkey, coded, dbidwsid) values(trim(upper(p_licence_key)), p_coded, p_dbidwsid);
    commit;
  end if;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error,
  p_procedure => 'SetLicenceKey', p_sqlerrm => sqlerrm );
  rollback;
  raise;
end;


------------------End of Crypto part--------------------------------------------


/*Extracts strings from HTML and separate them by space */
function html2str ( line in varchar2 ) return varchar2 is
    x       varchar2(32767) := null;
    in_html boolean         := FALSE;
    s       varchar2(4);
  begin
    if line is null then
      return line;
    end if;
    --pak_xslt_log.WriteLog( 'line: '||line, p_log_type => pak_xslt_log.g_warning, p_procedure => 'html2str');
    for i in 1 .. length( line ) loop
      s := substr( line, i, 1 );
      if in_html then
        if s = '>' then
          in_html := FALSE;
          if substr(x,length(x),1)<>' ' then
            x:=x||' ';
          end if;
        end if;
      else
        if s = '<' then
          in_html := TRUE;
        end if;
      end if;
      if not in_html and s != '>' then
        x := x|| s;
      end if;
    end loop;
    x:=trim(x);
    return x;
exception
  when others then
  pak_xslt_log.WriteLog( 'Error: '||line, p_log_type => pak_xslt_log.g_error, p_procedure => 'html2str', p_sqlerrm => sqlerrm );
  raise;
end html2str;

/* Remove special chars which caused ORA-31061: XDB error: special char to escaped char conversion failed. */
/*
function RemoveSpecialChars (p_inputstr varchar2)
return varchar2
as
l_special_chars varchar2(32);
l_spaces varchar2(32);
begin
  for i in 0..31 loop
    if i not in (9,10,13) then
      l_special_chars := l_special_chars||chr(i);
      l_spaces := l_spaces||' ';
    end if;
  end loop;
  return translate(p_inputstr, l_special_chars, l_spaces);
exception
  when others then
  pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'RemoveSpecialChars', p_sqlerrm => sqlerrm );
  raise;
end RemoveSpecialChars;
 */

-----------------pak_xml_convert------------------------------------------



procedure mhtCorrections
(
  p_clob          IN OUT NOCOPY CLOB
)
IS
l_part CLOB;
l_end_boundary number;
l_boundary varchar2(4000);
l_cur_pos number;
l_start_ct number;
l_end_ct number;
l_begin_part number;
l_end_part number;
l_ct varchar2(32000);
i number default 1;
begin
  --find boundary
  l_cur_pos := dbms_lob.instr(p_clob, 'boundary="');
  if nvl(l_cur_pos, 0) = 0 then
    --TODO Write error log
    return;
  end if;
  l_cur_pos := l_cur_pos + length('boundary="');
  l_end_boundary := dbms_lob.instr(p_clob, '"', l_cur_pos);
  if nvl(l_end_boundary, 0) = 0 then
    --TODO Write error log
    return;
  end if;
  l_boundary := dbms_lob.substr(p_clob, l_end_boundary - l_cur_pos, l_cur_pos);
  if instr(l_boundary, '_NextPart_') = 0 then
    --TODO Write error log
    return;
  end if;
  l_cur_pos := l_end_boundary;
  loop
    l_begin_part := dbms_lob.instr(p_clob, l_boundary, l_end_boundary, i);
    exit when nvl(l_begin_part, 0) = 0;
    l_end_part := dbms_lob.instr(p_clob, l_boundary, l_end_boundary, i + 1);
    exit when nvl(l_end_part, 0) = 0;
    --read Content-Type
    l_start_ct := dbms_lob.instr(p_clob, 'Content-Type: ', l_begin_part);
    if l_start_ct > 0 and l_start_ct < l_end_part then
      l_start_ct := l_start_ct + length('Content-Type: ');
      l_end_ct:= dbms_lob.instr(p_clob, ';', l_start_ct);
      if l_end_ct > 0 and l_start_ct < l_end_part then
        l_ct := dbms_lob.substr(p_clob, l_end_ct-l_start_ct, l_start_ct);
        if l_ct = 'text/html' then
          --do replace
          pak_blob_util.clobReplace(p_clob, '='||chr(10), '='||chr(13)||chr(10), l_begin_part, l_end_part);
          ----dbms_xslprocessor.clob2file(p_clob, 'XMLDIR', 'test'||to_char(i)||'.mht', NLS_CHARSET_ID('EE8MSWIN1250'));
          null;
        end if;
      end if;
    end if;
    i := i + 1;
  end loop;
  pak_blob_util.clobReplaceAll(p_clob, chr(10)||chr(10), g_crlf);
  --pak_blob_util.clobReplaceAll(p_clob, g_crlf||g_crlf, g_crlf);
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'mhtCorrections',
      p_sqlerrm => sqlerrm
    );
    raise;
end mhtCorrections;



/*
PROCEDURE Clob2File
(
  p_clob           IN CLOB,
  p_dir            IN VARCHAR2,
  p_fileName       IN VARCHAR2
)
  IS

  c_amount         CONSTANT BINARY_INTEGER := 32000;
  l_buffer         VARCHAR2(32000);
  l_chr10          PLS_INTEGER;
  l_clobLen        PLS_INTEGER;
  l_fHandler       UTL_FILE.FILE_TYPE;
  l_pos            PLS_INTEGER    := 1;
  l_line           PLS_INTEGER    := 0;

BEGIN

  l_clobLen  := DBMS_LOB.GETLENGTH(p_clob);
  l_fHandler := UTL_FILE.FOPEN(p_dir, p_fileName,'W',c_amount);

  WHILE l_pos < l_clobLen LOOP
    l_buffer := DBMS_LOB.SUBSTR(p_clob, c_amount, l_pos);
    EXIT WHEN l_buffer IS NULL;
    l_chr10  := INSTR(l_buffer,g_crlf, -1);
    IF l_chr10 != 0 THEN
      l_buffer := SUBSTR(l_buffer,1,l_chr10-1);
      l_line := l_line + 1;
    else
      l_chr10 := 0;
    END IF;
    UTL_FILE.PUT_LINE(l_fHandler, l_buffer, TRUE);
    l_pos := l_pos + LENGTH(l_buffer) + length(g_crlf);
  END LOOP;

  UTL_FILE.FCLOSE(l_fHandler);

EXCEPTION
WHEN OTHERS THEN
  pak_xslt_log.WriteLog(
      'Error when writing CLOBa to '||P_DIR||'\'||P_FILENAME,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'Clob2File'
   );
  IF UTL_FILE.IS_OPEN(l_fHandler) THEN
    UTL_FILE.FCLOSE(l_fHandler);
  END IF;
  RAISE;

END Clob2File;
*/


procedure StartXML(
pio_xml IN OUT NOCOPY CLOB,
p_encoding varchar2 default 'utf-8'
)
as
  l_start_string varchar2(200);
begin
  if p_encoding is null then
    l_start_string := '<?xml version="1.0"?>'||g_crlf||'<DOCUMENT>';
  else
    l_start_string := '<?xml version="1.0" encoding="'||p_encoding||'"?>'||g_crlf||'<DOCUMENT>';
  end if;
  DBMS_LOB.CREATETEMPORARY (pio_xml, false);
  DBMS_LOB.WRITE (pio_xml, lengthb(l_start_string), 1, l_start_string);
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'StartXML',
      p_sqlerrm => sqlerrm
    );
    raise;
end StartXML;

procedure EndXML(
pio_xml IN OUT NOCOPY CLOB
)
as
  l_end_string constant varchar2(40) := '</DOCUMENT>';
begin
  DBMS_LOB.WRITEAPPEND (pio_xml, lengthb(l_end_string), l_end_string);
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'endXML',
      p_sqlerrm => sqlerrm
    );
    raise;
end EndXML;


function ConvertColName2XmlName(
  p_colname varchar2,
  p_chars varchar2 default '#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2
as
l_ret varchar2(4000);
begin
  l_ret := p_colname;
  l_ret:= replace(l_ret,' ','_');
  l_ret:= replace(l_ret,'<br>','_');
  l_ret:= replace(l_ret,'<br/>','_');
  for i in 1..length(p_chars) loop
    l_ret:= substr(replace(l_ret, substr(p_chars,i, 1), 'x'||trim(to_char(ascii(substr(p_chars,i, 1)),'xx'))),1,30);
  end loop;
  return l_ret;
end;

procedure AddStringToTable
(
  pi_string IN varchar2
  ,pio_stringTable IN OUT tab_string
)
as
begin
  pio_stringTable.extend;
  pio_stringTable(pio_stringTable.count) := pi_string;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'AddStringToTable',
    p_sqlerrm => sqlerrm
  );
  raise;
end AddStringToTable;

procedure AddTableToTables
(
  pi_table IN t_coltype_table
  ,pio_tables IN OUT t_coltype_tables
)
as
begin
  pio_tables.extend;
  pio_tables(pio_tables.count) := pi_table;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'AddTableToTables',
    p_sqlerrm => sqlerrm
  );
  raise;
end AddTableToTables;

/*IzraÄTuna Excel oznako stolpca, 1=A, 2=B,...,26=Z, 27=AA, 28=AB,..., 54=BB,..*/
function ExcelCol(p_position number)
return varchar2
as
l_coldiv26 number;
l_colmod26 number;
l_ret varchar2(2);
begin
  l_coldiv26 := floor((p_position - 1)/26);
  l_colmod26 := mod(p_position - 1, 26);

  if l_coldiv26 > 0 then
    l_ret := chr(ascii('A')- 1 + l_coldiv26);
  end if;
  l_ret := l_ret || chr(ascii('A') + l_colmod26);
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ExcelCol',
    p_sqlerrm => sqlerrm
  );
  raise;
end;


/**sestavi tabelo iz selekta (ne iz APEX reporta), FORMAT_MASK in FULL_NAME je column name brez vezajev*/
function ReportTypesElementTab
(
  pi_selectQuery  IN varchar2
)
return t_coltype_table
as
  c           NUMBER;
  col_cnt     INTEGER;
  rec_tab     DBMS_SQL.DESC_TAB;
  l_ora_type  varchar2(40);
  l_type      varchar2(40);
  --l_ret       varchar2(32000) :='<REPORT_TYPES>'||g_crlf;
  l_ret       t_coltype_table := t_coltype_table();
  l_xmlname   varchar2(4000);

  cursor c_cur(c_col_type number) is
    select ora_type
    from oratype_codes where ora_code = c_col_type;
begin
  pak_xslt_log.WriteLog(
    'Start ReportTypesElementTab(pi_selectQuery): '||pi_selectQuery ,
    p_procedure => 'ReportTypesElementTab'
  );

  if pi_selectQuery is null then
    return l_ret;
  end if;

  c := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(c, pi_selectQuery, DBMS_SQL.NATIVE);
  DBMS_SQL.DESCRIBE_COLUMNS(c, col_cnt, rec_tab);
  DBMS_SQL.CLOSE_CURSOR(c);

  pak_xslt_log.WriteLog(
    'Parse SQL results. col_cnt: '||col_cnt||' rec_tab.count: '||rec_tab.count,
    p_procedure => 'ReportTypesElementTab'
  );






























  for i in 1..rec_tab.count loop
    l_type := 'VARCHAR2';
    if rec_tab(i).col_name not in ('REGION_HIGHLIGHTS') then
      l_xmlname := ConvertColName2XmlName(rec_tab(i).col_name);
      open c_cur(rec_tab(i).col_type);
      fetch c_cur into l_ora_type;
      if c_cur%notfound then
        pak_xslt_log.WriteLog(
          'Can''t find data type with ID: '||rec_tab(i).col_type||' in ORATYPE_CODES view, using ID instead ',
          p_log_type => pak_xslt_log.g_warning,
          p_procedure => 'ReportTypesElementTab'
        );
      end if;

      if rec_tab(i).col_type = 231 or l_ora_type = 'DATE' or l_ora_type like 'TIMESTAMP%' then
        l_type := 'DATE';
      elsif l_ora_type = 'NUMBER' then
        l_type := 'NUMBER';
      end if;
      l_ret.extend;
      l_ret(l_ret.count) := t_coltype_row(l_xmlname, l_type, null, null,
                            replace(replace(replace(replace(l_xmlname,'_x005F_',' '), '_', ' '),'x26','&'),'x2e','.'),
                            i, ExcelCol(i), null, null, null, null, null, null, null, null, null, null, null
                            );
      --l_ret := l_ret||'<'||l_xmlname||'><TYPE>'||l_type||'</TYPE></'||l_xmlname||'>'||g_crlf;
      close c_cur;
    end if;
  end loop;
  --return l_ret||'</REPORT_TYPES>';
  pak_xslt_log.WriteLog(
    'Returning l_ret.count: '||l_ret.count,
    p_procedure => 'ReportTypesElementTab'
  );







































  return l_ret;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'ReportTypesElementTab(pi_selectQuery)',
      p_sqlerrm => sqlerrm
    );
    raise;
end ReportTypesElementTab;

/*
function ReportTypesElement
(
  pi_selectQuery  IN varchar2
)
return varchar2
as

  l_ret       varchar2(32000) :='<REPORT_TYPES>'||g_crlf;
  l_xmlname   varchar2(64);
  l_reporttypes t_coltype_table;

begin
  pak_xslt_log.WriteLog(
    'Start ReportTypesElement(pi_selectQuery): '||pi_selectQuery ,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'ReportTypesElement'
  );

  l_reporttypes := ReportTypesElementTab(pi_selectQuery);


  for i in 1..l_reporttypes.count loop
    l_ret := l_ret||'<'||l_reporttypes(i).colname||'>'||g_crlf||
            '<TYPE>'||l_reporttypes(i).coltype||'</TYPE>'||g_crlf||
            '</'||l_reporttypes(i).colname||'>'||g_crlf;
  end loop;

  return l_ret||'</REPORT_TYPES>';
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'ReportTypesElement(pi_selectQuery)',
      p_sqlerrm => sqlerrm
    );
    raise;
end ReportTypesElement;
*/

/*
function ReportTypesElement
(
  p_coltypeTable  t_coltype_table
)
return varchar2
as

  l_ret       varchar2(32000) :='<REPORT_TYPES>'||g_crlf;
  l_xmlname   varchar2(64);

begin
  pak_xslt_log.WriteLog(
    'Start ReportTypesElement(p_coltypeTable) count: '||p_coltypeTable.count ,
    p_procedure => 'ReportTypesElement'
  );



  for i in 1..p_coltypeTable.count loop
    l_ret := l_ret||'<'||p_coltypeTable(i).colname||'>'||g_crlf||
            '<TYPE>'||p_coltypeTable(i).coltype||'</TYPE>'||g_crlf||
            '<FORMAT_MASK>'||p_coltypeTable(i).formatmask||'</FORMAT_MASK>'||g_crlf||
            '<FULL_NAME>'||p_coltypeTable(i).fullname||'</FULL_NAME>'||g_crlf||
            '</'||p_coltypeTable(i).colname||'>'||g_crlf;
  end loop;

  return l_ret||'</REPORT_TYPES>';
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'ReportTypesElement(p_coltypeTable)',
      p_sqlerrm => sqlerrm
    );
    raise;
end ReportTypesElement;
*/



function ReportTypesElement
(
  pi_selectQueries  IN tab_string
)
return t_coltype_tables
as
l_ret t_coltype_tables := t_coltype_tables();
begin













  for i in 1..pi_selectQueries.count loop
    AddTableToTables(ReportTypesElementTab(pi_selectQueries(i)), l_ret);
  end loop;








  return l_ret;
end;




/** Insert string at offset l_offset, then append a rest of CLOB
  *
  * @param pio_clob CLOB
  * @param p_insertingStr String to insert
  * @p_offset Offset of inserting point
  */
procedure InsertString(
  pio_clob IN OUT NOCOPY CLOB,
  p_insertingStr varchar2,
  p_offset number
)
as
l_temp CLOB;
begin
  dbms_lob.createtemporary(l_temp, false);
  dbms_lob.copy(l_temp, pio_clob, p_offset - 1);
  dbms_lob.writeappend(l_temp, length(p_insertingStr), p_insertingStr);
  dbms_lob.copy(l_temp, pio_clob, dbms_lob.getlength(pio_clob) - p_offset + 1, dbms_lob.getlength(l_temp) + 1, p_offset);
  dbms_lob.trim(pio_clob, 0);
  pio_clob := l_temp;
  dbms_lob.freetemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'InsertString',
    p_sqlerrm => sqlerrm
  );
  raise;
end InsertString;


function ElementRealNames(p_tempXml CLOB)
return t_string_table
as
l_start number;
l_end number;
l_elements varchar2(32000);
l_element varchar2(200);
l_ret t_string_table:= t_string_table();
begin
  l_start := dbms_lob.instr(p_tempXml, '<ROW>');
  if l_start > 0 then
    l_start := l_start + length('<ROW>');
    l_end := dbms_lob.instr(p_tempXml, '</ROW>');
    if l_end > 0 then
      l_elements := dbms_lob.substr(p_tempXml, l_end - l_start, l_start);
      pak_xslt_log.WriteLog('l_elements: '||l_elements, p_procedure => 'ElementRealNames');
      l_start := 1;
      loop
        l_start := instr(l_elements,'<', l_start);
        exit when nvl(l_start, 0) = 0;
        l_end := instr(l_elements,'>', l_start);
        exit when nvl(l_end, 0) = 0;
        l_element := substr(l_elements, l_start + 1, l_end - (l_start+1));
        l_start := instr(l_elements, '</'||l_element||'>', l_end);
        exit when nvl(l_start, 0) = 0;
        l_start := l_start + length('</'||l_element||'>');
        l_ret.extend;
        l_ret(l_ret.count) := t_string_row(l_element);
        pak_xslt_log.WriteLog(l_element||' added', p_procedure => 'ElementRealNames');
      end loop;
    end if;
  end if;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ElementRealNames',
    p_sqlerrm => sqlerrm
  );
  raise;
end ElementRealNames;

function ConvertXmlName2ColName(
  p_xmlname varchar2,
  p_chars varchar2 default ' _#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2
as
l_ret varchar2(4000);
begin
  l_ret := p_xmlname;
  --l_ret:= translate(l_ret,' ()','_');
  for i in 1..length(p_chars) loop
    l_ret:= replace(l_ret, '_x00'||trim(to_char(ascii(substr(p_chars,i, 1)),'xx'))||'_', substr(p_chars, i, 1));
    l_ret:= replace(l_ret, '_x00'||trim(to_char(ascii(substr(p_chars,i, 1)),'XX'))||'_', substr(p_chars, i, 1));
  end loop;
  return l_ret;
end ConvertXmlName2ColName;

-- Original
/*
procedure InsertTypeTableAndRegionAttr(
  pio_tempXml IN OUT NOCOPY CLOB,
  p_reportTypes t_coltype_table,
  p_regionAttr varchar2
)
as
l_offset number;
--l_correctedReportTypes t_coltype_table := t_coltype_table();
l_elementRealNames t_string_table;
l_colname varchar2(64);
l_coltype varchar2(30);
l_formatmask varchar2(60);
l_fullname varchar2(200);
l_reportTypesXml varchar2(32000);
i number := 0;
c_cur sys_refcursor; --cur_coltype;

begin
  pak_xslt_log.WriteLog(
      'Start procedure pio_tempXml size: '||dbms_lob.getlength(pio_tempXml),
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

  l_offset := dbms_lob.instr(pio_tempXml, '<ROWSET>');
  if nvl(l_offset, 0) > 0 then
    --Correct pi_reportTypes with real XML data
    pak_xslt_log.WriteLog(
      'Start ElementRealNames',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );
    l_elementRealNames := ElementRealNames(pio_tempXml);
    pak_xslt_log.WriteLog(
      'End ElementRealNames',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

    pak_xslt_log.WriteLog(
      'Open cursor',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

    open c_cur for
    select nvl(r.col, t.colname), t.coltype, t.formatmask, t.fullname from table(p_reportTypes) t
    left outer join table(l_elementRealNames) r on ConvertXmlName2ColName(r.col) = ConvertXmlName2ColName(t.colname);

    pak_xslt_log.WriteLog(
      'Close cursor',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

    pak_xslt_log.WriteLog(
      'Start cursor loop',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );
    loop
      fetch c_cur into l_colname, l_coltype, l_formatmask, l_fullname;
      exit when c_cur%notfound;
      --l_correctedReportTypes.extend;
      --l_correctedReportTypes(l_correctedReportTypes.count) := t_coltype_row(l_colname, l_coltype, l_formatmask, l_fullname);
      pio_tempXml := replace(pio_tempXml, '<'||l_colname||'>',
        '<'||l_colname||' TYPE="'||l_coltype||'" '||
        case when l_formatmask is not null then 'FORMAT_MASK="'||l_formatmask||'" ' end||
        'FULL_NAME="'||replace(l_fullname,'_',' ')||'">');

      pio_tempXml := replace(pio_tempXml, '<'||l_colname||'/>',
        '<'||l_colname||' TYPE="'||l_coltype||'" '||
        case when l_formatmask is not null then 'FORMAT_MASK="'||l_formatmask||'" ' end||
        'FULL_NAME="'||replace(l_fullname,'_',' ')||'"/>');

      i := i + 1;
    end loop;
    close c_cur;

    pak_xslt_log.WriteLog(
      'End cursor loop i: '||i,
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );
    --TODO dodaj columnom atribute TYPE, FORMAT_MASK, FULL_NAME
    InsertString(pio_tempXml,  ' '||p_regionAttr, l_offset+length('<ROWSET'));

    pak_xslt_log.WriteLog(
      'End InsertString',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'InsertTypeTableAndRegionAttr',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
*/

---Optimizirana verzija---
/*
procedure InsertTypeTableAndRegionAttr(
  pio_reportTypes IN OUT t_coltype_table,
  p_tempXml IN CLOB,
  p_regionAttr varchar2
)
as
l_offset number;
--l_correctedReportTypes t_coltype_table := t_coltype_table();
l_elementRealNames t_string_table;
l_colname varchar2(64);
l_coltype varchar2(30);
l_formatmask varchar2(400);
l_width number;
l_fullname varchar2(200);
l_reportTypesXml varchar2(32000);
i number := 0;
c_cur sys_refcursor; --cur_coltype;
l_destXML CLOB;
l_buffer varchar2(32000);
l_initialbuffSize number := 4000;
l_first boolean := true;
l_startoffset number;
l_position number;
l_excelcol varchar2(2);

begin
  pak_xslt_log.WriteLog(
      'Start procedure pio_tempXml size: '||dbms_lob.getlength(pio_tempXml),
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

  ----dbms_xslprocessor.clob2file(pio_tempXml, 'XMLDIR', 'debug1.xml');

  l_offset := dbms_lob.instr(p_tempXml, '<ROWSET>');
  if nvl(l_offset, 0) > 0 then
    --Correct pi_reportTypes with real XML data
    pak_xslt_log.WriteLog(
      'Start ElementRealNames',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );
    l_elementRealNames := ElementRealNames(p_tempXml);
    pak_xslt_log.WriteLog(
      'End ElementRealNames',
      p_procedure => 'InsertTypeTableAndRegionAttr'
    );

    dbms_lob.createtemporary(l_destXML, false);
    l_offset := 1;

    loop
      exit when nvl(l_offset, 0) = 0;
      l_startoffset := l_offset;
      loop
        l_offset := dbms_lob.instr(pio_tempXml, '<ROW>', l_offset);
        exit when nvl(l_offset, 0) = 0;
        l_offset := l_offset + length('<ROW>');
        exit when l_offset - l_startoffset > l_initialbuffSize;
      end loop;


      pak_xslt_log.WriteLog(
        'End inner loop l_offset: '||l_offset||' l_startoffset: '||l_startoffset,
        p_procedure => 'InsertTypeTableAndRegionAttr'
      );


      if nvl(l_offset, 0) = 0 then
        l_buffer := dbms_lob.substr(pio_tempXml, l_initialbuffSize + 1000, l_startoffset);
      else
        l_offset := l_offset - length('<ROW>');
        l_buffer := dbms_lob.substr(pio_tempXml, l_offset - l_startoffset, l_startoffset);
      end if;
      if l_first then
        l_buffer := replace(l_buffer, '<ROWSET>', '<ROWSET '||p_regionAttr||'>');
      end if;


      pak_xslt_log.WriteLog(
        'p_reportTypes.count = '||p_reportTypes.count||' in buffer (first 200 ch): '||substr(l_buffer, 1, 200),
        p_procedure => 'InsertTypeTableAndRegionAttr'
      );

      open c_cur for
      select nvl(r.col, t.colname), t.coltype, t.formatmask, t.columnwidth, t.fullname, t.position, t.excelcol from table(p_reportTypes) t
      left outer join table(l_elementRealNames) r on ConvertXmlName2ColName(r.col) = ConvertXmlName2ColName(t.colname);

      loop
        fetch c_cur into l_colname, l_coltype, l_formatmask, l_width, l_fullname, l_position, l_excelcol;
        exit when c_cur%notfound;
        --l_correctedReportTypes.extend;
        --l_correctedReportTypes(l_correctedReportTypes.count) := t_coltype_row(l_colname, l_coltype, l_formatmask, l_fullname);

        pak_xslt_log.WriteLog(
          'First replacing '||'<'||l_colname||'> with '||
          '<'||l_colname||' TYPE="'||l_coltype||'" '||
          case when l_formatmask is not null then 'FORMAT_MASK="'||l_formatmask||'" ' end||
          case when l_width is not null then 'COLUMN_WIDTH="'||l_width||'" ' end||
          case when l_position is not null then 'POSITION="'||l_position||'" ' end||
          case when l_excelcol is not null then 'EXCELCOL="'||l_excelcol||'" ' end||










          case when BreakOnCol(p_regionAttr, l_colname) then 'BREAK="1" ' end||
          'FULL_NAME="'||replace(l_fullname,'_',' ')||'">',
          p_procedure => 'InsertTypeTableAndRegionAttr'
        );

        l_buffer := replace(l_buffer, '<'||l_colname||'>',
          '<'||l_colname||' TYPE="'||l_coltype||'" '||
          case when l_formatmask is not null then 'FORMAT_MASK="'||l_formatmask||'" ' end||
          case when l_width is not null then 'COLUMN_WIDTH="'||l_width||'" ' end||
          case when l_position is not null then 'POSITION="'||l_position||'" ' end||
          case when l_excelcol is not null then 'EXCELCOL="'||l_excelcol||'" ' end||








          case when BreakOnCol(p_regionAttr, l_colname) then 'BREAK="1" ' end||
          'FULL_NAME="'||replace(l_fullname,'_',' ')||'">');

        pak_xslt_log.WriteLog(
          'replaced OK ',
          p_procedure => 'InsertTypeTableAndRegionAttr'
        );

        pak_xslt_log.WriteLog(
          'Second replacing '||'<'||l_colname||'> with '||
          '<'||l_colname||' TYPE="'||l_coltype||'" '||
          case when l_formatmask is not null then 'FORMAT_MASK="'||l_formatmask||'" ' end||
          case when l_width is not null then 'COLUMN_WIDTH="'||l_width||'" ' end||
          case when l_position is not null then 'POSITION="'||l_position||'" ' end||
          case when l_excelcol is not null then 'EXCELCOL="'||l_excelcol||'" ' end||












          case when BreakOnCol(p_regionAttr, l_colname) then 'BREAK="1" ' end||
          'FULL_NAME="'||replace(l_fullname,'_',' ')||'">',
          p_procedure => 'InsertTypeTableAndRegionAttr'
        );

        l_buffer := replace(l_buffer, '<'||l_colname||'/>',
          '<'||l_colname||' TYPE="'||l_coltype||'" '||
          case when l_formatmask is not null then 'FORMAT_MASK="'||l_formatmask||'" ' end||
          case when l_width is not null then 'COLUMN_WIDTH="'||l_width||'" ' end||
          case when l_position is not null then 'POSITION="'||l_position||'" ' end||
          case when l_excelcol is not null then 'EXCELCOL="'||l_excelcol||'" ' end||






          case when BreakOnCol(p_regionAttr, l_colname) then 'BREAK="1" ' end||
          'FULL_NAME="'||replace(l_fullname,'_',' ')||'"/>');

        pak_xslt_log.WriteLog(
          'replaced OK ',
          p_procedure => 'InsertTypeTableAndRegionAttr'
        );

        i := i + 1;
      end loop;
      close c_cur;


      pak_xslt_log.WriteLog(
        'out buffer (first 200 ch): '||substr(l_buffer, 1, 200),
        p_procedure => 'InsertTypeTableAndRegionAttr'
      );

      dbms_lob.writeappend(l_destXML, length(l_buffer), l_buffer);


      l_first:= false;
    end loop;
    ----dbms_xslprocessor.clob2file(l_destXML, 'XMLDIR', 'debug2.xml');
    dbms_lob.trim(pio_tempXml, 0);
    dbms_lob.copy(pio_tempXml, l_destXML, dbms_lob.getlength(l_destXML));
    ----dbms_xslprocessor.clob2file(pio_tempXml, 'XMLDIR', 'debug3.xml');
    dbms_lob.freetemporary(l_destXML);

  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'InsertTypeTableAndRegionAttr',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
*/

procedure AddXmlChunk
(
  pio_xml in out nocopy clob
  ,pi_regionAttr in varchar2
  ,pi_selectQuery  IN varchar2
  ,pio_reportTypes IN OUT t_coltype_table
  ,pi_max_rows  IN PLS_INTEGER
)
as
l_temp CLOB;
l_erase number;
l_erase_string constant varchar2(40) := '<?xml version="1.0"?>';
l_empty_region constant varchar2(4000) := '<ROWSET '||pi_regionAttr||'></ROWSET>';
l_plsql varchar2(32000);
l_licence_key varchar2(20);
l_coded varchar2(4000);
l_offset number;
ctx DBMS_XMLGEN.ctxHandle;


l_region_src varchar2(32000);
l_start_region_src number;
l_end_region_src number;




--l_ret_xml CLOB;
begin
    pak_xslt_log.WriteLog(
      'Start procedure pio_regionAttr: '||pi_regionAttr||' pio_reportTypes.count: '||pio_reportTypes.count,
      p_procedure => 'AddXmlChunk(varchar2)'
    );

    if pi_selectQuery is null then
      pak_xslt_log.WriteLog(
        'pi_selectQuery is null',
        p_procedure => 'AddXmlChunk(varchar2)'
      );
    else
      pak_xslt_log.WriteLog(
        'pi_selectQuery '||pi_selectQuery,
        p_procedure => 'AddXmlChunk(varchar2)'
      );

    end if;

    if pi_regionAttr is null then
      pak_xslt_log.WriteLog(
        'pio_regionAttr is null',
        p_procedure => 'AddXmlChunk(varchar2)'
      );
    else
      pak_xslt_log.WriteLog(
        'pi_regionAttr '||pi_regionAttr,
        p_procedure => 'AddXmlChunk(varchar2)'
      );
    end if;

    /* Za dat v EXECUTE immediate*/
    BEGIN
        ctx := DBMS_XMLGEN.NEWCONTEXT(pi_selectQuery);


        /*
        if IsFullVersion then --FULL
          DBMS_XMLGEN.SETMAXROWS (ctx, pi_max_rows); --TODO trial set to max 20
          --DBMS_XMLGEN.SETMAXROWS (ctx, 5);
        else                            --TRIAL
          DBMS_XMLGEN.SETMAXROWS (ctx, least(pi_max_rows,20));
        end if;
        */


        DBMS_XMLGEN.SETMAXROWS (ctx, pi_max_rows);
        DBMS_XMLGEN.SETROWSETTAG (ctx, 'ROWSET');
        DBMS_XMLGEN.SETROWTAG(ctx, 'ROW');
        DBMS_XMLGEN.SETNULLHANDLING(ctx, DBMS_XMLGEN.EMPTY_TAG);
        --DBMS_XMLGEN.GETXML (ctx, l_xml);
        -- napiL?i prva dva tag-a
        pak_xslt_log.WriteLog(
          'Start DBMS_XMLGEN.GETXML pi_max_rows: '||pi_max_rows,
          p_procedure => 'AddXmlChunk(varchar2)'
        );
        l_temp:= DBMS_XMLGEN.GETXML (ctx);
      exception
        when others then
          pak_xslt_log.WriteLog(
            'Select statement is not properly composed. Statement: '||pi_selectQuery,
            p_log_type => pak_xslt_log.g_error,
            p_procedure => 'AddXmlChunk(varchar2)',
            p_sqlerrm => sqlerrm
          );
          l_start_region_src := instr(pi_selectQuery, APEXREP2REPORT.g_start_region_src);
          l_end_region_src   := instr(pi_selectQuery, APEXREP2REPORT.g_end_region_src);
          if l_start_region_src > 0 and l_end_region_src > 0 then
              l_region_src := substr(pi_selectQuery, l_start_region_src + length(APEXREP2REPORT.g_start_region_src),
                                     l_end_region_src - l_start_region_src - length(APEXREP2REPORT.g_start_region_src) - 1);
              pak_xslt_log.WriteLog(
                'Trying with region select: '||l_region_src,
                p_log_type => pak_xslt_log.g_warning,
                p_procedure => 'AddXmlChunk(varchar2)'
              );
              ctx := DBMS_XMLGEN.NEWCONTEXT(l_region_src);
              DBMS_XMLGEN.SETMAXROWS (ctx, pi_max_rows);
              DBMS_XMLGEN.SETROWSETTAG (ctx, 'ROWSET');
              DBMS_XMLGEN.SETROWTAG(ctx, 'ROW');
              DBMS_XMLGEN.SETNULLHANDLING(ctx, DBMS_XMLGEN.EMPTY_TAG);
              --DBMS_XMLGEN.GETXML (ctx, l_xml);
              -- napiL?i prva dva tag-a
              pak_xslt_log.WriteLog(
                  'Start DBMS_XMLGEN.GETXML with region source. pi_max_rows: '||pi_max_rows,
                  p_procedure => 'AddXmlChunk(varchar2)'
              );
              l_temp:= DBMS_XMLGEN.GETXML (ctx);
          else
              raise;
          end if;
    END;










    pak_xslt_log.WriteLog(
      'Stop DBMS_XMLGEN.GETXML',
      p_procedure => 'AddXmlChunk(varchar2)'
    );

    /*konec bloka za EXECUTE immediate*/

    /*produkcijska nastavitev*/
    --EXECUTE IMMEDIATE DecPlSql(Query2Report.g_SelectEnc, null) into l_licence_key, l_coded;

    --test
    /*
    select swkey, coded into l_licence_key, l_coded from xsltswkey;

    l_plsql := DecPlSql(l_coded, l_licence_key);

    pak_xslt_log.WriteLog(
        'pi_selectQuery:'||pi_selectQuery,
        p_procedure => 'AddXmlChunk(varchar2)'
      );

    EXECUTE IMMEDIATE l_plsql USING IN pi_selectQuery, IN pi_max_rows, OUT l_temp;
*/
    if l_temp is null then
      dbms_lob.writeappend(pio_xml, length(l_empty_region),l_empty_region);
      pak_xslt_log.WriteLog(
        'Empty region pi_regionAttr '||pi_regionAttr,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'AddXmlChunk(varchar2)'
      );

    else
      --l_temp is not null
      ----dbms_xslprocessor.clob2file(l_temp, 'XMLDIR', 'debug1.xml');
      pak_xslt_log.WriteLog(
        'Before InsertTypeTableAndRegionAttr l_region_src: '||l_region_src||' pio_reportTypes.count: '||pio_reportTypes.count||' pi_selectQuery '||pi_selectQuery,
        p_procedure => 'AddXmlChunk(varchar2)'
      );

      if l_region_src is null then
          if nvl(pio_reportTypes.count, 0) = 0 then
              --InsertTypeTableAndRegionAttr(l_temp, ReportTypesElementTab(pi_selectQuery), pi_regionAttr); --not apex report, just select statement
              pio_reportTypes := ReportTypesElementTab(pi_selectQuery);
          else
              --InsertTypeTableAndRegionAttr(l_temp, pi_reportTypes, pi_regionAttr); --apex report
              null;
          end if;
      else
          --InsertTypeTableAndRegionAttr(l_temp, ReportTypesElementTab(l_region_src), pi_regionAttr); --select statement not properly composed, just region source query
          pio_reportTypes := ReportTypesElementTab(l_region_src);
      end if;

      --pak_blob_util.clobReplaceAll(l_temp, '<ROWSET>', '<ROWSET>'||OraTypesElement(pi_selectQuery)); --adding ora_types info
      --pak_blob_util.clobReplaceAll(l_temp, '<ROWSET>', '<ROWSET '||pi_regionAttr||'>'); --adding attribute

       ----dbms_xslprocessor.clob2file(l_temp, 'XMLDIR', 'debug2.xml');
      pak_xslt_log.WriteLog(
        'DBMS_XMLGEN.GETXML l_temp size '||to_char(dbms_lob.getlength(l_temp)),
        p_procedure => 'AddXmlChunk(varchar2)'
      );

      l_erase := lengthb(l_erase_string);
      DBMS_LOB.ERASE(l_temp, l_erase);
      pak_xslt_log.WriteLog(
        'Start DBMS_LOB.APPEND',
        p_procedure => 'AddXmlChunk(varchar2)'
      );

      DBMS_LOB.APPEND(pio_xml, l_temp);
      pak_xslt_log.WriteLog(
        'DBMS_LOB.APPEND',
        p_procedure => 'AddXmlChunk(varchar2)'
      );

      /*
      l_start_name := instr(pi_regionAttr, 'name="');
      l_start_name := l_start_name + length('name="');
      l_end_name := instr(pi_regionAttr, '"', l_start_name);
      l_name := substr(pi_regionAttr, l_start_name, l_end_name - l_start_name);
      ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug'||l_name||'.xml');
      */
      DBMS_LOB.FREETEMPORARY (l_temp);
      pak_xslt_log.WriteLog(
        'DBMS_LOB.FREETEMPORARY',
        p_procedure => 'AddXmlChunk(varchar2)'
      );
      ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug1.xml');
    end if;
  exception
    when others then
      pak_xslt_log.WriteLog(
        'Error',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'AddXmlChunk(varchar2)',
        p_sqlerrm => sqlerrm
      );
      raise;
end AddXmlChunk;

procedure AddXmlChunk
(
  pio_xml in out nocopy clob
  ,pi_regionAttr in varchar2
  ,pi_selectQuery  IN SYS_REFCURSOR
  ,pi_reportTypes IN t_coltype_table
  ,pi_max_rows  IN PLS_INTEGER
) as
l_temp CLOB;
l_erase number;
l_erase_string constant varchar2(40) := '<?xml version="1.0"?>';
l_empty_region constant varchar2(4000) := '<ROWSET '||pi_regionAttr||'></ROWSET>';
l_licence_key varchar2(20);
l_coded varchar2(4000);
l_plsql varchar2(32000);
l_offset number;

/*
l_start_string constant varchar2(40) := '<?xml version="1.0"?>'||ascii(10)||'<DOCUMENT>';
l_end_string constant varchar2(40) := '</DOCUMENT>';
l_erase_string constant varchar2(40) := '<?xml version="1.0"?>';
*/
--l_ret_xml CLOB;
begin
     pak_xslt_log.WriteLog(
      'Start procedure',
      p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
    );

    /*produkcijska nastavitev*/
    --EXECUTE IMMEDIATE DecPlSql(Query2Report.g_SelectEnc,null) into l_licence_key, l_coded;

    --test
    select swkey, coded into l_licence_key, l_coded from xsltswkey;

    l_plsql := DecPlSql(l_coded, l_licence_key);

    EXECUTE IMMEDIATE l_plsql USING IN pi_selectQuery, IN pi_max_rows, OUT l_temp;

    /*
    DBMS_XMLGEN.SETROWSETTAG (ctx, 'ROWSET');--pi_regionAttr);
    DBMS_XMLGEN.SETROWTAG(ctx, 'ROW'); --pi_regionAttr||'_ROW');
    DBMS_XMLGEN.SETNULLHANDLING(ctx, DBMS_XMLGEN.EMPTY_TAG);
    --DBMS_XMLGEN.GETXML (ctx, l_xml);
    -- napiL?i prva dva tag-a
    pak_xslt_log.WriteLog(
      'Start DBMS_XMLGEN.GETXML',
      p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
    );
    l_temp:= DBMS_XMLGEN.GETXML (ctx);
    */

    if l_temp is null then
      dbms_lob.writeappend(pio_xml, length(l_empty_region),l_empty_region);
      pak_xslt_log.WriteLog(
        'Empty region pi_regionAttr '||pi_regionAttr,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
      );
    else
      pak_xslt_log.WriteLog(
        'Before InsertTypeTableAndRegionAttr pi_reportTypes.count: '||pi_reportTypes.count,
        p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
      );

      --InsertTypeTableAndRegionAttr(l_temp, pi_reportTypes, pi_regionAttr);

      pak_xslt_log.WriteLog(
        'Start DBMS_XMLGEN.GETXML',
        p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
      );
      l_erase := lengthb(l_erase_string);
      DBMS_LOB.ERASE(l_temp, l_erase);

      pak_xslt_log.WriteLog(
        'Start Append',
        p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
      );
      DBMS_LOB.APPEND(pio_xml, l_temp);
      pak_xslt_log.WriteLog(
        'Append',
        p_procedure => 'AddXmlChunk(SYS_REFCURSOR)'
      );
      DBMS_LOB.FREETEMPORARY (l_temp);
      ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug1.xml');
    end if;

exception
    when others then
      pak_xslt_log.WriteLog(
        'Error',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'AddXmlChunk(SYS_REFCURSOR)',
        p_sqlerrm => sqlerrm
      );
      raise;
end AddXmlChunk;


function Query2Xml
(
  pi_regionAttrs in tab_string
  ,pi_selectQueries   IN tab_string
  ,pi_reportTypes     IN OUT t_coltype_tables
  ,pi_max_rows        in tab_integer

) return clob as
l_tbl_count number;
l_xml CLOB;
l_licence_key varchar2(20);
l_coded varchar2(4000);

begin
  l_tbl_count := least(pi_selectQueries.count, pi_regionAttrs.count);
  --DBMS_LOB.OPEN (l_xml, DBMS_LOB.LOB_READWRITE);
  pak_xslt_log.WriteLog(
    'Start procedure',
    p_procedure => 'Query2Xml(tab_string)'
  );
  StartXml(l_xml);
  pak_xslt_log.WriteLog(
    'StartXml',
    p_procedure => 'Query2Xml(tab_string)'
  );

  for i in 1..l_tbl_count loop
    pak_xslt_log.WriteLog(
      'Loop Start AddXmlChunk '||to_char(i),
      p_procedure => 'Query2Xml(tab_string)'
    );
    AddXmlChunk(l_xml, pi_regionAttrs(i), pi_selectQueries(i), pi_reportTypes(i), pi_max_rows(i));

    ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug2.xml');

    pak_xslt_log.WriteLog(
      'Loop End AddXmlChunk '||to_char(i),
      p_procedure => 'Query2Xml(tab_string)'
    );
  end loop;

  EndXml(l_xml);

  ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug3.xml');

  pak_xslt_log.WriteLog(
    'EndXml',
    p_procedure => 'Query2Xml(tab_string)'
  );

  return l_xml;
  exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Xml(tab_string)',
    p_sqlerrm => sqlerrm
  );
  raise;
end Query2Xml;



procedure AddIntegerToTable
(
  pi_integer IN varchar2
  ,pio_integerTable IN OUT tab_integer
)
as
begin
  pio_integerTable.extend;
  pio_integerTable(pio_integerTable.count) := pi_integer;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'AddIntegerToTable',
    p_sqlerrm => sqlerrm
  );
  raise;
end AddIntegerToTable;


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
)
as
begin
  if pi_regionAttr is not null and pi_selectQuery is not null then
    AddStringToTable(pi_selectQuery, pio_selectQueries);
    AddTableToTables(pi_reportTypes, pio_reportTypes);
    AddStringToTable(pi_regionAttr, pio_regionAttrs);
    AddIntegerToTable(nvl(pi_maxRows, 100000), pio_maxRows);
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'AddQuery',
    p_sqlerrm => sqlerrm
  );
  raise;
end AddQuery;



function Query2Xml
(
  pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_reportTypes1   IN t_coltype_table default null
  ,pi_maxRows1       IN PLS_INTEGER default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_reportTypes2   IN t_coltype_table default null
  ,pi_maxRows2       IN PLS_INTEGER default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_reportTypes3   IN t_coltype_table default null
  ,pi_maxRows3       IN PLS_INTEGER default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_reportTypes4   IN t_coltype_table default null
  ,pi_maxRows4       IN PLS_INTEGER default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_reportTypes5   IN t_coltype_table default null
  ,pi_maxRows5       IN PLS_INTEGER default 20
) return clob as
l_regionAttrs tab_string := tab_string();
l_selectQueries  tab_string := tab_string();
l_reportTypes    t_coltype_tables := t_coltype_tables();
l_maxRows        tab_integer := tab_integer();

begin
  AddQuery(pi_regionAttr1, pi_selectQuery1, pi_reportTypes1, pi_maxRows1, l_regionAttrs, l_selectQueries, l_reportTypes, l_maxRows);
  AddQuery(pi_regionAttr2, pi_selectQuery2, pi_reportTypes2, pi_maxRows2, l_regionAttrs, l_selectQueries, l_reportTypes, l_maxRows);
  AddQuery(pi_regionAttr3, pi_selectQuery3, pi_reportTypes3, pi_maxRows3, l_regionAttrs, l_selectQueries, l_reportTypes, l_maxRows);
  AddQuery(pi_regionAttr4, pi_selectQuery4, pi_reportTypes4, pi_maxRows4, l_regionAttrs, l_selectQueries, l_reportTypes, l_maxRows);
  AddQuery(pi_regionAttr5, pi_selectQuery5, pi_reportTypes5, pi_maxRows5, l_regionAttrs, l_selectQueries, l_reportTypes, l_maxRows);

  return Query2Xml(l_regionAttrs, l_selectQueries, l_reportTypes, l_maxRows);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Xml(varchar2)',
    p_sqlerrm => sqlerrm
  );
  raise;

end Query2Xml;

function Query2Xml
(
   pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_reportTypes1   IN OUT t_coltype_table
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_reportTypes2   IN OUT t_coltype_table
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_reportTypes3   IN OUT t_coltype_table
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_reportTypes4   IN OUT t_coltype_table
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_reportTypes5   IN OUT t_coltype_table
  ,pi_maxRows5       IN pls_integer default 20
) return clob as
l_xml CLOB;
begin
  StartXml(l_xml);
  if pi_regionAttr1 is not null and pi_selectQuery1 is not null then
     AddXmlChunk(l_xml, pi_regionAttr1, pi_selectQuery1, pi_reportTypes1, pi_maxRows1);
  end if;
  if pi_regionAttr2 is not null and pi_selectQuery2 is not null then
     AddXmlChunk(l_xml, pi_regionAttr2, pi_selectQuery2, pi_reportTypes2, pi_maxRows2);
  end if;
  if pi_regionAttr3 is not null and pi_selectQuery3 is not null then
     AddXmlChunk(l_xml, pi_regionAttr3, pi_selectQuery3, pi_reportTypes3, pi_maxRows3);
  end if;
  if pi_regionAttr4 is not null and pi_selectQuery4 is not null then
     AddXmlChunk(l_xml, pi_regionAttr4, pi_selectQuery4, pi_reportTypes4, pi_maxRows4);
  end if;
  if pi_regionAttr5 is not null and pi_selectQuery5 is not null then
     AddXmlChunk(l_xml, pi_regionAttr5, pi_selectQuery5, pi_reportTypes5, pi_maxRows5);
  end if;

  ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug2.xml');
  EndXml(l_xml);
  ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug3.xml');


  return l_xml;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Xml (SYS_REFCURSOR)',
    p_sqlerrm => sqlerrm
  );
  raise;
end Query2Xml;

procedure FormatCorrection(
  pio_clob IN OUT NOCOPY CLOB,
  p_format number
)
as
begin
  if p_format = F_MHT then
    mhtCorrections(pio_clob);
  /* commented because of really bad performance
  elsif p_format in (F_HTML, F_XML) then
    pak_blob_util.clobReplaceAll(pio_clob, '><','>'||chr(13)||chr(10)||'<');
  elsif p_format = F_RTF then
    pak_blob_util.clobReplaceAll(pio_clob, '}{','}'||chr(13)||chr(10)||'{');
  */
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'FormatCorrection',
    p_sqlerrm => sqlerrm
  );
  raise;
end FormatCorrection;

 function OOXMLFilename(p_filename varchar2)
 return boolean
 as
 begin
  return upper(substr(p_filename, nullif( instr(p_filename,'.', -1) +1, 1))) in ('DOCX', 'XLSX', 'PPTX');
 end;

/** Return otput of XSLT transformation (working function)
  *
  * @param p_Xml input XML
  * @param p_Xslt XSLT transformation
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to f_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
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
) return BLOB
as

retBlob     BLOB;

    begin
        retBlob := pak_xsltprocessor.Transform(p_Xml, p_Xslt, p_external_params, po_error);
        if p_format = f_ooxml and retBlob is not null and p_template is not null and po_error is null then
            retBlob := FLAT_OPC_PKG.FlatOPC2OOXML(pak_blob_util.blob2clob(retBlob), p_template);
        end if;
  return retBlob;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - function with XSLT BLOB',
    P_SQLERRM => sqlerrm
  );

  raise;
end XslTransform;






$if CCOMPILING.g_utl_file_privilege $then
/** Return otput of XSLT transformation
  *
  * @param p_Xml input XML
  * @param p_xsltDir ORA Directory of XSLT file
  * @param p_xsltFile Filename of XSLT file
  * @param P_NLS_CHARSET Charset of XSLT file (e.g. 'EE8MSWIN1250' for windows-1250)
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to g_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
  * @param p_template  Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
function XslTransform
(
p_Xml             IN    CLOB,
p_xsltDir         IN    varchar2,
p_xsltFile        IN    varchar2,
p_format          IN    number,
po_error          OUT   VARCHAR2,
p_Template          IN    CLOB, -- default null,
P_NLS_CHARSET     IN    VARCHAR2 default null,
p_external_params IN    varchar2 default null
) return BLOB
as

l_Xslt        CLOB;

begin
  l_Xslt := pak_blob_util.READ2CLOB(p_xsltDir, p_xsltFile, P_NLS_CHARSET);
  return XslTransform(
    p_Xml => p_Xml,
    p_Xslt => l_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params
  );

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - function with XSLT file',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
$END

/** Return otput of XSLT transformation. Replacement from Print Settings are made in XSLT prior to transformation.
  *
  * @param p_Xml input XML
  * @param p_Xslt input XSLT
  * @param p_app_id application ID from where Print Settings are read,
  * @param p_page_id page ID from where Print Settings are read,
  * @param p_region_name region name from where Print Settings are read,
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_error Outputs false if there is a problem on print server side.
  * @param p_template static OOXML template,
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
function XslTransformApex
(
p_Xml                   IN    CLOB,
p_Xslt                  IN OUT  CLOB,
p_app_id                IN    number,
p_page_id               IN    number,
p_region_name           IN    varchar2,
p_format                IN    number,  --default F_TEXT,
p_fileext               IN    varchar2, --docx, xlsx,..
po_error                OUT   VARCHAR2,
p_template              IN OUT CLOB, --default null,
p_external_params       IN    varchar2 default null
) return BLOB
as
begin
  pak_xslt_replacestr.SmartReplaceReportAttr(p_Xslt, p_app_id, p_page_id, p_region_name, p_format, p_fileext);
  pak_xslt_replacestr.SmartReplaceReportAttr(p_template, p_app_id, p_page_id, p_region_name, p_format, p_fileext);
  ----dbms_xslprocessor.clob2file(p_Xslt, 'XMLDIR', 'APEX_standard_layout_replaced.xslt');

  return XslTransform(
    p_Xml => p_Xml,
    p_Xslt => p_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params
  );

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformApex (CLOB)',
    P_SQLERRM => sqlerrm
  );
  raise;
end;



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
)

as

l_Xml         CLOB;
l_Xslt        CLOB;
l_template    CLOB;
l_out         BLOB;
l_fileext varchar2(10);

begin
  l_fileext := lower(substr(p_outFile, nullif( instr(p_outFile,'.', -1) +1, 1) ));
  l_Xml := pak_blob_util.READ2CLOB(p_xmlDir, p_xmlFile);
  l_Xslt := pak_blob_util.READ2CLOB(p_xsltDir, p_xsltFile);
  if p_templateDir is not null and p_templateFile is not null then
    l_template := pak_blob_util.READ2CLOB(p_templateDir, p_templateFile);
  end if;

  pak_xslt_replacestr.SmartReplaceReportAttr(l_Xslt, p_app_id, p_page_id, p_region_name, p_format, l_fileext);
  dbms_xslprocessor.clob2file(l_Xslt, p_xsltDir, p_xsltReplacedFile);
  if p_templateDir is not null and p_templateFile is not null then
      pak_xslt_replacestr.SmartReplaceReportAttr(l_template, p_app_id, p_page_id, p_region_name, p_format, l_fileext);
      dbms_xslprocessor.clob2file(l_template, p_templateDir, p_templateReplacedFile);
  end if;

  l_out := XslTransform(
    p_Xml => l_Xml,
    p_Xslt => l_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => l_template,
    p_external_params => p_external_params
  );

  pak_blob_util.Blob2File(p_outDir, p_outFile, l_out);

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformApex (file)',
    P_SQLERRM => sqlerrm
  );
  raise;
end;
$end

/** Return otput of XSLT transformation
  *
  * @param p_Xml input XML
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_page_id page ID from where Print Settings are read,
  * @param p_region_name region name from where Print Settings are read,
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_fileext File extension. E.g. xslx, docx
  * @param po_error Outputs false if there is a problem on print server side.
  * @param p_templateStaticFile Filename of APEX static file with static OOXML template,
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
function XslTransformApex
(
  p_Xml                   IN    CLOB,
  p_xsltStaticFile        IN    varchar2,
  p_page_id               IN    number,
  p_region_name           IN    varchar2,
  po_file_csid            OUT   number,
  p_format                IN    number,  --default F_TEXT,
  p_fileext               IN    varchar2,
  po_error                OUT   VARCHAR2,
  p_templateStaticFile    IN    varchar2, --default null,
  p_external_params       IN    varchar2 default null
) return BLOB
as

l_Xslt        CLOB;
l_template    CLOB;

begin
  l_Xslt := pak_blob_util.StaticFile2CLOB(p_xsltStaticFile, po_file_csid);
  ----dbms_xslprocessor.clob2file(l_Xslt, 'XMLDIR', 'APEX_standard_layout_replaced.xslt');
  if p_templateStaticFile is not null then
    l_template := pak_blob_util.StaticFile2CLOB(p_templateStaticFile, po_file_csid);
  end if;

  return XslTransformApex
  (
    p_Xml => p_Xml,
    p_Xslt => l_Xslt,
    p_app_id => V('APP_ID'),
    p_page_id => p_page_id,
    p_region_name => p_region_name,
    p_format => p_format,  --default F_TEXT,
    p_fileext => p_fileext,
    po_error => po_error,
    p_template => l_template, --default null,
    p_external_params => p_external_params
  );

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformApex',
    P_SQLERRM => sqlerrm
  );
  raise;
end;


$if CCOMPILING.g_utl_file_privilege $then
/** Return otput of XSLT transformation
  *
  * @param p_Xml input XML
  * @param p_xsltDir ORA Directory of XSLT file
  * @param p_xsltFile Filename of XSLT file
  * @param p_out_dir ORA Directory of output file
  * @param p_out_fileName Filename of output file
  * @param p_TemplateDir Oracle server directory of Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_TemplateFile Template filename in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param P_NLS_CHARSET Charset of XSLT file (e.g. 'EE8MSWIN1250' for windows-1250)
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
Procedure XslTransform
(
p_Xml                   IN    CLOB,
p_xsltDir               IN    varchar2,
p_xsltFile              IN    varchar2,
p_out_dir               IN    VARCHAR2,
p_out_fileName          IN    VARCHAR2,
p_format                IN    number, --default F_TEXT,
p_TemplateDir           IN    VARCHAR2, -- default null,
p_TemplateFile          IN    VARCHAR2, -- default null,
P_NLS_CHARSET           IN    VARCHAR2 default null,
p_external_params       IN    varchar2 default null
) as

/*
p           DBMS_XSLPROCESSOR.Processor;
ss          DBMS_XSLPROCESSOR.Stylesheet;
xmldoc      DBMS_XMLDOM.DOMDOCUMENT;
Xslt        CLOB;
xsltDoc     DBMS_XMLDOM.DOMDOCUMENT;
*/
l_output    BLOB;
--l_OOXML     BLOB;
l_length    number;
l_error     VARCHAR2(4000);

begin
  DBMS_LOB.CREATETEMPORARY(l_output, false);
  l_output := XslTransform(
    p_Xml => p_Xml,
    p_xsltDir => p_xsltDir,
    p_xsltFile => p_xsltFile,
    p_format => p_format,
    po_error => l_error,
    p_Template => pak_blob_util.READ2CLOB(p_TemplateDir, p_TemplateFile, nvl(NLS_CHARSET_ID(P_NLS_CHARSET), 0)),
    P_NLS_CHARSET => P_NLS_CHARSET,
    p_external_params => p_external_params
  );


  if l_output is null then
    pak_xslt_log.WriteLog(
      'XslTransform finished output null',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'XslTransform - XML as CLOB'
    );
  else
    l_length := dbms_lob.getlength(l_output);
    if l_length = 0 then
      pak_xslt_log.WriteLog(
        'XslTransform finished output zero length',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'XslTransform - XML as CLOB'
      );
    else
      pak_xslt_log.WriteLog(
        'XslTransform finished OK output CLOB length '||to_char(l_length),
        p_procedure => 'XslTransform - XML as CLOB'
      );
    end if;
  end if;

  pak_blob_util.Blob2File(p_out_dir, p_out_fileName, l_output);

  /*
  if l_OOXML is not null then
    pak_blob_util.Blob2File(p_out_dir, p_out_fileName, l_OOXML);
  else
    --dbms_xslprocessor.clob2file(l_output, p_out_dir, p_out_fileName, nvl(NLS_CHARSET_ID(P_NLS_CHARSET), 0));
  end if;
  */

  ----dbms_xslprocessor.clob2file(l_output, p_out_dir, p_out_fileName||'.xml', nvl(NLS_CHARSET_ID(P_NLS_CHARSET), 0));
  pak_xslt_log.WriteLog(
      'dbms_xslprocessor.clob2file finished OK',
      p_procedure => 'XslTransform - XML as CLOB'
    );
  DBMS_LOB.FREETEMPORARY(l_output);
exception
  when others then
  DBMS_LOB.FREETEMPORARY(l_output);
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - XML as CLOB',
    P_SQLERRM => sqlerrm
  );
  raise;
end XslTransform;
$end



--vrne konÄTnico (doc, txt,.. )
  function GetFileType(
    P_FILENAME VARCHAR2
  )
  return varchar2
  AS
  l_ret varchar2(20);
  l_pos number;
  BEGIN

    l_pos := INSTR(P_FILENAME, '.', -1, 1);
    if l_pos > 0 then
      l_ret := lower(SUBSTR(P_FILENAME, l_pos + 1));
    end if;

    return l_ret;
  end;

  function GetMimeType(
    P_FILENAME VARCHAR2
  )
  return varchar2
  AS
  BEGIN

    return
    case GetFileType(P_FILENAME)
      when 'doc'  then 'application/msword'
      when 'docx' then 'application/msword'
      when 'rtf'  then 'application/rtf'
      when 'xls'  then 'application/excel'
      when 'xlsx' then 'application/excel'
      else 'application/octet'
    end;
  END GetMimeType;


procedure DownloadBlob(
    P_APP_ID IN NUMBER,
    P_BLOB IN OUT BLOB,
    P_FILENAME VARCHAR2,
    P_TEMPORARY boolean default true,
    P_MIMETYPE varchar2 default 'application/octet'
  )
  as
    L_MIMETYPE varchar2(50);
    l_length number;
    l_workspace_id number;
  begin
   apex_application.g_flow_id := P_APP_ID;

    IF NOT nvl(wwv_flow_custom_auth_std.is_session_valid, false) then
      htp.p('Unauthorized access - file will not be downloaded. app_id '||to_char(p_app_id));

      pak_xslt_log.WriteLog(
        'Unauthorized access from : '|| sys_context('userenv','ip_address') ,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'DownloadBlob'
      );

      RETURN;
    END IF;

    L_MIMETYPE := nvl(P_MIMETYPE, getmimetype(p_filename));
    l_length := DBMS_LOB.GETLENGTH(p_Blob);

    --
  -- set up HTTP header
  --
      -- use an NVL around the mime type and
      -- if it is a null set it to application/octect
      -- application/octect may launch a download window from windows

  owa_util.mime_header( nvl(L_MIMETYPE,'application/octet'), FALSE );

  -- set the size so the browser knows how much to download
  htp.p('Content-length: ' || l_length);
  -- the filename will be used by the browser if the users does a save as
  htp.p('Content-Disposition: attachment; filename="'||p_filename||'"');
  -- close the headers
  owa_util.http_header_close;

  -- download the BLOB

  wpg_docload.download_file(p_blob);
  if P_TEMPORARY then
    DBMS_LOB.FREETEMPORARY(p_blob);
  end if;

  pak_xslt_log.WriteLog(
        'Downloaded : '||p_filename||' MIME '||nvl(L_MIMETYPE,'application/octet') ,
        p_procedure => 'DownloadBlob'
  );

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadBlob',
    P_SQLERRM => sqlerrm
  );
  raise;
end;

procedure DownloadConvertOutput
(
P_APP_ID        number
,p_document    BLOB
,p_file_name   VARCHAR2
,p_mime         VARCHAR2 default 'application/octet'
,p_error        VARCHAR2 default null
,p_blob_csid    number default NLS_CHARSET_ID('UTF8')
,p_convertblob boolean default false
,p_convertblob_param varchar2 default null
,P_APP_USER    varchar2 default V('APP_USER')
,P_RUN_IN_BACKGROUND number default 0
)
as
l_binBlob BLOB;
l_warning NUMBER;
l_lang_context number default 0;
l_blob_csid number;
l_src_offset number default 1;
l_dest_offset number default 1;
--l_error varchar(10);
l_convertblob varchar(10);

--l_filetype varchar2(5);

begin
  if p_convertblob = true then
    l_convertblob := 'true';
  elsif  p_convertblob = true then
    l_convertblob := 'false';
  end if;

  /*
  if p_error = true then
    l_error := 'true';
  elsif p_error = false then
    l_error := 'false';
  end if;
  */





















































































  pak_xslt_log.WriteLog(
        'Start P_APP_ID: '||P_APP_ID||' p_document lenght: '||dbms_lob.getlength(p_document)||
        ' p_file_name: ' ||p_file_name||' p_mime '||p_mime||
        ' p_convertblob: '||l_convertblob||' p_error: '||p_error




        --' OOXML length: '||dbms_lob.getlength(p_OOXML),

        ,p_procedure => 'DownloadConvertOutput'
  );


  --l_filetype := upper(substr(p_file_name, nullif( instr(p_file_name,'.', -1) +1, 1) ));
  /*
  if p_OOXML is not null then
    l_binBlob := p_OOXML;
    l_blob_csid := null; --binary ZIP no encoding
  else
    l_binBlob := pak_blob_util.clob2blob(p_document, p_blob_csid);
    l_blob_csid := nvl(p_blob_csid, NLS_CHARSET_ID('UTF8'));
  end if;
  */
  l_binBlob := p_document;
  l_blob_csid := nvl(p_blob_csid, NLS_CHARSET_ID('UTF8'));

  pak_xslt_log.WriteLog(
        'CLOB p_document lenght: '||dbms_lob.getlength(p_document)||
        ' converted to l_binBlob length: '||dbms_lob.getlength(l_binBlob),

        p_procedure => 'DownloadConvertOutput'
  );

  pak_xslt_log.WriteLog(
        'Start ConvertBLOB p_convertblob_param: '||p_convertblob_param||
        ' converted to l_binBlob length: '||dbms_lob.getlength(l_binBlob)||
        ' p_convertblob: '||l_convertblob||' p_error: '||p_error,








        p_procedure => 'DownloadConvertOutput'
  );

  if p_convertblob = true and p_error is null then
    ConvertBLOB(l_binBlob, p_convertblob_param, l_blob_csid, P_APP_USER, P_RUN_IN_BACKGROUND);
  else
      pak_xslt_log.WriteLog(
        'NOT starting ConvertBLOB p_convertblob_param: '||p_convertblob_param||
        ' converted to l_binBlob length: '||dbms_lob.getlength(l_binBlob)||
        ' p_convertblob: '||l_convertblob||' p_error: '||p_error ,
        p_procedure => 'DownloadConvertOutput');
  end if;

  pak_xslt_log.WriteLog(
        'Finish ConverBLOB p_convertblob_param: '||p_convertblob_param||
        ' converted to l_binBlob length: '||dbms_lob.getlength(l_binBlob),

        p_procedure => 'DownloadConvertOutput'
  );

  --DBMS_LOB.FREETEMPORARY(pio_document);
  if l_binBlob is not null then
    --if p_error then
      --DownloadBlob(P_APP_ID, l_binBlob, 'error.txt', p_mimetype => 'text/plain'); --full version
    --else
      DownloadBlob(P_APP_ID, l_binBlob, p_file_name, p_mimetype => p_mime);
    --end if;
  end if;


exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadConvertOutput',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

procedure DownloadStaticFile(
  p_staticFile            IN  varchar2,
  p_mime                 in  VARCHAR2 default 'application/octet'
)
as
l_file_id number;
l_apex_ver varchar2(10);
begin
  SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)
  into l_apex_ver
  FROM apex_release;

  select id into l_file_id
  from wwv_flow_files
  where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1') and filename = p_staticFile;

  apex_util.get_file(l_file_id, p_mime);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadStaticFile',
    p_sqlerrm => sqlerrm
  );
  raise;
end;




$if CCOMPILING.g_utl_file_privilege $then
/** Return otput of XSLT transformation
  *
  * @param p_xmlDir ORA Directory of input XML
  * @param p_xmlFname input XML filename
  * @param p_xsltDir ORA Directory of XSLT file
  * @param p_xsltFile Filename of XSLT file
  * @param p_out_dir ORA Directory of output file
  * @param p_out_fileName Filename of output file
  * @param P_NLS_CHARSET Charset of XSLT file (e.g. 'EE8MSWIN1250' for windows-1250)
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @return output of XSLT transformation on input XML
  */
Procedure XslTransform
(
p_xmlDir          IN  VARCHAR2,
p_xmlFname        IN  VARCHAR2,
p_xsltDir         IN  varchar2,
p_xsltFname       IN  varchar2,
p_outDir          IN  VARCHAR2,
p_outFname        IN  VARCHAR2,
P_NLS_CHARSET     IN  VARCHAR2 default null,
p_format          IN  number  default F_TEXT,
p_TemplateDir     IN  VARCHAR2 default null,
p_TemplateFile    IN  VARCHAR2 default null,
p_external_params IN    varchar2 default null
) as
l_Xml         CLOB;


begin
--WE8ISO8859P2

  l_Xml := pak_blob_util.READ2CLOB(p_xmlDir, p_xmlFname); --, P_NLS_CHARSET);
  XslTransform
  (
    p_Xml               => l_Xml,
    p_xsltDir           => p_xsltDir,
    p_xsltFile          => p_xsltFname,
    p_out_dir           => p_outDir,
    p_out_fileName      => p_outFname,
    p_format            => p_format, --default F_TEXT,
    p_TemplateDir       => p_TemplateDir, -- default null,
    p_TemplateFile      => p_TemplateFile, -- default null,
    P_NLS_CHARSET       => P_NLS_CHARSET,
    p_external_params   => p_external_params
  );
  dbms_lob.freetemporary(l_Xml);
exception
  when others then
  dbms_lob.freetemporary(l_Xml);
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - XML as file',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransform;
$end

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
) return BLOB
as
l_document  BLOB;
l_error     VARCHAR2(400);
--l_first_document CLOB;
l_file_csid number;
--l_OOXML BLOB;
l_start_time PLS_INTEGER;
l_fileext varchar2(10);

begin

  l_fileext := lower(substr(p_filename, nullif( instr(p_filename,'.', -1) +1, 1) ));

  if p_log_level is not null then
    pak_xslt_log.SetLevel(p_log_level);
  end if;

  if p_security_group_id is not null then
    wwv_flow_api.set_security_group_id(p_security_group_id);
  end if;


  l_start_time := dbms_utility.get_time();
  ----dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug4.xml');
  pak_xml_convert.xmlConvert(p_Xml, p_filename, pi_regionAttrs, pi_reportTypes);--, pio_endOffset => l_offset);
  ----dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug5.xml');
  pak_xslt_log.WriteLog(
    'Query2Report.ConvertXml finished'
    ,p_procedure => 'XslTransform'
    , p_start_time => l_start_time
  );

  l_start_time := dbms_utility.get_time();

  pak_xslt_log.WriteLog( p_description => 'XslTransform started length(p_xml) '||dbms_lob.getlength(p_xml)||
                                ' p_xsltStaticFile: '||p_xsltStaticFile||
                                ' p_page_id: '||p_page_id||
                                ' p_region_name: '||p_region_name||
                                ' p_filename: '||p_filename||
                                --' p_mime: '||p_mime||
                                ' p_format: '||p_format||
                                ' p_external_params: '||p_external_params||
                                ' p_second_XsltStaticFile: '||p_second_XsltStaticFile||
                                ' p_second_external_params: '||p_second_external_params||
                                --' p_convertblob_param: '||p_convertblob_param||
                                ' p_log_level: '||p_log_level--||
                                --' p_security_group_id: '||p_security_group_id||
                                --' P_APP_USER: '||P_APP_USER--||
                                --' P_RUN_IN_BACKGROUND: '||P_RUN_IN_BACKGROUND,
                                ,p_procedure => 'XslTransform'
                              );

  pak_xslt_log.WriteLog( p_description => 'XslTransform started - pi_reportTypes: '||PAK_XML_CONVERT.LogColTypes(pi_reportTypes),
                                p_procedure => 'XslTransform'
                              );

  if p_second_XsltStaticFile is not null then
    l_document := XslTransformApex(
      p_Xml => p_Xml,
      p_xsltStaticFile => p_XsltStaticFile,
      p_page_id => p_page_id,
      p_region_name => p_region_name,
      po_file_csid => l_file_csid,
      p_format => F_XML,
      p_fileext => 'xml',
      po_error => l_error,
      p_templateStaticFile => null, --default null,
      p_external_params => p_external_params
    );


    if l_error is null then
      l_document := XslTransformApex( --first output must be XML
        p_Xml => pak_blob_util.blob2clob(l_document),
        p_xsltStaticFile => p_second_XsltStaticFile,
        p_page_id => p_page_id,
        p_region_name => p_region_name,
        po_file_csid => l_file_csid,
        p_format => p_format,
        p_fileext => l_fileext,
        po_error => l_error,
        p_templateStaticFile => p_templateStaticFile, --default null,
        p_external_params => p_second_external_params
      );
    end if;
  else
    l_document := XslTransformApex(
      p_Xml => p_Xml,
      p_xsltStaticFile => p_XsltStaticFile,
      p_page_id => p_page_id,
      p_region_name => p_region_name,
      po_file_csid => l_file_csid,
      p_format => p_format,
      p_fileext => l_fileext,
      po_error => l_error,
      p_templateStaticFile => p_templateStaticFile, --default null,
      p_external_params => p_external_params
    );
  end if;


  pak_xslt_log.WriteLog( 'XslTransform finished ',
                                p_procedure => 'XslTransform',
                                p_start_time => l_start_time
                              );

   return l_document;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransform;


/** Download otput or do some action  defined in ConvertBlob procedure with otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_Xml input XML
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_TemplateFile Filename of Template uploaded inro static files (in Flat OPC format) from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure.
  * @param p_log_level Log level in job.
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
) as
l_document  BLOB;
l_error     VARCHAR2(400);
l_file_csid number;
l_start_time PLS_INTEGER;

begin

  l_start_time := dbms_utility.get_time();

  l_document :=
    XslTransform
    (
        p_Xml            ,
        p_xsltStaticFile ,
        p_page_id         ,
        p_region_name      ,
        p_filename         ,
        pi_regionAttrs     ,
        pi_reportTypes      ,
        p_format             ,
        p_templateStaticFile  ,
        p_external_params      ,
        p_second_XsltStaticFile ,
        p_second_external_params,
        p_log_level             ,
        p_security_group_id
    );

  DownloadConvertOutput(V('APP_ID'), l_document, p_filename,
              p_error => l_error,
              p_blob_csid => l_file_csid,
              p_mime => p_mime,
              p_convertblob => true,
              p_convertblob_param => p_convertblob_param,
              p_app_user => p_app_user,
              p_run_in_background => p_run_in_background
              );

  pak_xslt_log.WriteLog( 'XslTransformAndDownload finished ',
                                p_procedure => 'XslTransformAndDownload',
                                p_start_time => l_start_time
                              );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownload',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownload;

/** Download otput or do some action  defined in ConvertBlob procedure with otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_id_temporary_xml ID of input XML in temporary_xml table
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_TemplateFile Filename of Template uploaded inro static files (in Flat OPC format) from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure.
  * @param p_log_level Log level in job.
  * See format notes at p_external_params parameter.
  */
Procedure XslTransformAndDownloadXMLID
(
p_id_temporary_xml      IN  NUMBER,
p_xsltStaticFile        IN  varchar2,
p_page_id               IN NUMBER,
p_region_name           IN VARCHAR2,
p_filename              in VARCHAR2,
p_regionAttrs           in VARCHAR2,
p_reportTypes           IN VARCHAR2,
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
) as
l_xmlclob CLOB;
l_start_time PLS_INTEGER;
l_regionAttrs Query2Report.tab_string;
l_reportTypes Query2Report.t_coltype_tables;
begin
  pak_xslt_log.Setlevel(p_log_level);

  l_start_time := dbms_utility.get_time();

  pak_xslt_log.WriteLog( p_description => 'Background XslTransformAndDownloadXMLID started p_id_temporary_xml '||p_id_temporary_xml||
                                ' p_xsltStaticFile: '||p_xsltStaticFile||
                                ' p_page_id: '||p_page_id||
                                ' p_region_name: '||p_region_name||
                                ' p_filename: '||p_filename||
                                ' p_regionAttrs: '||p_regionAttrs||
                                ' p_reportTypes: '||p_reportTypes||
                                ' p_mime: '||p_mime||
                                ' p_format: '||p_format||
                                ' p_external_params: '||p_external_params||
                                ' p_second_XsltStaticFile: '||p_second_XsltStaticFile||
                                ' p_second_external_params: '||p_second_external_params||
                                ' p_convertblob_param: '||p_convertblob_param||
                                ' p_log_level: '||p_log_level||
                                ' p_security_group_id: '||p_security_group_id||
                                ' P_APP_USER: '||P_APP_USER||
                                ' P_RUN_IN_BACKGROUND: '||P_RUN_IN_BACKGROUND,
                                p_procedure => 'XslTransformAndDownloadXMLID'
                              );

  select xmlclob into l_xmlclob
  from temporary_xml
  where id_temporary_xml = p_id_temporary_xml;

  l_regionAttrs := PAK_XML_CONVERT.DeserializeRegionAttrs(p_regionAttrs);
  l_reportTypes := PAK_XML_CONVERT.DeserializeColTypes(p_reportTypes);

  XslTransformAndDownload
  (
    l_xmlclob,
    p_xsltStaticFile,
    p_page_id,
    p_region_name,
    p_filename  ,
    l_regionAttrs,
    l_reportTypes,
    p_mime,
    p_format,
    p_templateStaticFile,
    p_external_params,
    p_second_XsltStaticFile ,
    p_second_external_params,
    p_convertblob_param     ,
    p_log_level             ,
    p_security_group_id     ,
    p_app_user              ,
    p_run_in_background
  );

  delete from temporary_xml
  where id_temporary_xml = p_id_temporary_xml;
  commit;

  pak_xslt_log.WriteLog( 'Background XslTransformAndDownloadXMLID finished ',
                                p_procedure => 'XslTransformAndDownloadXMLID',
                                p_start_time => l_start_time
                              );
exception when others then
  rollback;
  delete from temporary_xml
  where id_temporary_xml = p_id_temporary_xml;
  commit;
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownloadXMLID',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownloadXMLID;


/** Execute below procedure as job with DBMS_SCHEDULER package
  *
  * @param p_Xml input XML
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_TemplateFile Filename of Template uploaded inro static files (in Flat OPC format) from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
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
p_id_temporary_xml    IN  number,
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
) as
l_regionAttrs VARCHAR2(32000);
l_reportTypes VARCHAR2(32000);
begin
  l_regionAttrs := PAK_XML_CONVERT.SerializeRegionAttrs(p_regionAttrs);
  l_reportTypes := PAK_XML_CONVERT.SerializeColTypes(p_reportTypes);

  pak_xslt_log.WriteLog( 'XslTransformAndDownloadJob started p_id_temporary_xml '||p_id_temporary_xml||
                                ' p_xsltStaticFile: '||p_xsltStaticFile||
                                ' p_page_id: '||p_page_id||
                                ' p_region_name: '||p_region_name||
                                ' p_filename: '||p_filename||
                                ' l_regionAttrs: '||l_regionAttrs||
                                ' l_reportTypes: '||l_reportTypes||
                                ' p_mime: '||p_mime||
                                ' p_format: '||p_format||
                                ' p_external_params: '||p_external_params||
                                ' p_second_XsltStaticFile: '||p_second_XsltStaticFile||
                                ' p_second_external_params: '||p_second_external_params||
                                ' p_convertblob_param: '||p_convertblob_param||
                                ' p_log_level: '||p_log_level,

                                p_procedure => 'XslTransformAndDownloadJob'
                              );


  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 1,
                                        argument_value    => p_id_temporary_xml);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 2,
                                        argument_value    => p_xsltStaticFile);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 3,
                                        argument_value    => p_page_id);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 4,
                                        argument_value    => p_region_name);


  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 5,
                                        argument_value    => p_filename);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 6,
                                        argument_value    => l_regionAttrs);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 7,
                                        argument_value    => l_reportTypes);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 8,
                                        argument_value    => p_mime);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 9,
                                        argument_value    => p_format);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 10,
                                        argument_value    => p_templateStaticFile);


  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 11,
                                        argument_value    => p_external_params);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 12,
                                        argument_value    => p_second_XsltStaticFile);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 13,
                                        argument_value    => p_second_external_params);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 14,
                                        argument_value    => p_convertblob_param);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 15,
                                        argument_value    => p_log_level);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 16,
                                        argument_value    => apex_custom_auth.get_security_group_id);

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 17,
                                        argument_value    => V('APP_USER'));

  dbms_scheduler.set_job_argument_value(job_name          => 'job_XslTransformAndDownload',
                                        argument_position => 18,
                                        argument_value    => 1);

  dbms_scheduler.run_job(job_name => 'job_XslTransformAndDownload', use_current_session => false);

  pak_xslt_log.WriteLog( 'Query2Report.XslTransformAndDownloadJob finished ',
                                p_procedure => 'XslTransformAndDownloadJob'
                              );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownloadJob',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownloadJob;


/** Return otput of (p_Xslt) or two (p_Xslt, p_second_Xslt) XSLT transformation(s) applied on single input XML (p_Xml).
  *
  * @param p_Xml input XML
  * @param p_Xslt First XSLT CLOB
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to g_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
  * @param p_template  Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt Second XSLT BLOB applied after p_Xslt
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @return otput of (p_Xslt) or two (p_Xslt, p_second_Xslt) XSLT transformation(s) applied on single input XML (p_Xml).
  */
function XslTransformEx
(
p_Xml                   IN  CLOB,
p_Xslt                  IN  CLOB,
p_format                IN  number default null,
po_error                OUT VARCHAR2,
p_Template              IN    CLOB default null,
p_external_params       IN  varchar2 default null,
p_second_Xslt           IN  CLOB default null,
p_second_external_params IN  varchar2 default null
)
return BLOB
as
l_document  BLOB;

begin

  if p_second_Xslt is not null then

    l_document := XslTransform(
      p_Xml => p_Xml,
      p_Xslt => p_Xslt,
      p_format => F_XML,
      po_error => po_error,
      p_template => p_template,
      p_external_params => p_external_params
    );

    if po_error is null then
      l_document := XslTransform( --first output must be XML
        p_Xml => pak_blob_util.blob2clob(l_document),
        p_Xslt => p_second_Xslt,
        p_format => p_format,
        po_error => po_error,
        p_template => p_template,
        p_external_params => p_second_external_params
      );
    end if;
  else
    l_document := XslTransform(
      p_Xml => p_Xml,
      p_Xslt => p_Xslt,
      p_format => p_format,
      po_error => po_error,
      p_template => p_template,
      p_external_params => p_external_params
    );
  end if;
  return l_document;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformEx (both XSLT)',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformEx;


/** Download otput of (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformation(s) applied on single input XML
  *
  * @param p_Xml input XML
  * @param p_Xslt First XSLT BLOB
  * @param p_filename Filename of downloaded output
  * @param p_XSLT_CS Character set of first XSLT. E.g. 'EEMSWIN1250' for windows-1250 CS
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_template Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_template_CS Character set of Template in Flat OPC format. E.g. 'EEMSWIN1250' for windows-1250 CS. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt Second XSLT BLOB applied after p_Xslt
  * @param p_second_XSLT_file_CS Character set ID of second XSLT
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  */
Procedure XslTransformAndDownload
(
p_Xml                   IN  CLOB,
p_Xslt                  IN  BLOB,
p_filename              in  VARCHAR2,
p_XSLT_CS               in  varchar2 default null,
p_mime                  in  VARCHAR2 default 'application/octet',
p_format                IN  number default null,
p_template              IN  BLOB  default null,
p_template_CS           IN  varchar2 default null,
p_external_params       IN  varchar2 default null,
p_second_Xslt           IN  BLOB default null,
p_second_XSLT_CS        in  varchar2 default null,
p_second_external_params IN  varchar2 default null,
p_convertblob_param      IN  varchar2 default null
) as
l_document BLOB;
--l_first_document CLOB;

--l_XSLT_csid number;
--l_second_XSLT_csid number;
--l_template_csid number;

l_Xslt CLOB;
l_second_Xslt CLOB;
l_template CLOB;
l_error VARCHAR2(4000);

begin
  l_Xslt:=pak_blob_util.BLOB2CLOB(p_Xslt, NLS_CHARSET_ID(p_XSLT_CS));
  if p_second_Xslt is not null then
    l_second_Xslt:=pak_blob_util.BLOB2CLOB(p_second_Xslt, NLS_CHARSET_ID(p_second_XSLT_CS));
  end if;

  if p_template is not null then
    l_template := pak_blob_util.BLOB2CLOB(p_template, NLS_CHARSET_ID(p_template_CS));
  end if;

  l_document := XslTransformEx
  (
    p_Xml => p_Xml,
    p_Xslt => l_Xslt,
    p_format => p_format,
    po_error => l_error,
    p_template => l_template,
    p_external_params => p_external_params,
    p_second_Xslt => l_second_Xslt,
    p_second_external_params => p_second_external_params
  );

  DownloadConvertOutput(V('APP_ID'), l_document, p_filename,
    p_error => l_error,
    p_blob_csid => nvl(NLS_CHARSET_ID(p_second_XSLT_CS), NLS_CHARSET_ID(p_XSLT_CS)),
    p_mime => p_mime,
    p_convertblob => true,
    p_convertblob_param => p_convertblob_param
  );
  --dbms_lob.freetemporary(l_document);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransformAndDownload',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslTransformAndDownload;

/** Create "starter" XSLT transformation from text produced by MS Office when
  * saving document in format which is not XML, HTML, RTF or MHT.
  * "starter" XSLT transformation means that if you apply XSLT to custom XML
  * you get the original text. No XML data will be included in resulted text.
  * You should build your specific XSLT for transforming XML from this starter XSLT.
  *
  * @param pio_rtf CLOB On input this CLOB is in RTF or MHT format on output this is starter XSLT.
  * @param p_no_esc Set this to true if format contains special XML characters (<,>," and &).
  */
 procedure Text2XSLT(
  pio_rtf     IN OUT NOCOPY CLOB
)
as
l_xslt CLOB;
l_text_offset number default 1;
l_no_esc boolean;
c_amount constant number := 4000;

begin
  dbms_lob.createtemporary(l_xslt, false);
  DBMS_LOB.WRITEAPPEND(l_xslt, length(g_start_xslt_text), g_start_xslt_text);
  l_no_esc := dbms_lob.instr(pio_rtf, '<') > 0 or dbms_lob.instr(pio_rtf, '>') > 0
            or dbms_lob.instr(pio_rtf, '"') > 0 or dbms_lob.instr(pio_rtf, '&') > 0;

  while l_text_offset <= dbms_lob.getlength(pio_rtf)
  loop --we limit text section to c_amount chars
    if l_no_esc then
      dbms_lob.writeappend(l_xslt, length(g_startstr_txt_no_esc), g_startstr_txt_no_esc);
    else
      dbms_lob.writeappend(l_xslt, length(g_startstr_txt), g_startstr_txt);
    end if;

    dbms_lob.copy(l_xslt, pio_rtf, c_amount, dbms_lob.getlength(l_xslt)+1, l_text_offset);

    l_text_offset := l_text_offset + c_amount;

    --DBMS_LOB.APPEND(l_xslt, pio_rtf);

    if l_no_esc then
      dbms_lob.writeappend(l_xslt, length(g_endStr_txt_no_esc), g_endStr_txt_no_esc);
    else
      dbms_lob.writeappend(l_xslt, length(g_endStr_txt), g_endStr_txt);
    end if;
  end loop;
  DBMS_LOB.WRITEAPPEND(l_xslt, length(g_end_xslt), g_end_xslt);
  pio_rtf := l_xslt; --ÄTe ne dela nared copy

  --close meta tags if needed
  --end of closing meta tags
  dbms_lob.freetemporary(l_xslt);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Text2XSLT CLOB',
    p_sqlerrm => sqlerrm
  );
  raise;
end Text2XSLT;

/** Create "starter" XSLT transformation from text produced by Wordpad or MS Office when
  * saving document as RTF.
  * "starter" XSLT transformation means that if you apply XSLT to custom XML
  * you get the original RTF. No XML data will be included in resulted text.
  * You should build your specific XSLT for transforming XML to
  * RTF from this starter XSLT.
  * @param pio_rtf CLOB input this CLOB is in RTFformat on output this is starter XSLT.
  * @param p_no_esc Set this to true if format contains special XML characters (<,>," and &).
  */
 procedure RTF2XSLT(
  pio_rtf     IN OUT NOCOPY CLOB
)
as
begin
  --RemoveRTFComments(pio_rtf);
  text2xslt(pio_rtf);
end;


/** Create "starter" XSLT transformation from text produced by MS Office when
  * saving document as MHT.
  * "starter" XSLT transformation means that if you apply XSLT to custom XML
  * you get the original MHT document. No XML data will be included in resulted text.
  * You should build your specific XSLT for transforming XML to
  * Office MHT format from this starter XSLT.
  * @param pio_mht On input this CLOB is in MHT format on output this is starter XSLT.
  */
 procedure MHT2XSLT(
  pio_mht     IN OUT NOCOPY CLOB
)
as
begin
  text2xslt(pio_mht);
end;


-------------------XML-----------------------------------

/** Replaces part of clob which start at offset p_start_pos and ends at
  * p_end_pos with replacment string
  *
  * @param pio_clob CLOB
  * @param p_start_pos Offset of block to replace
  * @param p_end_pos Offset of end of block to replace
  * @param p_replacement Replacement string
  */
procedure ReplaceClobPart(
  pio_clob IN OUT NOCOPY CLOB,
  p_start_pos number,
  p_end_pos number,
  p_replacement varchar2)
as
l_temp clob;
begin
  dbms_lob.createtemporary(l_temp, false);
  dbms_lob.copy(l_temp, pio_clob, p_start_pos - 1);
  dbms_lob.writeappend(l_temp, length(p_replacement), p_replacement);
  dbms_lob.copy(
    l_temp,
    pio_clob,
    dbms_lob.getlength(pio_clob) - p_end_pos + 1,
    dbms_lob.getlength(l_temp)+1,
    p_end_pos
  );
  pio_clob := l_temp;
  dbms_lob.freetemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ReplaceClobPart',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Change xmlns default definitions in child nodes into references on main xmlns definitions in DOCUMENT node.
  * This procedure workarounds Oracle bug
  * @param pio_xml CLOB represent XML got when saving Office document as XML
  */
procedure ReorganizeXmlns(
  pio_xml IN OUT NOCOPY CLOB
)
as
l_main_xmlns varchar2(32000);
l_cur_pos number default 1;
l_end_attr_pos number;
l_end_element_pos number;
l_end_element_name_pos number;
l_element_name varchar2(4000);
l_xmlns varchar2(4000);
l_element varchar2(32000);
l_start_xmlns_pos number;
l_end_xmlns_pos number;

l_space_pos number;
--l_end_attr_pos number;
l_close_tag_pos number;
l_wb_xmlns_pos number;
l_wb_xmlns_start_pos number;
l_xmlns_alias_pos number;
l_xmlns_alias_end_pos number;
l_xmlns_alias varchar2(20);

begin
  loop
    l_cur_pos:= dbms_lob.instr(pio_xml, '<', l_cur_pos);
    exit when dbms_lob.substr(pio_xml, 1, l_cur_pos+1) <> '?';
    l_cur_pos := dbms_lob.instr(pio_xml, '?>', l_cur_pos) + length('?>');
    if l_cur_pos = 0 then
      pak_xslt_log.WriteLog(
        'Can''t find closing tag ?> of XML processing instruction',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'ReorganizeXmlns'
      );
      return;
    end if;
  end loop;
  l_end_attr_pos:= dbms_lob.instr(pio_xml, '>', l_cur_pos);
  l_main_xmlns := dbms_lob.substr(pio_xml, l_end_attr_pos - l_cur_pos + 1, l_cur_pos + 1);
  l_cur_pos := l_end_attr_pos;
  loop
    l_cur_pos := dbms_lob.instr(pio_xml, '<', l_cur_pos);
    exit when nvl(l_cur_pos, 0) = 0;
    l_space_pos := dbms_lob.instr(pio_xml, ' ', l_cur_pos);
    l_end_attr_pos := dbms_lob.instr(pio_xml, '>', l_cur_pos);
    l_close_tag_pos := dbms_lob.instr(pio_xml, '/>', l_cur_pos);

    if l_space_pos = 0 then l_space_pos := dbms_lob.LOBMAXSIZE; end if;
    if l_end_attr_pos = 0 then l_end_attr_pos := dbms_lob.LOBMAXSIZE; end if;
    if l_close_tag_pos = 0 then l_close_tag_pos := dbms_lob.LOBMAXSIZE; end if;

    l_end_element_name_pos := least(l_space_pos, l_end_attr_pos, l_close_tag_pos);

    exit when l_end_attr_pos = dbms_lob.LOBMAXSIZE or l_end_element_name_pos = dbms_lob.LOBMAXSIZE;
    l_element_name := dbms_lob.substr(pio_xml, l_end_element_name_pos - l_cur_pos -1, l_cur_pos + 1);

    if substr(l_element_name, 1, 1)<>'/' then --not closing tag
      if l_close_tag_pos + 1 = l_end_attr_pos then
        l_end_element_pos := l_close_tag_pos + length('/>');
      else
        l_end_element_pos := dbms_lob.instr(pio_xml, '</'||l_element_name||'>', l_cur_pos);
        exit when l_end_element_pos = 0;
        l_end_element_pos := l_end_element_pos + length('</'||l_element_name||'>');
      end if;

      if instr(dbms_lob.substr(pio_xml, l_end_attr_pos - l_cur_pos + 1, l_cur_pos),'xmlns="') > 0 then --extract whole element
        l_element := dbms_lob.substr(pio_xml, l_end_element_pos - l_cur_pos + 1, l_cur_pos);
        l_start_xmlns_pos := instr(l_element, 'xmlns=') + length('xmlns=');
        l_end_xmlns_pos := instr(l_element, '"', l_start_xmlns_pos , 2);
        exit when l_end_xmlns_pos = 0;
        l_xmlns := substr(l_element, l_start_xmlns_pos, l_end_xmlns_pos - l_start_xmlns_pos + 1);
        l_wb_xmlns_pos := instr(l_main_xmlns, l_xmlns);
        if l_wb_xmlns_pos > 0 then --change child namespace with parent (global) one
          l_wb_xmlns_start_pos := instr(l_main_xmlns, 'xmlns:', l_wb_xmlns_pos - length(l_main_xmlns), 1);
          exit when l_wb_xmlns_start_pos = 0;
          l_xmlns_alias_pos := l_wb_xmlns_start_pos + length('xmlns:');
          l_xmlns_alias_end_pos := instr(l_main_xmlns, '=', l_xmlns_alias_pos);
          l_xmlns_alias := substr(l_main_xmlns, l_xmlns_alias_pos, l_xmlns_alias_end_pos - l_xmlns_alias_pos);
          l_element := replace(l_element, ' xmlns='||l_xmlns);
          l_element := replace(l_element, '<', '<'||l_xmlns_alias||':');
          l_element := replace(l_element, '<'||l_xmlns_alias||':/', '</'||l_xmlns_alias||':');
          --replace old element with changed element
          ReplaceClobPart(pio_xml, l_cur_pos, l_end_element_pos, l_element);
          l_cur_pos := l_cur_pos + length(l_element) + 1;
        else
          l_cur_pos := l_end_element_pos +1;
        end if;  --we don' count on nested child default xmlns, so we skip to the beginning of next element

      else
        l_cur_pos := l_end_attr_pos +1;
      end if;
    else --it is closing tag
      l_cur_pos := l_end_attr_pos +1; --skip closing tag
    end if;
  end loop;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ReorganizeXmlns',
    p_sqlerrm => sqlerrm
  );
  raise;

end;

function ReadElementOpeningTag(
  p_xml IN CLOB
  ,p_element_name varchar2
)
return varchar2
as
l_ret varchar2(4000);
l_start number;
l_end number;
l_amount number;
begin
  l_start := dbms_lob.instr(p_xml, '<'||p_element_name);
  l_end :=  dbms_lob.instr(p_xml, '>', l_start);

  if nvl(l_start, 0) = 0 or nvl(l_end, 0) = 0
  then
    return null;
  end if;
  l_amount := l_end - l_start + 1;
  dbms_lob.read(p_xml, l_amount, l_start, l_ret);
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ReadElementOpeningTag',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

FUNCTION SplitXMLNS (p_in_string VARCHAR2, po_xmlns_exists out boolean) RETURN tab_string
  IS

  i       number :=0;
  pos     number :=0;
  lv_str  varchar2(32000) := replace(p_in_string,'>');

  strings tab_string := tab_string();

  BEGIN
      -- determine first chuck of string
      po_xmlns_exists := false;
      pos := instr(lv_str,' ',1,1);
      -- while there are chunks left, loop
      WHILE ( pos != 0) LOOP
         i := i + 1;
         -- create array element for chuck of string
         IF lv_str like 'xmlns:%' and lv_str not like 'xmlns:xsl=%' THEN
           strings.extend;
           strings(strings.count) := trim(substr(lv_str,1,pos));
         ELSIF lv_str like 'xmlns=%' THEN
            po_xmlns_exists := true;
         END IF;
         -- remove chunk from string
         lv_str := substr(lv_str,pos+1,length(lv_str));
         -- determine next chunk
         pos := instr(lv_str,' ',1,1);
         -- no last chunk, add to array
         IF pos = 0 and lv_str like 'xmlns:%' and lv_str not like 'xmlns:xsl=%' THEN
            strings.extend;
            strings(strings.count) := trim(lv_str);
         END IF;
      END LOOP;
      -- return array
      RETURN strings;
  exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'SplitXMLNS',
    p_sqlerrm => sqlerrm
  );
  raise;
END SplitXMLNS;

procedure EscapeBraces(pio_xml IN OUT NOCOPY CLOB)
as
l_start_brace number;
l_end_brace   number;
l_offset number := 1;
l_cur_element_start number;
l_element_start number;
l_element_end number;
l_end_tag number;
l_end_element_space number;
l_element_name varchar2(400);
l_element_end_tag varchar2(400);
l_element varchar2(32000);
begin
  loop
    l_start_brace := dbms_lob.instr(pio_xml,'="{', l_offset);
    exit when nvl(l_start_brace, 0) = 0;
    l_end_brace := dbms_lob.instr(pio_xml,'}"', l_start_brace);
    exit when nvl(l_end_brace, 0) = 0;
    l_cur_element_start :=  dbms_lob.instr(pio_xml,'<', l_offset);
    exit when nvl(l_cur_element_start, 0) = 0;
    l_element_start := l_cur_element_start;
    while l_cur_element_start < l_start_brace loop
      l_element_start := l_cur_element_start;
      l_cur_element_start :=  dbms_lob.instr(pio_xml,'<', l_cur_element_start + 1);
      if nvl(l_cur_element_start, 0)=0 then
        return;
      end if;
    end loop;
    --read element name
    l_end_tag := dbms_lob.instr(pio_xml,'>', l_element_start);
    exit when nvl(l_end_tag, 0) = 0;
    l_end_element_space := dbms_lob.instr(pio_xml,' ', l_element_start);
    if l_end_element_space > 0 and l_end_element_space < l_end_tag then
      l_end_tag := l_end_element_space;
    end if;
    l_element_name := dbms_lob.substr(pio_xml, l_end_tag - l_element_start - 1, l_element_start + 1);
    l_element_end_tag :='</'||l_element_name||'>';
    l_element_end := dbms_lob.instr(pio_xml, l_element_end_tag, l_element_start);
    if l_element_end > 0 then
      l_element_end := l_element_end + length(l_element_end_tag);
    else
      l_element_end := dbms_lob.instr(pio_xml, '/>', l_element_start);
      exit when nvl(l_element_end, 0) = 0;
      l_element_end := l_element_end + length('/>');
    end if;
    pak_blob_util.clobReplace(
      pio_xml,
      l_element_start,
      l_element_end - 1,
      g_startStr_txt_no_esc||
      dbms_lob.substr(pio_xml, l_element_end - l_element_start, l_element_start)||
      g_endStr_txt_no_esc
    );
    l_offset := l_element_end + length(g_startStr_txt_no_esc) + length(g_endStr_txt_no_esc);
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'EscapeBraces',
    p_sqlerrm => sqlerrm
  );
end;


procedure EscapeBinaryBlock(pio_binary IN OUT NOCOPY CLOB)
as
l_temp CLOB;
c_blocklimit  constant number := 210*66;
l_amount      number;
l_offset      number := 1;
l_buffer      varchar2(32000);
l_buffsz   number;
l_after_sz    number;
begin
  dbms_lob.CreateTemporary(l_temp, false);
  dbms_lob.WriteAppend(l_temp, length(g_startStr_txt_no_esc_lb), g_startStr_txt_no_esc_lb);
  l_amount := c_blocklimit;
  loop
    exit when l_offset > dbms_lob.getlength(pio_binary) or l_amount = 0;
    dbms_lob.read(pio_binary, l_amount, l_offset, l_buffer);
    l_buffsz := length(l_buffer);
    l_buffer := replace(l_buffer, chr(13)||chr(10), g_endStr_txt_no_esc_lb||chr(13)||chr(10)||g_startStr_txt_no_esc_lb);
    if length(l_buffer) = l_buffsz then
      l_buffer := replace(l_buffer, chr(10), g_endStr_txt_no_esc_lb||chr(10)||g_startStr_txt_no_esc_lb);
    end if;
    dbms_lob.WriteAppend(l_temp, length(l_buffer), l_buffer);
    l_offset := l_offset + l_amount;
  end loop;
  --pak_blob_util.clobReplaceAll(pio_binary, g_crlf, g_endStr_txt_no_esc_lb||g_crlf||g_startStr_txt_no_esc_lb);
  --dbms_lob.Copy(l_temp, pio_binary, dbms_lob.getlength(pio_binary), dbms_lob.getlength(l_temp)+1, 1);
  dbms_lob.WriteAppend(l_temp, length(g_endStr_txt_no_esc_lb), g_endStr_txt_no_esc_lb);
  pio_binary := l_temp;
  dbms_lob.freeTemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'EscapeBinaryBlock',
    p_sqlerrm => sqlerrm
  );
  raise;
end;


procedure EscapeBinaryData(pio_xml IN OUT NOCOPY CLOB)
as
l_binaryStartTag varchar2(40);
l_binaryEndTag varchar2(40);
l_offset number := 1;
c_blocklimit constant number := 210*66;
l_buffer varchar2(32000);
l_startBinary number;
l_endBinary number;
l_binaryBlock CLOB;
begin
  if dbms_lob.instr(pio_xml,'<pkg:package ') > 0 then
    l_binaryStartTag := '<pkg:binaryData';
  else
    l_binaryStartTag := '<w:binData';
  end if;
  l_binaryEndTag := '</'||substr(l_binaryStartTag,2)||'>';
  loop
    --find start of binary block
    l_startBinary := dbms_lob.instr(pio_xml, l_binaryStartTag, l_offset);
    exit when nvl(l_startBinary, 0) = 0;
    l_startBinary := dbms_lob.instr(pio_xml, '>', l_startBinary + length(l_binaryStartTag));
    exit when nvl(l_startBinary, 0) = 0;
    l_startBinary := l_startBinary + 1;
    --find end of binary block
    l_endBinary := dbms_lob.instr(pio_xml, l_binaryEndTag, l_startBinary);
    exit when nvl(l_endBinary, 0) = 0;
    if l_endBinary - l_startBinary > c_blocklimit then
      dbms_lob.CreateTemporary(l_binaryBlock, false);
      dbms_lob.Copy(l_binaryBlock, pio_xml, l_endBinary-l_startBinary, 1, l_startBinary);
      EscapeBinaryBlock(l_binaryBlock);
      pak_blob_util.clobReplace(pio_xml, l_startBinary, l_endBinary - 1, l_binaryBlock);
      l_offset := l_startBinary + dbms_lob.getlength(l_binaryBlock) + length(l_binaryEndTag);
      dbms_lob.freeTemporary(l_binaryBlock);
    else
      l_offset := l_endBinary + length(l_binaryEndTag);
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'EscapeBinaryData',
    p_sqlerrm => sqlerrm
  );
  RAISE;
end;

/** When creating starter XSLT transformation it moves xmlns atributes from <w:wordDocument> element
  * to <xsl:stylesheet> element
  *
  * @param pio_xml CLOB XML Spreadsheet 2003 or Word 2003 XML.
  */
procedure MoveXMLNS(
  pio_xml IN OUT NOCOPY CLOB,
  p_from_DOCUMENT_element varchar2,
  p_to_DOCUMENT_element varchar2 default 'xsl:stylesheet'
)
as
l_xsl_stylesheet varchar2(4000);
l_xsl_stylesheet_new varchar2(4000);
l_doc_DOCUMENT_element varchar2(4000);
l_doc_DOCUMENT_element_new varchar2(4000);
l_xmlns tab_string;
l_xmlns_exists boolean;

begin
  l_doc_DOCUMENT_element := ReadElementOpeningTag(pio_xml, p_from_DOCUMENT_element);--'w:wordDocument'
  l_xsl_stylesheet := ReadElementOpeningTag(pio_xml, p_to_DOCUMENT_element);
  if l_doc_DOCUMENT_element is null or l_xsl_stylesheet is null then
    return;
  end if;
  l_xmlns := SplitXMLNS(l_doc_DOCUMENT_element, l_xmlns_exists);
  l_doc_DOCUMENT_element_new := l_doc_DOCUMENT_element;
  l_xsl_stylesheet_new := l_xsl_stylesheet;
  for i in 1..l_xmlns.count loop
    pak_xslt_log.WriteLog('l_xmlns(i): '||l_xmlns(i)||'#', p_procedure => 'MoveXMLNS');
    l_doc_DOCUMENT_element_new := replace(l_doc_DOCUMENT_element_new, ' '||l_xmlns(i));
    l_xsl_stylesheet_new := replace(l_xsl_stylesheet_new,'>',' '||l_xmlns(i)||'>');
  end loop;
  pak_xslt_log.WriteLog(
    'l_doc_DOCUMENT_element: '||l_doc_DOCUMENT_element||' l_doc_DOCUMENT_element_new: '||l_doc_DOCUMENT_element_new,
    p_procedure => 'MoveXMLNS'
  );

  pak_xslt_log.WriteLog(
    'l_xsl_stylesheet: '||l_xsl_stylesheet||' l_xsl_stylesheet_new: '||l_xsl_stylesheet_new,
    p_procedure => 'MoveXMLNS'
  );
  if l_xmlns_exists then --enclose xml element in xsl:text
    l_doc_DOCUMENT_element_new := g_startStr_txt_no_esc||l_doc_DOCUMENT_element_new||g_endStr_txt_no_esc;
    pak_blob_util.clobReplaceAll(pio_xml, '</'||p_from_DOCUMENT_element||'>', g_startStr_txt_no_esc||'</'||p_from_DOCUMENT_element||'>'||g_endStr_txt_no_esc);
  end if;
  pak_blob_util.clobReplaceAll(pio_xml, l_doc_DOCUMENT_element, l_doc_DOCUMENT_element_new);
  pak_blob_util.clobReplaceAll(pio_xml, l_xsl_stylesheet, l_xsl_stylesheet_new);

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'MoveXMLNS',
    p_sqlerrm => sqlerrm
  );
  raise;
end MoveXMLNS;

/** Create starter XSLT transformation from XML produced
  * by MS Office (Excel when saving document as XML Spreadsheet 2003 or by MS Word
  * when saving as XML)
  * starter XSLT transformation means that if you apply XSLT to custom suorce XML
  * you get the original XML. No suorce XML data will be included in
  * resulted destination XML (saved by MS Office).
  * You should build your specific XSLT for transforming XML produced by MS Office*
  * from this starter XSLT.
  *
  * @param pio_xml CLOB On input this CLOB is in XML Spreadsheet 2003 or Word 2003 XML format on output is starter XSLT.
  */
procedure XML2XSLT(
  pio_xml IN OUT NOCOPY CLOB
)
as
l_cur_pos number;
l_end_pi_attr number;
l_xml_pi varchar2(4000);
l_xml_pi_name varchar2(4000);
l_xml_pi_attr varchar2(4000);
l_xml_pi_space_pos number;
l_start_xslt_xml varchar2(4000):=
  '<?xml version="1.0"?>'|| g_crlf||
  '<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">'|| g_crlf||
  '<xsl:output method="xml" ';
i number default 0;
l_temp CLOB;

begin
  --l_cur_pos := dbms_lob.instr(pio_xml, '<?xml version="1.0"?>');
  --l_cur_pos := l_cur_pos + length('<?xml version="1.0"?>') + 1;
  ReorganizeXmlns(pio_xml);
  ------dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug2.xml');
  l_cur_pos := dbms_lob.instr(pio_xml, '<?');
  if l_cur_pos > 0 then
    l_cur_pos := l_cur_pos + length('<?');
    l_end_pi_attr := dbms_lob.instr(pio_xml, '?>', l_cur_pos)-1;
    l_xml_pi := dbms_lob.substr(pio_xml,  l_end_pi_attr - l_cur_pos + 1, l_cur_pos);
    if substr(l_xml_pi, 1, 4) = 'xml ' then
      l_start_xslt_xml := l_start_xslt_xml||substr(l_xml_pi, 4)||'/>'||g_crlf||
      '<xsl:template match="/">'|| g_crlf|| g_crlf;
      l_cur_pos := l_end_pi_attr + length('?>') + 1;
    else
      l_start_xslt_xml := l_start_xslt_xml||'version="1.0"/>'||g_crlf||
      '<xsl:template match="/">'|| g_crlf|| g_crlf;
      l_cur_pos :=1;
    end if;

    loop
      l_cur_pos := dbms_lob.instr(pio_xml, '<?', l_cur_pos);
      exit when l_cur_pos = 0;
      i := i + 1;
      l_cur_pos := l_cur_pos + length('<?');
      l_end_pi_attr := dbms_lob.instr(pio_xml, '?>', l_cur_pos)-1;
      l_xml_pi := dbms_lob.substr(pio_xml,  l_end_pi_attr - l_cur_pos + 1, l_cur_pos);
      l_xml_pi_space_pos := instr(l_xml_pi, ' ');
      if l_xml_pi_space_pos > 0 then
        l_start_xslt_xml := l_start_xslt_xml||g_crlf||
        '<xsl:processing-instruction name="'||substr(l_xml_pi, 1, l_xml_pi_space_pos -1)||'">'||substr(l_xml_pi, l_xml_pi_space_pos + 1)||'</xsl:processing-instruction>'||g_crlf;
      else
        l_start_xslt_xml := l_start_xslt_xml||g_crlf||
        '<xsl:processing-instruction name="'||l_xml_pi||'"/>'||g_crlf;
      end if;
    end loop;
    dbms_lob.createtemporary(l_temp, false);
    DBMS_LOB.WRITEAPPEND(l_temp, length(l_start_xslt_xml), l_start_xslt_xml);
    --dbms_lob.append(l_temp, pio_xml);
    DBMS_LOB.COPY (
      l_temp,
      pio_xml,
      dbms_lob.getlength(pio_xml) - l_end_pi_attr - 2,
      dbms_lob.getlength(l_temp)+1,
      l_end_pi_attr + 3
    );
    DBMS_LOB.WRITEAPPEND(l_temp, length(g_end_xslt), g_end_xslt);
    --pak_blob_util.clobReplaceAll(l_temp, '><','>'||chr(13)||chr(10)||'<');
    MoveXMLNS(l_temp, 'w:wordDocument');
    MoveXMLNS(l_temp, 'Workbook');
    ----dbms_xslprocessor.clob2file(l_temp, 'XMLDIR', 'debug3.xml');
    EscapeBraces(l_temp);
    ----dbms_xslprocessor.clob2file(l_temp, 'XMLDIR', 'debug4.xml');
    EscapeBinaryData(l_temp);
    pio_xml := l_temp;
    dbms_lob.freetemporary(l_temp);
  else
    pak_xslt_log.WriteLog(
    'Input document is not XML',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XMLWrap CLOB'
  );
  end if;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XML2XSLT CLOB',
    p_sqlerrm => sqlerrm
  );
  raise;
end XML2XSLT;

----------------------HTML--------------------------------------------

/** Put attribute values in HTML in quotas (") and add starting and ending xsl tags
  *
  * @param pio_html CLOB represents HTML
  */
procedure MSWordHTMLQAttrXSlWrap(
  pio_html IN OUT NOCOPY CLOB
)
as
l_xslt CLOB;
l_eq_pos number default 0;
l_next_eq_pos number default 0;
l_next_gt_pos number default 0;
l_start_of_attr number;
l_start_of_attr_char varchar2(1);
l_end_of_attr number default 0;
l_space_pos number default 0;
l_crlf_pos number default 0;
l_copy_offset number default 1;
l_end_of_html varchar2(32767);

begin
  dbms_lob.createtemporary(l_xslt, false);

  DBMS_LOB.WRITEAPPEND(l_xslt, length(g_start_xslt_html), g_start_xslt_html);

  loop
    l_eq_pos := dbms_lob.instr(pio_html, '=', l_eq_pos + 1);
    exit when nvl(l_eq_pos, 0) = 0;
    l_start_of_attr := l_eq_pos + 1;
    l_start_of_attr_char := dbms_lob.substr(pio_html, 1, l_start_of_attr);
    if l_start_of_attr_char in ('''', '"') then
      l_end_of_attr := dbms_lob.instr(pio_html, l_start_of_attr_char, l_start_of_attr + 1);
      l_eq_pos := l_end_of_attr; --no need to search for '=' inside this attribute, so skip this
    else  --attribute not in quotas
      l_next_eq_pos := dbms_lob.instr(pio_html, '=', l_start_of_attr);
      l_next_gt_pos := dbms_lob.instr(pio_html, '>', l_start_of_attr);

      if l_next_eq_pos < l_next_gt_pos and l_next_eq_pos > 0 then
        --find first space in reverse order
        l_end_of_attr := l_start_of_attr;
        while l_space_pos <  l_next_eq_pos and l_end_of_attr > 0
        loop
          l_space_pos := dbms_lob.instr(pio_html, ' ', l_end_of_attr +1);
          l_crlf_pos := dbms_lob.instr(pio_html, Query2Report.g_crlf, l_end_of_attr +1);
          if nvl(l_space_pos,0) = 0 and nvl(l_crlf_pos, 0) = 0 then
            l_space_pos := 0;
          elsif nvl(l_space_pos,0) = 0 then
            l_space_pos := l_crlf_pos;
          elsif nvl(l_crlf_pos, 0) = 0 then
            null; --l_space_pos already has right value
          else
            l_space_pos := least(l_space_pos, l_crlf_pos);
          end if;
          exit when l_space_pos > l_next_eq_pos or nvl(l_space_pos,0) = 0;
          l_end_of_attr := l_space_pos;
        end loop;
        if nvl(l_end_of_attr,0) > 0 then
          l_end_of_attr := l_end_of_attr - 1;
          while dbms_lob.substr(pio_html, 1, l_end_of_attr) in (' ',chr(13), chr(10))
          loop
            exit when l_end_of_attr <= l_start_of_attr;
            l_end_of_attr := l_end_of_attr - 1;
          end loop;
        end if;
      end if;

      if (l_next_gt_pos < l_next_eq_pos or l_next_eq_pos = 0) and l_next_gt_pos > 0 then
        --find first space in reverse order
        l_end_of_attr := l_next_gt_pos - 1;
        while dbms_lob.substr(pio_html, 1, l_end_of_attr) in (' ','/','>',chr(13), chr(10))
        loop
          exit when l_end_of_attr <= l_start_of_attr;
          l_end_of_attr := l_end_of_attr - 1;
        end loop;

        /*
        l_end_of_attr := dbms_lob.instr(pio_html, ' ', l_next_eq_pos, -1);
        if nvl(l_end_of_attr,0) > 0 then
          l_end_of_attr := l_end_of_attr - 1;
        end if;
        */
      end if;
    end if; --attribute not in quotas
    pak_xslt_log.WriteLog('Attribute: '||to_char(l_start_of_attr)||' - '||to_char(l_end_of_attr)||' : '||
      dbms_lob.substr(pio_html, l_end_of_attr - l_start_of_attr + 1, l_start_of_attr), p_procedure => 'MSWordHTMLQAttrXSlWrap' );
      --append html chunk before element attribute
      --DBMS_LOB.WRITEAPPEND(l_xslt, l_start_of_attr - l_copy_offset, dbms_lob.substr(pio_html, l_start_of_attr - l_copy_offset, l_copy_offset));
      DBMS_LOB.COPY(l_xslt, pio_html, l_start_of_attr - l_copy_offset, dbms_lob.getlength(l_xslt)+1, l_copy_offset);
      l_start_of_attr_char := dbms_lob.substr(pio_html, 1, l_start_of_attr);
      if l_start_of_attr_char not in ('''','"') then --append quote
        DBMS_LOB.WRITEAPPEND(l_xslt, 1, '"');
      else --attribute have spaces, so we must move l_end_of_attr from space to closing quote example: meta tag in MS Word HTML
        l_end_of_attr := dbms_lob.instr(pio_html, l_start_of_attr_char, l_start_of_attr + 1);
      end if;
      --append attribute
      --DBMS_LOB.WRITEAPPEND(l_xslt, l_end_of_attr - l_start_of_attr + 1, dbms_lob.substr(pio_html, l_end_of_attr - l_start_of_attr + 1, l_start_of_attr));
      DBMS_LOB.COPY(l_xslt, pio_html, l_end_of_attr - l_start_of_attr + 1, dbms_lob.getlength(l_xslt)+1, l_start_of_attr);
      if dbms_lob.substr(pio_html, 1, l_end_of_attr) not in ('''','"') then --append quote
        DBMS_LOB.WRITEAPPEND(l_xslt, 1, '"');
      end if;
      l_copy_offset := l_end_of_attr + 1;
  end loop;
  l_end_of_html := dbms_lob.substr(pio_html, offset => l_copy_offset);
  DBMS_LOB.WRITEAPPEND(l_xslt, length(l_end_of_html), l_end_of_html);

  DBMS_LOB.WRITEAPPEND(l_xslt, length(g_end_xslt), g_end_xslt);
  pio_html := l_xslt;

  dbms_lob.freetemporary(l_xslt);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'MSWordHTMLQAttrXSlWrap',
    p_sqlerrm => sqlerrm
  );
  raise;
end MSWordHTMLQAttrXSlWrap;


/** Enclose p_findStr with p_startStr and p_endStr at offset pio_cur_pos,
  * set pio_cur_pos to the end of p_endStr
  *
  * @param pio_clob CLOB
  * @param pio_cur_pos Offset of p_findStr string to enclose, set to the end of p_endStr at the return
  * @param p_findStr String to enclose
  * @param p_startStr String on the left of p_findStr
  * @param p_endStr String on the right of p_findStr
  */
procedure EncloseString(
  pio_clob IN OUT NOCOPY CLOB,
  pio_cur_pos in out number,
  p_findStr varchar2,
  p_startStr varchar2,
  p_endStr varchar2
)
as
begin
  if pio_cur_pos > 0 then
    InsertString(pio_clob, p_startStr, pio_cur_pos);
    pio_cur_pos := pio_cur_pos + length(p_startStr) + length(p_findStr);
    InsertString(pio_clob, p_endStr, pio_cur_pos);
    pio_cur_pos := pio_cur_pos + length(p_endStr);
  end if;
end;

/** Enclose all occurrences of p_findStr with p_startStr and p_endStr
  *
  * @param pio_clob CLOB
  * @param p_findStr String to enclose
  * @param p_startStr String on the left of p_findStr
  * @param p_endStr String on the right of p_findStr
  */
procedure EncloseString(
  pio_clob IN OUT NOCOPY CLOB,
  p_findStr varchar2,
  p_startStr varchar2,
  p_endStr varchar2
)
as
 l_cur_pos number default 1;
begin
  loop
    l_cur_pos := dbms_lob.instr(pio_clob, p_findStr, l_cur_pos);
    exit when l_cur_pos = 0;
    EncloseString(pio_clob, l_cur_pos, p_findStr, p_startStr, p_endStr);
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'EncloseString',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Enclose all occurrences of p_findStr in <xsl:text disable-output-escaping="yes"> element
  *
  * @param pio_clob CLOB
  * @param p_findStr String to enclose
  */
procedure XslEncloseString(
  pio_clob IN OUT NOCOPY CLOB,
  p_findStr varchar2
)
as
begin
  EncloseString(pio_clob, p_findStr, g_startStr_txt_no_esc, g_endStr_txt_no_esc);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslEncloseString (all)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Enclose p_findStr with <xsl:text disable-output-escaping="yes"> element at offset pio_cur_pos,
  * set pio_cur_pos to the end of closing tag </xsl:text>
  *
  * @param pio_clob CLOB
  * @param pio_cur_pos Offset of p_findStr string to enclose, set to the end of p_endStr at the return
  * @param p_findStr String to enclose
  */
procedure XslEncloseString(
  pio_clob IN OUT NOCOPY CLOB,
  pio_cur_pos in out number,
  p_findStr varchar2
)
as
begin
  EncloseString(pio_clob, pio_cur_pos, p_findStr, g_startStr_txt_no_esc, g_endStr_txt_no_esc);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslEncloseString (one)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Enclose HTML or XML comments with <xsl:text disable-output-escaping="yes"> element and CDATA
  * @param pio_clob CLOB
  */
procedure XslEncloseComments(
  pio_clob IN OUT NOCOPY CLOB
)
as
  l_cur_pos number default 1;
begin
  loop
    l_cur_pos := dbms_lob.instr(pio_clob, '<!--', l_cur_pos);
    exit when l_cur_pos = 0;
    InsertString(pio_clob, g_startStr_txt_no_esc, l_cur_pos);
    l_cur_pos := l_cur_pos + length(g_startStr_txt_no_esc);
    l_cur_pos := dbms_lob.instr(pio_clob, '-->', l_cur_pos);
    if l_cur_pos = 0 then
      pak_xslt_log.WriteLog(
        'There is no closing tag --> for comment',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'XslEncloseComments'
      );
      exit;
    end if;
    l_cur_pos := l_cur_pos + length('-->');
    InsertString(pio_clob, g_endStr_txt_no_esc, l_cur_pos);
    l_cur_pos := l_cur_pos + length(g_endStr_txt_no_esc);
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslEncloseComments',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslEncloseComments;


/** Enclose all not xml tags like <meta in HTML with <xsl:text disable-output-escaping="yes"> element
  * and CDATA section
  * @param pio_clob CLOB
  */
procedure EncloseNonXmlElements(
  pio_clob IN OUT NOCOPY CLOB
)
as
  l_cur_pos number default 1;
  l_end_element_pos number;
  l_element_name varchar2(200);
 -- l_closing_tag_pos number;
  l_closing_gt_pos number;
  l_space_pos number;
  l_crlf_pos number;
  l_end_tag_pos number;
  l_close_tag_pos number;
begin
  l_cur_pos := length(g_start_xslt_html) + 1;
  loop
    l_cur_pos := dbms_lob.instr(pio_clob, '<', l_cur_pos);
    exit when l_cur_pos = 0;
    l_space_pos := dbms_lob.instr(pio_clob, ' ', l_cur_pos);
    l_crlf_pos := dbms_lob.instr(pio_clob, Query2Report.g_crlf, l_cur_pos);

    if nvl(l_space_pos,0) = 0 and nvl(l_crlf_pos, 0) = 0 then
      l_space_pos := 0;
    elsif nvl(l_space_pos,0) = 0 then
      l_space_pos := l_crlf_pos;
    elsif nvl(l_crlf_pos, 0) = 0 then
      null; --l_space_pos already has right value
    else
      l_space_pos := least(l_space_pos, l_crlf_pos);
    end if;

    l_end_tag_pos := dbms_lob.instr(pio_clob, '>', l_cur_pos);
    l_close_tag_pos := dbms_lob.instr(pio_clob, '/>', l_cur_pos);

    if l_space_pos = 0 then l_space_pos := dbms_lob.LOBMAXSIZE; end if;
    if l_end_tag_pos = 0 then l_end_tag_pos := dbms_lob.LOBMAXSIZE; end if;
    if l_close_tag_pos = 0 then l_close_tag_pos := dbms_lob.LOBMAXSIZE; end if;

    l_end_element_pos := least(l_space_pos, l_end_tag_pos, l_close_tag_pos);

    exit when l_end_element_pos = dbms_lob.LOBMAXSIZE;
    l_element_name := dbms_lob.substr(pio_clob, l_end_element_pos - l_cur_pos -1, l_cur_pos + 1);
    if substr(l_element_name, 1,1) = '/' then--it is closing tag
      l_cur_pos := dbms_lob.instr(pio_clob, '>', l_cur_pos) + 1;
    else
      if l_element_name like '![CDATA[%' then --excluse CDATA part
        l_cur_pos := dbms_lob.instr(pio_clob, ']]>', l_cur_pos);
        if l_cur_pos = 0 then
          pak_xslt_log.WriteLog(
            'There is no closing tag ]]> for CDATA',
            p_log_type => pak_xslt_log.g_error,
            p_procedure => 'EncloseNonXmlElements'
          );
          exit;
        else
          l_cur_pos := l_cur_pos + length(']]>') + 1;
        end if;
      else --element is not HTML comment
        --exclude HTML comments
        if l_element_name like '!--%' then
          l_cur_pos := dbms_lob.instr(pio_clob, '-->', l_cur_pos);
          if l_cur_pos = 0 then
            pak_xslt_log.WriteLog(
              'There is no closing tag --> for comment',
              p_log_type => pak_xslt_log.g_error,
              p_procedure => 'EncloseNonXmlElements'
            );
            exit;
          else
            l_cur_pos := l_cur_pos + length('-->') + 1;
          end if;
        else --element is not HTML comment
          l_closing_gt_pos := dbms_lob.instr(pio_clob, '>', l_cur_pos);
          exit when l_closing_gt_pos = 0;
          if dbms_lob.substr(pio_clob, 2, l_closing_gt_pos - 1) = '/>' then --element XML closed, it doesn't have nested elements
            l_cur_pos := l_closing_gt_pos + 1;
          else --element has nested element or it's not XML closed
            if lower(l_element_name) in ('meta','link','br')
              and dbms_lob.instr(pio_clob, '</'||l_element_name||'>', l_cur_pos) = 0
            then --it's not XML closed so enclose element with xls:text element
              --TODO: Enclose element
              InsertString(pio_clob, g_startStr_txt_no_esc, l_cur_pos);
              l_closing_gt_pos := l_closing_gt_pos + length(g_startStr_txt_no_esc);
              InsertString(pio_clob, g_endStr_txt_no_esc, l_closing_gt_pos + 1);
              l_cur_pos := l_closing_gt_pos + length(g_endStr_txt_no_esc);
            else --element has nested element
              l_cur_pos := l_closing_gt_pos + 1;
            end if;
          end if;
        end if;
      end if;
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'EncloseNonXmlElements',
    p_sqlerrm => sqlerrm
  );
  raise;
end EncloseNonXmlElements;

/** Returns true if p_esc_code is HTML escape code
  * @param p_esc_code Candidate for HTML escape code
  */
function IsHtmlEscCode(
  p_esc_code varchar2
)
return boolean
as
l_code_length number;
begin
  if substr(p_esc_code,1,1) <> '&' then return false; end if; --must start with &
  l_code_length := length(p_esc_code);
  if substr(p_esc_code,l_code_length,l_code_length) <> ';' then return false; end if; --must end with ;
  if substr(p_esc_code, 2, 1) = '#' then --it must be integer code
    for i in 3..l_code_length-1
    loop
      if ascii(substr(p_esc_code, i, 1)) not between ascii('0') and ascii('9') then
        return false;
      end if;
    end loop;
  else
    for i in 2..l_code_length-1
    loop
      if ascii(substr(p_esc_code, i, 1)) not between ascii('0') and ascii('9') and
         ascii(substr(p_esc_code, i, 1)) not between ascii('a') and ascii('z') and
         ascii(substr(p_esc_code, i, 1)) not between ascii('A') and ascii('Z')
      then
        return false;
      end if;
    end loop;
  end if;
  return true;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'IsHtmlEscCode',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/*TODO
/** Enclose all html escape chars like &nbsp; with <xsl:text disable-output-escaping="yes"> element
  * @param pio_clob CLOB
  */
procedure EncloseEscapeChars(
  pio_clob IN OUT NOCOPY CLOB
)
as
l_cur_pos number default 1;
l_end_esc_char number;
l_escape_code varchar2(8);
l_start_comment number default 1;
l_end_comment number default 1;
l_amp_pos number;
begin
  loop
    l_cur_pos := dbms_lob.instr(pio_clob, '&', l_cur_pos);
    while nvl(l_start_comment, 0) > 0 and nvl(l_end_comment, 0) > 0
    loop
      l_start_comment := dbms_lob.instr(pio_clob, '<!--', l_start_comment);
      l_end_comment := dbms_lob.instr(pio_clob, '-->', l_end_comment);
      exit when l_end_comment > l_cur_pos or l_start_comment = 0 or l_end_comment = 0;
      l_end_comment := l_end_comment + length('-->');
      l_start_comment := l_end_comment;
    end loop;

    exit when l_cur_pos = 0;
    if l_cur_pos between l_start_comment and l_end_comment then --escape char is part of comment, skip comment
      l_cur_pos := l_end_comment + length('-->');
    else
      l_end_esc_char := dbms_lob.instr(pio_clob, ';', l_cur_pos);
      exit when l_end_esc_char = 0;
      if l_end_esc_char - l_cur_pos <= 7 then --could be HTML escape code
        l_escape_code := dbms_lob.substr(pio_clob, l_end_esc_char - l_cur_pos + 1, l_cur_pos);
        if IsHtmlEscCode(l_escape_code) then
          XslEncloseString(pio_clob, l_cur_pos, l_escape_code);
        end if;
      else
        l_cur_pos := l_cur_pos + 8;
      end if;
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'EncloseEscapeChars',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Create starter XSLT transformation from HTML produced by MS Office (Word) when saving document as HTML.
  * starter XSLT transformation means that if you apply XSLT to custom XML
  * you get the original HTML. No XML data will be included in resulted HTML.
  * You should build your specific XSLT for transforming XML to
  * MS Office (Word) HTML from this starter XSLT.
  *
  * @param pio_clob IN - MS Word HTML CLOB OUT - Starter XSLT
  */
procedure HTML2XSLT(
  pio_clob IN OUT NOCOPY CLOB
)
as
begin
  MSWordHTMLQAttrXSlWrap(pio_clob);
  EncloseEscapeChars(pio_clob);
  XslEncloseComments(pio_clob);
  EncloseNonXmlElements(pio_clob);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'HTML2XSLT(CLOB)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Creates Starter XSLT from Building block file and then download it
* @param p_BBFile Building block file
* @param p_BBformat Format of Building block file from XSLT processor point of view: F_TEXT, F_HTML, F_XML
* @param p_BB_no_esc_sc Applied only when p_BBformat is F_TEXT. If true then not escape XML special characters.
* You should escape special XML (<,>," and &) characters if Building block file is in RTF format.
* You should not escape special characters if Building block file is in MHT format.
*/
procedure DownloadStarterXSLT(
  p_BBFile                  IN varchar2,
  p_BBformat                IN number
)
as
l_clob CLOB;
l_file_csid number;
begin
  l_clob := pak_blob_util.StaticFile2CLOB(p_BBFile, l_file_csid);
  if p_BBformat = F_MHT then
    MHT2XSLT(l_clob);
  elsif p_BBformat = F_RTF then
    RTF2XSLT(l_clob);
  elsif p_BBformat = F_TEXT then
    Text2XSLT(l_clob);
  elsif p_BBformat = F_HTML then
    HTML2XSLT(l_clob);
  elsif p_BBformat = F_XML then
    XML2XSLT(l_clob);
  end if;
  DownloadConvertOutput(V('APP_ID'), pak_blob_util.clob2blob(l_clob, l_file_csid), p_BBFile||'.Starter.xslt',
    p_error => null,







    p_mime => 'application/xslt+xml',
    p_blob_csid => l_file_csid
  );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadStarterXSLT',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

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
)
as
begin
  if p_dwld_type = g_dwld_xslt then
    DownloadStaticFile(p_xsltStaticFile, 'application/xslt+xml');
  elsif p_dwld_type = g_dwld_second_xslt then
    if p_second_xsltStaticFile is not null then
      DownloadStaticFile(p_second_xsltStaticFile, 'application/xslt+xml');
    end if;
  /*
  elsif p_dwld_type = g_dwld_bb then
    if p_BBFile is not null then
      DownloadStaticFile(p_BBFile, p_mime);
    end if;
  elsif p_dwld_type = g_dwld_starter_xslt then
    if p_BBFile is not null then
      DownloadStarterXSLT(p_BBFile, p_format, p_BB_no_esc_sc);
    end if;
    */
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'DownloadStaticFile',
    p_sqlerrm => sqlerrm
  );
  raise;
end DownloadStaticFile;

function GetAttrValue(
  p_attrs varchar2,
  p_name varchar2
)
return varchar2
as
l_start number;
l_end number;
begin
  l_start := instr(p_attrs,p_name||'="');
  if l_start > 0 then
    l_start := l_start + length(p_name||'="');
    l_end := instr(p_attrs,'"', l_start + 1);
    if l_end > l_start then
      return substr(p_attrs, l_start, l_end - l_start);
    end if;
  end if;
  return null;
end;

function AddStringToFilename(
    P_FILENAME VARCHAR2,
    P_STRING VARCHAR2
  )
  return varchar2
  AS
  l_koncnica number;
  BEGIN
    if P_STRING is null then
      return P_FILENAME;
    end if;
    l_koncnica := INSTR(P_FILENAME, '.', -1, 1);
    if l_koncnica > 0 then
      return SUBSTR(P_FILENAME, 1, l_koncnica-1)||'_'||P_STRING||SUBSTR(P_FILENAME, l_koncnica);
    else
      return P_FILENAME||'_'||P_STRING;
    end if;
  END AddStringToFilename;

  function IsInteger(p_string varchar2)
  return boolean
  as
  begin
    if LENGTH(TRIM(TRANSLATE(p_string, '0123456789', ' '))) is null then return true;
    else return false; end if;
  end;

  function AddNumberToFilename(
    P_FILENAME VARCHAR2,
    P_NUM NUMBER
  )
  return varchar2
  AS
  l_koncnica number(5);
  l_zacetek number(5);
  l_filename varchar2(300);
  l_num varchar2(50);
  BEGIN
    --if already exists number at the end of filename
    l_koncnica := INSTR(P_FILENAME, '.', -1, 1);
    l_zacetek := INSTR(P_FILENAME, '_', -1, 1);

    if l_zacetek >0 and l_koncnica > 0 then
      l_num := substr(p_filename, l_zacetek+1, l_koncnica - l_zacetek -1);
      if IsInteger(l_num) then
        l_filename := replace(p_filename, '_'||l_num||'.', '_'||to_char(p_num)||'.');
      else
        l_filename := AddStringToFilename(P_FILENAME, to_char(P_NUM));
      end if;
    elsif l_zacetek >0 then
      l_num := substr(p_filename, l_zacetek+1);
      if IsInteger(l_num) then
        l_filename := replace(p_filename, '_'||l_num, '_'||to_char(p_num));
      else
        l_filename := AddStringToFilename(P_FILENAME, to_char(P_NUM));
      end if;
    else
      l_filename := AddStringToFilename(P_FILENAME, to_char(P_NUM));
    end if;
    return l_filename;
  END AddNumberToFilename;

function XMLOrSourceFilename(
  p_page_id number,
  pi_regionAttrs tab_string
)
return varchar2
as
l_ret varchar2(4000);
l_name varchar2(4000);
l_IR_name varchar2(4000);
begin
  if p_page_id = V('APP_PAGE_ID') then
    l_ret := 'A'||V('APP_ID')||'_Q'||p_page_id;
  else
    l_ret :=  'A'||V('APP_ID')||'_P'||p_page_id;
  end if;
  for i in 1..pi_regionAttrs.count loop
    if pi_regionAttrs(i) is not null then
      l_name := GetAttrValue(pi_regionAttrs(i),'name');
      l_IR_name := GetAttrValue(pi_regionAttrs(i),'IR_name');
      if l_name is not null then
        l_ret:= l_ret||'_'||l_name;
      end if;
      if l_IR_name is not null then
        l_ret:= l_ret||'_IR_'||l_IR_name;
      end if;
    end if;
  end loop;
  l_ret := trim(substr(translate(l_ret,'?,''":;?*+()/\|&%$#! '||query2report.g_crlf,'______________________'),1, 255));
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XMLOrSourceFilename',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

function XMLOrSourceFilename(
  p_page_id number,
  pi_regionAttr1 varchar2,
  pi_regionAttr2 varchar2,
  pi_regionAttr3 varchar2,
  pi_regionAttr4 varchar2,
  pi_regionAttr5 varchar2
)
return varchar2
as
l_regionAttrs tab_string := tab_string();
begin
  if pi_regionAttr1 is not null then
    l_regionAttrs.extend;
    l_regionAttrs(l_regionAttrs.count) := pi_regionAttr1;
  end if;
  if pi_regionAttr2 is not null then
    l_regionAttrs.extend;
    l_regionAttrs(l_regionAttrs.count) := pi_regionAttr2;
  end if;
  if pi_regionAttr3 is not null then
    l_regionAttrs.extend;
    l_regionAttrs(l_regionAttrs.count) := pi_regionAttr3;
  end if;
  if pi_regionAttr4 is not null then
    l_regionAttrs.extend;
    l_regionAttrs(l_regionAttrs.count) := pi_regionAttr4;
  end if;
  if pi_regionAttr5 is not null then
    l_regionAttrs.extend;
    l_regionAttrs(l_regionAttrs.count) := pi_regionAttr5;
  end if;
  return XMLOrSourceFilename(p_page_id, l_regionAttrs);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XMLOrSourceFilename varchar2 ver.',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

procedure Insert_XPM_XML(
  p_filename varchar2,
  p_xml clob
)as
l_filename varchar2(400);
l_count number;
l_num number := 0;
l_xml BLOB;
begin
  l_filename := p_filename;
  loop
    select count(*) into l_count from xpm_xml where fname = l_filename||'.xml';
    if l_count = 0 then
      l_xml := pak_blob_util.CLOB2BLOB(p_xml);
      insert into xpm_xml(fname, xmlblob) values(l_filename||'.xml', l_xml);
      dbms_lob.freetemporary(l_xml);
      return;
    else
      l_num := l_num + 1;
      l_filename := AddNumberToFilename(l_filename,l_num);
    end if;
  end loop;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Insert_XPM_XML',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

-------------------------------------------------------PUBLIC Query2DownloadReport and Query2CLOBReport procedures--------------------------------------------

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in DOCUMENT/ROWSET element
  * with attributes pi_regionAttrs(N).
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param pi_regionAttrs Set of ROWSET elemenents attributes
  * @param pi_selectQueries Set of selects from which we build temporary XML
  * @param pi_maxRows Set of max rows limits of fetching rows for build temporary XML
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_TemplateFile Filename of Template uploaded inro static files (in Flat OPC format) from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
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
  p_templateStaticFile      in  VARCHAR2, --default null,
  p_external_params         IN varchar2 default null,
  p_second_XsltStaticFile   IN varchar2 default null,
  p_second_external_params  IN varchar2 default null,
  --p_BBFile                 IN varchar2 default null,
  --p_BB_no_esc_sc            IN boolean default false,
  p_convertblob_param       IN varchar2 default null
)
as
l_xml CLOB;
l_filename varchar2(400);
l_reportTypes t_coltype_tables;

begin

  if p_dwld_type in (g_dwld_xml, g_dwld_xml_copyto_xpm, g_dwld_transformed) then
    l_reportTypes := ReportTypesElement(pi_selectQueries);
    l_xml := Query2Xml(pi_regionAttrs, pi_selectQueries, l_reportTypes, pi_maxRows);
    --dbms_xslprocessor.clob2file(l_xml, 'XMLDIR', 'debug1.xml');
    if p_dwld_type in (g_dwld_xml, g_dwld_xml_copyto_xpm) then
      l_filename := XMLOrSourceFilename(p_page_id, pi_regionAttrs);
      DownloadConvertOutput(V('APP_ID'), pak_blob_util.clob2blob(l_xml), l_filename||'.xml',
          p_error => null,
          p_mime => 'text/xml');

      if p_dwld_type = g_dwld_xml_copyto_xpm then
        insert_xpm_xml(l_filename, l_xml);
      end if;
    else
      ----dbms_xslprocessor.clob2file(pio_xml, 'XMLDIR', 'debug2.xml');
      XslTransformAndDownload(
        p_Xml => l_xml,
        p_xsltStaticFile => p_xsltStaticFile,
        p_page_id  => null,
        p_region_name => null,
        p_filename => p_filename,
        pi_regionAttrs => pi_regionAttrs,
        pi_reportTypes => l_reportTypes,
        p_mime => p_mime,
        p_format => p_format,
        p_templateStaticFile => p_templateStaticFile, --default null,
        p_external_params => p_external_params,
        p_second_XsltStaticFile => p_second_XsltStaticFile,
        p_second_external_params => p_second_external_params,
        p_convertblob_param => p_convertblob_param
      );

    end if;
    dbms_lob.freetemporary(l_xml);
  else
    DownloadStaticFile(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      --p_BBFile,
      --p_BB_no_esc_sc,
      p_dwld_type,
      p_mime
    );
  end if;
  commit;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure =>'Query2DownloadReport (tab_string)',
    p_sqlerrm => sqlerrm
  );
  rollback;
  raise;
end;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in DOCUMENT/ROWSET element
  * with attributes pi_regionAttrN.
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param pi_regionAttr1 First ROWSET elemenent attributes.
  * @param pi_selectQuery1 First select from which we build temporary XML. All data is embeeded in pi_regionAttr1 element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionAttr2 Second ROWSET elemenent attributes.
  * @param pi_selectQuery2 Second select from which we build temporary XML. All data is embeeded in pi_regionAttr2 element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionAttr3 Third ROWSET elemenent attributes.
  * @param pi_selectQuery3 Third select from which we build temporary XML. All data is embeeded in pi_regionAttr3 element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionAttr4 Fourth ROWSET elemenent attributes.
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. All data is embeeded in pi_regionAttr4 element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionAttr5 Fifth ROWSET elemenent attributes.
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. All data is embeeded in pi_regionAttr5 element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_BBFile Building block file
  * @param p_BBescapeSC Applied only when p_format is F_TEXT. If true then not escape XML special characters.
  * You should escape special XML (<,>," and &) characters if Building block file is in RTF format.
  * You should not escape special characters if Building block file is in MHT format.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure
  */
procedure Query2DownloadReport
(
  p_xsltStaticFile  IN varchar2,
  p_filename    in VARCHAR2,
  p_dwld_type     in  number default g_dwld_transformed,
  p_mime in VARCHAR2 default 'application/octet',
   pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_page_id         IN number default V('APP_PAGE_ID')
  ,p_format                IN  number default null
  ,p_templateStaticFile    in  VARCHAR2 default null
  ,p_external_params       IN  varchar2 default null
  ,p_second_XsltStaticFile  IN  varchar2 default null
  ,p_second_external_params IN  varchar2 default null,
  --p_BBFile                 IN varchar2 default null,
  --p_BB_no_esc_sc            IN boolean default false,
  p_convertblob_param       IN varchar2 default null
)
as
l_xml CLOB;
l_filename varchar2(400);
l_reportTypes1 T_COLTYPE_TABLE;
l_reportTypes2 T_COLTYPE_TABLE;
l_reportTypes3 T_COLTYPE_TABLE;
l_reportTypes4 T_COLTYPE_TABLE;
l_reportTypes5 T_COLTYPE_TABLE;
l_reportTypes t_coltype_tables;
begin
  if p_dwld_type in (g_dwld_xml, g_dwld_xml_copyto_xpm, g_dwld_transformed) then
    l_reportTypes1 := ReportTypesElementTab(pi_selectQuery1);
    l_reportTypes2 := ReportTypesElementTab(pi_selectQuery2);
    l_reportTypes3 := ReportTypesElementTab(pi_selectQuery3);
    l_reportTypes4 := ReportTypesElementTab(pi_selectQuery4);
    l_reportTypes5 := ReportTypesElementTab(pi_selectQuery5);

    l_xml := Query2Xml
    (
      pi_regionAttr1
      ,pi_selectQuery1
      ,l_reportTypes1
      ,pi_maxRows1
      ,pi_regionAttr2
      ,pi_selectQuery2
      ,l_reportTypes2
      ,pi_maxRows2
      ,pi_regionAttr3
      ,pi_selectQuery3
      ,l_reportTypes3
      ,pi_maxRows3
      ,pi_regionAttr4
      ,pi_selectQuery4
      ,l_reportTypes4
      ,pi_maxRows4
      ,pi_regionAttr5
      ,pi_selectQuery5
      ,l_reportTypes5
      ,pi_maxRows5
    );
    --dbms_xslprocessor.clob2file(l_xml, 'XMLDIR', 'debug1.xml');
    if p_dwld_type in (g_dwld_xml, g_dwld_xml_copyto_xpm) then
      l_filename := XMLOrSourceFilename(p_page_id, pi_regionAttr1, pi_regionAttr2, pi_regionAttr3, pi_regionAttr4, pi_regionAttr5);
      DownloadConvertOutput(V('APP_ID'),  pak_blob_util.clob2blob(l_xml), l_filename||'.xml',
                            p_error => null,
                            p_mime => 'text/xml');

      if p_dwld_type = g_dwld_xml_copyto_xpm then
        insert_xpm_xml(l_filename, l_xml);
      end if;
    else
      l_reportTypes := t_coltype_tables(l_reportTypes1, l_reportTypes2, l_reportTypes3, l_reportTypes4, l_reportTypes5);
      XslTransformAndDownload(
        p_Xml => l_xml,
        p_xsltStaticFile => p_xsltStaticFile,
        p_page_id => null,
        p_region_name => null,
        p_filename => p_filename,
        pi_regionAttrs => tab_string(pi_regionAttr1, pi_regionAttr2, pi_regionAttr3, pi_regionAttr4, pi_regionAttr5),
        pi_reportTypes => l_reportTypes,
        p_mime => p_mime,
        p_format => p_format,
        p_templateStaticFile => p_templateStaticFile, --default null,
        p_external_params => p_external_params,
        p_second_XsltStaticFile => p_second_XsltStaticFile,
        p_second_external_params => p_second_external_params,
        p_convertblob_param => p_convertblob_param
      );
    end if;
    dbms_lob.freetemporary(l_xml);
  else
    DownloadStaticFile(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      --p_BBFile,
      --p_BB_no_esc_sc,
      p_dwld_type,
      p_mime
    );
  end if;
  commit;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2DownloadReport (varchar2)',
    p_sqlerrm => sqlerrm
  );
  rollback;
  raise;
end;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in DOCUMENT/ROWSET element
  * with attributes pi_regionAttrN.
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param pi_regionAttr1 First ROWSET elemenent attributes.
  * @param pi_selectQuery1 First select from which we build temporary XML. All data is embeeded in pi_regionAttr1 element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionAttr2 Second ROWSET elemenent attributes.
  * @param pi_selectQuery2 Second select from which we build temporary XML. All data is embeeded in pi_regionAttr2 element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionAttr3 Third ROWSET elemenent attributes.
  * @param pi_selectQuery3 Third select from which we build temporary XML. All data is embeeded in pi_regionAttr3 element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionAttr4 Fourth ROWSET elemenent attributes.
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. All data is embeeded in pi_regionAttr4 element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionAttr5 Fifth ROWSET elemenent attributes.
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. All data is embeeded in pi_regionAttr5 element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param p_TemplateFile Filename of Template uploaded inro static files (in Flat OPC format) from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @param p_BBFile Building block file
  * @param p_BBescapeSC Applied only when p_BBformat is F_TEXT. If true then not escape XML special characters.
  * You should escape special XML (<,>," and &) characters if Building block file is in RTF format.
  * You should not escape special characters if Building block file is in MHT format.
  * @param p_convertblob_param P_PARAM Parameter of ConvertBLOB procedure
  */
procedure Query2DownloadReport
(
  p_xsltStaticFile  IN varchar2,
  p_filename    in VARCHAR2,
  p_dwld_type     in  number default g_dwld_transformed,
  p_mime in VARCHAR2 default 'application/octet',
  pi_regionAttr1 in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_page_id         IN number default V('APP_PAGE_ID')
  ,p_format                IN    number default null
  ,p_templateStaticFile    in  VARCHAR2 default null
  ,p_external_params       IN    varchar2 default null
  ,p_second_XsltStaticFile  IN  varchar2 default null
  ,p_second_external_params IN  varchar2 default null,
  --p_BBFile                 IN varchar2 default null,
  --p_BB_no_esc_sc            IN boolean default false,
  p_convertblob_param       IN varchar2 default null
)
as
l_xml CLOB;
l_filename varchar2(400);
l_reportTypes t_coltype_table;
l_reportTypesTbl t_coltype_tables;
begin
  if p_dwld_type in (g_dwld_xml, g_dwld_xml_copyto_xpm, g_dwld_transformed) then

    l_xml := Query2Xml
    (
      pi_regionAttr1
      ,pi_selectQuery1
      ,l_reportTypes
      ,pi_maxRows1
      ,pi_regionAttr2
      ,pi_selectQuery2
      ,l_reportTypes
      ,pi_maxRows2
      ,pi_regionAttr3
      ,pi_selectQuery3
      ,l_reportTypes
      ,pi_maxRows3
      ,pi_regionAttr4
      ,pi_selectQuery4
      ,l_reportTypes
      ,pi_maxRows4
      ,pi_regionAttr5
      ,pi_selectQuery5
      ,l_reportTypes
      ,pi_maxRows5
    );
    --dbms_xslprocessor.clob2file(l_xml, 'XMLDIR', 'debug1.xml');
    if p_dwld_type in (g_dwld_xml, g_dwld_xml_copyto_xpm) then
      l_filename := XMLOrSourceFilename(p_page_id, pi_regionAttr1, pi_regionAttr2, pi_regionAttr3, pi_regionAttr4, pi_regionAttr5);
      DownloadConvertOutput(V('APP_ID'),  pak_blob_util.clob2blob(l_xml), l_filename||'.xml',
                            p_error => null,
                            p_mime => 'text/xml');

      if p_dwld_type = g_dwld_xml_copyto_xpm then
        insert_xpm_xml(l_filename, l_xml);
      end if;
    else
      XslTransformAndDownload(
        p_Xml => l_xml,
        p_xsltStaticFile => p_xsltStaticFile,
        p_page_id => null,
        p_region_name => null,
        p_filename => p_filename,
        pi_regionAttrs => tab_string(pi_regionAttr1, pi_regionAttr2, pi_regionAttr3, pi_regionAttr4, pi_regionAttr5),
        pi_reportTypes => l_reportTypesTbl,
        p_mime => p_mime,
        p_format => p_format,
        p_templateStaticFile => p_templateStaticFile, --default null,
        p_external_params => p_external_params,
        p_second_XsltStaticFile => p_second_XsltStaticFile,
        p_second_external_params => p_second_external_params,
        p_convertblob_param => p_convertblob_param
      );
    end if;
    dbms_lob.freetemporary(l_xml);
  else
    DownloadStaticFile(
      p_xsltStaticFile,
      p_second_XsltStaticFile,
      --p_BBFile,
      --p_BB_no_esc_sc,
      p_dwld_type,
      p_mime
    );
  end if;
  commit;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2DownloadReport (SYS_REFCURSOR)',
    p_sqlerrm => sqlerrm
  );
  rollback;
  raise;
end;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in DOCUMENT/ROWSET element
  * with attributes pi_regionAttrs(N).
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML to return tarnsformed output. Temporary XML is output parameter.
  *
  * @param p_Xslt CLOB with first XSLT
  * @param pi_regionAttrs Set of ROWSET elemenents attributes
  * @param pi_selectQueries Set of selects from which we build temporary XML
  * @param pi_maxRows Set of max rows limits of fetching rows for build temporary XML
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to g_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
  * @param p_template  Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_Xslt CLOB with XSLT applied after first XSLT (p_Xslt)
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @po_Xml Temporary XML is output parameter.
  * @return Result of one or two XSLT on temporary XML.
  */
function Query2ClobReport
(
  p_Xslt                    IN CLOB,
  pi_regionAttrs            in tab_string,
  pi_selectQueries          IN tab_string,
  pi_maxRows                IN tab_integer,
  p_format                  IN number default null,
  po_error                  OUT varchar2,
  p_Template                IN CLOB default null,
  p_external_params         IN varchar2 default null,
  p_second_Xslt             IN CLOB default null,
  p_second_external_params  IN varchar2 default null,
  po_xml                    OUT CLOB
)
return BLOB
as
l_reportTypes t_coltype_tables;
begin
    l_reportTypes := ReportTypesElement(pi_selectQueries);
    po_xml := Query2Xml(pi_regionAttrs, pi_selectQueries, l_reportTypes, pi_maxRows);
    --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug.xml');
    return XslTransformEx
    (
      p_Xml => po_Xml,
      p_Xslt => p_Xslt,
      p_format => p_format,
      po_error => po_error,
      p_template => p_template,
      p_external_params => p_external_params,
      p_second_Xslt => p_second_Xslt,
      p_second_external_params => p_second_external_params
    );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure =>'Query2ClobReport (tab_string)',
    p_sqlerrm => sqlerrm
  );
  raise;
end Query2ClobReport;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in DOCUMENT/ROWSET element
  * with attributes pi_regionAttrN.
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param pi_regionAttr1 First child of DOCUMENT node
  * @param pi_selectQuery1 First select from which we build temporary XML. All data is embeeded in pi_regionAttr1 element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionAttr2 Second child of DOCUMENT node.
  * @param pi_selectQuery2 Second select from which we build temporary XML. All data is embeeded in pi_regionAttr2 element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionAttr3 Third child of DOCUMENT node
  * @param pi_selectQuery3 Third select from which we build temporary XML. All data is embeeded in pi_regionAttr3 element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionAttr4 Fourth child of DOCUMENT node
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. All data is embeeded in pi_regionAttr4 element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionAttr5 Fifth child of DOCUMENT node
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. All data is embeeded in pi_regionAttr5 element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to g_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
  * @param p_template  Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @po_Xml Temporary XML is output parameter.
  * @return Result of one or two XSLT on temporary XML.
  */
function Query2ClobReport
(
  p_Xslt              IN CLOB,
   pi_regionAttr1     in varchar2 default null
  ,pi_selectQuery1   IN varchar2 default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2 in varchar2 default null
  ,pi_selectQuery2   IN varchar2 default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3 in varchar2 default null
  ,pi_selectQuery3   IN varchar2 default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4 in varchar2 default null
  ,pi_selectQuery4   IN varchar2 default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN varchar2 default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_format                  IN number default null
  ,po_error                  OUT varchar2
  ,p_Template                IN CLOB default null
  ,p_external_params       IN  varchar2 default null
  ,p_second_Xslt           IN CLOB default null
  ,p_second_external_params IN  varchar2 default null
  ,po_xml                   OUT CLOB
)
return BLOB
as

begin
  po_xml := Query2Xml
  (
    pi_regionAttr1
    ,pi_selectQuery1
    ,ReportTypesElementTab(pi_selectQuery1)
    ,pi_maxRows1
    ,pi_regionAttr2
    ,pi_selectQuery2
    ,ReportTypesElementTab(pi_selectQuery2)
    ,pi_maxRows2
    ,pi_regionAttr3
    ,pi_selectQuery3
    ,ReportTypesElementTab(pi_selectQuery3)
    ,pi_maxRows3
    ,pi_regionAttr4
    ,pi_selectQuery4
    ,ReportTypesElementTab(pi_selectQuery4)
    ,pi_maxRows4
    ,pi_regionAttr5
    ,pi_selectQuery5
    ,ReportTypesElementTab(pi_selectQuery5)
    ,pi_maxRows5
  );
  --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug1.xml');
  return XslTransformEx
  (
    p_Xml => po_Xml,
    p_Xslt => p_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params,
    p_second_Xslt => p_second_Xslt,
    p_second_external_params => p_second_external_params
  );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2ClobReport (varchar2)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Queries data with multiple selects in pi_selectQueries then convert data to temporary XML.
  * XML fragment which contains data from N-th single select is embeeded in DOCUMENT/ROWSET element
  * with attributes pi_regionAttrN.
  * One (p_xsltStaticFile) or two (p_xsltStaticFile, p_second_XsltStaticFile) XSLT transformations
  * are applied to temporary XML. Output is then downloaded in APEX enviroment.
  *
  * @param p_xsltStaticFile Filename of APEX static file with XSLT
  * @param p_filename Filename of downloaded output
  * @param p_dwld_type What to download: transformed output (default), input XML, XSLT, second XSLT, building block file, starter XSLT
  * @param p_mime Mime type of downloaded file
  * @param pi_regionAttr1 First child of DOCUMENT node
  * @param pi_selectQuery1 First select from which we build temporary XML. All data is embeeded in pi_regionAttr1 element.
  * @param pi_maxRows1 Number of max rows fetched from first select
  * @param pi_regionAttr2 Second child of DOCUMENT node.
  * @param pi_selectQuery2 Second select from which we build temporary XML. All data is embeeded in pi_regionAttr2 element.
  * @param pi_maxRows2 Number of max rows fetched from second select
  * @param pi_regionAttr3 Third child of DOCUMENT node
  * @param pi_selectQuery3 Third select from which we build temporary XML. All data is embeeded in pi_regionAttr3 element.
  * @param pi_maxRows3 Number of max rows fetched from third select
  * @param pi_regionAttr4 Fourth child of DOCUMENT node
  * @param pi_selectQuery4 Fourth select from which we build temporary XML. All data is embeeded in pi_regionAttr4 element.
  * @param pi_maxRows4 Number of max rows fetched from fourth select
  * @param pi_regionAttr5 Fifth child of DOCUMENT node
  * @param pi_selectQuery5 Fifth select from which we build temporary XML. All data is embeeded in pi_regionAttr5 element.
  * @param pi_maxRows5 Number of max rows fetched from fifth select
  * @param p_format Output format. Must be set for OOXML or MHT format.
  * @param po_OOXML If p_format is set to g_ooxml OOXML (DOCX or XLSX) BLOB will be returned.
  * @param p_template  Template in Flat OPC format from where static parts of po_OOXML come. Actual only if p_format is set to g_ooxml.
  * @param p_external_params External parameters for transformation p_xslt.
  * Format for single parameter is name='value'. Example: p_external_params=> 'startX=''50'' baseColor=''magenta'''
  * Notice that we had to put single quotes around the text value magenta!
  * @param p_second_XsltStaticFile Filename of APEX static file with XSLT applied after p_xsltStaticFile
  * @param p_second_external_params External parameters for transformation p_second_XsltStaticFile.
  * See format notes at p_external_params parameter.
  * @po_Xml Temporary XML is output parameter.
  * @return Result of one or two XSLT on temporary XML.
  */
function Query2ClobReport
(
  p_Xslt            IN CLOB,
  pi_regionAttr1    in varchar2 default null
  ,pi_selectQuery1   IN SYS_REFCURSOR default null
  ,pi_maxRows1       IN pls_integer default 20
  ,pi_regionAttr2    in varchar2 default null
  ,pi_selectQuery2   IN SYS_REFCURSOR default null
  ,pi_maxRows2       IN pls_integer default 20
  ,pi_regionAttr3     in varchar2 default null
  ,pi_selectQuery3   IN SYS_REFCURSOR default null
  ,pi_maxRows3       IN pls_integer default 20
  ,pi_regionAttr4     in varchar2 default null
  ,pi_selectQuery4   IN SYS_REFCURSOR default null
  ,pi_maxRows4       IN pls_integer default 20
  ,pi_regionAttr5 in varchar2 default null
  ,pi_selectQuery5   IN SYS_REFCURSOR default null
  ,pi_maxRows5       IN pls_integer default 20
  ,p_format                  IN number default null
  ,po_error                  OUT varchar2
  ,p_Template                IN CLOB default null
  ,p_external_params         IN    varchar2 default null
  ,p_second_Xslt             IN CLOB default null
  ,p_second_external_params  IN  varchar2 default null
  ,po_Xml                    OUT CLOB
)
return BLOB
as
l_reportTypes t_coltype_table;
begin
  po_xml := Query2Xml
  (
    pi_regionAttr1
    ,pi_selectQuery1
    ,l_reportTypes
    ,pi_maxRows1
    ,pi_regionAttr2
    ,pi_selectQuery2
    ,l_reportTypes
    ,pi_maxRows2
    ,pi_regionAttr3
    ,pi_selectQuery3
    ,l_reportTypes
    ,pi_maxRows3
    ,pi_regionAttr4
    ,pi_selectQuery4
    ,l_reportTypes
    ,pi_maxRows4
    ,pi_regionAttr5
    ,pi_selectQuery5
    ,l_reportTypes
    ,pi_maxRows5
  );
  --dbms_xslprocessor.clob2file(po_xml, 'XMLDIR', 'debug1.xml');
  return XslTransformEx
  (
    p_Xml => po_Xml,
    p_Xslt => p_Xslt,
    p_format => p_format,
    po_error => po_error,
    p_template => p_template,
    p_external_params => p_external_params,
    p_second_Xslt => p_second_Xslt,
    p_second_external_params => p_second_external_params
  );
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2ClobReport (SYS_REFCURSOR)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
-------------------------------------------------END of PUBLIC Query2DownloadReport and Query2CLOBReport procedures--------------------------------------------


 procedure RemoveRTFComments(
  pio_rtf     IN OUT NOCOPY CLOB
)
as
l_start_comment number := 1;
l_end_comment   number;
l_rtf CLOB;
begin
  dbms_lob.createtemporary(l_rtf, false);
  loop
    l_start_comment := dbms_lob.instr(pio_rtf, '{\*\', l_start_comment);
    l_end_comment := dbms_lob.instr(pio_rtf, ';}', l_start_comment);
    exit when nvl(l_start_comment, 0) = 0 or nvl(l_end_comment, 0) = 0;
    dbms_lob.copy(l_rtf, pio_rtf, l_start_comment - 1);
    dbms_lob.copy(l_rtf, pio_rtf, dbms_lob.getlength(pio_rtf) - l_end_comment - length(';}') + 1,
                  dbms_lob.getlength(l_rtf) + 1, l_end_comment + length(';}'));
    pio_rtf := l_rtf;
    dbms_lob.trim(l_rtf, 0);
  end loop;
  if ascii(dbms_lob.substr(pio_rtf, 1, dbms_lob.getlength(pio_rtf))) = 0 then
    dbms_lob.trim(pio_rtf, dbms_lob.getlength(pio_rtf)-1);
  end if;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'RemoveRTFComments',
    p_sqlerrm => sqlerrm
  );
  raise;
end;


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
)
as
l_clob      CLOB;
--l_file_csid number;
l_format    number := p_format;
l_filetype  varchar2(5);
l_parts     varchar2(4000);


begin

  pak_xslt_log.WriteLog(
    'Start pio_templ: '||dbms_lob.getlength(pio_templ)||' p_format: '||p_format||' p_nls_charset: '||p_nls_charset,
    p_procedure => 'Template2XSLT (BLOB)'
  );

  l_clob := pak_blob_util.BLOB2CLOB(pio_templ, NLS_CHARSET_ID(p_nls_charset));

  Template2XSLT(l_clob, p_format, p_partsToTransform);

  pak_xslt_log.WriteLog(
    'Finish pio_templ: '||dbms_lob.getlength(pio_templ),
    p_procedure => 'Template2XSLT (BLOB)'
  );

  pio_templ := pak_blob_util.CLOB2BLOB(l_clob,  NLS_CHARSET_ID(p_nls_charset));


exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Template2XSLT (BLOB)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

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
)
as
begin

  pak_xslt_log.WriteLog(
    'Start pio_templ: '||dbms_lob.getlength(pio_templ)||' p_format: '||p_format,
    p_procedure => 'Query2Report.Template2XSLT (CLOB)',
    p_log_type => pak_xslt_log.g_warning
  );

  if p_format = f_ooxml then
    FLAT_OPC_PKG.FlatOPCTransfromedOnly(pio_templ, p_partsToTransform);
    XML2XSLT(pio_templ);
  end if;

  if p_format = f_html then
    HTML2XSLT(pio_templ);
  end if;
  if p_format = f_rtf then
    RTF2XSLT(pio_templ);
  end if;
  if p_format = f_mht then
    MHT2XSLT(pio_templ);
  end if;
  if p_format = f_text then
    Text2XSLT(pio_templ);
  end if;
  if p_format = f_xml then
    XML2XSLT(pio_templ);
  end if;

  pak_xslt_log.WriteLog(
    'Finish pio_templ: '||dbms_lob.getlength(pio_templ),
    p_procedure => 'Template2XSLT (CLOB)'
  );

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Template2XSLT (CLOB)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;







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
)as
l_templ CLOB;

begin
  l_templ := pak_blob_util.READ2CLOB(p_templDir, p_templFile, p_nls_charset);
  Template2XSLT(l_templ, p_format, p_partsToTransform);

  dbms_xslprocessor.clob2file(l_templ, p_xsltDir, p_xsltFile, nvl(NLS_CHARSET_ID(p_nls_charset), 0));

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Template2XSLT (file)',
    p_sqlerrm => sqlerrm
  );
  raise;
end;
$end

function GetAttributeValues(
  p_xslt CLOB,
  p_element varchar2,
  p_attribute varchar2
)
return tab_string
as
l_ret tab_string := tab_string();
l_start_element number;
l_end_element number := 1;
l_start_attribute number;
l_end_attribute number;
l_attribute varchar(400);
l_attribute_val varchar(400);

function ValueExists(p_tab_string tab_string, p_value varchar2)
return boolean
as
begin
  for i in 1..p_tab_string.count loop
    if p_tab_string(i)=p_value then
      return true;
    end if;
  end loop;
  return false;
end;

begin
  loop
    l_start_element := dbms_lob.instr(p_xslt, '<'||p_element, l_end_element);
    exit when nvl(l_start_element, 0) = 0;
    l_end_element := dbms_lob.instr(p_xslt, '>', l_start_element);
    exit when nvl(l_end_element, 0) = 0;
    l_start_attribute := dbms_lob.instr(p_xslt, ' '||p_attribute, l_start_element);
    if l_start_attribute between l_start_element and l_end_element then
      l_end_attribute := dbms_lob.instr(p_xslt, '"', l_start_attribute, 2);
      if l_end_attribute between l_start_element and l_end_element then
        l_attribute := dbms_lob.substr(p_xslt, l_end_attribute - l_start_attribute + 1, l_start_attribute);
        l_attribute := replace(l_attribute, ' ');
        l_attribute := replace(l_attribute, chr(13)||chr(10));
        l_attribute := replace(l_attribute, chr(10));
        if l_attribute like p_attribute||'="%"' then --get what is inside quotes
          l_attribute_val := substr(l_attribute, length(p_attribute||'="')+1, length(l_attribute) - length(p_attribute||'="')-1);
          if not ValueExists(l_ret, l_attribute_val) then
            l_ret.extend;
            l_ret(l_ret.count) := l_attribute_val;
          end if;
        end if;
      end if;
    end if;
  end loop;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error p_element: '||p_element||' p_attribute: '||p_attribute,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.GetAttributeValues',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

function GetAttrValueOffset(
  p_xslt          IN CLOB,
  p_element       IN varchar2,
  p_attribute     IN varchar2,
  p_value         IN varchar2,
  po_end_tag      OUT number,
  pio_end_element   IN OUT number
)
return number
as
l_start_element number;
l_next_start_element number;
l_start_attribute number;
l_end_attribute number;
l_attribute varchar(400);
l_attribute_val varchar(400);
l_closing_length number;

begin
  loop
    l_start_element := dbms_lob.instr(p_xslt, '<'||p_element, pio_end_element);
    exit when nvl(l_start_element, 0) = 0;
    po_end_tag := dbms_lob.instr(p_xslt, '>', l_start_element + length('<'||p_element));
    pio_end_element := dbms_lob.instr(p_xslt, '/>', l_start_element + length('<'||p_element));
    l_closing_length := length('/>');
    l_next_start_element := dbms_lob.instr(p_xslt, '<', l_start_element + length('<'||p_element));
    if l_next_start_element < pio_end_element then
      pio_end_element := dbms_lob.instr(p_xslt, '</'||p_element||'>', l_start_element + length('<'||p_element));
      l_closing_length := length('</'||p_element||'>');
    end if;
    exit when nvl(pio_end_element, 0) = 0;
    pio_end_element := pio_end_element + l_closing_length;
    l_start_attribute := dbms_lob.instr(p_xslt, ' '||p_attribute, l_start_element);
    if l_start_attribute between l_start_element and pio_end_element then
      l_end_attribute := dbms_lob.instr(p_xslt, '"', l_start_attribute, 2);
      if l_end_attribute between l_start_element and po_end_tag then
        l_attribute := dbms_lob.substr(p_xslt, l_end_attribute - l_start_attribute + 1, l_start_attribute);
        l_attribute := replace(l_attribute, ' ');
        l_attribute := replace(l_attribute, chr(13)||chr(10));
        l_attribute := replace(l_attribute, chr(10));
        if l_attribute like p_attribute||'="%"' then --get what is inside quotes
          l_attribute_val := substr(l_attribute, length(p_attribute||'="')+1, length(l_attribute) - length(p_attribute||'="')-1);
          if upper(l_attribute_val) = upper(p_value) then
            return l_start_element;
          elsif lower(p_attribute) = 'match' then --don't need exact match
            if substr(l_attribute_val, 1, 1) != '/' then
              l_attribute_val := '/'||l_attribute_val;
            end if;
            if substr(l_attribute_val, length(l_attribute_val), 1) != '/' then
              l_attribute_val := l_attribute_val||'/';
            end if;
            if instr('/'||p_value||'/', l_attribute_val) > 0 then
              return l_start_element;
            end if;
          end if;--lower(p_attribute) = 'match'
        end if;
      end if;
    end if;
  end loop;
  return null;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error p_element: '||p_element||' p_attribute: '||p_attribute,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.GetAttrValueOffset',
    p_sqlerrm => sqlerrm
  );
  raise;
end GetAttrValueOffset;


function GetTemplateMatches(p_xslt CLOB)
return tab_string
as
begin
  return GetAttributeValues(p_xslt, 'xsl:apply-templates', 'select');
end;

function GetTemplateNames(p_xslt CLOB)
return tab_string
as
begin
  return GetAttributeValues(p_xslt, 'xsl:call-template', 'name');
end;

procedure MainTemplateLimits(p_xslt IN CLOB, po_start_tmpl OUT NUMBER, po_end_tmpl OUT NUMBER)
as
c_start_tmpl constant varchar2(40):= '<xsl:template match="/">';
c_end_tmpl constant varchar2(40):= '</xsl:template>';
l_start_tmpl_crlf number;
begin
  po_start_tmpl:= dbms_lob.instr(p_xslt, c_start_tmpl)+length(c_start_tmpl);
  l_start_tmpl_crlf:= dbms_lob.instr(p_xslt, c_start_tmpl||g_crlf)+length(c_start_tmpl||g_crlf);
  if nvl(l_start_tmpl_crlf, 0) > po_start_tmpl then
    po_start_tmpl := l_start_tmpl_crlf;
  end if;
  po_end_tmpl:= dbms_lob.instr(p_xslt, c_end_tmpl, po_start_tmpl);
  /*
  if nvl(po_start_tmpl, 0) = 0 or nvl(l_end_tmpl, 0) = 0 then
    return;
  end if;
  */
end;

procedure AppendModifiedElelmentTag(
  p_dest IN OUT NOCOPY CLOB,
  p_source CLOB,
  p_amount number,
  p_offset number,
  p_replace_otag varchar2,
  p_replace_ctag varchar2
)
as
l_element_string varchar2(4000);
begin
  l_element_string := dbms_lob.substr(p_source, p_amount, p_offset);
  l_element_string := replace(l_element_string,'<', p_replace_otag);
  l_element_string := substr(l_element_string, 1, length(l_element_string)-1)|| p_replace_ctag;
  dbms_lob.writeappend(p_dest, length(l_element_string), l_element_string); --write start element tag with <> replaced
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error p_amount: '||p_amount||' p_offset: '||p_offset,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.AppendModifiedElelmentTag',
    p_sqlerrm => sqlerrm
  );
  raise;
end AppendModifiedElelmentTag;

function ModifiedElelmentTag(
  p_source CLOB,
  p_amount number,
  p_offset number,
  p_replace_otag varchar2 default null,
  p_replace_ctag varchar2 default null
)
return varchar2
as
l_ret varchar2(400);
begin
  l_ret := dbms_lob.substr(p_source, p_amount, p_offset);
  if p_replace_otag is null or p_replace_ctag is null or
    l_ret like '<xsl:processing-instruction name="%'
  then --
    l_ret := replace(l_ret, '<xsl:processing-instruction name="','<?');
    l_ret := replace(l_ret, '</xsl:processing-instruction>','?>');
    l_ret := replace(l_ret, '">',' ');
  else
    l_ret := replace(l_ret,'<', p_replace_otag);
    l_ret := substr(l_ret, 1, length(l_ret)-1)|| p_replace_ctag;
  end if;
  return l_ret;
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error p_amount: '||p_amount||' p_offset: '||p_offset,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.ModifiedElelmentTag',
    p_sqlerrm => sqlerrm
  );
  raise;
end;

/** Procedure is called just inside XSLTInsertTemplates. It includes code from selected xsl:template into main template.
    Template call <xsl:apply-templates> or <xsl:call-template> is "commented out"
  * @param pio_xslt On input CLOB representing XSLT on output document.
  * @param p_element <xsl:apply-templates> element or <xsl:call-template> element which will be replaced with actual template code in main XSLT template
  * @param p_attribute Attribute "select" of <xsl:call-template> element or "match" of <xsl:apply-templates> element
  * @param p_value Value of attribute
  * @param p_replace_otag Opening <xsl:apply-templates> and <xsl:call-template> tag <xsl: will be replaced with p_replace_otag.
  * @param p_replace_ctag Closing <xsl:apply-templates> and <xsl:call-template> tag > will be replaced with p_replace_ctag.
  */
procedure XSLTInsertTemplate(
  pio_xslt IN OUT NOCOPY CLOB,
  p_element       IN varchar2,
  p_attribute     IN varchar2,
  p_value         IN varchar2,
  p_replace_otag varchar2 default '&lt;',
  p_replace_ctag varchar2 default '&gt;'
)
as
l_start_tmpl    number;
l_end_tmpl      number;
l_end_element   number := 1;
l_end_tag       number;
l_start_element number;
l_start_template number;
l_end_template  number;
l_attribute varchar2(400);
--l_element_string varchar2(4000);
l_temp CLOB;
begin
  pak_xslt_log.WriteLog(
    'Start XSLTInsertTemplate p_element '||p_element||' p_attribute '||p_attribute||
    ' p_value '||p_value||
    ' p_replace_otag '||p_replace_otag||' p_replace_ctag '||p_replace_ctag,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'Query2Report.XSLT2Document'
  );

  if p_attribute = 'select' and p_element = 'xsl:apply-templates' then
    l_attribute := 'match';
  else
    l_attribute := p_attribute;
  end if;

  dbms_lob.createTemporary(l_temp, false);
  loop
    MainTemplateLimits(pio_xslt, l_start_tmpl, l_end_tmpl); --find main xsl template limits (match="/")

    if nvl(l_start_tmpl, 0) = 0 or nvl(l_end_tmpl, 0) = 0 then
      return;
    end if;
    l_end_template := l_end_tmpl;
    --find first <xsl:apply-templates select="matchattr"> element
    l_start_element := GetAttrValueOffset(pio_xslt, p_element, p_attribute, p_value, l_end_tag, l_end_element);
    exit when nvl(l_start_element, 0) = 0;

    dbms_lob.copy(l_temp, pio_xslt, l_start_element - 1, 1, 1); --write till l_start_element

     --replace start and end element and write start element tag with <> replaced
    AppendModifiedElelmentTag(
      l_temp,
      pio_xslt,
      l_end_tag - l_start_element + 1,
      l_start_element,
      p_replace_otag,
      p_replace_ctag
    );

    --loop
    --find <xsl:template match="matchattr"> in pio_xslt and copy templates after
    l_start_template := GetAttrValueOffset(pio_xslt, 'xsl:template', l_attribute, p_value, l_end_tag, l_end_template);
    if l_start_template > 0 then --found template

      --replace start and end element and write start element tag with <> replaced
      AppendModifiedElelmentTag(
        l_temp,
        pio_xslt,
        l_end_tag - l_start_template + 1,
        l_start_template,
        p_replace_otag,
        p_replace_ctag
      );

      dbms_lob.copy(l_temp, pio_xslt, l_end_template - length('</xsl:template>') - l_end_tag - 1, dbms_lob.getlength(l_temp) + 1, l_end_tag + 1); --write template to l_temp
      dbms_lob.writeappend(l_temp, length(p_replace_otag||'/xsl:template'||p_replace_ctag), p_replace_otag||'/xsl:template'||p_replace_ctag); --write end element tag with <> replaced

      --dbms_lob.copy(l_temp, pio_xslt, l_start_template - l_end_element, dbms_lob.getlength(l_temp) + 1, l_end_element); --write chunk from l_end_element to l_start_template
      --dbms_lob.copy(l_temp, pio_xslt, dbms_lob.getlength(pio_xslt) - l_end_template, dbms_lob.getlength(l_temp) + 1, l_end_template);--write chunk from l_end_template till end
      dbms_lob.copy(l_temp, pio_xslt, dbms_lob.getlength(pio_xslt) - l_end_element +1, dbms_lob.getlength(l_temp) + 1, l_end_element);--write chunk from l_end_template till end
      pio_xslt := l_temp;
      dbms_lob.trim(l_temp, 0);
      ----dbms_xslprocessor.clob2file(pio_xslt, 'XMLDIR', 'debug_loop.doc.xml');
    else
      --not found template, just copy entire blob from l_end_element to l_temp
      dbms_lob.copy(l_temp, pio_xslt, dbms_lob.getlength(pio_xslt) - l_end_element, dbms_lob.getlength(l_temp) + 1, l_end_element);
      pio_xslt := l_temp;
      dbms_lob.trim(l_temp, 0);
      ----dbms_xslprocessor.clob2file(pio_xslt, 'XMLDIR', 'debug_loop.doc.xml');
      exit;
    end if;
    --end loop;

  end loop;
  dbms_lob.freeTemporary(l_temp);

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.XSLTInsertTemplate',
    p_sqlerrm => sqlerrm
  );
  raise;
end XSLTInsertTemplate;

procedure XslRemoveComments(
  pio_clob IN OUT NOCOPY CLOB
)
as
  l_start_comment number default 1;
  l_end_comment number default 1;
  l_temp CLOB;
begin
  dbms_lob.createtemporary(l_temp, false);
  loop
    l_start_comment := dbms_lob.instr(pio_clob, '<!--', l_start_comment);
    exit when nvl(l_start_comment, 0) = 0;
    l_end_comment := dbms_lob.instr(pio_clob, '-->', l_start_comment);
    exit when nvl(l_end_comment, 0) = 0;
    l_end_comment := l_end_comment + length('-->');
    dbms_lob.copy(l_temp, pio_clob, l_start_comment - 1, 1, 1);
    dbms_lob.copy(l_temp, pio_clob, dbms_lob.GetLength(pio_clob) - l_end_comment + 1, dbms_lob.GetLength(l_temp) + 1 , l_end_comment);
    pio_clob := l_temp;
    dbms_lob.trim(l_temp, 0);
  end loop;
  dbms_lob.freetemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslRemoveComments',
    p_sqlerrm => sqlerrm
  );
  raise;
end XslRemoveComments;

/** Procedure is called just in the begining of next procedure XSLT2Document. It includes code from selected xsl:templates into main template.
    Template calls <xsl:apply-templates> and <xsl:call-template> are "commented out"
  * @param pio_xslt On input CLOB representing XSLT on output document.
  * @param p_match_templates Select attributes of <xsl:apply-templates> elements which will be replaced with actual template code in main XSLT template
  * @param p_name_templates Name attributes of <xsl:call-template> elements which will be replaced with actual template code in main XSLT template
  * @param p_replace_otag Opening <xsl:apply-templates> and <xsl:call-template> tag <xsl: will be replaced with p_replace_otag.
  * @param p_replace_ctag Closing <xsl:apply-templates> and <xsl:call-template> tag > will be replaced with p_replace_ctag.
  */
procedure XSLTInsertTemplates(
  pio_xslt IN OUT NOCOPY CLOB,
  p_match_templates tab_string,
  p_name_templates tab_string,
  p_replace_otag varchar2 default '&lt;',
  p_replace_ctag varchar2 default '&gt;'
)
as

begin
  pak_xslt_log.WriteLog(
    'Start XSLTInsertTemplates match templates '||p_match_templates.count||' name templates '||p_name_templates.count||
    ' p_replace_otag '||p_replace_otag||' p_replace_ctag '||p_replace_ctag,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'Query2Report.XSLT2Document'
  );

  XslRemoveComments(pio_xslt);

  for i in 1..p_match_templates.count loop
    --find <xsl:apply-templates select="attr"> in pio_xslt and copy templates after
    XSLTInsertTemplate(pio_xslt, 'xsl:apply-templates', 'select', p_match_templates(i), p_replace_otag, p_replace_ctag);
    ----dbms_xslprocessor.clob2file(pio_xslt, 'XMLDIR', 'debug_select.doc'||i||'_'||p_match_templates(i)||'.xml');
  end loop;

  --for i in 1..p_name_templates.count loop
  for i in 1..p_name_templates.count loop
    --find <xsl:call-template name="nameattr"> in pio_xslt and copy templates after. nameattr must match
    XSLTInsertTemplate(pio_xslt, 'xsl:call-template', 'name', p_name_templates(i), p_replace_otag, p_replace_ctag);
    ----dbms_xslprocessor.clob2file(pio_xslt, 'XMLDIR', 'debug_match.doc'||i||'_'||p_name_templates(i)||'.xml');
  end loop;
  --end loop;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'Query2Report.XSLTInsertTemplates',
    p_sqlerrm => sqlerrm
  );
  raise;
end XSLTInsertTemplates;

/** Create (Office) document from XSLT.
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
)
as
l_start_tmpl number;
l_end_tmpl number;

c_workbook_start_crlf constant varchar2(400):='<xsl:text disable-output-escaping="yes">'||g_crlf||
'<![CDATA[';

c_workbook_end_crlf constant varchar2(400):=']]>'||g_crlf||
'</xsl:text>';

c_workbook_start_lf constant varchar2(400):='<xsl:text disable-output-escaping="yes">'||chr(10)||
'<![CDATA[';

c_workbook_end_lf constant varchar2(400):=']]>'||chr(10)||
'</xsl:text>';

l_start_xsl_text varchar2(20);
l_xsl_text_element boolean;
l_start_xsl number;
l_start_cxsl number;
l_start_copy number;
l_end_xsl number;
l_start_pi number;
l_end_pi number;
l_temp CLOB;
l_str_replace_with varchar2(32000);
l_start_remove number;
l_end_remove number;
begin
  pak_xslt_log.WriteLog(
    'Start XSLT2Document p_basic_format_name '||p_basic_format_name||' p_xml_procinstr '||p_xml_procinstr||
    ' match templates '||p_match_templates.count||' name templates '||p_name_templates.count||
    ' p_replace_otag '||p_replace_otag||' p_replace_ctag '||p_replace_ctag,
    p_log_type => pak_xslt_log.g_warning,
    p_procedure => 'Query2Report.XSLT2Document'
  );

  XSLTInsertTemplates(
    pio_xslt,
    p_match_templates,
    p_name_templates,
    p_replace_otag,
    p_replace_ctag
  );

  ----dbms_xslprocessor.clob2file(pio_xslt, 'XMLDIR', 'debug.doc.xml');

  MoveXMLNS(pio_xslt, 'xsl:stylesheet', 'w:wordDocument');
  MoveXMLNS(pio_xslt, 'xsl:stylesheet', 'Workbook');


  if dbms_lob.instr(pio_xslt, c_workbook_start_crlf||'<Workbook')> 0 or
    dbms_lob.instr(pio_xslt, c_workbook_start_lf||'<Workbook')> 0
  then
    pak_blob_util.clobReplaceAll(pio_xslt, c_workbook_start_crlf||'<Workbook', '<Workbook');
    pak_blob_util.clobReplaceAll(pio_xslt, c_workbook_start_lf||'<Workbook', '<Workbook');

    --odstrani od prvi ]]> do </xsl:text>
    l_start_remove := dbms_lob.instr(pio_xslt,']]>');
    l_end_remove := dbms_lob.instr(pio_xslt,'</xsl:text>');
    if l_start_remove > 0 and l_end_remove > 0 and l_end_remove > l_start_remove then
      pak_blob_util.clobReplace(pio_xslt, ']]>', '', l_start_remove, l_end_remove);
      pak_blob_util.clobReplace(pio_xslt, '</xsl:text>', '', l_start_remove, l_end_remove);
    end if;
  end if;

  pak_blob_util.clobReplaceAll(pio_xslt, c_workbook_start_crlf||'</Workbook>'||c_workbook_end_crlf, '</Workbook>');
  pak_blob_util.clobReplaceAll(pio_xslt, c_workbook_start_lf||'</Workbook>'||c_workbook_end_lf, '</Workbook>');

  if p_basic_format_name = 'mht' then
    pak_blob_util.clobReplaceAll(pio_xslt, chr(13)||g_crlf, g_crlf);
    /*
    pak_blob_util.clobReplaceAll(pio_xslt, '</xsl:text>'||g_crlf||g_crlf||g_crlf, '</xsl:text>');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||g_crlf||g_crlf||'<xsl:text', '<xsl:text');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||g_crlf||g_crlf||'<![CDATA[', '');
    pak_blob_util.clobReplaceAll(pio_xslt, ']]>'||g_crlf||g_crlf||g_crlf, '');


    pak_blob_util.clobReplaceAll(pio_xslt, '</xsl:text>'||g_crlf||g_crlf, '</xsl:text>');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||g_crlf||'<xsl:text', '<xsl:text');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||g_crlf||'<![CDATA[', '');
    pak_blob_util.clobReplaceAll(pio_xslt, ']]>'||g_crlf||g_crlf, '');
    */

    pak_blob_util.clobReplaceAll(pio_xslt, '</xsl:text>'||g_crlf, '</xsl:text>');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||'<xsl:text', '<xsl:text');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||'<![CDATA[', '');
    pak_blob_util.clobReplaceAll(pio_xslt, ']]>'||g_crlf, '');

  elsif p_basic_format_name != 'xml' then
    pak_blob_util.clobReplaceAll(pio_xslt, '</xsl:text>'||g_crlf, '</xsl:text>');
    pak_blob_util.clobReplaceAll(pio_xslt, g_crlf||'<xsl:text', '<xsl:text');
  end if;

  pak_blob_util.clobReplaceAll(pio_xslt, '<![CDATA[', '');
  pak_blob_util.clobReplaceAll(pio_xslt, ']]>', '');

  /*
  l_start_tmpl:= dbms_lob.instr(pio_xslt, c_start_tmpl)+length(c_start_tmpl);
  l_start_tmpl_crlf:= dbms_lob.instr(pio_xslt, c_start_tmpl||g_crlf)+length(c_start_tmpl||g_crlf);
  if nvl(l_start_tmpl_crlf, 0) > l_start_tmpl then
    l_start_tmpl := l_start_tmpl_crlf;
  end if;
  l_end_tmpl:= dbms_lob.instr(pio_xslt, c_end_tmpl, l_start_tmpl);
  */
  MainTemplateLimits(pio_xslt, l_start_tmpl, l_end_tmpl);

  if nvl(l_start_tmpl, 0) = 0 or nvl(l_end_tmpl, 0) = 0 then
    return;
  end if;



  dbms_lob.createtemporary(l_temp, false);

  pak_xslt_log.WriteLog(
        'Start p_basic_format_name: '||p_basic_format_name||' p_xml_procinstr: '||p_xml_procinstr,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

  if p_xml_procinstr is not null and p_basic_format_name = 'xml' then
    DBMS_LOB.WRITEAPPEND(l_temp, length(p_xml_procinstr),p_xml_procinstr);
  end if;
  l_start_xsl := l_start_tmpl;
  l_end_xsl := l_start_tmpl;
  l_start_pi := l_start_tmpl;
  loop
    pak_xslt_log.WriteLog(
        'start loop l_end_xsl: '||l_end_xsl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

    l_start_xsl := dbms_lob.instr(pio_xslt, '<xsl:', l_end_xsl);
    l_start_cxsl := dbms_lob.instr(pio_xslt, '</xsl:', l_end_xsl);

    pak_xslt_log.WriteLog(
        'start loop l_start_xsl: '||l_start_xsl||' l_start_cxsl: '||l_start_cxsl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

    if l_start_cxsl > 0 and l_start_xsl > 0 then
      l_start_xsl := least(l_start_xsl, l_start_cxsl);
    elsif l_start_cxsl > 0 and nvl(l_start_xsl, 0) = 0 then
      l_start_xsl := l_start_cxsl;
    end if;
    exit when nvl(l_start_xsl, 0) = 0 or l_start_xsl >= l_end_tmpl;
    if l_start_xsl = l_start_cxsl then
      l_start_xsl_text := '</xsl:text>';
    else
      l_start_xsl_text := '<xsl:text';
    end if;

    l_xsl_text_element := dbms_lob.substr(pio_xslt, length(l_start_xsl_text), l_start_xsl) = l_start_xsl_text;

    if l_start_xsl > l_end_xsl then
      pak_xslt_log.WriteLog(
        'start copy to end of l_temp from '||l_end_xsl||' and new '||l_start_xsl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

      DBMS_LOB.COPY (l_temp, pio_xslt, l_start_xsl - l_end_xsl, nvl(DBMS_LOB.GETLENGTH(l_temp),0)+1, l_end_xsl); --copy LOB

     pak_xslt_log.WriteLog(
        'finsih copy to end of l_temp from '||l_end_xsl||' and new '||l_start_xsl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

    end if;

    l_start_pi :=dbms_lob.instr(pio_xslt, '<xsl:processing-instruction', l_start_xsl);
    if l_start_pi = l_start_xsl then --this is processing-instruction


      l_end_xsl := dbms_lob.instr(pio_xslt, '</xsl:processing-instruction>', l_start_pi);

      pak_xslt_log.WriteLog(
        'xsl:processing-instruction: '||l_start_pi||'-'||l_end_xsl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

      exit when nvl(l_end_xsl, 0) = 0;
      l_end_xsl := l_end_xsl + length('</xsl:processing-instruction>');
      --l_str_replace_with := dbms_lob.substr(pio_xslt, l_end_xsl - l_start_xsl, l_start_xsl);
      l_str_replace_with := ModifiedElelmentTag(pio_xslt, l_end_xsl - l_start_xsl, l_start_xsl);

      --l_str_replace_with := replace(l_str_replace_with, '<xsl:processing-instruction name="','<?');
      --l_str_replace_with := replace(l_str_replace_with, '</xsl:processing-instruction>','?>');
      --l_str_replace_with := replace(l_str_replace_with, '">',' ');

      pak_xslt_log.WriteLog(
        'xsl:processing-instruction l_str_replace_with: '||l_str_replace_with,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

    else --xsl element not a processing-instruction
      l_end_xsl := dbms_lob.instr(pio_xslt, '>', l_start_xsl);
      exit when nvl(l_end_xsl, 0) = 0;
      l_end_xsl := l_end_xsl + length('>');

      pak_xslt_log.WriteLog(
        'xsl: '||l_start_xsl||'-'||l_end_xsl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );



      if not l_xsl_text_element or p_basic_format_name = 'xml' then
        --l_str_replace_with := dbms_lob.substr(pio_xslt, l_end_xsl - l_start_xsl, l_start_xsl);
        --l_str_replace_with := replace(l_str_replace_with, '<', p_replace_otag);
        --l_str_replace_with := replace(l_str_replace_with, '>', p_replace_ctag);
        l_str_replace_with := ModifiedElelmentTag(pio_xslt, l_end_xsl - l_start_xsl, l_start_xsl, p_replace_otag, p_replace_ctag);

        pak_xslt_log.WriteLog(
          'xsl: l_str_replace_with: '||l_str_replace_with,
          p_log_type => pak_xslt_log.g_warning,
          p_procedure => 'XSLT2Document' );
      end if;
    end if;
    if l_str_replace_with is not null and l_start_xsl < l_end_tmpl and
      (not l_xsl_text_element or p_basic_format_name = 'xml')
    then
      DBMS_LOB.WRITEAPPEND(l_temp, length(l_str_replace_with),l_str_replace_with);

      pak_xslt_log.WriteLog(
        'WRITEAPPEND '||l_str_replace_with||' to l_temp ',
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

    end if;
  end loop;
  if l_end_xsl > 0 then --from last end_xsl to the end
    DBMS_LOB.COPY (l_temp, pio_xslt, l_end_tmpl - l_end_xsl, nvl(DBMS_LOB.GETLENGTH(l_temp),0)+1, l_end_xsl);

    pak_xslt_log.WriteLog(
        'copy the rest to end of l_temp from '||l_end_xsl||' and end of template '||l_end_tmpl,
        p_log_type => pak_xslt_log.g_warning,
        p_procedure => 'XSLT2Document' );

  end if;

  if p_basic_format_name = 'mht' then --must start with: MIME-Version
    dbms_lob.trim(pio_xslt, 0);
    dbms_lob.copy(
      pio_xslt, l_temp,
      dbms_lob.getlength(l_temp) - dbms_lob.instr(l_temp, 'MIME-Version'),
      1, dbms_lob.instr(l_temp, 'MIME-Version')
    );
  else
    pio_xslt := l_temp;
  end if;

  dbms_lob.freetemporary(l_temp);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XSLT2Document',
    p_sqlerrm => sqlerrm
  );
  raise;
end XSLT2Document;



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
)
as
l_xslt CLOB;
begin
  l_xslt := pak_blob_util.READ2CLOB(p_xsltDir, p_xsltFname);
  XSLT2Document(
    l_xslt,
    p_basic_format_name,
    p_match_templates,
    p_name_templates,
    p_xml_procinstr,
    p_replace_otag,
    p_replace_ctag
  );
  --dbms_xslprocessor.clob2file(l_xslt, p_docDir, p_docFname);
exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XSLT2Document',
    p_sqlerrm => sqlerrm
  );
  raise;
end XSLT2Document;


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
)
as
l_workspace_id number;
l_blob BLOB;
l_apex_ver varchar2(10);
begin
    select workspace_id
    into l_workspace_id
    from apex_workspaces
    where workspace = upper(p_ws);

    wwv_flow_api.set_security_group_id(l_workspace_id);

    l_blob := pak_blob_util.GetBlob(p_filedir, p_filename);

    SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)
    into l_apex_ver
    FROM apex_release;

    update wwv_flow_files set
    blob_content = l_blob,
    doc_size = dbms_lob.getlength(l_blob)
    where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1')
    and filename = p_static_filename;
    commit;
exception
  when others then
  pak_xslt_log.WriteLog('Error RefreshStaticFile '||p_static_Filename||' with content of file '||p_filedir||'\'||P_FILENAME,
                  p_log_type => pak_xslt_log.g_error, p_procedure => 'RefreshStaticFile' );
  rollback;
  raise;
end;
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
)
as
l_workspace_id number;
l_blob BLOB;
l_warning NUMBER;
l_lang_context number default 0;
--l_blob_csid number default 0;
l_src_offset number default 1;
l_dest_offset number default 1;
l_apex_ver varchar2(10);

begin
  DBMS_LOB.CREATETEMPORARY(l_blob, true);

  DBMS_LOB.OPEN (l_blob, DBMS_LOB.LOB_READWRITE);

    --pretvori CLOB v BLOB

    --l_blob_csid := NLS_CHARSET_ID('EE8MSWIN1250'); --debug briL?i
  DBMS_LOB.CONVERTTOBLOB(
    l_blob,
    p_clob,
    DBMS_LOB.LOBMAXSIZE,
    l_src_offset,
    l_dest_offset,
    p_clob_csid,
    l_lang_context,
    l_warning
  );

  select workspace_id
  into l_workspace_id
  from apex_workspaces
  where workspace = upper(p_ws);

  wwv_flow_api.set_security_group_id(l_workspace_id);

  SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)
  into l_apex_ver
  FROM apex_release;

  update wwv_flow_files set
  blob_content = l_blob,
  doc_size = dbms_lob.getlength(l_blob)
  where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1')
  and filename = p_static_filename;

  DBMS_LOB.FREETEMPORARY(l_blob);
  commit;
exception
  when others then
  pak_xslt_log.WriteLog('Error RefreshStaticFile CLOB ',
                  p_log_type => pak_xslt_log.g_error, p_procedure => 'RefreshStaticFile' );
  rollback;
  raise;
end;

end QUERY2REPORT;
/
