--------------------------------------------------------
--  DDL for Package PAK_ZIP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PAK_ZIP" AS

  procedure add1file
  ( p_zipped_blob in out blob
    , p_name in varchar2
    , p_content in blob
  );

  procedure finish_zip(
    p_zipped_blob in out blob,
    p_comment varchar2 default 'Zipped by Region2XSLTReport software http://www.mirmas.si'
  );

$if CCOMPILING.g_utl_file_privilege $then
  procedure save_zip
  ( p_zipped_blob in blob
    , p_dir in varchar2
    , p_filename in varchar2
  );
$end

  function compressText(p_content CLOB, p_file_name varchar2 :='Region2XSLTReport') return BLOB;

  function decompressToText
    ( p_zipped_blob blob
    , p_file_name varchar2 :='Region2XSLTReport'
    )
  return clob;

  function decompress
    ( p_zipped_blob blob
    , p_file_name varchar2 :='Region2XSLTReport'
    )
  return blob;

END PAK_ZIP;

/
