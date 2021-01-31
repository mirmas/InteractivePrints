
CREATE OR REPLACE PROCEDURE "CONVERTBLOB"
(
  PIO_BLOB IN OUT NOCOPY BLOB
, P_PARAM IN VARCHAR2
, p_blob_csid number default NLS_CHARSET_ID('UTF8')
, P_APP_USER IN VARCHAR2 default V('APP_USER')
, P_RUN_IN_BACKGROUND IN NUMBER default 0
)
AS
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

  
l_start_time PLS_INTEGER := dbms_utility.get_time;
l_to VARCHAR2(2000);
l_filename varchar2(4000);
l_mail_id number;
--l_clob CLOB; --Uncoment if you need CLOB
BEGIN
   pak_xslt_log.WriteLog(
      'Start ConvertBLOB P_PARAM: '||P_PARAM||' p_blob_csid: '||p_blob_csid||' P_APP_USER '||P_APP_USER||' P_RUN_IN_BACKGROUND '||P_RUN_IN_BACKGROUND,
      p_procedure => 'ConvertBLOB'
    );

    /*Uncoment if you need CLOB
    if p_blob_csid is not null then
      l_clob := pak_blob_util.blob2clob(PIO_BLOB, p_blob_csid);
    end if;
    */

   /*
  if P_PARAM = 'FO2PDF' then
    pk_fo2pdf.fo2pdfblob(PIO_BLOB);
  end if;

  if P_PARAM = 'XFRENDER' then
    pk_fo2pdf.XERenderFOP(PIO_BLOB, 'docx');
  end if;
   */

  if P_PARAM like 'SENDMAIL;%;%' then
    --get l_to, l_filename
    l_to := substr(P_PARAM, instr(P_PARAM,';')+1, instr(P_PARAM,';',1,2)-instr(P_PARAM,';')-1);
    l_filename := substr(P_PARAM, instr(P_PARAM,';',1,2)+1);
    pak_xslt_log.WriteLog(
      'apex_mail.send P_PARAM: '||P_PARAM||' l_to '||l_to||' l_filename '||l_filename,
      p_log_type => pak_xslt_log.g_warning,
      p_procedure => 'ConvertBLOB'
    );

    l_mail_id :=
    apex_mail.send(p_to => l_to, p_from => 'info@mirmas.si', p_body => 'Attachment generated with Region2XSLTReport plug-in', p_subj =>  'Region2XSLTReport');

     APEX_MAIL.ADD_ATTACHMENT(
     p_mail_id    => l_mail_id,
     p_attachment => PIO_BLOB,
     p_filename   => l_filename,
     p_mime_type  => 'application/octet'
     );

    --Free BLOB and set it to null because we don't want BLOB download.
    DBMS_LOB.FREETEMPORARY(PIO_BLOB);
    PIO_BLOB := null;
  end if;

  /*
  if P_PARAM like 'http://%' or P_PARAM like 'https://%' then
    pk_fo2pdf.printServerFOP(PIO_BLOB, P_PARAM);
  end if;
   */

  pak_xslt_log.WriteLog(
      'ConvertBLOB finished P_PARAM: '||P_PARAM,
      p_procedure => 'ConvertBLOB',
      p_start_time => l_start_time
  );

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error P_PARAM: '||P_PARAM,
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'ConvertBLOB',
    P_SQLERRM => sqlerrm
  );
  raise;
END ConvertBLOB;

/
