--------------------------------------------------------
--  DDL for Package Body PAK_XPM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PAK_XPM" AS
 
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
 
  function ConvertTabStringToLOV(p_tab_string Query2Report.tab_string)
  return varchar2
  as
  l_ret varchar2(4000);
  begin
    for i in 1..p_tab_string.count loop
      if l_ret is null then
        l_ret:= p_tab_string(i);
      else
        l_ret:= l_ret||':'||p_tab_string(i);
      end if;
    end loop;
    return l_ret;
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.ConvertTabStringToLOV',
      p_sqlerrm => sqlerrm
    );
    raise;
  end;
  
  FUNCTION SplitString (p_in_string VARCHAR2, p_delim VARCHAR2 default ':') 
  RETURN Query2Report.tab_string 
  IS
    --i       number :=0;
    pos     number :=0;
    lv_str  varchar2(4000) := p_in_string||p_delim;    
    strings Query2Report.tab_string := Query2Report.tab_string();   
     BEGIN
        -- determine first chuck of string  
        pos := instr(lv_str,p_delim,1,1);
        -- while there are chunks left, loop 
        WHILE ( pos != 0) LOOP
           -- increment counter 
           --i := i + 1;
           -- create array element for chuck of string 
           --strings(i) := trim(substr(lv_str,1,pos-length(p_delim)));
           strings.extend;
           strings(strings.count) := trim(substr(lv_str,1,pos-length(p_delim)));
           -- remove chunk from string 
           lv_str := substr(lv_str,pos+1,length(lv_str));
           -- determine next chunk 
           pos := instr(lv_str,p_delim,1,1);
           -- no last chunk, add to array 
           IF pos = 0 THEN
              strings.extend;
              strings(strings.count) := trim(lv_str);
              --strings(i+1) := trim(lv_str);
           END IF;
        END LOOP;
     
        -- return array 
        RETURN strings;
  exception
    when others then
    pak_xslt_log.WriteLog( 'Error p_in_string: '||p_in_string,
      p_log_type => pak_xslt_log.g_error, 
      p_procedure => 'pak_xpm.SplitString', 
      p_sqlerrm => sqlerrm );
    raise;      
  END SplitString; 
  
  procedure FlatOPCFromTemplate(
    p_id_project number) 
  AS
  l_templ_last_updated      xpm_project.templ_last_updated%type;
  l_FLATOPC_blob            xpm_project.FLATOPC_blob%type;
  l_template_blob           xpm_project.template_blob%type;
  l_templ_xslt_cs           xpm_project.templ_xslt_cs%type;
  l_templ_fname             xpm_project.templ_fname%type;
  l_flatopc_last_updated    xpm_project.flatopc_last_updated%type;
  l_id_basic_format     xpm_format.id_basic_format%type;
  l_id_format           xpm_format.id_format%type;
  l_ext                 varchar2(5);
  l_flatOPC             CLOB;
  l_parts               varchar2(4000);
  
  BEGIN
    if p_id_project is null then
      return;
    end if;
    
    select p.templ_last_updated,
    p.template_blob     ,
    p.templ_xslt_cs     ,
    p.templ_fname       ,
    p.flatopc_last_updated,
    p.flatopc_blob     ,
    f.id_format         ,
    f.id_basic_format   
    into
    l_templ_last_updated,
    l_template_blob     ,
    l_templ_xslt_cs     ,
    l_templ_fname       ,
    l_flatopc_last_updated,
    l_flatopc_blob     ,
    l_id_format         ,
    l_id_basic_format   
    from xpm_project p
    join xpm_format f on p.id_format = f.id_format
    where id_project = p_id_project;
    
    l_ext := upper(substr(l_templ_fname, nullif( instr(l_templ_fname,'.', -1) +1, 1)));
    
    if l_ext in ('DOCX','XLSX') and (l_template_blob is not null) and 
      (l_flatopc_blob is null or l_flatopc_last_updated < l_templ_last_updated)
    then
      l_flatOPC := FLAT_OPC_PKG.OOXML2FlatOPC(l_template_blob, l_ext, l_parts); --, p_unzip_embeedeings => true);
    
      update xpm_project 
        set FLATOPC_blob = pak_blob_util.CLOB2BLOB(l_flatOPC), 
        FLATOPC_last_updated = sysdate,
        FLATOPC_fname = templ_fname||'.xml',
        ALL_PARTS = l_parts,
        PARTS_TO_TRANSFORM = l_parts
      where id_project = p_id_project;
    end if;
    commit;
    
exception
  when others then  
  rollback;
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'pak_xpm.FlatOPCFromTemplate',
    p_sqlerrm => sqlerrm
  );
  raise;
  END FlatOPCFromTemplate;
  
  procedure XSLTFromTemplate(
    p_id_project number, 
    p_on_demand boolean default false) 
  AS
  l_xslt_last_updated   xpm_project.xslt_last_updated%type;
  l_templ_last_updated  xpm_project.templ_last_updated%type;
  l_xslt_blob           xpm_project.xslt_blob%type;
  l_template_blob       xpm_project.template_blob%type;
  l_templ_xslt_cs       xpm_project.templ_xslt_cs%type;
  l_id_basic_format     xpm_format.id_basic_format%type;
  l_id_format           xpm_format.id_format%type;
  l_parts_to_transform  xpm_project.parts_to_transform%type;
  l_all_parts           xpm_project.all_parts%type;
  l_FLATOPC_blob            xpm_project.FLATOPC_blob%type;
  l_flatopc_last_updated    xpm_project.flatopc_last_updated%type;
  
  BEGIN
    if p_id_project is null then
      return;
    end if;
    
    select p.xslt_last_updated ,
    p.templ_last_updated,
    p.xslt_blob         ,
    p.template_blob     ,
    p.templ_xslt_cs     ,
    f.id_format         ,
    f.id_basic_format   ,
    p.parts_to_transform,
    p.all_parts         ,
    p.flatopc_blob      ,
    p.flatopc_last_updated
    into
    l_xslt_last_updated ,
    l_templ_last_updated,
    l_xslt_blob         ,
    l_template_blob     ,
    l_templ_xslt_cs     ,
    l_id_format         ,
    l_id_basic_format   ,
    l_parts_to_transform,
    l_all_parts         ,
    l_flatopc_blob      ,
    l_flatopc_last_updated
    from xpm_project p
    join xpm_format f on p.id_format = f.id_format
    where id_project = p_id_project;
    
    if (l_xslt_blob is null and l_template_blob is not null) or 
      (p_on_demand and l_xslt_last_updated < l_templ_last_updated)
    then
      if l_flatopc_blob is not null and l_flatopc_last_updated >= l_templ_last_updated then
        l_template_blob := l_flatopc_blob;
      end if;
      Query2Report.Template2XSLT(l_template_blob, l_id_basic_format, l_templ_xslt_cs, 
                  nvl(l_parts_to_transform, l_all_parts));
      l_xslt_blob := l_template_blob;
      
      update xpm_project 
        set xslt_blob = l_xslt_blob, 
        xslt_fname = nvl(xslt_fname, templ_fname||'.xslt'),
        xslt_last_updated = sysdate
      where id_project = p_id_project;
    end if;
exception
  when others then  
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'pak_xpm.XSLTFromTemplate',
    p_sqlerrm => sqlerrm
  );
  raise;
  END XSLTFromTemplate;
  
  procedure DownloadOutput(p_id_project number)
  as
  l_xmlblob             xpm_xml.xmlblob%type;
  l_xml_charset         xpm_xml.xml_charset%type;
  l_xslt_blob           xpm_project.xslt_blob%type;
  l_xslt_fname          xpm_project.xslt_fname%type;
  l_templ_xslt_cs       xpm_project.templ_xslt_cs%type;
  l_id_basic_format     xpm_format.id_basic_format%type;
  l_open_as             xpm_format.open_as%type;
  l_external_params     xpm_project.external_params%type;
  l_flatopc_blob        xpm_project.flatopc_blob%type;
  --l_file_csid         number;
  
  begin
    select x.xmlblob      ,
        x.xml_charset     ,
        p.xslt_blob       ,
        p.xslt_fname      ,
        p.templ_xslt_cs   ,
        f.id_basic_format  ,
        f.open_as         ,
        p.external_params ,
        p.flatopc_blob    
        into
        l_xmlblob         ,
        l_xml_charset     ,
        l_xslt_blob       ,
        l_xslt_fname      ,
        l_templ_xslt_cs   ,
        l_id_basic_format  ,
        l_open_as         ,
        l_external_params ,
        l_flatopc_blob    
  from xpm_project p 
  join xpm_xml x on x.id_xml = p.id_xml
  join xpm_format f on p.id_format = f.id_format
  where p.id_project = p_id_project;
  
  Query2Report.XslTransformAndDownload
  (
    p_Xml                 => pak_blob_util.BLOB2CLOB(l_xmlblob, NLS_CHARSET_ID(l_xml_charset)),
    p_Xslt                => l_xslt_blob,
    p_filename            => l_xslt_fname||'.'||l_open_as,
    p_XSLT_CS             => l_templ_xslt_cs,
    p_format              => l_id_basic_format,
    p_template            => l_flatopc_blob,
    p_template_CS          => l_templ_xslt_cs,
    p_external_params     => l_external_params
  );
  exception
  when others then  
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'pak_xpm.DownloadOutput',
    p_sqlerrm => sqlerrm
  );
  raise;
  end DownloadOutput;
  
    
  procedure SaveAsXML(p_id_project number)
  as
  l_xmlblob           xpm_xml.xmlblob%type;
  l_xml_charset       xpm_xml.xml_charset%type;
  l_xslt_blob         xpm_project.xslt_blob%type;
  l_xslt_fname        xpm_project.xslt_fname%type;
  l_description       xpm_project.description%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_id_basic_format    xpm_format.id_basic_format%type;
  l_open_as           xpm_format.open_as%type;
  l_external_params   xpm_project.external_params%type;
  --l_file_csid         number;
  --l_xslt_csid         number; 
  l_xml               BLOB;
  l_error             boolean;
  
  begin
      select x.xmlblob      ,
          x.xml_charset     ,
          p.xslt_blob       ,
          p.xslt_fname      ,
          p.description     ,
          p.templ_xslt_cs   ,
          f.id_basic_format  ,
          f.open_as         ,
          p.external_params 
          into
          l_xmlblob         ,
          l_xml_charset     ,
          l_xslt_blob       ,
          l_xslt_fname      ,
          l_description     ,
          l_templ_xslt_cs   ,
          l_id_basic_format  ,
          l_open_as         ,
          l_external_params 
    from xpm_project p 
    join xpm_xml x on x.id_xml = p.id_xml
    join xpm_format f on p.id_format = f.id_format
    where p.id_project = p_id_project;
    
    l_xml := Query2Report.XslTransform(
      p_Xml => pak_blob_util.BLOB2CLOB(l_xmlblob, NLS_CHARSET_ID(l_xml_charset)),
      p_Xslt => pak_blob_util.BLOB2CLOB(l_xslt_blob, NLS_CHARSET_ID(l_templ_xslt_cs)), 
      p_format => Query2Report.F_XML,
      po_error => l_error,
      p_external_params => l_external_params);
      
    insert into xpm_xml(fname, xmlblob) 
    values ('output_'||
      trim(substr(translate(l_description,'?,''":;?*+()/\|&%$#! '||query2report.g_crlf,'______________________'),1, 245))||
      '.xml', l_xml);
    commit;
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.SaveAsXML',
      p_sqlerrm => sqlerrm
    );
    rollback;
  raise;
  end SaveAsXML;
  
  procedure DownloadTemplate(p_id_project number)
  as
  l_template_blob     xpm_project.template_blob%type;
  l_flatopc_blob      xpm_project.flatopc_blob%type;
  l_templ_fname       xpm_project.xslt_fname%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_open_as           xpm_format.open_as%type;
  --l_file_csid         number;
  --l_clob              CLOB;
  
  begin
    select p.template_blob ,
        p.templ_fname      ,
        p.flatopc_blob     ,
        p.templ_xslt_cs    ,
        f.open_as         
        into
        l_template_blob   ,
        l_templ_fname     ,
        l_flatopc_blob    ,
        l_templ_xslt_cs   ,
        l_open_as         
    from xpm_project p 
    join xpm_format f on p.id_format = f.id_format
    where p.id_project = p_id_project;
    
    if l_open_as in ('docx', 'xslx') then
      Query2Report.DownloadBlob(V('APP_ID'), l_template_blob, l_templ_fname||'.'||l_open_as);
    else
      Query2Report.DownloadConvertOutput(V('APP_ID'), l_template_blob, l_templ_fname||'.'||l_open_as, p_blob_csid => NLS_CHARSET_ID(l_templ_xslt_cs)); 
    end if;
    --l_file_csid, p_mime => p_mime, p_convertblob => true, p_convertblob_param => p_convertblob_param);
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.DownloadTemplate',
      p_sqlerrm => sqlerrm
    );
    raise;
  end DownloadTemplate;
  
  procedure DownloadXML(p_id_project number)
  as
  l_xmlblob           xpm_xml.xmlblob%type;
  l_xml_charset       xpm_xml.xml_charset%type;
  l_fname             xpm_xml.fname%type;
  
  
  begin
    select x.xmlblob      ,
          x.xml_charset     ,
          x.fname
          into
          l_xmlblob         ,
          l_xml_charset     ,
          l_fname
    from xpm_project p 
    join xpm_xml x on x.id_xml = p.id_xml
    where p.id_project = p_id_project;
    
    Query2Report.DownloadConvertOutput(V('APP_ID'), l_xmlblob, l_fname, p_blob_csid => NLS_CHARSET_ID(l_xml_charset)); 
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.DownloadXML',
      p_sqlerrm => sqlerrm
    );
    raise;
  end DownloadXML;
  
  procedure DownloadMainXsltTemplate(p_id_project number, 
    p_match_templates varchar2,
    p_name_templates varchar2,
    p_xml_procinstr varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||Query2Report.g_crlf,
    p_replace_otag varchar2 default '&lt;',
    p_replace_ctag varchar2 default '&gt;')
  as
  l_xslt_blob           xpm_project.template_blob%type;
  l_xslt_fname          xpm_project.xslt_fname%type;
  l_templ_xslt_cs       xpm_project.templ_xslt_cs%type;
  l_open_as             xpm_format.open_as%type;
  l_basic_format_name   xpm_basic_format.name%type;
  --l_file_csid         number;
  l_clob              CLOB;
  
  begin
    select p.xslt_blob ,
        p.xslt_fname      ,
        p.templ_xslt_cs    ,
        f.open_as,
        b.name
        into
        l_xslt_blob   ,
        l_xslt_fname     ,
        l_templ_xslt_cs   ,
        l_open_as,      
        l_basic_format_name
    from xpm_project p 
    join xpm_format f on p.id_format = f.id_format
    join xpm_basic_format b on f.id_basic_format = b.id_basic_format
    where p.id_project = p_id_project;
  
    l_clob := pak_blob_util.BLOB2CLOB(l_xslt_blob, NLS_CHARSET_ID(l_templ_xslt_cs));
    /*
  select b.name into l_basic_format_name 
  from xpm_format f 
  join xpm_basic_format b on f.id_basic_format = b.id_basic_format
  where f.id_format = p_id_format;
  */
    
    Query2Report.XSLT2Document(l_clob, l_basic_format_name, 
      SplitString(p_match_templates),
      SplitString(p_name_templates),
      p_xml_procinstr, p_replace_otag, p_replace_ctag);
      
    Query2Report.DownloadConvertOutput(
      V('APP_ID'), 
      pak_blob_util.CLOB2BLOB(l_clob, NLS_CHARSET_ID(l_templ_xslt_cs)),
      l_xslt_fname||'.'||l_open_as, 
      p_blob_csid => NLS_CHARSET_ID(l_templ_xslt_cs)
    );
  exception
  when others then  
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'pak_xpm.DownloadMainXsltTemplate',
    p_sqlerrm => sqlerrm
  );
  raise;
  end DownloadMainXsltTemplate;
  
  procedure Download(p_id_project number, 
    p_dwld_type number,
    p_match_templates varchar2 default null,
    p_name_templates varchar2 default null,
    p_xml_procinstr varchar2 default '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||Query2Report.g_crlf,
    p_replace_otag varchar2 default '&lt;',
    p_replace_ctag varchar2 default '&gt;'
  )
  as
  begin
    if p_dwld_type = g_dwld_xml then --0
      DownloadXML(p_id_project);
    elsif p_dwld_type = g_dwld_output then --1
      DownloadOutput(p_id_project);
    elsif p_dwld_type = g_dwld_template then --2
      DownloadTemplate(p_id_project);
    elsif p_dwld_type = g_dwld_mx_template then --3
      DownloadMainXsltTemplate(p_id_project, p_match_templates, p_name_templates, p_xml_procinstr, p_replace_otag, p_replace_ctag);
    end if;
    exception
      when others then  
      pak_xslt_log.WriteLog(
        'Error',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'pak_xpm.Download',
        p_sqlerrm => sqlerrm
      );
    raise;
  end Download;
  
  function LoggedUserIsDeveloper
  return boolean
  as
  l_ret varchar2(4000);
  begin
    l_ret := apex_util.get_user_roles(V('APP_USER'));
    return instr(l_ret,'CREATE')>0 and instr(l_ret,'EDIT')>0;
  exception
      when others then  
      pak_xslt_log.WriteLog(
        'Error',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'pak_xpm.LoggedUserIsDeveloper',
        p_sqlerrm => sqlerrm
      );
    raise;
  end;
  
  function CanRefreshStaticFile(p_fname varchar2)
  return boolean
  as
  l_apex_ver          varchar2(10);
  l_count             number;
  begin
    SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)  
    into l_apex_ver
    FROM apex_release;
    
    select count(*) into l_count 
    from wwv_flow_files
    where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1')
    and filename = p_fname;
    
    return l_count = 1;
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.CanRefreshStaticFile' );
    raise;
  end CanRefreshStaticFile;
  
  procedure RefreshStaticFile(
    p_app_id  number,
    p_blob    BLOB,
    p_fname   varchar2,
    p_cs      varchar2
  )
  as
  l_apex_ver          varchar2(10);
  l_count             number;
   
  begin
    
    
    SELECT substr(version_no, 1, instr(version_no, '.', 1, 2)-1)  
    into l_apex_ver
    FROM apex_release;
    
    select count(*) into l_count 
    from wwv_flow_files
    where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1')
    and filename = p_fname;
    
    if l_count = 1 then
      update wwv_flow_files set
      flow_id = p_app_id,
      blob_content = p_blob,
      doc_size = dbms_lob.getlength(p_blob)
      where (file_type = 'STATIC_FILE' or l_apex_ver = '4.1')
      and filename = p_fname;
    elsif l_count > 1 then
      raise_application_error(-20001, 'There are '||l_count||' '||p_fname||' static files!');
    end if;
    
    commit;
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.RefreshStaticFile' );
    rollback;
    raise;
  end RefreshStaticFile;
  
  procedure RefreshXSLTStaticFile(p_id_project number, p_app_id number)
  as
  l_xslt_blob         xpm_project.template_blob%type;
  l_xslt_fname        xpm_project.xslt_fname%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
   
  begin
    select p.xslt_blob ,
        p.xslt_fname      ,
        p.templ_xslt_cs   
        into
        l_xslt_blob   ,
        l_xslt_fname     ,
        l_templ_xslt_cs   
    from xpm_project p 
    join xpm_format f on p.id_format = f.id_format
    where p.id_project = p_id_project;
    
    RefreshStaticFile(
      p_app_id,
      l_xslt_blob,
      l_xslt_fname,
      l_templ_xslt_cs
    );
    
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.RefreshXSLTStaticFile' );
    raise;
  end RefreshXSLTStaticFile;
  
  procedure RefreshFlatOPCStaticFile(p_id_project number, p_app_id number)
  as
  l_flatopc_blob         xpm_project.template_blob%type;
  l_flatopc_fname        xpm_project.xslt_fname%type;
  l_templ_xslt_cs        xpm_project.templ_xslt_cs%type;
   
  begin
    select p.flatopc_blob ,
        p.flatopc_fname      ,
        p.templ_xslt_cs   
        into
        l_flatopc_blob   ,
        l_flatopc_fname     ,
        l_templ_xslt_cs   
    from xpm_project p 
    join xpm_format f on p.id_format = f.id_format
    where p.id_project = p_id_project;
    
    RefreshStaticFile(
      p_app_id,
      l_flatopc_blob,
      l_flatopc_fname,
      l_templ_xslt_cs
    );
    
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.RefreshFlatOPCStaticFile' );
    raise;
  end RefreshFlatOPCStaticFile;
  
  procedure InsertIntoStaticFiles(
    p_app_id number,
    p_blob  BLOB, 
    p_fname varchar2,
    p_cs    varchar2,
    p_mime_type varchar2 default 'text/xml'
  )
  as
  
  l_apex_ver          varchar2(10);
  l_count             number;
   
  begin
    select count(*) into l_count 
    from wwv_flow_files
    where filename = p_fname;
          
    if l_count = 0 then
      insert into wwv_flow_files (flow_id, name, mime_type, doc_size, content_type, 
        blob_content, file_type, file_charset)
      values (p_app_id, 'XPM/'||p_fname, 'text/xml',  dbms_lob.getlength(p_blob), 'BLOB', 
        p_blob, 'STATIC_FILE', p_cs);
    else
       raise_application_error(-20002, 'There already exists static file '||p_fname||'!');
    end if;
    commit;
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.InsertIntoStaticFiles' );
    rollback;
    raise;
  end InsertIntoStaticFiles;
  
  procedure InsertXSLTIntoStaticFiles(p_id_project number, p_app_id number)
  as
  l_xslt_blob         xpm_project.template_blob%type;
  l_xslt_fname        xpm_project.xslt_fname%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
   
  begin
    select p.xslt_blob ,
        p.xslt_fname      ,
        p.templ_xslt_cs   
        into
        l_xslt_blob   ,
        l_xslt_fname     ,
        l_templ_xslt_cs   
    from xpm_project p 
    join xpm_format f on p.id_format = f.id_format
    where p.id_project = p_id_project;
    
    InsertIntoStaticFiles(
      p_app_id,
      l_xslt_blob, 
      l_xslt_fname,
      l_templ_xslt_cs
    );
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.InsertXSLTIntoStaticFiles' );
    raise;
  end InsertXSLTIntoStaticFiles;
  
  procedure InsertFlatOPCIntoStaticFiles(p_id_project number, p_app_id number)
  as
  l_flatOPC_blob         xpm_project.flatopc_blob%type;
  l_flatOPC_fname        xpm_project.flatOPC_fname%type;
  l_templ_xslt_cs        xpm_project.templ_xslt_cs%type;
  
   
  begin
    select p.flatOPC_blob ,
        p.flatOPC_fname      ,
        p.templ_xslt_cs   
        into
        l_flatOPC_blob   ,
        l_flatOPC_fname     ,
        l_templ_xslt_cs   
    from xpm_project p 
    join xpm_format f on p.id_format = f.id_format
    where p.id_project = p_id_project;
    
    InsertIntoStaticFiles(
      p_app_id,
      l_flatOPC_blob, 
      l_flatOPC_fname,
      l_templ_xslt_cs
    );
  exception
    when others then  
    pak_xslt_log.WriteLog('Error',
                    p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xpm.InsertFlatOPCIntoStaticFiles' );
    raise;
  end InsertFlatOPCIntoStaticFiles;
  
  function GetTemplateMatchesLOV(p_id_project number)
  return varchar2
  as
  l_xslt_blob         xpm_project.template_blob%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_clob CLOB;
  l_file_csid number;
  begin
    select xslt_blob ,
        templ_xslt_cs   
        into
        l_xslt_blob   ,
        l_templ_xslt_cs   
    from xpm_project 
    where id_project = p_id_project;
    
    l_clob := pak_blob_util.BLOB2CLOB(l_xslt_blob, NLS_CHARSET_ID(l_templ_xslt_cs));
    
    return ConvertTabStringToLOV(Query2Report.GetTemplateMatches(l_clob));
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error p_id_project: '||p_id_project,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.GetTemplateMatcesLOV',
      p_sqlerrm => sqlerrm
    );
    raise;
  end;
  function GetTemplateNamesLOV(p_id_project number)
  return varchar2
  as
  l_xslt_blob         xpm_project.template_blob%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_clob CLOB;
  --l_file_csid number;
  begin
    select xslt_blob ,
        templ_xslt_cs   
        into
        l_xslt_blob   ,
        l_templ_xslt_cs   
    from xpm_project 
    where id_project = p_id_project;
    
    l_clob := pak_blob_util.BLOB2CLOB(l_xslt_blob, NLS_CHARSET_ID(l_templ_xslt_cs));
    
    return ConvertTabStringToLOV(Query2Report.GetTemplateNames(l_clob));
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error p_id_project: '||p_id_project,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.GetTemplateNamesLOV',
      p_sqlerrm => sqlerrm
    );
    raise;
  end;
  
  function ConvertTabString2StringTable(p_tab_string Query2Report.tab_string)
  return t_string_table
  as
  l_ret t_string_table := t_string_table();
  begin
    for i in 1..p_tab_string.count loop
      l_ret.extend;
      l_ret(l_ret.count) := t_string_row(p_tab_string(i));
    end loop;
    return l_ret;
  end;
  function GetTemplateNamesTable(p_id_project number)
  return t_string_table
  as
  l_xslt_blob         xpm_project.template_blob%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_clob              CLOB;
  l_file_csid         number;
  l_tab_string        Query2Report.tab_string;
  begin
    select xslt_blob ,
        templ_xslt_cs   
        into
        l_xslt_blob   ,
        l_templ_xslt_cs   
    from xpm_project 
    where id_project = p_id_project;
    
    l_clob := pak_blob_util.BLOB2CLOB(l_xslt_blob, NLS_CHARSET_ID(l_templ_xslt_cs));
    l_tab_string := Query2Report.GetTemplateNames(l_clob);
    
    return ConvertTabString2StringTable(l_tab_string);
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error p_id_project: '||p_id_project,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.GetTemplateNamesTable',
      p_sqlerrm => sqlerrm
    );
    raise;
  end;
  
  function GetTemplateMatchesTable(p_id_project number)
  return t_string_table
  as
  l_xslt_blob         xpm_project.template_blob%type;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_clob              CLOB;
  --l_file_csid         number;
  l_tab_string        Query2Report.tab_string;
  begin
    select xslt_blob ,
        templ_xslt_cs   
        into
        l_xslt_blob   ,
        l_templ_xslt_cs   
    from xpm_project 
    where id_project = p_id_project;
    
    l_clob := pak_blob_util.BLOB2CLOB(l_xslt_blob, NLS_CHARSET_ID(l_templ_xslt_cs));
    l_tab_string := Query2Report.GetTemplateMatches(l_clob);
    
    return ConvertTabString2StringTable(l_tab_string);
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error p_id_project: '||p_id_project,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.GetTemplateMatchesTable',
      p_sqlerrm => sqlerrm
    );
    raise;
  end;
  
  procedure FlatOPCTransfromedOnly(
    p_id_project number, 
    p_partsToTransform varchar2
  )
  as
  l_flatopc_blob      xpm_project.flatopc_blob%type;
  l_flatopc_clob      CLOB;
  l_templ_xslt_cs     xpm_project.templ_xslt_cs%type;
  l_all_parts         xpm_project.all_parts%type;
  l_file_csid         number;
  begin
    select flatopc_blob,
    all_parts
    into l_flatopc_blob,
    l_all_parts
    from xpm_project where id_project = p_id_project;
    
    l_flatopc_clob := pak_blob_util.BLOB2CLOB(l_flatopc_blob, NLS_CHARSET_ID(l_templ_xslt_cs));
    
    Query2Report.Template2XSLT(l_flatopc_clob, Query2Report.f_ooxml, nvl(p_partsToTransform, l_all_parts));
    
    update xpm_project 
    set xslt_blob = pak_blob_util.CLOB2BLOB(l_flatopc_clob),
    xslt_last_updated = sysdate,
    parts_to_transform = p_partsToTransform,
    xslt_edited = 0
    where id_project = p_id_project;
  exception
    when others then  
    pak_xslt_log.WriteLog(
      'Error p_id_project: '||p_id_project,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xpm.FlatOPCTransfromedOnly',
      p_sqlerrm => sqlerrm
    );
    rollback;
    raise;  
  end;
END PAK_XPM;

/
