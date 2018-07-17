--------------------------------------------------------
--  DDL for Package ZIP_UTIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "ZIP_UTIL_PKG" 
is

  /*

  Purpose:      Package handles zipping and unzipping of files

  Remarks:      by Anton Scheffer, see http://forums.oracle.com/forums/thread.jspa?messageID=9289744#9289744

                for unzipping, see http://technology.amis.nl/blog/8090/parsing-a-microsoft-word-docx-and-unzip-zipfiles-with-plsql
                for zipping, see http://forums.oracle.com/forums/thread.jspa?threadID=1115748&tstart=0

  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     09.01.2011  Created

  */

  type t_file_list is table of clob;
--
  function get_file_list(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_encoding in varchar2 := null
  )
    return t_file_list;
--
  function get_file_list(
    p_zipped_blob in blob
  , p_encoding in varchar2 := null /* Use CP850 for zip files created with a German Winzip to see umlauts, etc */
  )
    return t_file_list;
--
  function get_file(
    p_dir in varchar2
  , p_zip_file in varchar2
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob;
--
  function get_file(
    p_zipped_blob in blob
  , p_file_name in varchar2
  , p_encoding in varchar2 := null
  )
    return blob;
--
  procedure add_file(
    p_zipped_blob in out blob
  , p_name in varchar2
  , p_content in blob
  );

  /** Adds folder to zip file. It seems that DOCX and XLSX need also folders structure in ZIP
  * @param p_zipped_blob Current ZIP blob (IN OUT)
  * @param p_name folder path
  */
  procedure add_folder(
    p_zipped_blob in out blob
  , p_name in varchar2
  );
--
  procedure finish_zip(
    p_zipped_blob in out blob
  );
--
$if CCOMPILING.g_utl_file_privilege $then  
  procedure save_zip(
    p_zipped_blob in blob
  , p_dir in varchar2
  , p_filename in varchar2
  );

  procedure save_blob_to_file (p_directory_name in varchar2,
                             p_file_name in varchar2,
                             p_blob in blob);
$end          

end zip_util_pkg;

/
