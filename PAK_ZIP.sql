
CREATE OR REPLACE PACKAGE "PAK_ZIP" AS

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
