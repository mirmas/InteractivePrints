--------------------------------------------------------
--  DDL for Procedure CONVERTBLOB
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "CONVERTBLOB" 
(
  PIO_BLOB IN OUT NOCOPY BLOB
, P_PARAM IN VARCHAR2
, p_blob_csid number default NLS_CHARSET_ID('UTF8')
, P_APP_USER IN VARCHAR2 default V('APP_USER')
, P_RUN_IN_BACKGROUND IN NUMBER default 0
)
AS
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
