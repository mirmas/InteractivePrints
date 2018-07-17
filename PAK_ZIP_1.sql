--------------------------------------------------------
--  DDL for Package Body PAK_ZIP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PAK_ZIP" AS

c_LOCAL_FILE_HEADER        constant raw(4) := hextoraw( '504B0304' ); -- Local file header signature
c_END_OF_CENTRAL_DIRECTORY constant raw(4) := hextoraw( '504B0506' ); -- End of central directory signature
--
  function blob2num( p_blob blob, p_len integer, p_pos integer )
  return number
  is
    rv number;
  begin
    rv := utl_raw.cast_to_binary_integer( dbms_lob.substr( p_blob, p_len, p_pos ), utl_raw.little_endian );
    if rv < 0
    then
      rv := rv + 4294967296;
    end if;
    return rv;
  end;

  function raw2varchar2( p_raw raw, p_encoding varchar2 )
  return varchar2
  is
  begin
    return coalesce( utl_i18n.raw_to_char( p_raw, p_encoding )
                   , utl_i18n.raw_to_char( p_raw, utl_i18n.map_charset( p_encoding, utl_i18n.GENERIC_CONTEXT, utl_i18n.IANA_TO_ORACLE ) )
                   );
  end;

function little_endian( p_big in number, p_bytes in pls_integer := 4 )
  return raw
  is
  begin
    return utl_raw.substr( utl_raw.cast_from_binary_integer( p_big, utl_raw.little_endian ), 1, p_bytes );
  exception
    when others then

    pak_xslt_log.WriteLog
     ( p_description       => 'Error p_big '||p_big||' p_bytes '||p_bytes
     , p_log_type      => pak_xslt_log.g_error
     , p_procedure  => 'pak_zip.little_endian'
     , P_SQLERRM   =>  sqlerrm
     );
     raise;
  end little_endian;
--
  procedure add1file
    ( p_zipped_blob in out blob
    , p_name in varchar2
    , p_content in blob
    )
  is
    t_now date;
    t_blob blob;
    t_clen integer;
  begin
    t_now := sysdate;
    t_blob := utl_compress.lz_compress( p_content );
    t_clen := dbms_lob.getlength( t_blob );
    if p_zipped_blob is null
    then
      dbms_lob.createtemporary( p_zipped_blob, true );
    end if;
    dbms_lob.append( p_zipped_blob
                   , utl_raw.concat( hextoraw( '504B0304' ) -- Local file header signature
                                   , hextoraw( '1400' )     -- version 2.0
                                   , hextoraw( '0000' )     -- no General purpose bits
                                   , hextoraw( '0800' )     -- deflate
                                   , little_endian( to_number( to_char( t_now, 'ss' ) ) / 2
                                                  + to_number( to_char( t_now, 'mi' ) ) * 32
                                                  + to_number( to_char( t_now, 'hh24' ) ) * 2048
                                                  , 2
                                                  ) -- File last modification time
                                   , little_endian( to_number( to_char( t_now, 'dd' ) )
                                                  + to_number( to_char( t_now, 'mm' ) ) * 32
                                                  + ( to_number( to_char( t_now, 'yyyy' ) ) - 1980 ) * 512
                                                  , 2
                                                  ) -- File last modification date
                                   , dbms_lob.substr( t_blob, 4, t_clen - 7 )         -- CRC-32
                                   , little_endian( t_clen - 18 )                     -- compressed size
                                   , little_endian( dbms_lob.getlength( p_content ) ) -- uncompressed size
                                   , little_endian( length( p_name ), 2 )             -- File name length
                                   , hextoraw( '0000' )                               -- Extra field length
                                   , utl_raw.cast_to_raw( p_name )                    -- File name
                                   )
                   );
    --dbms_lob.append( p_zipped_blob, dbms_lob.substr( t_blob, t_clen - 18, 11 ) );     -- compressed content --doesn't work if t_clen > 32K

    DBMS_LOB.COPY (  -- compressed content
      p_zipped_blob,
      t_blob,
      t_clen - 18,
      dbms_lob.getlength(p_zipped_blob) + 1,
      11
    );

    dbms_lob.freetemporary( t_blob );
  exception
    when others then
    pak_xslt_log.WriteLog
     ( p_description       => 'Error p_name '||p_name
     , p_log_type      => pak_xslt_log.g_error
     , p_procedure  => 'pak_zip.add1file'
     , P_SQLERRM   =>  sqlerrm
     );
     raise;
  end add1file;

--
  procedure finish_zip(
    p_zipped_blob in out blob,
    p_comment varchar2 default 'Zipped by Region2XSLTReport software http://www.mirmas.si'
  )
  is
    t_cnt pls_integer := 0;
    t_offs integer;
    t_offs_dir_header integer;
    t_offs_end_header integer;
    t_comment raw(32767) := utl_raw.cast_to_raw(p_comment);
  begin
    t_offs_dir_header := dbms_lob.getlength( p_zipped_blob );
    t_offs := dbms_lob.instr( p_zipped_blob, hextoraw( '504B0304' ), 1 );
    while t_offs > 0
    loop
      t_cnt := t_cnt + 1;
      dbms_lob.append( p_zipped_blob
                     , utl_raw.concat( hextoraw( '504B0102' )      -- Central directory file header signature
                                     , hextoraw( '1400' )          -- version 2.0
                                     , dbms_lob.substr( p_zipped_blob, 26, t_offs + 4 )
                                     , hextoraw( '0000' )          -- File comment length
                                     , hextoraw( '0000' )          -- Disk number where file starts
                                     , hextoraw( '0100' )          -- Internal file attributes
                                     , hextoraw( '2000B681' )      -- External file attributes
                                     , little_endian( t_offs - 1 ) -- Relative offset of local file header
                                     , dbms_lob.substr( p_zipped_blob
                                                      , utl_raw.cast_to_binary_integer( dbms_lob.substr( p_zipped_blob, 2, t_offs + 26 ), utl_raw.little_endian )
                                                      , t_offs + 30
                                                      )            -- File name
                                     )
                     );
      t_offs := dbms_lob.instr( p_zipped_blob, hextoraw( '504B0304' ), t_offs + 32 );
    end loop;
    t_offs_end_header := dbms_lob.getlength( p_zipped_blob );
    dbms_lob.append( p_zipped_blob
                   , utl_raw.concat( hextoraw( '504B0506' )                                    -- End of central directory signature
                                   , hextoraw( '0000' )                                        -- Number of this disk
                                   , hextoraw( '0000' )                                        -- Disk where central directory starts
                                   , little_endian( t_cnt, 2 )                                 -- Number of central directory records on this disk
                                   , little_endian( t_cnt, 2 )                                 -- Total number of central directory records
                                   , little_endian( t_offs_end_header - t_offs_dir_header )    -- Size of central directory
                                   , little_endian( t_offs_dir_header )                        -- Relative offset of local file header
                                   , little_endian( nvl( utl_raw.length( t_comment ), 0 ), 2 ) -- ZIP file comment length
                                   , t_comment
                                   )
                   );
  exception
    when others then
    pak_xslt_log.WriteLog
     ( p_description       => 'Error'
     , p_log_type      => pak_xslt_log.g_error
     , p_procedure  => 'pak_zip.finish_zip'
     , P_SQLERRM   =>  sqlerrm
     );
     raise;
  end finish_zip;
--
$if CCOMPILING.g_utl_file_privilege $then  
  procedure save_zip
    ( p_zipped_blob in blob
    , p_dir in varchar2
    , p_filename in varchar2
    )
  is
    t_fh utl_file.file_type;
    t_len pls_integer := 32767;
  begin
    t_fh := utl_file.fopen( p_dir, p_filename, 'wb' );
    for i in 0 .. trunc( ( dbms_lob.getlength( p_zipped_blob ) - 1 ) / t_len )
    loop
      utl_file.put_raw( t_fh, dbms_lob.substr( p_zipped_blob, t_len, i * t_len + 1 ) );
    end loop;
    utl_file.fclose( t_fh );
  exception
    when others then
    pak_xslt_log.WriteLog
     ( p_description       => 'Error p_dir '||p_dir||' p_filename '||p_filename
     , p_log_type      => pak_xslt_log.g_error
     , p_procedure  => 'pak_zip.save_zip'
     , P_SQLERRM   =>  sqlerrm
     );
     raise;
  end save_zip;
$end

  function compressText(p_content CLOB, p_file_name varchar2 :='Region2XSLTReport') return BLOB
  as
  l_zipped_blob blob;
  l_suorce_blob blob;
  begin
    l_suorce_blob := pak_blob_util.CLOB2BLOB(p_content, NLS_CHARSET_ID('AL32UTF8'));
    add1file(l_zipped_blob, p_file_name, l_suorce_blob);
    finish_zip(l_zipped_blob);
    return l_zipped_blob;
  end compressText;

  function get_file
    ( p_zipped_blob blob
    , p_file_name varchar2
    , p_encoding varchar2 := null
    )
  return blob
  is
    t_tmp blob;
    t_ind integer;
    t_hd_ind integer;
    t_fl_ind integer;
    t_encoding varchar2(32767);
    t_len integer;
  begin
    t_ind := dbms_lob.getlength( p_zipped_blob ) - 21;
    loop
      exit when t_ind < 1 or dbms_lob.substr( p_zipped_blob, 4, t_ind ) = c_END_OF_CENTRAL_DIRECTORY;
      t_ind := t_ind - 1;
    end loop;
--
    if t_ind <= 0
    then
      return null;
    end if;
--
    t_hd_ind := blob2num( p_zipped_blob, 4, t_ind + 16 ) + 1;
    for i in 1 .. blob2num( p_zipped_blob, 2, t_ind + 8 )
    loop
      if p_encoding is null
      then
        if utl_raw.bit_and( dbms_lob.substr( p_zipped_blob, 1, t_hd_ind + 9 ), hextoraw( '08' ) ) = hextoraw( '08' )
        then
          t_encoding := 'UTF8'; -- utf8
        else
          t_encoding := 'US8PC437'; -- IBM codepage 437
        end if;
      else
        t_encoding := p_encoding;
      end if;
      if p_file_name = raw2varchar2
                         ( dbms_lob.substr( p_zipped_blob
                                          , blob2num( p_zipped_blob, 2, t_hd_ind + 28 )
                                          , t_hd_ind + 46
                                          )
                         , t_encoding
                         )
      then
        t_len := blob2num( p_zipped_blob, 4, t_hd_ind + 24 ); -- uncompressed length
        if t_len = 0
        then
          if substr( p_file_name, -1 ) in ( '/', '\' )
          then  -- directory/folder
            return null;
          else -- empty file
            return empty_blob();
          end if;
        end if;
--
        if dbms_lob.substr( p_zipped_blob, 2, t_hd_ind + 10 ) = hextoraw( '0800' ) -- deflate
        then
          t_fl_ind := blob2num( p_zipped_blob, 4, t_hd_ind + 42 );
          t_tmp := hextoraw( '1F8B0800000000000003' ); -- gzip header
          dbms_lob.copy( t_tmp
                       , p_zipped_blob
                       ,  blob2num( p_zipped_blob, 4, t_hd_ind + 20 )
                       , 11
                       , t_fl_ind + 31
                       + blob2num( p_zipped_blob, 2, t_fl_ind + 27 ) -- File name length
                       + blob2num( p_zipped_blob, 2, t_fl_ind + 29 ) -- Extra field length
                       );
          dbms_lob.append( t_tmp, utl_raw.concat( dbms_lob.substr( p_zipped_blob, 4, t_hd_ind + 16 ) -- CRC32
                                                , little_endian( t_len ) -- uncompressed length
                                                )
                         );
          return utl_compress.lz_uncompress( t_tmp );
        end if;
--
        if dbms_lob.substr( p_zipped_blob, 2, t_hd_ind + 10 ) = hextoraw( '0000' ) -- The file is stored (no compression)
        then
          t_fl_ind := blob2num( p_zipped_blob, 4, t_hd_ind + 42 );
          dbms_lob.createtemporary( t_tmp, true );
          dbms_lob.copy( t_tmp
                       , p_zipped_blob
                       , t_len
                       , 1
                       , t_fl_ind + 31
                       + blob2num( p_zipped_blob, 2, t_fl_ind + 27 ) -- File name length
                       + blob2num( p_zipped_blob, 2, t_fl_ind + 29 ) -- Extra field length
                       );
          return t_tmp;
        end if;
      end if;
      t_hd_ind := t_hd_ind + 46
                + blob2num( p_zipped_blob, 2, t_hd_ind + 28 )  -- File name length
                + blob2num( p_zipped_blob, 2, t_hd_ind + 30 )  -- Extra field length
                + blob2num( p_zipped_blob, 2, t_hd_ind + 32 ); -- File comment length
    end loop;
--
    return null;
  end;

  function decompressToText
    ( p_zipped_blob blob
    , p_file_name varchar2 :='Region2XSLTReport'
    )
  return clob
  as
  begin
    return pak_blob_util.BLOB2CLOB(get_file(p_zipped_blob, p_file_name, NLS_CHARSET_ID('AL32UTF8')),NLS_CHARSET_ID('AL32UTF8'));
  end decompressToText;

  function decompress
    ( p_zipped_blob blob
    , p_file_name varchar2 :='Region2XSLTReport'
    )
  return blob
  as
  begin
    return get_file(p_zipped_blob, p_file_name, NLS_CHARSET_ID('AL32UTF8'));
  end decompress;

END PAK_ZIP;

/
