create or replace PACKAGE BODY "PAK_XSLTPROCESSOR" AS

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


  /*
  Change URL to your FOP server.
  E.g. default Tomcat installation on localhost: http://localhost:8080/J4LFOPServer/Apex
  Use of J4LFOPServer is recommended. Please note that J4LFOPServer is licensed product.
  Check http://www.apex-reports.com/apex5.html and 
  https://matthiashoys.wordpress.com/2012/05/04/configuration-and-deployment-of-pdf-printing-in-apex-4-1-1-using-glassfish-3-1-2-and-apache-fop/
  */
  g_fop_print_server constant varchar2(400):= null;
  
  /*  
  Change URL to your Office print server. 
  E.g. default Tomcat installation on localhost: http://localhost:8080/XSLTServlet/XSLTServlet
  Please note that Office print server is licensed product 
  Check http://www.mirmas.si. Write to info@mirmas.si to purchase.
  */
  g_office_print_server constant varchar2(400) := null;
  
  --Office print server will be used if xml is larger (in bytes) then g_xml_size_office_server
  g_xml_size_office_server constant number := 500000;
  
  --POST request to Office print server will be compressed if xml is larger (in bytes) then g_xml_size_zip_office_server
  g_xml_size_zip_office_server constant number := 2000000;

  G_RESPONSE_HEADER WWV_FLOW_GLOBAL.VC_ARR2;

  PROCEDURE LOB_REPLACE(
     P_LOB                IN OUT NOCOPY CLOB,
     P_SEARCH_STRING      IN VARCHAR2,
     P_REPLACEMENT_STRING IN VARCHAR2 )
  IS
     L_TEMP_CLOB CLOB;
  BEGIN
     L_TEMP_CLOB := REPLACE( P_LOB, P_SEARCH_STRING, P_REPLACEMENT_STRING );
     SYS.DBMS_LOB.COPY( P_LOB, L_TEMP_CLOB, SYS.DBMS_LOB.GETLENGTH( L_TEMP_CLOB ));

     IF SYS.DBMS_LOB.GETLENGTH( P_LOB ) > SYS.DBMS_LOB.GETLENGTH( L_TEMP_CLOB ) THEN
         SYS.DBMS_LOB.TRIM( P_LOB, SYS.DBMS_LOB.GETLENGTH( L_TEMP_CLOB ));
     END IF;
  END LOB_REPLACE;

  PROCEDURE LOB_PREPARE(P_LOB IN OUT NOCOPY CLOB)
  IS
  BEGIN
    LOB_REPLACE(P_LOB, '%', '%25');
    LOB_REPLACE(P_LOB, '&', '%26');
    LOB_REPLACE(P_LOB, '+', '%2B');
    LOB_REPLACE(P_LOB, '-', '%2D');
  END;

  FUNCTION LOB_PREPARE(P_LOB IN CLOB)
  RETURN BLOB
  IS
  L_CLOB CLOB;
  BEGIN
    L_CLOB := P_LOB;
    LOB_REPLACE(L_CLOB, '%', '%25');
    LOB_REPLACE(L_CLOB, '&', '%26');
    LOB_REPLACE(L_CLOB, '+', '%2B');
    LOB_REPLACE(L_CLOB, '-', '%2D');
    return pak_blob_util.clob2blob(L_CLOB);
  END;
  
  FUNCTION CLOB_PREPARE(P_LOB IN CLOB)
  RETURN CLOB
  IS
  L_CLOB CLOB;
  BEGIN
    L_CLOB := P_LOB;
    LOB_REPLACE(L_CLOB, '%', '%25');
    LOB_REPLACE(L_CLOB, '&', '%26');
    LOB_REPLACE(L_CLOB, '+', '%2B');
    LOB_REPLACE(L_CLOB, '-', '%2D');
    return L_CLOB;
  END;

	FUNCTION XSLTransformServlet(
		P_URL IN  varchar2,
		P_XML    IN CLOB,
		P_XSLT       IN CLOB,
		p_zipedB64encoded boolean default false,
		p_xslParams varchar2 default null,
		po_error OUT varchar2  
	) RETURN BLOB
	IS
		L_RESPONSE              CLOB;
		L_XML                   CLOB;
		L_XSLT                  CLOB;
		L_BODY                  CLOB;
		L_BLOB                  BLOB;
		L_PARAMS                VARCHAR2(4000);
		
	BEGIN
		pak_xslt_log.SetLevel(3);
		
		if p_Xml is null then
		  pak_xslt_log.WriteLog(
			'p_Xml is null',
			p_log_type => pak_xslt_log.g_error,
			p_procedure => 'pak_xsltprocessor.XslTransformServlet'
		  );
		end if;

		po_error := null;
		
		L_XSLT := P_XSLT;

		if p_zipedB64encoded then
		  L_XSLT := pak_blob_util.base64_encode(pak_zip.compressText(L_XSLT));
		end if;
		LOB_PREPARE(L_XSLT);
		
		pak_xslt_log.WriteLog(
			'After LOB_PREPARE(L_XSLT)',
			p_log_type => pak_xslt_log.g_error,
			p_procedure => 'pak_xsltprocessor.XslTransformServlet'
		  );
		
		if p_zipedB64encoded then
		  L_XML := clob_prepare(pak_blob_util.base64_encode(pak_zip.compressText(p_xml)));
		else
		  L_XML := clob_prepare(P_XML);
		end if;
		
		pak_xslt_log.WriteLog(
			'After LOB_PREPARE(L_XML)',
			p_log_type => pak_xslt_log.g_error,
			p_procedure => 'pak_xsltprocessor.XslTransformServlet'
		  );
		  
		apex_web_service.g_request_headers(1).name := 'Content-Type';
		apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded; charset=utf-8';
		
		l_body := ('xml='||l_xml||
			'&xslt='||l_xslt||
			case when p_xslParams is not null then '&xslParams='||p_xslParams end||
			'&zipedB64encoded='||case p_zipedB64encoded when true then 'true' else 'false' end);

		pak_xslt_log.WriteLog(
			  'Before Make request',
			   p_log_type => pak_xslt_log.g_information,
			   p_procedure => 'pak_xsltprocessor.XslTransformServlet'
	   );

		l_response := apex_web_service.make_rest_request(
		p_url => p_url,
		p_http_method => 'POST',
		p_body_blob => pak_blob_util.clob2blob(l_body)
		);

		
		
		-----Check for JAS error-----------------------
		pak_xslt_log.WriteLog(
			  'Start of returning BLOB: '||substr(L_RESPONSE, 1, length('Region2XSLTReport - Java application server error:')),
			   p_log_type => pak_xslt_log.g_information,
			   p_procedure => 'pak_xsltprocessor.XslTransformServlet'
	   );

	   if substr(L_RESPONSE, 1, length('Region2XSLTReport - Java application server error:')) = 'Region2XSLTReport - Java application server error:' then 
		  po_error := L_RESPONSE;
	   end if;

		
	  if po_error is null then --if it's error message don't decompress
		if p_zipedB64encoded then
			L_BLOB := pak_zip.decompress(pak_blob_util.base64_decode(L_RESPONSE));
		else
			L_BLOB :=pak_blob_util.clob2blob(L_RESPONSE);
		end if;
	  end if;


		RETURN L_BLOB;

	exception
		when others then
		pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xsltprocessor.XSLTransformServlet', p_sqlerrm => sqlerrm );
		raise;

	END XSLTransformServlet;


function XslTransformPlSql
(
p_Xml               IN    CLOB,
p_Xslt              IN    CLOB,
p_external_params   IN    varchar2 default null
) return CLOB
as

p           DBMS_XSLPROCESSOR.Processor;
ss          DBMS_XSLPROCESSOR.Stylesheet;
xmldoc      DBMS_XMLDOM.DOMDOCUMENT;
xsltDoc      DBMS_XMLDOM.DOMDOCUMENT;
retClob     CLOB;
l_external_params varchar2(1000);

l_space_pos number;
l_first_quote_pos number;
l_second_quote_pos number;
l_end_name_value number;

l_start_name_value number default 1;
l_name_value varchar2(100);
l_equal_sign_pos number;
l_name varchar2(100);
l_value varchar2(100);
l_external_params_count number default 1;
l_start_time PLS_INTEGER;


begin
  if p_Xml is null then
    pak_xslt_log.WriteLog(
      'p_Xml is null',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'pak_xsltprocessor.XslTransformPlsql'
    );
  end if;

  p:= DBMS_XSLPROCESSOR.NEWPROCESSOR;
  xmldoc := DBMS_XMLDOM.NEWDOMDOCUMENT(p_Xml);
  DBMS_LOB.CREATETEMPORARY(retClob, false);
  xsltDoc := DBMS_XMLDOM.NEWDOMDOCUMENT(p_Xslt);
  ss:= DBMS_XSLPROCESSOR.NEWSTYLESHEET(xsltDoc, null);
  DBMS_XSLPROCESSOR.RESETPARAMS(ss);

  --parsing out and seting external parameters
  if p_external_params is not null then
    l_external_params := trim(p_external_params);
    l_end_name_value := 1;

    while nvl(l_end_name_value, 0) > 0 and l_external_params_count < 100
    loop
      l_space_pos := instr(l_external_params,' ',l_start_name_value);
      l_first_quote_pos := instr(l_external_params,'''',l_start_name_value, 1);
      l_second_quote_pos := instr(l_external_params,'''',l_start_name_value, 2);

      if l_space_pos not between l_first_quote_pos and l_second_quote_pos
      then
        l_end_name_value := l_space_pos - 1;
      else
        l_end_name_value := l_second_quote_pos;
      end if;
      if nvl(l_end_name_value, 0) <= 0 then
        l_name_value := trim(substr(l_external_params, l_start_name_value));
      else
        l_name_value := trim(substr(l_external_params, l_start_name_value, l_end_name_value-l_start_name_value+1));
      end if;
      l_equal_sign_pos := instr(l_name_value, '=');
      /*
      pak_xslt_log.WriteLog(
            'l_space_pos '||l_space_pos||
            ' l_first_quote_pos '||l_first_quote_pos||
            ' l_second_quote_pos '||l_second_quote_pos||
            ' l_start_name_value '||l_start_name_value||
            ' l_end_name_value '||l_end_name_value||
            ' l_equal_sign_pos '||l_equal_sign_pos,
            p_procedure => 'XslTransform - function with XSLT CLOB'
      );
      */
      if nvl(l_equal_sign_pos, 0)  > 0 then
        l_name := trim(substr(l_name_value, 1, l_equal_sign_pos - 1));
        l_value := trim(substr(l_name_value, l_equal_sign_pos + 1));
        if l_name is not null and l_value is not null then
          /*
          pak_xslt_log.WriteLog(
            'DBMS_XSLPROCESSOR.SETPARAM(l_name='||to_char(l_name)||', l_value='||to_char(l_value)||')',
            p_procedure => 'pak_xsltprocessor.XslTransformPlsql'
          );
          */
          DBMS_XSLPROCESSOR.SETPARAM(ss, l_name, l_value);

          /*
          pak_xslt_log.WriteLog(
            'Finished DBMS_XSLPROCESSOR.SETPARAM(l_name='||to_char(l_name)||', l_value='||to_char(l_value)||')',
            p_procedure => 'pak_xsltprocessor.XslTransformPlsql'
          );
          */
        end if;
      end if;
      l_start_name_value := l_end_name_value + 2;
      l_external_params_count := l_external_params_count + 1;
    end loop;
  end if;
  --end of parsing out and seting external parameters
  l_start_time := dbms_utility.get_time;
  pak_xslt_log.WriteLog(
      'DBMS_XSLPROCESSOR.PROCESSXSL started',
      p_procedure => 'pak_xsltprocessor.XslTransformPlsql',
      p_start_time => l_start_time
    );

  DBMS_XSLPROCESSOR.PROCESSXSL(p, ss, xmldoc, retClob);
  pak_xslt_log.WriteLog(
      'DBMS_XSLPROCESSOR.PROCESSXSL finished',
      p_procedure => 'pak_xsltprocessor.XslTransformPlsql',
      p_start_time => l_start_time
  );
  --dbms_xslprocessor.clob2file(retClob, 'XMLDIR', 'document.xml');
  DBMS_XMLDOM.FREEDOCUMENT(xsltDoc);
  DBMS_XMLDOM.FREEDOCUMENT(xmldoc);
  DBMS_XSLPROCESSOR.FREESTYLESHEET(ss);
  DBMS_XSLPROCESSOR.FREEPROCESSOR(p);

  if retClob is null then
    pak_xslt_log.WriteLog(
      'return NULL CLOB',
      p_log_type => pak_xslt_log.g_warning,
      p_procedure => 'XslTransform - function with XSLT CLOB'
    );
  --else
    --FormatCorrection(retClob, p_format);
  end if;

  --OOXML part
  /*
  if p_format = f_ooxml and retClob is not null then
    po_OOXml := FLAT_OPC_PKG.FlatOPC2OOXML(retClob, p_template); --, p_partsToTransform);
  end if;
  */
  return retClob;

exception
  when others then
  pak_xslt_log.WriteLog(
    'Error',
    p_log_type => pak_xslt_log.g_error,
    p_procedure => 'XslTransform - function with XSLT CLOB',
    P_SQLERRM => sqlerrm
  );
  DBMS_XMLDOM.FREEDOCUMENT(xsltDoc);
  DBMS_XMLDOM.FREEDOCUMENT(xmldoc);
  DBMS_XSLPROCESSOR.FREESTYLESHEET(ss);
  DBMS_XSLPROCESSOR.FREEPROCESSOR(p);
  raise;
end XslTransformPlSql;

function Transform
(
  p_Xml               IN    CLOB,
  p_template          IN    CLOB,
  p_external_params   IN    varchar2 default null,
  po_error            OUT   varchar2
) return BLOB
as
l_xml_length number;
l_retBlob BLOB;
l_zipedB64encoded boolean := false;
l_zipedB64encodedStr varchar2(20) := 'NOT zipedB64encoded';

begin
  po_error := null;
  --dbms_xslprocessor.clob2file(p_template, 'XMLDIR', 'debug1.xslt');
  if nvl(instr(p_template, 'xmlns:fo="http://www.w3.org/1999/XSL/Format"'),0) > 0 and nvl(instr(g_fop_print_server, 'http'),0) > 0 then --XML-FO expected pdf format
    pak_xslt_log.WriteLog( 'PDF Transform started', p_log_type => pak_xslt_log.g_warning, p_procedure => 'pak_xsltprocessor.Transform');
    --dbms_xslprocessor.clob2file(p_template, 'XMLDIR', 'fop.xslt');
    l_retBlob := APEX_UTIL.GET_PRINT_DOCUMENT (p_Xml,  p_template , p_print_server => g_fop_print_server); --enter print server URL
    pak_xslt_log.WriteLog( 'PDF Transform ended', p_log_type => pak_xslt_log.g_warning, p_procedure => 'pak_xsltprocessor.Transform');
  else --expected MS office or any other text base format
    l_xml_length := dbms_lob.getlength(p_Xml);
    pak_xslt_log.WriteLog( 'XML SIZE: '||l_xml_length||' XSLT SIZE: '||dbms_lob.getlength(p_template), p_log_type => pak_xslt_log.g_warning, p_procedure => 'pak_xsltprocessor.Transform');
    if (
        g_office_print_server is null or 
        l_xml_length < g_xml_size_office_server) 
    and substr(p_template,1,4000) like '%<xsl:stylesheet%version="1.0"%>%'  -- xml < 0,5M and XSLT is version 1
    then
      l_retBlob := pak_blob_util.clob2blob(XslTransformPlSql(p_xml, p_template, p_external_params));
      pak_xslt_log.WriteLog( 'XslTransformPlSql finished', p_log_type => pak_xslt_log.g_information, p_procedure => 'pak_xsltprocessor.Transform');
    elsif g_office_print_server is not null then
      if l_xml_length > g_xml_size_zip_office_server then --xml > 2M then zip and b64 encode data before HTTP post to avoid post limits on App Server (GlassFish or WebLogic)
        l_zipedB64encoded := true;
        l_zipedB64encodedStr := 'zipedB64encoded';
      end if;

      --dbms_xslprocessor.clob2file(p_xml, 'XMLDIR', 'debug1.xml');
      l_retBlob := XSLTransformServlet(
      /*
        'http://localhost:8181/XSLTServlet/XSLTServlet', --GF
        'http://vboxjavaws04.comland.si:8080/XSLTServlet/XSLTServlet', --GF
        'http://vboxjavaws04.comland.si:7001/XSLTServlet/XSLTServlet', --WLS
        'http://turon.comland.si:7001/XSLTServlet/XSLTServlet', --WLS
        */
        g_office_print_server, --WLS
        P_XML,
        p_template,
        l_zipedB64encoded,
        p_external_params,
        po_error
      );

      pak_xslt_log.WriteLog(
        'pak_xsltprocessor.Transform finished '||l_zipedB64encodedStr||' output size: '||dbms_lob.getlength(l_retBlob),
        p_log_type => pak_xslt_log.g_information,
        p_procedure => 'pak_xsltprocessor.Transform');
    ELSE
        pak_xslt_log.WriteLog(
        'Cannot process. Please enter FOP server in pak_xsltprocesor package or purchase full version.',
        p_log_type => pak_xslt_log.g_error,
        p_procedure => 'pak_xsltprocessor.Transform');
        raise_application_error(-20001, 'Cannot process. Please enter FOP server in pak_xsltprocesor package and recompile it or purchase full version.');
    end if;

  end if;

  --dbms_xslprocessor.clob2file(p_xml, 'XMLDIR', 'Persons2000.xml');
  return l_retBlob;

  exception
    when others then
    pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xsltprocessor.Transform', p_sqlerrm => sqlerrm );
    raise;
end Transform;

$if CCOMPILING.g_utl_file_privilege $then
--testing function
  procedure WriteResponseToFile(
    p_url varchar2,
    p_xmlDir varchar2,
    p_xmlFile varchar2,
    p_xsltDir varchar2,
    p_xsltFile varchar2,
    p_outputDir varchar2,
    p_outputFile varchar2,
    p_zipedB64encoded boolean default false,
    p_xslParams varchar2 default null,
    P_NLS_CHARSET varchar2 default 'AL32UTF8'
  ) AS
  l_xml CLOB;
  l_xslt CLOB;
  l_output BLOB;
  l_error varchar2(32000);
  BEGIN
    l_xml := pak_blob_util.Read2Clob(p_xmlDir, p_xmlFile, 'AL32UTF8'); --'EE8MSWIN1250' --'AL32UTF8', 'WE8MSWIN1252'   WE8ISO8859P2
    l_xslt := pak_blob_util.Read2Clob(p_xsltDir, p_xsltFile, P_NLS_CHARSET);
    l_output := XSLTransformServlet(p_url, l_xml, l_xslt, p_zipedB64encoded, p_xslParams, l_error);
    --dbms_xslprocessor.clob2file(l_output, p_outputDir, p_outputFile);
    pak_blob_util.blob2file(p_outputDir, p_outputFile, l_output);
    --pak_blob_util.clob2file(p_outputDir, p_outputFile, l_output);

  exception
    when others then
    pak_xslt_log.WriteLog( 'Error', p_log_type => pak_xslt_log.g_error, p_procedure => 'pak_xsltprocessor.WriteResponseToFile', p_sqlerrm => sqlerrm );
    raise;

  END WriteResponseToFile;
$end

END PAK_XSLTPROCESSOR;
/