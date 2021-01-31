BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'JOB_XSLTRANSFORMANDDOWNLOAD');
END;
/


BEGIN
  DBMS_SCHEDULER.DROP_PROGRAM
    (program_name          => 'PROG_XSLTRANSFORMANDDOWNLOAD');
END;
/


begin    
	dbms_scheduler.create_program(program_name      => 'prog_XslTransformAndDownload',
                                  program_type        => 'STORED_PROCEDURE',                                                          
                                  program_action      => 'Query2Report.XslTransformAndDownloadXMLID', 
                                  number_of_arguments => 18,
                                  enabled             => false,
                                  comments            => 'Running XslTransformAndDownload in background');
  
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_id_temporary_xml',
                                         argument_position => 1,
                                         argument_type     => 'NUMBER');
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_xsltStaticFile',
                                         argument_position => 2,
                                         argument_type     => 'VARCHAR2');                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_page_id',
                                         argument_position => 3,
                                         argument_type     => 'NUMBER');
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_region_name',
                                         argument_position => 4,
                                         argument_type     => 'VARCHAR2');
                                           
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_filename',
                                         argument_position => 5,
                                         argument_type     => 'VARCHAR2');         
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_reportTypes',
                                         argument_position => 6,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                                                                                                                                                                                    
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_regionAttrs',
                                         argument_position => 7,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                                                                                                                                     
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_mime',
                                         argument_position => 8,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => 'application/octet');
                                         
    dbms_scheduler.define_program_argument(program_name    => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_format',
                                         argument_position => 9,
                                         argument_type     => 'NUMBER',
                                         default_value     => 0);
                                         
    dbms_scheduler.define_program_argument(program_name    => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_templateStaticFile',
                                         argument_position =>  10,
                                         argument_type     => 'VARCHAR2');                                        
    
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_external_params',
                                         argument_position => 11,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_second_XsltStaticFile',
                                         argument_position => 12,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_second_external_params',
                                         argument_position => 13,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_convertblob_param',
                                         argument_position => 14,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_log_level',
                                         argument_position => 15,
                                         argument_type     => 'NUMBER',
                                         default_value     => null);
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_security_group_id',
                                         argument_position => 16,
                                         argument_type     => 'NUMBER',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_app_user',
                                         argument_position => 17,
                                         argument_type     => 'VARCHAR2',
                                         default_value     => null);                                       
                                         
    dbms_scheduler.define_program_argument(program_name      => 'prog_XslTransformAndDownload',
                                         argument_name     => 'p_run_in_background',
                                         argument_position => 18,
                                         argument_type     => 'NUMBER',
                                         default_value     => 1);                                          
                                                                              
    dbms_scheduler.enable (name => 'prog_XslTransformAndDownload');
  
  
    
    dbms_scheduler.create_job(job_name        => 'job_XslTransformAndDownload',
                              program_name    => 'prog_XslTransformAndDownload',
                              start_date      => sysdate,
                              end_date        => null);
    commit;
end;	