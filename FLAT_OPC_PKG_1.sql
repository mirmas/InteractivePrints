
CREATE OR REPLACE PACKAGE BODY FLAT_OPC_PKG AS

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

  TYPE TContentTypes IS TABLE OF VARCHAR2(400) INDEX BY VARCHAR2(256);
  TYPE TFoldersAndFiles IS TABLE OF varchar2(400);

  c_xml_proc_instr constant varchar(200) := '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'||chr(13)||chr(10);

  function LogFoldersAndFiles(p_foldersAndFiles TFoldersAndFiles)
  return varchar2
  as
  l_ret varchar2(32000);
  begin
    for i in 1..p_foldersAndFiles.count loop
      l_ret := l_ret||p_foldersAndFiles(i)||',';
    end loop;
    if l_ret is not null then
      l_ret := rtrim(l_ret,',');
    end if;
    return l_ret;
  end;

  function LogContentTypes(p_contentTypes TContentTypes)
  return varchar2
  as
  l_ret varchar2(32000);
  l_index varchar2(256);
  begin
    l_index := p_contentTypes.FIRST;
    if l_index is not null then
      l_ret := l_index||':'||p_contentTypes(l_index)||',';
    end if;
    while l_index is not null loop
      l_index := p_contentTypes.NEXT(l_index);
      if l_index is not null then
        l_ret := l_ret||l_index||':'||p_contentTypes(l_index)||',';
      end if;
    end loop;
    if l_ret is not null then
      l_ret := rtrim(l_ret,',');
    end if;
    return l_ret;
  end;

  -------------------------------------------------------------OOXML2FlatOPC procedures and functions---------------------------------------------------------

/** Fills ContentType info from predefined elelment of OOXML file [Content_Types].xml into TContentTypes associative array. Predefined element could be "Default" or "Override"
  * @param p_contentTypesXml CLOB version of [Content_Types].xml file.
  * @param p_elementName Can be "Default" or "Override".
  * @param p_attributName Can be "Extension" or "PartName".
  * @return TContentTypes associative array.
  */
  function GetContentTypesCollection(
    p_contentTypesXml         CLOB,
    p_elementName             varchar2,
    p_attributName            varchar2
  )
  return TContentTypes
  as
  l_offset number := 1;
  l_element_start number;
  l_element_end number;
  l_key_attr_start number;
  l_key_attr_end number;
  l_value_attr_start number;
  l_value_attr_end number;
  l_key varchar2(256);
  l_value varchar2(400);

  l_ret TContentTypes;
  begin
    loop
      l_element_start := dbms_lob.instr(p_contentTypesXml, '<'||p_elementName||' ', l_offset);
      exit when nvl(l_element_start, 0) = 0;
      l_element_end := dbms_lob.instr(p_contentTypesXml, '>', l_element_start);
      exit when nvl(l_element_end, 0) = 0;
      l_key_attr_start := dbms_lob.instr(p_contentTypesXml, p_attributName||'="', l_element_start);
      exit when nvl(l_key_attr_start, 0) = 0;
      l_key_attr_start := l_key_attr_start + length(p_attributName||'="');
      l_key_attr_end := dbms_lob.instr(p_contentTypesXml, '"', l_key_attr_start);
      exit when nvl(l_key_attr_end, 0) = 0;
      l_value_attr_start := dbms_lob.instr(p_contentTypesXml, 'ContentType="', l_element_start);
      exit when nvl(l_value_attr_start, 0) = 0;
      l_value_attr_start := l_value_attr_start + length('ContentType="');
      l_value_attr_end := dbms_lob.instr(p_contentTypesXml, '"', l_value_attr_start);
      exit when nvl(l_key_attr_end, 0) = 0;
      l_key := dbms_lob.substr(p_contentTypesXml, l_key_attr_end - l_key_attr_start, l_key_attr_start);
      l_value := dbms_lob.substr(p_contentTypesXml, l_value_attr_end - l_value_attr_start, l_value_attr_start);
      l_ret(l_key) := l_value;
      l_offset := l_element_end;
    end loop;
    return l_ret;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'flat_OPC_pkg.GetContentTypesCollection'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end GetContentTypesCollection;

/** Fills ContentType info from predefined element of OOXML file [Content_Types].xml into two TContentTypes associative arrays one for "Default" element and one for "Override" element.
  * @param p_contentTypesXml CLOB version of [Content_Types].xml file.
  * @param po_extensionContentTypes Associative array of ContentTypes of "Default" elements.
  * @param po_fileContentTypes Associative array of ContentTypes of "Extension" elements.
  */
  procedure GetContentTypesCollections(
    p_contentTypesXml         CLOB,
    po_extensionContentTypes  OUT TContentTypes,
    po_fileContentTypes       OUT TContentTypes
  )
  as
  begin
    po_extensionContentTypes := GetContentTypesCollection(p_contentTypesXml, 'Default', 'Extension');
    po_fileContentTypes := GetContentTypesCollection(p_contentTypesXml, 'Override', 'PartName');
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'flat_OPC_pkg.GetContentTypesCollections'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end GetContentTypesCollections;

  function GetProcessingInstruction(p_filetype varchar2)
  return varchar2
  as
  l_ret varchar2(400);
  begin
    if upper(p_filetype) = 'DOCX' then
      l_ret:='<?mso-application progid="Word.Document"?>'||chr(13)||chr(10);
    elsif upper(p_filetype) = 'PPTX' then
      l_ret:='<?mso-application progid="PowerPoint.Show"?>'||chr(13)||chr(10);
    elsif upper(p_filetype) = 'XLSX' then
      l_ret:='<?mso-application progid="Excel.Sheet"?>'||chr(13)||chr(10);
    end if;
    return l_ret;
  end;


/** returns proper ContentType for given filename from one of two associative array.
  * @param p_filename File name.
  * @param p_extensionContentTypes Associative array of ContentTypes of "Default" elements.
  * @param p_fileContentTypes Associative array of ContentTypes of "Extension" elements.
  * @return Proper ContentType for given filename.
  */
  function GetContentType(
    p_filename varchar2,
    p_extensionContentTypes TContentTypes,
    p_fileContentTypes TContentTypes
  )
  return varchar2
  as
  l_ext varchar2(5);
  begin
    if p_fileContentTypes.EXISTS(p_filename) then
      return p_fileContentTypes(p_filename);
    else
      l_ext := substr(p_filename, nullif( instr(p_filename,'.', -1) +1, 1) );
      if l_ext is not null then
        return p_extensionContentTypes(l_ext);
      end if;
    end if;
    --return null;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error p_filename: '||p_filename
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.GetContentType'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end GetContentType;

/** Prepares unziped XMLe from OOXML file for include in Flat OPC. Decode blob to CLOB and cut off xml processing instruction.
  * @param p_XML XML file from OOXML file as BLOB.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  * @return XML without xml processing instruction as CLOB .
  */
  function PrepareXML(p_xml BLOB, p_encoding number)
  return CLOB
  as
  l_ret CLOB;
  l_temp CLOB;
  --l_nls_cs number;
  l_offset number := 1;

  begin
    l_temp := pak_blob_util.BLOB2CLOB(p_xml, NLS_CHARSET_ID(p_encoding));
    --find first element which is not proc instr

    l_offset := dbms_lob.instr(l_temp, '<', l_offset);
    if nvl(l_offset, 0) = 0 then
      return null;
    end if;
    if dbms_lob.substr(l_temp, 5, l_offset+1) = '?xml ' then
      l_offset := dbms_lob.instr(l_temp, '<', l_offset + 1);
      if nvl(l_offset, 0) = 0 then
        return null;
      end if;
    end if;
    dbms_lob.CreateTemporary(l_ret, false);
    --dbms_lob.WriteAppend(l_ret, length(l_element_tag), l_element_tag);
    dbms_lob.Copy(l_ret, l_temp, dbms_lob.getlength(l_temp) - l_offset + 1, 1, l_offset);
    return l_ret;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.PrepareXML'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end PrepareXML;


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
    p_encoding in varchar2 := null
  )
  return CLOB AS
  l_ret CLOB;
  l_procinstr varchar2(400);
  fl zip_util_pkg.t_file_list;
  l_file blob;
  l_xml clob;
  --l_nls_charsetid number;

  l_fileContentTypes TContentTypes;
  l_extensionContentTypes TContentTypes;
  l_contentType varchar2(400);
  l_line varchar2(4000);
  l_parts varchar2(4000);
  BEGIN
    dbms_lob.CreateTemporary(l_ret, false);
    if p_filetype is not null then
      l_procinstr := GetProcessingInstruction(p_filetype);
      dbms_lob.WriteAppend(l_ret, length(l_procinstr), l_procinstr);
    end if;

    fl := zip_util_pkg.get_file_list(p_OOXML);
    l_xml := pak_blob_util.BLOB2CLOB(
      zip_util_pkg.GET_FILE( p_OOXML, '[Content_Types].xml' ), NLS_CHARSET_ID(p_encoding));

    GetContentTypesCollections(l_xml, l_extensionContentTypes, l_fileContentTypes);

    if fl.count() > 0
    then
      dbms_lob.WriteAppend(l_ret, length('<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">'||chr(13)||chr(10)),
      '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">'||chr(13)||chr(10));
      for i in fl.first .. fl.last
      loop
        --dbms_output.put_line ( fl( i ) );
        if substr(fl(i), length(fl(i)), 1 ) != '/' then --just files not folders
          l_file := zip_util_pkg.GET_FILE( p_OOXML, fl( i ) );
          if fl( i ) != '[Content_Types].xml' then
            l_contentType := GetContentType('/'||fl( i ), l_extensionContentTypes, l_fileContentTypes);
            po_parts:=po_parts||fl( i )||':';
            if substr(l_contentType, length(l_contentType)-3)='+xml' then
              l_line := '<pkg:part pkg:name="/'||fl( i )||'" pkg:contentType="'||l_contentType||'">'||chr(13)||chr(10);
              dbms_lob.WriteAppend(l_ret, length(l_line), l_line);
              --add XML Data
              dbms_lob.WriteAppend(l_ret, length('<pkg:xmlData>'||chr(13)||chr(10)), '<pkg:xmlData>'||chr(13)||chr(10));
                --insert XML without proc instruction and namespaces
                l_xml := PrepareXML(l_file, p_encoding);
                dbms_lob.Copy(l_ret, l_xml, dbms_lob.getlength(l_xml), dbms_lob.getlength(l_ret)+1, 1);
              dbms_lob.WriteAppend(l_ret, length('</pkg:xmlData>'||chr(13)||chr(10)), '</pkg:xmlData>'||chr(13)||chr(10));
            elsif p_unzip_embeedeings and
                  (
                    (fl( i ) like 'word/embeddings/%.xlsx' and l_contentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
                    (fl( i ) like 'xl/embeddings/%.docx' and l_contentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
                  )
            then
              l_line := '<pkg:part pkg:name="/'||fl( i )||'" pkg:contentType="'||l_contentType||'">'||chr(13)||chr(10);
              dbms_lob.WriteAppend(l_ret, length(l_line), l_line);
              --add XML Data
              dbms_lob.WriteAppend(l_ret, length('<pkg:xmlData>'||chr(13)||chr(10)), '<pkg:xmlData>'||chr(13)||chr(10));
                --insert XML without proc instruction and namespaces
                l_xml := OOXML2FlatOPC(l_file, null, l_parts, false,  p_encoding);
                dbms_lob.Copy(l_ret, l_xml, dbms_lob.getlength(l_xml), dbms_lob.getlength(l_ret)+1, 1);
              dbms_lob.WriteAppend(l_ret, length('</pkg:xmlData>'||chr(13)||chr(10)), '</pkg:xmlData>'||chr(13)||chr(10));
            else
              l_line := '<pkg:part pkg:name="/'||fl( i )||'" pkg:contentType="'||l_contentType||'" pkg:compression="store">'||chr(13)||chr(10);
              dbms_lob.WriteAppend(l_ret, length(l_line), l_line);
              --add Binary Data
              dbms_lob.WriteAppend(l_ret, length('<pkg:binaryData>'||chr(13)||chr(10)), '<pkg:binaryData>'||chr(13)||chr(10));
                --insert B64 encoded Binary data
                l_xml := pak_blob_util.base64_encode(l_file);
                dbms_lob.Copy(l_ret, l_xml, dbms_lob.getlength(l_xml), dbms_lob.getlength(l_ret)+1, 1);
              dbms_lob.WriteAppend(l_ret, length('</pkg:binaryData>'||chr(13)||chr(10)), '</pkg:binaryData>'||chr(13)||chr(10));
            end if;
            dbms_lob.WriteAppend(l_ret, length('</pkg:part>'||chr(13)||chr(10)), '</pkg:part>'||chr(13)||chr(10));
          end if;
        end if;
        --dbms_output.put_line( ' ' || nvl( dbms_lob.getlength( l_file ), -1 ) );
        --zip_util_pkg.save_blob_to_file ('XMLDIR', 'unzipped_file_' || fl(i), l_file);
      end loop;
      po_parts := rtrim(po_parts, ':');
      dbms_lob.WriteAppend(l_ret, length('</pkg:package>'), '</pkg:package>');
    end if;

    RETURN l_ret;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.OOXML2FlatOPC (BLOB ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END OOXML2FlatOPC;

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
    p_encoding    varchar2 := null
  ) AS
  l_FlatOPC CLOB;
  l_FlatOPCDir  varchar2(400);
  l_FlatOPCFile varchar2(400);
  l_filetype varchar2(5);
  BEGIN
    l_filetype := upper(substr(p_OOXMLFile, nullif( instr(p_OOXMLFile,'.', -1) +1, 1) ));
    l_FlatOPCDir := nvl(p_FlatOPCDir, p_OOXMLDir);
    l_FlatOPCFile := nvl(p_FlatOPCFile, p_OOXMLFile||'.xml');
    l_FlatOPC := OOXML2FlatOPC(pak_blob_util.GetBlob(p_OOXMLDir, p_OOXMLFile),l_filetype, po_parts, p_unzip_embeedeings, p_encoding);
    ZIP_UTIL_PKG.save_blob_to_file(l_FlatOPCDir, l_FlatOPCFile, pak_blob_util.Clob2Blob(l_FlatOPC, p_encoding));
    dbms_lob.freetemporary(l_FlatOPC);
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.OOXML2FlatOPC (file ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END OOXML2FlatOPC;
$end

  --------------------------------FlatOPC2XML procedures and functions-------------------------------------------------------------------------------------------

/** Builds [Content_Types].xml OOXML file from two TContentTypes associative arrays one for "Default" element and one for "Override" element.
  * Inverse of GetContentTypesCollections procedure
  * @param p_extensionContentTypes Associative array of ContentTypes of "Default" elements.
  * @param p_fileContentTypes Associative array of ContentTypes of "Extension" elements.
  * @return CLOB version of [Content_Types].xml file.
  */
  function GetContentTypesXml(
    p_extensionContentTypes  TContentTypes,
    p_fileContentTypes       TContentTypes
  )
  return CLOB
  as
  l_ret CLOB;
  l_openning varchar2(4000);
  l_key varchar2(256);
  l_line varchar2(4000);
  i number;
  begin
    dbms_lob.CreateTemporary(l_ret, false);
    dbms_lob.WriteAppend(l_ret, length(c_xml_proc_instr), c_xml_proc_instr);
    l_line := '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">';
    dbms_lob.WriteAppend(l_ret, length(l_line), l_line);

    l_key := p_extensionContentTypes.FIRST;
    while l_key is not null loop
      l_line := '<Default Extension="'||l_key||'" ContentType="'||p_extensionContentTypes(l_key)||'"/>';
      dbms_lob.WriteAppend(l_ret, length(l_line), l_line);
      l_key := p_extensionContentTypes.NEXT(l_key);
    end loop;

    l_key := p_fileContentTypes.FIRST;
    while l_key is not null loop
      l_line := '<Override PartName="'||l_key||'" ContentType="'||p_fileContentTypes(l_key)||'"/>';--prej ||'/'||l_key
      dbms_lob.WriteAppend(l_ret, length(l_line), l_line);
      l_key := p_fileContentTypes.NEXT(l_key);
    end loop;

    dbms_lob.WriteAppend(l_ret, length('</Types>'), '</Types>');
    return l_ret;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'flat_OPC_pkg.GetContentTypesXml'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end GetContentTypesXml;




  function FolderOrFileExists(
    p_existingFoldersFiles TFoldersAndFiles,
    p_folderorfile varchar2
  )
  return boolean
  as
  begin
    for i in 1..p_existingFoldersFiles.count loop
      if p_existingFoldersFiles(i) = p_folderorfile then
        return true;
      end if;
    end loop;
    return false;
  end;

/** Adds ALL folder structure of file to zip. E.g. if we have file word/theme/theme1.xml procedure will add folders word/ and word/theme/ to zip.
  * @param p_zipped_blob Blob with ZIP.
  * @param p_filename Filename.
  * @param pio_existingFolders Table of folders already added to zip to avoid double zip entries.
  */
  procedure AddFolders(
    p_zipped_blob in out blob
    ,p_filename        IN varchar2
    ,pio_existingFolders IN OUT TFoldersAndFiles
  )
  as
  l_filename varchar2(400);
  l_folder varchar2(400);
  i integer := 1;
  l_end integer;

  begin
    l_filename := ltrim(p_filename,'/');
    loop
      l_end := instr(l_filename,'/', 1, i);
      exit when nvl(l_end, 0) = 0;
      l_folder := substr(l_filename, 1, l_end);
      if not FolderOrFileExists(pio_existingFolders, l_folder) then
        pio_existingFolders.extend;
        pio_existingFolders(pio_existingFolders.count) := l_folder;
        zip_util_pkg.add_folder(p_zipped_blob, l_folder);
      end if;
      i:=i+1;
    end loop;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'flat_OPC_pkg.AddFolders'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end;

/** Adds pkg namespace xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage" into root pkg:package if missing
  * @param p_FlatOPC Flat OPC XML.
  */
  procedure AddPkgNamespace(
    p_FlatOPC IN OUT NOCOPY CLOB
  )
  as
  l_start number;
  l_end number;
  l_element varchar2(400);
  begin
    if nvl(dbms_lob.instr(p_FlatOPC, '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">'), 0) = 0 then
      l_start := dbms_lob.instr(p_FlatOPC, '<pkg:package>');
      if nvl(l_start, 0) = 0 then
        pak_xslt_log.WriteLog
           ( p_description => 'Cannot find pkg:package element'
           , p_log_type    => pak_xslt_log.g_error
           , p_procedure   => 'flat_OPC_pkg.AddPackageNamespace'
           );
        return;
      end if;
      pak_blob_util.ClobReplace(p_FlatOPC, l_start, l_start+length('<pkg:package>')-1,
      '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">');
    end if;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description => 'Error'
         , p_log_type    => pak_xslt_log.g_error
         , p_procedure   => 'flat_OPC_pkg.AddPackageNamespace'
         , P_SQLERRM     =>  sqlerrm
         );
      raise;
  end;

/** Replace DOCX and XLSX embeeding in Flat OPC format with &lt;pkg:binaryData&gt; element with base64 encoded OOXML as text node.
  * @param p_FlatOPC Input: Flat OPC Clob with embeeded DOCX and XLSX content also extended.
  * Output: Flat OPC Clob with embeeded DOCX and XLSX content as base64 encoded OOXML.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  */
  Procedure ZipEmbeedingsOld(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
  )
  as
  l_flatOPCXML SYS.XMLType;
  l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part DBMS_XMLDOM.DOMNODE;
  l_xml_data DBMS_XMLDOM.DOMNODE;
  l_xml_data_old_child DBMS_XMLDOM.DOMNODE;
  l_new_child DBMS_XMLDOM.DOMNODE;
  l_filename varchar2(400);
  l_filetype varchar2(5);
  l_proc_instr varchar2(400);
  l_startXMLData number default 1;
  l_endXMLData number;
  l_startPackage number default 1;
  l_endPackage number;
  l_contentType varchar2(400);
  l_extensionContentTypes  TContentTypes;
  l_fileContentTypes       TContentTypes;
  l_ext varchar2(5);
  l_xml_data_name varchar2(400);
  l_xml CLOB;
  l_temp CLOB;
  --l_existingFolders TFoldersAndFiles := TFoldersAndFiles();

  BEGIN
    l_flatOPCXML := XMLType(p_FlatOPC);

    if l_flatOPCXML.getRootElement() = 'package'
      and l_flatOPCXML.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      l_pkg_parts := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML), 'part');

      for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
        l_pkg_part := DBMS_XMLDOM.ITEM(l_pkg_parts, i);

        l_pkg_part_attrs := DBMS_XMLDOM.GETATTRIBUTES(l_pkg_part);
        l_filename := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'name')),'/');
        l_contentType := DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'contentType'));

        if (l_filename like 'word/embeddings/%.xlsx' and l_contentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
           (l_filename like 'xl/embeddings/%.docx' and l_contentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        then
          l_xml_data := DBMS_XMLDOM.GETFIRSTCHILD(l_pkg_part);
          l_xml_data_name := DBMS_XMLDOM.GETNODENAME(l_xml_data);
          if l_xml_data_name = 'pkg:xmlData' then
            dbms_lob.CreateTemporary(l_xml, false);
            dbms_lob.CreateTemporary(l_temp, false);
            l_proc_instr := GetProcessingInstruction(upper(substr(l_filename, instr(l_filename,'.',-1, 1) + 1)));

            --get offsets of pkg:xmlData and child pkg:package elements
            l_startXMLData := dbms_lob.instr(p_FlatOPC, '<pkg:part pkg:name="/'||l_filename||'"');
            exit when nvl(l_startXMLData, 0) = 0;

            l_startXMLData := dbms_lob.instr(p_FlatOPC, '<pkg:xmlData>', l_startXMLData);
            exit when nvl(l_startXMLData, 0) = 0;
            l_startPackage := l_startXMLData + length('<pkg:xmlData>');

            l_endPackage := dbms_lob.instr(p_FlatOPC, '</pkg:package>', l_startPackage);
            exit when nvl(l_endPackage, 0) = 0;
            l_endPackage := l_endPackage + length('</pkg:package>');

            l_endXMLData := dbms_lob.instr(p_FlatOPC, '</pkg:xmlData>', l_endPackage);
            exit when nvl(l_endXMLData, 0) = 0;
            l_endXMLData := l_endXMLData + length('</pkg:xmlData>');

            --get XML CLOB to convert to OPEN XML
            dbms_lob.writeappend(l_xml, length(l_proc_instr), l_proc_instr);
            dbms_lob.copy(l_xml, p_FlatOPC, l_endPackage - l_startPackage, dbms_lob.getlength(l_xml) +1, l_startPackage);


            --get clob (l_temp) converted to OPEN XML and Base64 encoded to replace pkg:xmlData element--
            dbms_lob.trim(l_temp, 0);
            dbms_lob.writeappend(l_temp, length('<pkg:binaryData>'),'<pkg:binaryData>');
            AddPkgNamespace(l_xml);
            dbms_lob.append(l_temp, pak_blob_util.base64_encode(FlatOPC2OOXML(l_xml)));
            dbms_lob.writeappend(l_temp, length('</pkg:binaryData>'), '</pkg:binaryData>');

            --replace from l_startXMLData to l_endXMLData with l temp
            --DBMS_XSLPROCESSOR.CLOB2FILE(l_temp, 'XMLDIR', replace(l_filename, '/', '_')||'_temp.xml');
            pak_blob_util.ClobReplace(p_FlatOPC, l_startXMLData, l_endXMLData - 1, l_temp);

            --dbms_lob.trim(l_temp, 0);
            --DBMS_XMLDOM.WRITETOCLOB(l_pkg_part, l_temp);
            --DBMS_XSLPROCESSOR.CLOB2FILE(p_FlatOPC, 'XMLDIR', replace(l_filename, '/', '_')||'.xml');
            dbms_lob.FreeTemporary(l_temp);
            dbms_lob.FreeTemporary(l_xml);
          end if;
        end if;
      end loop;

    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.ZipEmbeedings'
       );
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.ZipEmbeedings'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end ZipEmbeedingsOld;

  /** Replace DOCX and XLSX embeeding in Flat OPC format with &lt;pkg:binaryData&gt; element with base64 encoded OOXML as text node.
  * @param p_FlatOPC Input: Flat OPC Clob with embeeded DOCX and XLSX content also extended.
  * Output: Flat OPC Clob with embeeded DOCX and XLSX content as base64 encoded OOXML.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  */
  Procedure ZipEmbeedings(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
  )
  as
  l_flatOPCXML SYS.XMLType;
  /*
  l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part DBMS_XMLDOM.DOMNODE;
  l_xml_data DBMS_XMLDOM.DOMNODE;
  l_xml_data_old_child DBMS_XMLDOM.DOMNODE;
  l_new_child DBMS_XMLDOM.DOMNODE;
  */
  l_filename varchar2(400);
  l_filetype varchar2(5);
  l_proc_instr varchar2(400);
  l_startXMLData number default 1;
  l_endXMLData number;
  l_startPackage number default 1;
  l_endPackage number;
  l_contentType varchar2(400);
  l_extensionContentTypes  TContentTypes;
  l_fileContentTypes       TContentTypes;
  l_ext varchar2(5);
  l_xml_data_name varchar2(400);
  l_xml CLOB;
  l_temp CLOB;
  l_cur_pack_offset number default 1;
  --l_existingFolders TFoldersAndFiles := TFoldersAndFiles();

  BEGIN
    if dbms_lob.instr(p_FlatOPC, '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">') < 200
    then
      loop
        l_cur_pack_offset := dbms_lob.instr(p_FlatOPC, '<pkg:part ', l_cur_pack_offset);
        exit when nvl(l_cur_pack_offset, 0) = 0;

         --preberemo atribute (pkg:contentType, pkg:name = ime datoteke
        l_filename := ReadAttribute(p_FlatOPC, l_cur_pack_offset, 'pkg:name');
        exit when l_filename is null;

        l_contentType := ReadAttribute(p_FlatOPC, l_cur_pack_offset, 'pkg:contentType');
        exit when l_contentType is null;

        pak_xslt_log.WriteLog
         ( p_description => 'Start processing file '||l_filename
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'flat_OPC_pkg.ZipEmbeedings'
         );

        if (l_filename like 'word/embeddings/%.xlsx' and l_contentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
           (l_filename like 'xl/embeddings/%.docx' and l_contentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        then
            --get offsets of pkg:xmlData and child pkg:package elements
            l_startXMLData := dbms_lob.instr(p_FlatOPC, '<pkg:part pkg:name="/'||l_filename||'"');
            exit when nvl(l_startXMLData, 0) = 0;
            l_cur_pack_offset := l_startXMLData + length('<pkg:part pkg:name="/'||l_filename||'"');

            l_startXMLData := dbms_lob.instr(p_FlatOPC, '<pkg:xmlData>', l_startXMLData);
            exit when nvl(l_startXMLData, 0) = 0 or l_startXMLData - l_cur_pack_offset > 100;
            l_startPackage := l_startXMLData + length('<pkg:xmlData>');

            l_endPackage := dbms_lob.instr(p_FlatOPC, '</pkg:package>', l_startPackage);
            exit when nvl(l_endPackage, 0) = 0;
            l_endPackage := l_endPackage + length('</pkg:package>');

            l_endXMLData := dbms_lob.instr(p_FlatOPC, '</pkg:xmlData>', l_endPackage);
            exit when nvl(l_endXMLData, 0) = 0;
            l_endXMLData := l_endXMLData + length('</pkg:xmlData>');

            dbms_lob.CreateTemporary(l_xml, false);
            dbms_lob.CreateTemporary(l_temp, false);
            l_proc_instr := GetProcessingInstruction(upper(substr(l_filename, instr(l_filename,'.',-1, 1) + 1)));

            --get XML CLOB to convert to OPEN XML
            dbms_lob.writeappend(l_xml, length(l_proc_instr), l_proc_instr);
            dbms_lob.copy(l_xml, p_FlatOPC, l_endPackage - l_startPackage, dbms_lob.getlength(l_xml) +1, l_startPackage);

            --get clob (l_temp) converted to OPEN XML and Base64 encoded to replace pkg:xmlData element--
            dbms_lob.trim(l_temp, 0);
            dbms_lob.writeappend(l_temp, length('<pkg:binaryData>'),'<pkg:binaryData>');
            AddPkgNamespace(l_xml);
            dbms_lob.append(l_temp, pak_blob_util.base64_encode(FlatOPC2OOXML(l_xml)));
            dbms_lob.writeappend(l_temp, length('</pkg:binaryData>'), '</pkg:binaryData>');

            --replace from l_startXMLData to l_endXMLData with l temp
            --DBMS_XSLPROCESSOR.CLOB2FILE(l_temp, 'XMLDIR', replace(l_filename, '/', '_')||'_temp.xml');
            pak_blob_util.ClobReplace(p_FlatOPC, l_startXMLData, l_endXMLData - 1, l_temp);

            --dbms_lob.trim(l_temp, 0);
            --DBMS_XMLDOM.WRITETOCLOB(l_pkg_part, l_temp);
            --DBMS_XSLPROCESSOR.CLOB2FILE(p_FlatOPC, 'XMLDIR', replace(l_filename, '/', '_')||'.xml');
            dbms_lob.FreeTemporary(l_temp);
            dbms_lob.FreeTemporary(l_xml);

        end if;
        l_cur_pack_offset := dbms_lob.instr(p_FlatOPC, '</pkg:part>', l_cur_pack_offset);
        exit when nvl(l_cur_pack_offset, 0) = 0;
        l_cur_pack_offset := l_cur_pack_offset + length('</pkg:part>');
      end loop;

    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.ZipEmbeedings'
       );
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.ZipEmbeedings'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end ZipEmbeedings;


/** Replace base64 encoded DOCX and XLSX embeeding in Flat OPC format with embeeded FlatOPC with &lt;pkg:package&gt; as root element.
  * @param p_FlatOPC Input: Flat OPC Clob with embeeded DOCX and XLSX content also extended.
  * Output: Flat OPC Clob with embeeded DOCX and XLSX content as base64 encoded OOXML.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  */
  Procedure UnzipEmbeedings(
    p_FlatOPC IN OUT NOCOPY CLOB,
    p_encoding varchar2 := null
  )
  as
  l_flatOPCXML SYS.XMLType;
  l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part DBMS_XMLDOM.DOMNODE;
  l_bindata DBMS_XMLDOM.DOMNODE;
  --l_new_child DBMS_XMLDOM.DOMNODE;
  l_filename varchar2(400);
  l_filetype varchar2(5);
  --l_proc_instr varchar2(400);
  l_startXMLData number default 1;
  l_endXMLData number;
  l_startB64 number default 1;
  l_endB64 number;
  l_contentType varchar2(400);
  --l_extensionContentTypes  TContentTypes;
  --l_fileContentTypes       TContentTypes;
  --l_ext varchar2(5);
  l_bindata_name varchar2(400);
  l_bin CLOB;
  l_temp CLOB;
  l_parts varchar2(4000);
  --l_existingFolders TFoldersAndFiles := TFoldersAndFiles();

  BEGIN
    l_flatOPCXML := XMLType(p_FlatOPC);

    if l_flatOPCXML.getRootElement() = 'package'
      and l_flatOPCXML.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      l_pkg_parts := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML), 'part');

      for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
        l_pkg_part := DBMS_XMLDOM.ITEM(l_pkg_parts, i);

        l_pkg_part_attrs := DBMS_XMLDOM.GETATTRIBUTES(l_pkg_part);
        l_filename := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'name')),'/');
        l_contentType := DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'contentType'));

        if (l_filename like 'word/embeddings/%.xlsx' and l_contentType='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet') or
           (l_filename like 'xl/embeddings/%.docx' and l_contentType='application/vnd.openxmlformats-officedocument.wordprocessingml.document')
        then
          l_bindata := DBMS_XMLDOM.GETFIRSTCHILD(l_pkg_part);
          l_bindata_name := DBMS_XMLDOM.GETNODENAME(l_bindata);
          if l_bindata_name = 'pkg:binaryData' then
            --base64_decode(l_b64)
            dbms_lob.CreateTemporary(l_bin, false);
            dbms_lob.CreateTemporary(l_temp, false);

            --get offsets of pkg:xmlData and child pkg:package elements
            l_startXMLData := dbms_lob.instr(p_FlatOPC, '<pkg:part pkg:name="/'||l_filename||'"');
            exit when nvl(l_startXMLData, 0) = 0;

            l_startXMLData := dbms_lob.instr(p_FlatOPC, '<pkg:binaryData>', l_startXMLData);
            exit when nvl(l_startXMLData, 0) = 0;
            l_startB64 := l_startXMLData + length('<pkg:binaryData>');

            l_endB64 := dbms_lob.instr(p_FlatOPC, '</pkg:binaryData>', l_startB64);
            exit when nvl(l_endB64, 0) = 0;
            --l_endPackage := l_endPackage + length('</pkg:package>');

            l_endXMLData := l_endB64 + length('</pkg:binaryData>');

            --get XML CLOB to convert to OPEN XML

            dbms_lob.copy(l_bin, p_FlatOPC, l_endB64 - l_startB64, 1, l_startB64);
            --ZIP_UTIL_PKG.save_blob_to_file ('XMLDIR', 'test4'||i||'.xml', base64_decode(l_bin)); OK
            l_bin := OOXML2FlatOPC(
              pak_blob_util.base64_decode(l_bin),
              p_filetype => null,
              po_parts => l_parts,
              p_unzip_embeedeings => false,
              p_encoding => p_encoding
            );

            dbms_lob.writeappend(l_temp, length('<pkg:xmlData>'), '<pkg:xmlData>');
            dbms_lob.append(l_temp, l_bin);
            dbms_lob.writeappend(l_temp, length('</pkg:xmlData>'), '</pkg:xmlData>');

            --replace from l_startXMLData to l_endXMLData with l_bin
            pak_blob_util.ClobReplace(p_FlatOPC, l_startXMLData, l_endXMLData - 1, l_temp);
            dbms_lob.FreeTemporary(l_bin);
            dbms_lob.FreeTemporary(l_temp);
          end if;
        end if;
      end loop;

    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.UnzipEmbeedings'
       );
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.UnzipEmbeedings'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end UnzipEmbeedings;


/** Returns parts of p_FlatOPC separated with colons (:).
  * @param p_FlatOPC Clob with Flat OPC.
  * @return Parts separated with colons.
  */
  function GetFlatOPCParts(
    p_FlatOPC             IN CLOB
  ) return varchar2
  as
  l_flatOPC SYS.XMLType;
  l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part DBMS_XMLDOM.DOMNODE;
  l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_filename varchar2(400);
  l_ret varchar2(32000);

  BEGIN
    l_flatOPC := XMLType(p_FlatOPC);
    if l_flatOPC.getRootElement() = 'package'
      and l_flatOPC.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      l_pkg_parts := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPC))));

      for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
        l_pkg_part := DBMS_XMLDOM.ITEM(l_pkg_parts, i);
        l_pkg_part_attrs := DBMS_XMLDOM.GETATTRIBUTES(l_pkg_part);
        l_filename := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'name')),'/');

        if l_ret is null then
          l_ret := l_filename;
        else
          l_ret := l_ret||':'||l_filename;
        end if;
      end loop;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.GetFlatOPCParts'
       );
    end if;
    return l_ret;
  exception
    when others then
      pak_xslt_log.WriteLog
         ( p_description       => 'Error'
         , p_log_type      => pak_xslt_log.g_error
         , p_procedure  => 'flat_OPC_pkg.GetFlatOPCParts'
         , P_SQLERRM   =>  sqlerrm
         );
      raise;
  END GetFlatOPCParts;


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
  ) return CLOB
  as
  l_ret CLOB;
  l_second_flatOPC SYS.XMLType;
  l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part DBMS_XMLDOM.DOMNODE;
  l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_filename varchar2(400);
  l_partsToTransform varchar2(400);
  l_flatOPCNode DBMS_XMLDOM.DOMNODE;
  l_flatOPCDoc  DBMS_XMLDOM.DOMDOCUMENT;

  BEGIN
    l_flatOPCDoc := DBMS_XMLDOM.NEWDOMDOCUMENT(p_flatOPC);
    l_flatOPCNode := DBMS_XMLDOM.GETLASTCHILD(DBMS_XMLDOM.MAKENODE(l_flatOPCDoc));
    l_partsToTransform := GetFlatOPCParts(p_flatOPC);
    l_second_flatOPC := XMLType(p_second_FlatOPC);
    dbms_lob.CreateTemporary(l_ret, false);
    if l_second_flatOPC.getRootElement() = 'package'
      and l_second_flatOPC.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      l_pkg_parts := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(l_second_flatOPC))));
      for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
        l_pkg_part := DBMS_XMLDOM.ITEM(l_pkg_parts, i);
        l_pkg_part_attrs := DBMS_XMLDOM.GETATTRIBUTES(l_pkg_part);
        l_filename := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'name')),'/');

        pak_xslt_log.WriteLog
         ( p_description => 'Start processing file '||l_filename
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'flat_OPC_pkg.MergeFlatOPC'
         );

        if l_partsToTransform is null or nvl(instr(l_partsToTransform, ':'||l_filename||':'),0) = 0 then

          pak_xslt_log.WriteLog
           ( p_description => 'Start append child '||l_filename
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.MergeFlatOPC'
           );

          l_pkg_part := DBMS_XMLDOM.IMPORTNODE(l_flatOPCDoc, l_pkg_part, deep => true);
          l_pkg_part := DBMS_XMLDOM.APPENDCHILD(l_flatOPCNode, l_pkg_part);

          pak_xslt_log.WriteLog
           ( p_description => 'Finish append child '||l_filename
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.MergeFlatOPC'
           );
        end if;

        pak_xslt_log.WriteLog
        ( p_description => 'File '||l_filename||' processed '
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'flat_OPC_pkg.MergeFlatOPC'
        );
      end loop;
      DBMS_XMLDOM.WRITETOCLOB(l_flatOPCDoc, l_ret);
      return l_ret;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.MergeFlatOPC'
       );
       dbms_lob.FreeTemporary(l_ret);
      return p_FlatOPC;
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.MergeFlatOPC'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END MergeFlatOPC;

$if CCOMPILING.g_utl_file_privilege $then
/** Add file p_second_FlatOPCDir/File to file p_FlatOPCDir/File part by part and returns merged Flat OPC in file p_merged_FlatOPCDir/File.
  * Parts listed in p_partsToTransform are not added to file p_merged_FlatOPCDir/File.
  * @param p_FlatOPCDir Location of first Flat OPC. First Flat OPC will be copied into returned file p_merged_FlatOPCDir/File as a whole.
  * @param p_FlatOPCFile Filename of first Flat OPC. First Flat OPC will be copied into returned file p_merged_FlatOPCDir/File as a whole.
  * @param p_second_FlatOPCDir Location of second Flat OPC. Parts not listed in p_partsToTransform will be copied to returned file p_merged_FlatOPCDir/File.
  * @param p_second_FlatOPCFile Filename of second Flat OPC. Parts not listed in p_partsToTransform will be copied to returned file p_merged_FlatOPCDir/File.
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
  )
  as
  l_merged_FlatOPC  CLOB;
  l_FlatOPC         CLOB;
  l_second_FlatOPC  CLOB;
  begin
    l_flatOPC := pak_blob_util.Read2CLOB(p_FlatOPCDir, p_FlatOPCFile, p_encoding);
    l_second_flatOPC := pak_blob_util.Read2CLOB(p_second_FlatOPCDir, p_second_FlatOPCFile, p_encoding);
    l_merged_FlatOPC := MergeFlatOPC(l_FlatOPC, l_second_FlatOPC, p_encoding);
    dbms_xslprocessor.clob2file(l_merged_FlatOPC, p_merged_FlatOPCDir, p_merged_FlatOPCFile, nvl(NLS_CHARSET_ID(p_encoding), 0));
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.MergeFlatOPC (file ver.)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end;
$end

  procedure FlatOPC2OOXMLExOld(
    pio_OOXml                 IN OUT NOCOPY BLOB,
    pio_FlatOPC               IN OUT NOCOPY CLOB,
    pio_extensionContentTypes IN OUT TContentTypes,
    pio_fileContentTypes      IN OUT TContentTypes,
    pio_existingFolders       IN OUT TFoldersAndFiles,
    pio_nonXMLFiles           IN OUT TFoldersAndFiles,
    p_finishZip               boolean,
    p_encoding                varchar2 default null
  )
  as
  l_flatOPCXML SYS.XMLType;
  l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part DBMS_XMLDOM.DOMNODE;
  l_binary_or_xml_data DBMS_XMLDOM.DOMNODE;
  l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_filename varchar2(400);
  l_startXMLData number default 1;
  l_endXMLData number;
  l_contentType varchar2(400);
  l_ext varchar2(5);
  l_binary_or_xml_data_name varchar2(400);
  l_xml CLOB;
  l_b64 CLOB;
  l_skip_part boolean := false;
  l_log varchar2(400);

  BEGIN
    --initialization--
    if pio_existingFolders is null then
      pio_existingFolders := TFoldersAndFiles();
    end if;

    if pio_nonXMLFiles is null then
      pio_nonXMLFiles := TFoldersAndFiles();
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-extensionContentTypes: '||LogContentTypes(pio_extensionContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-fileContentTypes: '||LogContentTypes(pio_fileContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-existingFolders: '||LogFoldersAndFiles(pio_existingFolders)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-nonXMLFiles: '||LogFoldersAndFiles(pio_nonXMLFiles)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    ZipEmbeedings(pio_FlatOPC, p_encoding);
    l_flatOPCXML := XMLType(pio_FlatOPC);
    --l_partsToTransform := ':'||translate(p_partsToTransform,',;?*+#!',':::::::')||':';
    if l_flatOPCXML.getRootElement() = 'package'
      and l_flatOPCXML.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      --l_pkg_parts := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML), 'part');
      --prebere childe od dokument node-a - <pkg:part> elemente
      l_pkg_parts := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML))));
      dbms_lob.CreateTemporary(l_b64, false);
      dbms_lob.CreateTemporary(l_xml, false);
      --gremo cez vse <pkg:part> elemente
      for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
        l_pkg_part := DBMS_XMLDOM.ITEM(l_pkg_parts, i);

         --preberemo atribute (pkg:contentType, pkg:name = ime datoteke
        l_pkg_part_attrs := DBMS_XMLDOM.GETATTRIBUTES(l_pkg_part);
        l_filename := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'name')),'/');

        if l_filename is not null then --naredimo
          l_contentType := DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'contentType'));

          pak_xslt_log.WriteLog
           ( p_description => 'Start processing file '||l_filename
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
           );

          --dodamo folderje v zip
          AddFolders(pio_OOXml, l_filename, pio_existingFolders);
          l_skip_part := false;

          --ce gre za xml part
          if substr(l_filename, length(l_filename)-3) = '.xml' and substr(l_contentType, length(l_contentType)-3) = '+xml' then
            if pio_fileContentTypes.exists(l_filename) then --already exists, ga ne vkljucimo v OOXML
              l_skip_part := true;
            else
              pio_fileContentTypes(l_filename) := l_contentType; --ga vkljucimo
            end if;
          else --sicer gre za vkljucen drug tip dokumenta (npr xlsx v wordu-docx)
            l_ext := substr(l_filename, nullif( instr(l_filename,'.', -1) +1, 1) );
            if l_ext is not null and not pio_extensionContentTypes.exists(l_ext) then
              pio_extensionContentTypes(l_ext) := l_contentType;
            end if;
            --ce že obstaja
            if FolderOrFileExists(pio_nonXMLFiles, l_filename) then
              l_skip_part := true;
            else
              pio_nonXMLFiles.extend;
              pio_nonXMLFiles(pio_nonXMLFiles.count) := l_filename;
            end if;
          end if;

          l_binary_or_xml_data := DBMS_XMLDOM.GETFIRSTCHILD(l_pkg_part); --preberemo ali <pkg:xmlData> ali <pkg:binaryData>
          l_binary_or_xml_data_name := DBMS_XMLDOM.GETNODENAME(l_binary_or_xml_data);

          if l_binary_or_xml_data_name = 'pkg:xmlData' then
            l_startXMLData := dbms_lob.instr(pio_FlatOPC, '<pkg:xmlData>', l_startXMLData);
            exit when nvl(l_startXMLData, 0) = 0;
            l_startXMLData := l_startXMLData + length('<pkg:xmlData>');
            l_startXMLData := dbms_lob.instr(pio_FlatOPC, '<', l_startXMLData);
            exit when nvl(l_startXMLData, 0) = 0;
            l_endXMLData := dbms_lob.instr(pio_FlatOPC, '</pkg:xmlData>', l_startXMLData);
            exit when nvl(l_endXMLData, 0) = 0;

            if not l_skip_part then
              dbms_lob.Trim(l_xml, 0);
              dbms_lob.WriteAppend(l_xml, length(c_xml_proc_instr), c_xml_proc_instr);
              dbms_lob.Copy(l_xml, pio_FlatOPC, l_endXMLData-l_startXMLData, dbms_lob.getlength(l_xml)+1, l_startXMLData);
              zip_util_pkg.add_file(pio_OOXml, l_filename, pak_blob_util.Clob2Blob(l_xml, p_encoding));
              l_log:='FlatOPC offset '||l_startXMLData||' - '||l_endXMLData;
            end if;
            l_startXMLData := l_endXMLData + length('</pkg:xmlData>');
          elsif l_binary_or_xml_data_name = 'pkg:binaryData' then
            --decode base64 l_xml_or_binary to BLOB
            if not l_skip_part then
              dbms_lob.Trim(l_b64, 0);
              DBMS_XMLDOM.WRITETOCLOB(DBMS_XMLDOM.GETFIRSTCHILD(l_binary_or_xml_data), l_b64);
              zip_util_pkg.add_file(pio_OOXml, l_filename, pak_blob_util.base64_decode(l_b64));
              l_log:='Binary part';
            end if;
          end if;
          if l_skip_part then
            pak_xslt_log.WriteLog
             ( p_description => 'File '||l_filename||' skipped '
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
             );
          else
            pak_xslt_log.WriteLog
             ( p_description => 'File '||l_filename||' processed. '||l_log
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
             );
          end if;
        end if;
      end loop;
      dbms_lob.FreeTemporary(l_b64);
      dbms_lob.FreeTemporary(l_xml);

      if p_finishZip then
        --add [Content_Types].xml
        pio_extensionContentTypes('xml') := 'application/xml'; --always in [Content_Types].xml
        zip_util_pkg.add_file(pio_OOXml, '[Content_Types].xml',
            pak_blob_util.Clob2Blob(GetContentTypesXml(pio_extensionContentTypes, pio_fileContentTypes), p_encoding)
        );
        zip_util_pkg.finish_zip(pio_OOXml);

        pak_xslt_log.WriteLog
           ( p_description => 'Zip completed'
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
           );
      end if;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
       );
      pio_OOXml := pak_blob_util.Clob2Blob(pio_FlatOPC, p_encoding);
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-extensionContentTypes: '||LogContentTypes(pio_extensionContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-fileContentTypes: '||LogContentTypes(pio_fileContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-existingFolders: '||LogFoldersAndFiles(pio_existingFolders)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-nonXMLFiles: '||LogFoldersAndFiles(pio_nonXMLFiles)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END FlatOPC2OOXMLExOld;

  function ReadAttribute(p_Xml CLOB, p_offset number, p_attrname varchar2)
  return varchar2
  as
  l_attr_offset number;
  l_attr_end number;
  l_ret varchar2(4000);
  begin
    l_attr_offset := dbms_lob.instr(p_Xml, p_attrname||'="', p_offset);
    if l_attr_offset > 0 then
      l_attr_offset := l_attr_offset + length(p_attrname||'="');
      l_attr_end := dbms_lob.instr(p_Xml, '"', l_attr_offset);
      if l_attr_end > 0 then
        l_ret := dbms_lob.substr(p_Xml, l_attr_end - l_attr_offset, l_attr_offset);
      end if;
    end if;

    return l_ret;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.ReadAttribute'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end ReadAttribute;

  procedure FlatOPC2OOXMLEx(
    pio_OOXml                 IN OUT NOCOPY BLOB,
    pio_FlatOPC               IN OUT NOCOPY CLOB,
    pio_extensionContentTypes IN OUT TContentTypes,
    pio_fileContentTypes      IN OUT TContentTypes,
    pio_existingFolders       IN OUT TFoldersAndFiles,
    pio_nonXMLFiles           IN OUT TFoldersAndFiles,
    p_finishZip               boolean,
    p_encoding                varchar2 default null
  )
  as
  --l_flatOPCXML SYS.XMLType;
  --l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
  l_pkg_part varchar2(4000);
  l_binary_or_xml_data CLOB;
  --l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
  l_filename varchar2(400);
  l_cur_pack_offset number default 1;

  l_startXMLData number default 1;
  l_endXMLData number;
  l_startBinaryData number default 1;
  l_endBinaryData number;

  l_contentType varchar2(400);
  l_ext varchar2(5);
  l_binary_or_xml_data_name varchar2(400);
  l_binary_offset number;
  l_xml_offset number;
  l_xml CLOB;
  l_b64 CLOB;
  l_skip_part boolean := false;
  l_log varchar2(400);

  BEGIN
    --initialization--
    if pio_existingFolders is null then
      pio_existingFolders := TFoldersAndFiles();
    end if;

    if pio_nonXMLFiles is null then
      pio_nonXMLFiles := TFoldersAndFiles();
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-extensionContentTypes: '||LogContentTypes(pio_extensionContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-fileContentTypes: '||LogContentTypes(pio_fileContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-existingFolders: '||LogFoldersAndFiles(pio_existingFolders)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'Start proc-nonXMLFiles: '||LogFoldersAndFiles(pio_nonXMLFiles)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    ZipEmbeedings(pio_FlatOPC, p_encoding);
    --l_flatOPCXML := XMLType(pio_FlatOPC);
    --l_partsToTransform := ':'||translate(p_partsToTransform,',;?*+#!',':::::::')||':';
    if dbms_lob.instr(pio_FlatOPC, '<pkg:package xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage">') < 200
    then
      --l_pkg_parts := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML), 'part');
      --prebere childe od dokument node-a - <pkg:part> elemente
      --l_pkg_parts := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML))));
      dbms_lob.CreateTemporary(l_b64, false);
      dbms_lob.CreateTemporary(l_xml, false);
      --gremo cez vse <pkg:part> elemente
      --for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
      loop
        l_cur_pack_offset := dbms_lob.instr(pio_FlatOPC, '<pkg:part ', l_cur_pack_offset);
        exit when nvl(l_cur_pack_offset, 0) = 0;

         --preberemo atribute (pkg:contentType, pkg:name = ime datoteke
        l_filename := ReadAttribute(pio_FlatOPC, l_cur_pack_offset, 'pkg:name');
        exit when l_filename is null;

        l_contentType := ReadAttribute(pio_FlatOPC, l_cur_pack_offset, 'pkg:contentType');
        exit when l_contentType is null;

        pak_xslt_log.WriteLog
         ( p_description => 'Start processing file '||l_filename
         , p_log_type    => pak_xslt_log.g_information
         , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
         );

        --dodamo folderje v zip
        AddFolders(pio_OOXml, l_filename, pio_existingFolders);
        l_skip_part := false;

        --ce gre za xml part
        if substr(l_filename, length(l_filename)-3) = '.xml' and substr(l_contentType, length(l_contentType)-3) = '+xml' then
          if pio_fileContentTypes.exists(l_filename) then --already exists, ga ne vkljucimo v OOXML
            l_skip_part := true;

            pak_xslt_log.WriteLog
             ( p_description => 'Skip file '||l_filename
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
             );
          else
            pak_xslt_log.WriteLog
             ( p_description => 'Include file '||l_filename
             , p_log_type    => pak_xslt_log.g_information
             , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
             );
            pio_fileContentTypes(l_filename) := l_contentType; --ga vkljucimo
          end if;
        else --sicer gre za vkljucen drug tip dokumenta (npr xlsx v wordu-docx)
          l_ext := substr(l_filename, nullif( instr(l_filename,'.', -1) +1, 1) );
          if l_ext is not null and not pio_extensionContentTypes.exists(l_ext) then
            pio_extensionContentTypes(l_ext) := l_contentType;
          end if;
          --ce že obstaja
          if FolderOrFileExists(pio_nonXMLFiles, l_filename) then
            l_skip_part := true;
          else
            pio_nonXMLFiles.extend;
            pio_nonXMLFiles(pio_nonXMLFiles.count) := l_filename;
          end if;
        end if;

        --l_binary_or_xml_data := DBMS_XMLDOM.GETFIRSTCHILD(l_pkg_part); --preberemo ali <pkg:xmlData> ali <pkg:binaryData>
        --l_binary_or_xml_data_name := DBMS_XMLDOM.GETNODENAME(l_binary_or_xml_data);

        l_startXMLData := nvl(dbms_lob.instr(pio_FlatOPC, '<pkg:xmlData>', l_cur_pack_offset), 0);
        l_startBinaryData := nvl(dbms_lob.instr(pio_FlatOPC, '<pkg:binaryData>', l_cur_pack_offset), 0);

        if l_startXMLData > 0 and (l_startXMLData < l_startBinaryData or l_startBinaryData = 0) then
          --l_startXMLData := dbms_lob.instr(pio_FlatOPC, '<pkg:xmlData>', l_startXMLData);
          --exit when nvl(l_startXMLData, 0) = 0;
          l_startXMLData := l_startXMLData + length('<pkg:xmlData>');
          l_startXMLData := dbms_lob.instr(pio_FlatOPC, '<', l_startXMLData);
          exit when nvl(l_startXMLData, 0) = 0;
          l_endXMLData := dbms_lob.instr(pio_FlatOPC, '</pkg:xmlData>', l_startXMLData);
          exit when nvl(l_endXMLData, 0) = 0;

          if not l_skip_part then
            dbms_lob.Trim(l_xml, 0);
            dbms_lob.WriteAppend(l_xml, length(c_xml_proc_instr), c_xml_proc_instr);
            dbms_lob.Copy(l_xml, pio_FlatOPC, l_endXMLData-l_startXMLData, dbms_lob.getlength(l_xml)+1, l_startXMLData);
            zip_util_pkg.add_file(pio_OOXml, ltrim(l_filename,'/'), pak_blob_util.Clob2Blob(l_xml, p_encoding));
            l_log:='FlatOPC offset '||l_startXMLData||' - '||l_endXMLData;
          end if;
          l_startXMLData := l_endXMLData + length('</pkg:xmlData>');
        elsif l_startBinaryData > 0 and (l_startBinaryData < l_startXMLData or l_startXMLData = 0) then
          --decode base64 l_xml_or_binary to BLOB
          l_startBinaryData := l_startBinaryData + length('<pkg:binaryData>');
          --l_startBinaryData := dbms_lob.instr(pio_FlatOPC, '<', l_startBinaryData);
          exit when nvl(l_startBinaryData, 0) = 0;
          l_endBinaryData := dbms_lob.instr(pio_FlatOPC, '</pkg:binaryData>', l_startBinaryData);
          exit when nvl(l_startBinaryData, 0) = 0;
          if not l_skip_part then
            --TODO preberi v l_b64 na enak nacin kot binaryData
            dbms_lob.Trim(l_b64, 0);
            --dbms_lob.WriteAppend(l_b64, length(c_xml_proc_instr), c_xml_proc_instr);
            dbms_lob.Copy(l_b64, pio_FlatOPC, l_endBinaryData-l_startBinaryData, dbms_lob.getlength(l_b64)+1, l_startBinaryData);
            zip_util_pkg.add_file(pio_OOXml, ltrim(l_filename,'/'), pak_blob_util.base64_decode(l_b64));
            l_log:='Binary part';
          end if;
        end if;
        if l_skip_part then
          pak_xslt_log.WriteLog
           ( p_description => 'File '||l_filename||' skipped '
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
           );
        else
          pak_xslt_log.WriteLog
           ( p_description => 'File '||l_filename||' processed. '||l_log
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
           );
        end if;
        l_cur_pack_offset := dbms_lob.instr(pio_FlatOPC, '</pkg:part>', l_cur_pack_offset);
        exit when nvl(l_cur_pack_offset, 0) = 0;
        l_cur_pack_offset := l_cur_pack_offset + length('</pkg:part>');
      end loop;
      dbms_lob.FreeTemporary(l_b64);
      dbms_lob.FreeTemporary(l_xml);

      if p_finishZip then
        --add [Content_Types].xml
        pio_extensionContentTypes('xml') := 'application/xml'; --always in [Content_Types].xml
        zip_util_pkg.add_file(pio_OOXml, '[Content_Types].xml',
            pak_blob_util.Clob2Blob(GetContentTypesXml(pio_extensionContentTypes, pio_fileContentTypes), p_encoding)
        );
        zip_util_pkg.finish_zip(pio_OOXml);

        pak_xslt_log.WriteLog
           ( p_description => 'Zip completed'
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
           );
      end if;
    else
      pak_xslt_log.WriteLog
       ( p_description => 'Invalid Format, Not Flat OPC'
       , p_log_type    => pak_xslt_log.g_error
       , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
       );
      pio_OOXml := pak_blob_util.Clob2Blob(pio_FlatOPC, p_encoding);
    end if;

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-extensionContentTypes: '||LogContentTypes(pio_extensionContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-fileContentTypes: '||LogContentTypes(pio_fileContentTypes)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-existingFolders: '||LogFoldersAndFiles(pio_existingFolders)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );

    pak_xslt_log.WriteLog
     ( p_description => 'End proc-nonXMLFiles: '||LogFoldersAndFiles(pio_nonXMLFiles)
     , p_log_type    => pak_xslt_log.g_information
     , p_procedure   => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
     );
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.FlatOPC2OOXMLEx'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END FlatOPC2OOXMLEx;

  /** Convert Flat OPC XML CLOB to OOXML BLOB (DOCX, XLSX, PPTX).
  * You should set parameters p_staticParts, p_partsToTransform to non null values only if you really need to compose
  * final OOXML from two Flat OPC CLOBs. Custom scenario would be producing FlatOPC CLOB with XSLT (dynamic parts) and add the rest of the OOXML parts
  * from p_staticParts CLOB.
  * @param pio_FlatOPC Flat OPC clob, on output FLAT OPC with base64 encoded embeeded DOCX and XLSX content that can be opened with Word or Power Point. Excel doesn't support Flat OPC format.
  * If input CLOB doesn't contain any embeeded DOCX and XLSX content output CLOB is equal to input CLOB.
  * @param p_staticParts Flat OPC CLOB with static OOXML parts.
  * These should be parts (dynamic parts) of pio_FlatOPC CLOB. The rest of the parts will be included from p_staticParts CLOB.
  * @param p_encoding Encoding (if left null UTF8 assumed).
  * @return OOXML BLOB
  */
  function FlatOPC2OOXMLEx(
    pio_FlatOPC IN OUT NOCOPY CLOB,
    pio_staticParts IN OUT NOCOPY CLOB,
    p_encoding varchar2 default null
  )
  return BLOB AS

  l_ret BLOB;
  l_extensionContentTypes  TContentTypes;
  l_fileContentTypes       TContentTypes;
  l_existingFolders TFoldersAndFiles := TFoldersAndFiles();
  l_nonXMLFiles     TFoldersAndFiles := TFoldersAndFiles();
  BEGIN
    if pio_staticParts is not null then
      --dbms_xslprocessor.clob2file(pio_FlatOPC, 'XMLDIR', 'test1.xml', nvl(NLS_CHARSET_ID(p_encoding), 0));
      FlatOPC2OOXMLEx(
        l_ret,
        pio_FlatOPC,
        l_extensionContentTypes,
        l_fileContentTypes,
        l_existingFolders,
        l_nonXMLFiles,
        p_finishZip => false,
        p_encoding => p_encoding
      );

      FlatOPC2OOXMLEx(
        l_ret,
        pio_staticParts,
        l_extensionContentTypes,
        l_fileContentTypes,
        l_existingFolders,
        l_nonXMLFiles,
        p_finishZip => true,
        p_encoding => p_encoding
      );
    else --p_staticParts is null
      FlatOPC2OOXMLEx(
        l_ret,
        pio_FlatOPC,
        l_extensionContentTypes,
        l_fileContentTypes,
        l_existingFolders,
        l_nonXMLFiles,
        p_finishZip => true,
        p_encoding => p_encoding
      );
    end if;

    --TODO add l_staticParts into pio_FlatOPC
    --pio_FlatOPC := MergeFlatOPC(pio_FlatOPC, l_staticParts, p_encoding);

  RETURN l_ret;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.FlatOPC2OOXMLEx(BLOB ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END FlatOPC2OOXMLEx;


  /** Convert Flat OPC XML CLOB to OOXML BLOB (DOCX, XLSX, PPTX).
  * You should set parameters p_staticParts, p_partsToTransform to non null values only if you really need to compose
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
    p_encoding varchar2 := null
  )
  return BLOB AS
  l_FlatOPC CLOB := p_FlatOPC;
  l_staticParts CLOB := p_staticParts;
  begin
    return FlatOPC2OOXMLEx(l_FlatOPC, l_staticParts, p_encoding);
  end;


$if CCOMPILING.g_utl_file_privilege $then
   /** Convert Flat OPC XML file to OOXML file (DOCX, XLSX, PPTX). Optionaly can also write "valid" FLAT OPC file with
  * base64 encoded embeeded DOCX and XLSX content that can be opened with Word or Power Point. Excel doesn't support Flat OPC format.
  * You should set parameters p_staticPartsDir, p_staticPartsFile, p_partsToTransform to non null values only if you really need to compose
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
    p_encoding    varchar2 := null
  ) AS
  l_flatOPC     CLOB;
  l_staticParts  CLOB;
  l_OOXMLDir  varchar2(400);
  l_OOXMLFile varchar2(400);
  l_blob BLOB;

  BEGIN
    l_OOXMLDir := nvl(p_OOXMLDir, p_FlatOPCDir);
    l_OOXMLFile := nvl(p_OOXMLFile, p_FlatOPCFile||'.zip');
    l_flatOPC := pak_blob_util.Read2CLOB(p_FlatOPCDir, p_FlatOPCFile, p_encoding);

    if p_staticPartsDir is not null and p_staticPartsFile is not null then
      l_staticParts := pak_blob_util.Read2CLOB(p_staticPartsDir, p_staticPartsFile, p_encoding);
    end if;

    l_blob := FlatOPC2OOXMLEx(l_FlatOPC, l_staticParts, /*p_partsToTransform,*/ p_encoding);
    ZIP_UTIL_PKG.save_blob_to_file (l_OOXMLDir, l_OOXMLFile, FlatOPC2OOXML(l_FlatOPC, p_encoding));

    if p_FlatOPCValidDir is not null and p_FlatOPCValidFile is not null then
      l_FlatOPC := MergeFlatOPC(l_FlatOPC, l_staticParts, p_encoding);
      ZIP_UTIL_PKG.save_blob_to_file (p_FlatOPCValidDir, p_FlatOPCValidFile, pak_blob_util.Clob2Blob(l_FlatOPC, p_encoding));
    end if;
    dbms_lob.freetemporary(l_flatOPC);
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.FlatOPC2OOXML (file ver)'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  END FlatOPC2OOXML;
$end

  /** Exclude only parts for transformation
  * @param pio_FlatOPC Flat OPC clob, on output FLAT OPC with parts for XSL transformation only.
  * @param p_partsToTransform XSL Transformed parts of po_OOXML separated with comma.
  */
  procedure FlatOPCTransfromedOnly(
    pio_FlatOPC IN OUT CLOB,
    p_partsToTransform varchar2
  )
  as
    l_pkg_parts DBMS_XMLDOM.DOMNODELIST;
    l_pkg_part DBMS_XMLDOM.DOMNODE;
    l_deleted_pkg_part DBMS_XMLDOM.DOMNODE;
    l_pkg_part_attrs DBMS_XMLDOM.DOMNAMEDNODEMAP;
    l_xmldoc DBMS_XMLDOM.DOMDOCUMENT;
    l_filename varchar2(400);

    l_flatOPCXML SYS.XMLType;
  begin
    --UnzipEmbeedings(pio_FlatOPC);
    l_flatOPCXML := XMLType(pio_FlatOPC);

    if l_flatOPCXML.getRootElement() = 'package'
      and l_flatOPCXML.getNamespace() = 'http://schemas.microsoft.com/office/2006/xmlPackage'
    then
      l_xmldoc := DBMS_XMLDOM.NEWDOMDOCUMENT(l_flatOPCXML);
      --l_pkg_parts := DBMS_XMLDOM.GETELEMENTSBYTAGNAME(l_xmldoc, 'part');
      l_pkg_parts := DBMS_XMLDOM.GETCHILDNODES(DBMS_XMLDOM.MAKENODE(DBMS_XMLDOM.GETDOCUMENTELEMENT(l_xmldoc)));
      --dbms_lob.CreateTemporary(l_b64, false);
      --dbms_lob.CreateTemporary(l_xml, false);
      for i in 0..DBMS_XMLDOM.GETLENGTH(l_pkg_parts)-1 loop
        l_pkg_part := DBMS_XMLDOM.ITEM(l_pkg_parts, i);

        l_pkg_part_attrs := DBMS_XMLDOM.GETATTRIBUTES(l_pkg_part);
        l_filename := ltrim(DBMS_XMLDOM.GETNODEVALUE(DBMS_XMLDOM.GETNAMEDITEM(l_pkg_part_attrs, 'name')),'/');

        if  nvl(instr(':'||p_partsToTransform||':', ':'||l_filename||':'), 0)=0 then
          l_deleted_pkg_part := DBMS_XMLDOM.REMOVECHILD(DBMS_XMLDOM.MAKENODE(l_xmldoc), l_pkg_part);
          pak_xslt_log.WriteLog
           ( p_description => 'Deleting part '||l_filename
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPCTransfromedOnly'
           );
        else
          pak_xslt_log.WriteLog
           ( p_description => 'Part '||l_filename||' left in OPC'
           , p_log_type    => pak_xslt_log.g_information
           , p_procedure   => 'flat_OPC_pkg.FlatOPCTransfromedOnly'
           );
        end if;
      end loop;
      dbms_lob.trim(pio_FlatOPC, 0);
      DBMS_XMLDOM.WRITETOCLOB(DBMS_XMLDOM.MAKENODE(l_xmldoc), pio_FlatOPC);
    end if;
  exception
  when others then
    pak_xslt_log.WriteLog
       ( p_description       => 'Error'
       , p_log_type      => pak_xslt_log.g_error
       , p_procedure  => 'flat_OPC_pkg.FlatOPCTransfromedOnly'
       , P_SQLERRM   =>  sqlerrm
       );
    raise;
  end FlatOPCTransfromedOnly;

END FLAT_OPC_PKG;

/
