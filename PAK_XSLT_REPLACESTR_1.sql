--------------------------------------------------------
--  DDL for Package Body PAK_XSLT_REPLACESTR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE BODY "PAK_XSLT_REPLACESTR" AS   
  function fontsize(p_fontsize varchar2, p_default number, p_format number, p_fileext varchar2)   
  return varchar2   
  as   
  l_fontsize number := p_default;   
  begin   
    if p_fontsize is not null then   
      l_fontsize := to_number(p_fontsize);   
    end if;   
    if p_fileext = 'docx' then 
      l_fontsize := l_fontsize*2;  
    end if; 
    return replace(to_char(l_fontsize),',','.');   
  exception   
  when others then   
  pak_xslt_log.WriteLog(   
    'Error p_fontsize: '||p_fontsize,   
    p_log_type => pak_xslt_log.g_error,   
    p_procedure => 'PAK_XSLT_REPLACESTR.fontsize',   
    P_SQLERRM => sqlerrm   
  );   
  raise;   
  end fontsize;   
     
  function fontweight(p_fontweight varchar2, p_format number, p_fileext varchar2, p_header_footer boolean default false) 
  return varchar2 
  as 
  l_fontweight varchar2(20) := ''; 
  begin 
    if p_fontweight = 'bold' then 
      if p_fileext = 'docx' then 
        l_fontweight := '<w:b w:val="1"/>'; 
      elsif p_fileext = 'xlsx' then 
          if p_header_footer then 
              l_fontweight := 'Bold'; 
          else 
              l_fontweight := '<b/>'; 
          end if; 
      end if; 
    else 
      if p_fileext = 'docx' then 
        l_fontweight := '<w:b w:val="0"/>'; 
      end if; 
    end if; 
    return l_fontweight; 
  exception 
  when others then 
  pak_xslt_log.WriteLog( 
    'Error p_fontweight: '||p_fontweight, 
    p_log_type => pak_xslt_log.g_error, 
    p_procedure => 'PAK_XSLT_REPLACESTR.fontweight', 
    P_SQLERRM => sqlerrm 
  ); 
  raise; 
  end fontweight;   
     
  function font(p_font varchar2, p_default varchar2, p_format number)   
  return varchar2   
  as   
  begin   
    return   
    case p_font   
      when 'Helvetica' then 'Calibri'   
      when 'Times' then 'Times New Roman'   
      when 'Courier' then 'Courier New'   
      else p_default   
    end;   
  exception   
  when others then   
  pak_xslt_log.WriteLog(   
    'Error p_font: '||p_font,   
    p_log_type => pak_xslt_log.g_error,   
    p_procedure => 'PAK_XSLT_REPLACESTR.font',   
    P_SQLERRM => sqlerrm   
  );   
  raise;   
  end font;   
     
  function text(p_text varchar2,  p_format number, p_fileext varchar2)   
  return varchar2   
  as   
  l_text varchar2(32000) := p_text; 
  begin  
   if p_fileext = 'docx' then 
      l_text := nvl(replace(replace(l_text, chr(13)||chr(10),'<w:br/>'),  chr(10), '<w:br/>'), '');  
   end if; 
   return l_text; 
   exception   
    when others then   
    pak_xslt_log.WriteLog(   
      'Error p_text: '||p_text,   
      p_log_type => pak_xslt_log.g_error,   
      p_procedure => 'PAK_XSLT_REPLACESTR.text',   
      P_SQLERRM => sqlerrm   
    );   
    raise;   
  end text;   
   
  function alignment(p_alignment varchar2,  p_format number, p_fileext varchar2) 
  return varchar2 
  as 
  l_alignment varchar2(32000) := nvl(lower(p_alignment), 'center'); 
  begin 
   if p_fileext = 'xlsx' then 
       l_alignment := upper(substr(l_alignment,1,1)); 
   end if; 
   return l_alignment; 
   exception 
    when others then 
    pak_xslt_log.WriteLog( 
      'Error p_alignment: '||p_alignment, 
      p_log_type => pak_xslt_log.g_error, 
      p_procedure => 'PAK_XSLT_REPLACESTR.alignment', 
      P_SQLERRM => sqlerrm 
    ); 
    raise; 
  end alignment; 
     
/** replace replacement strings (format #STRING#) with APEX items values and values from Print Attributes dialog   
  *   
  * @param p_Xslt input XSLT or static OOXML tempalte   
  * @param p_app_id application ID from where Print Settings are read   
  * @param p_page_id page ID from where Print Settings are read   
  * @param p_region_name region name from where Print Settings are read   
  * @param p_format Format of target document. Parameter is here for future use, now MS OOXML is assumed   
  * @param p_fileext File extension. E.g. xslx, docx 
  */    
  procedure SmartReplaceReportAttr(   
    p_xslt IN OUT NOCOPY CLOB,    
    p_app_id number,    
    p_page_id number,    
    p_region_name varchar2,    
    p_format number,   
    p_fileext varchar2   
  )   
  as   
  L_PAPER_SIZE                                varchar2(4000);   
  L_ORIENTATION               varchar2(4000);   
  L_PAPER_SIZE_UNITS          varchar2(4000);   
  L_BORDER_WIDTH                            varchar2(4000);   
  L_BORDER_COLOR                            varchar2(4000);   
  L_HEIGHT                                    varchar2(4000);   
  L_PAPER_SIZE_WIDTH                    varchar2(4000);   
  L_PAGE_HEADER_FONT_COLOR         varchar2(4000);   
  L_PAGE_HEADER_FONT_FAMILY     varchar2(4000);   
  L_PAGE_HEADER_FONT_SIZE         varchar2(4000);   
  L_PAGE_HEADER_FONT_WEIGHT     varchar2(4000);   
  L_PAGE_HEADER_ALIGNMENT            varchar2(4000);   
  L_PAGE_HEADER                                    varchar2(4000);   
  L_HEADER_FONT_SIZE                    varchar2(4000);   
  L_HEADER_FONT_FAMILY                varchar2(4000);   
  L_HEADER_FONT_WEIGHT                varchar2(4000);   
  L_HEADER_BACKGROUND_COLOR                        varchar2(4000);   
  L_HEADER_FONT_COLOR                    varchar2(4000);   
  L_BODY_FONT_FAMILY                     varchar2(4000);   
  L_BODY_FONT_SIZE                         varchar2(4000);   
  L_BODY_FONT_WEIGHT                     varchar2(4000);   
  L_BODY_BACKGROUND_COLOR                            varchar2(4000);   
  L_BODY_FONT_COLOR                        varchar2(4000);   
  L_FOOTER_FONT_COLOR         varchar2(4000);   
  L_FOOTER_FONT_FAMILY     varchar2(4000);   
  L_FOOTER_FONT_SIZE         varchar2(4000);   
  L_FOOTER_FONT_WEIGHT     varchar2(4000);   
  L_FOOTER_ALIGNMENT            varchar2(4000);   
  L_FOOTER                             varchar2(4000);   
  l_id                  number;   
  l_region_name         varchar2(4000):= p_region_name;   
  l_semicolon           number;   
  l_count               number;   
  l_logged              boolean:= false; 
  begin   
    if instr(p_xslt, '#') > 0 then --if # exists in XSLT   
      if l_region_name is not null then   
        l_semicolon := instr(l_region_name, ';');   
        if l_semicolon > 0 then   
          l_region_name := substr(l_region_name, 1, l_semicolon); --use print params from first region   
        end if;   
        select count(*) into l_count   
        from   
        $IF CCOMPILING.g_views_granted $THEN   
        APEX_APPLICATION_PAGE_RPT_EX   
        $ELSE   
        APEX_APPLICATION_PAGE_RPT   
        $END   
        where application_id = p_app_id and page_id = p_page_id and region_name = l_region_name;   
      end if;   
      if l_count = 1 then   
        $IF CCOMPILING.g_views_granted $THEN   
        select id into l_id   
        from   
        APEX_APPLICATION_PAGE_RPT_EX   
        $ELSE   
        select region_id into l_id   
        from   
        APEX_APPLICATION_PAGE_RPT   
        $END   
        where application_id = p_app_id and page_id = p_page_id and region_name = l_region_name;   
         
        pak_xslt_log.WriteLog(   
            'Exact match find in APEX_APPLICATION_PAGE_RPT (region_id: '||l_id||') for p_app_id: '||p_app_id|| ' p_page_id: '||p_page_id||' p_region_name: '||p_region_name||' l_region_name: '||l_region_name,   
            p_procedure => 'PAK_XSLT_REPLACESTR.SmartReplace' 
        );   
        l_logged := true; 
      else   
        $IF CCOMPILING.g_views_granted $THEN   
        select max(id) into l_id   
        from   
        APEX_APPLICATION_PAGE_RPT_EX   
        $ELSE   
        select max(region_id) into l_id   
        from   
        APEX_APPLICATION_PAGE_RPT   
        $END   
        where application_id = p_app_id and page_id = p_page_id   
        and (   
            PAPER_SIZE                                IS NOT NULL OR   
            ORIENTATION               IS NOT NULL OR   
            PAPER_SIZE_UNITS          IS NOT NULL OR   
            BORDER_WIDTH                            IS NOT NULL OR   
            BORDER_COLOR                            IS NOT NULL OR   
            HEIGHT                                IS NOT NULL OR   
            PAPER_SIZE_WIDTH                    IS NOT NULL OR   
            PAGE_HEADER_FONT_COLOR         IS NOT NULL OR   
            PAGE_HEADER_FONT_FAMILY     IS NOT NULL OR   
            PAGE_HEADER_FONT_SIZE         IS NOT NULL OR   
            PAGE_HEADER_FONT_WEIGHT     IS NOT NULL OR   
            PAGE_HEADER_ALIGNMENT            IS NOT NULL OR   
            PAGE_HEADER                              IS NOT NULL OR   
            HEADER_FONT_SIZE                    IS NOT NULL OR   
            HEADER_FONT_FAMILY                IS NOT NULL OR   
            HEADER_FONT_WEIGHT                IS NOT NULL OR   
            HEADER_BACKGROUND_COLOR        IS NOT NULL OR   
            HEADER_FONT_COLOR                    IS NOT NULL OR   
            BODY_FONT_FAMILY                     IS NOT NULL OR   
            BODY_FONT_SIZE                         IS NOT NULL OR   
            BODY_FONT_WEIGHT                     IS NOT NULL OR   
            BODY_BACKGROUND_COLOR            IS NOT NULL OR   
            BODY_FONT_COLOR                        IS NOT NULL OR   
            FOOTER_FONT_COLOR         IS NOT NULL OR   
            FOOTER_FONT_FAMILY     IS NOT NULL OR   
            FOOTER_FONT_SIZE         IS NOT NULL OR   
            FOOTER_FONT_WEIGHT     IS NOT NULL OR   
            FOOTER_ALIGNMENT            IS NOT NULL OR   
            FOOTER IS NOT NULL   
        );  
        if l_id is null then   
            $IF CCOMPILING.g_views_granted $THEN   
            select max(id) into l_id   
            from   
            APEX_APPLICATION_PAGE_RPT_EX   
            $ELSE   
            select max(region_id) into l_id   
            from   
            APEX_APPLICATION_PAGE_RPT   
            $END   
            where application_id = p_app_id-- and page_id = p_page_id   
            and (   
                PAPER_SIZE                                IS NOT NULL OR   
                ORIENTATION               IS NOT NULL OR   
                PAPER_SIZE_UNITS          IS NOT NULL OR   
                BORDER_WIDTH                            IS NOT NULL OR   
                BORDER_COLOR                            IS NOT NULL OR   
                HEIGHT                                IS NOT NULL OR   
                PAPER_SIZE_WIDTH                    IS NOT NULL OR   
                PAGE_HEADER_FONT_COLOR         IS NOT NULL OR   
                PAGE_HEADER_FONT_FAMILY     IS NOT NULL OR   
                PAGE_HEADER_FONT_SIZE         IS NOT NULL OR   
                PAGE_HEADER_FONT_WEIGHT     IS NOT NULL OR   
                PAGE_HEADER_ALIGNMENT            IS NOT NULL OR   
                PAGE_HEADER                              IS NOT NULL OR   
                HEADER_FONT_SIZE                    IS NOT NULL OR   
                HEADER_FONT_FAMILY                IS NOT NULL OR   
                HEADER_FONT_WEIGHT                IS NOT NULL OR   
                HEADER_BACKGROUND_COLOR        IS NOT NULL OR   
                HEADER_FONT_COLOR                    IS NOT NULL OR   
                BODY_FONT_FAMILY                     IS NOT NULL OR   
                BODY_FONT_SIZE                         IS NOT NULL OR   
                BODY_FONT_WEIGHT                     IS NOT NULL OR   
                BODY_BACKGROUND_COLOR            IS NOT NULL OR   
                BODY_FONT_COLOR                        IS NOT NULL OR   
                FOOTER_FONT_COLOR         IS NOT NULL OR   
                FOOTER_FONT_FAMILY     IS NOT NULL OR   
                FOOTER_FONT_SIZE         IS NOT NULL OR   
                FOOTER_FONT_WEIGHT     IS NOT NULL OR   
                FOOTER_ALIGNMENT            IS NOT NULL OR   
                FOOTER IS NOT NULL   
            );  
        else 
            pak_xslt_log.WriteLog(   
                'Find match at the same page with max region_id APEX_APPLICATION_PAGE_RPT (region_id: '||l_id||') for p_app_id: '||p_app_id|| ' p_page_id: '||p_page_id||' p_region_name: '||p_region_name||' l_region_name: '||l_region_name,   
                p_procedure => 'PAK_XSLT_REPLACESTR.SmartReplace' 
            );   
            l_logged := true; 
        end if; 
      end if;   
      if l_id is not null then   
        select   
        PAPER_SIZE                                ,   
        ORIENTATION               ,   
        PAPER_SIZE_UNITS          ,   
        BORDER_WIDTH                            ,   
        BORDER_COLOR                            ,   
        HEIGHT                                ,   
        PAPER_SIZE_WIDTH                                ,   
        PAGE_HEADER_FONT_COLOR         ,   
        PAGE_HEADER_FONT_FAMILY     ,   
        PAGE_HEADER_FONT_SIZE         ,   
        PAGE_HEADER_FONT_WEIGHT     ,   
        PAGE_HEADER_ALIGNMENT            ,   
        PAGE_HEADER                                    ,   
        HEADER_FONT_SIZE                    ,   
        HEADER_FONT_FAMILY                ,   
        HEADER_FONT_WEIGHT                ,   
        HEADER_BACKGROUND_COLOR                        ,   
        HEADER_FONT_COLOR                    ,   
        BODY_FONT_FAMILY                     ,   
        BODY_FONT_SIZE                         ,   
        BODY_FONT_WEIGHT                     ,   
        BODY_BACKGROUND_COLOR                            ,   
        BODY_FONT_COLOR                        ,   
        FOOTER_FONT_COLOR         ,   
        FOOTER_FONT_FAMILY     ,   
        FOOTER_FONT_SIZE         ,   
        FOOTER_FONT_WEIGHT     ,   
        FOOTER_ALIGNMENT            ,   
        FOOTER   
        into   
        L_PAPER_SIZE                                ,   
        L_ORIENTATION               ,   
        L_PAPER_SIZE_UNITS          ,   
        L_BORDER_WIDTH                            ,   
        L_BORDER_COLOR                            ,   
        L_HEIGHT                                ,   
        L_PAPER_SIZE_WIDTH                                ,   
        L_PAGE_HEADER_FONT_COLOR         ,   
        L_PAGE_HEADER_FONT_FAMILY     ,   
        L_PAGE_HEADER_FONT_SIZE         ,   
        L_PAGE_HEADER_FONT_WEIGHT     ,   
        L_PAGE_HEADER_ALIGNMENT            ,   
        L_PAGE_HEADER                                    ,   
        L_HEADER_FONT_SIZE                    ,   
        L_HEADER_FONT_FAMILY                ,   
        L_HEADER_FONT_WEIGHT                ,   
        L_HEADER_BACKGROUND_COLOR                        ,   
        L_HEADER_FONT_COLOR                    ,   
        L_BODY_FONT_FAMILY                     ,   
        L_BODY_FONT_SIZE                         ,   
        L_BODY_FONT_WEIGHT                     ,   
        L_BODY_BACKGROUND_COLOR                            ,   
        L_BODY_FONT_COLOR                        ,   
        L_FOOTER_FONT_COLOR         ,   
        L_FOOTER_FONT_FAMILY     ,   
        L_FOOTER_FONT_SIZE         ,   
        L_FOOTER_FONT_WEIGHT     ,   
        L_FOOTER_ALIGNMENT            ,   
        L_FOOTER   
        from   
        $IF CCOMPILING.g_views_granted $THEN   
        APEX_APPLICATION_PAGE_RPT_EX   
        where id = l_id;   
        $ELSE   
        APEX_APPLICATION_PAGE_RPT   
        where region_id = l_id;   
        $END          
         
        if not l_logged then 
             pak_xslt_log.WriteLog(   
                'Find match at the same app with max region_id APEX_APPLICATION_PAGE_RPT (region_id: '||l_id||') for p_app_id: '||p_app_id|| ' p_page_id: '||p_page_id||' p_region_name: '||p_region_name||' l_region_name: '||l_region_name,   
                p_procedure => 'PAK_XSLT_REPLACESTR.SmartReplace' 
             );   
             l_logged := true; 
         end if; 
      else --end: l_id is not null   
          pak_xslt_log.WriteLog(   
                'Cand find Classic report in application p_app_id: '||p_app_id,   
                p_procedure => 'PAK_XSLT_REPLACESTR.SmartReplace' 
          );   
          l_logged := true; 
      end if; --end: l_id is null   
       
      p_xslt := replace(p_xslt, '#PAPER_SIZE#' , nvl(L_PAPER_SIZE, 'A4'));   
      p_xslt := replace(p_xslt, '#ORIENTATION#', case L_ORIENTATION when 'VERTICAL' then 'portrait' when 'HORIZONTAL' then 'landscape' else 'portrait' end);   
      L_PAPER_SIZE_UNITS := case L_PAPER_SIZE_UNITS   
                                when 'POINTS' then 'pt'   
                                when 'INCHES' then 'in'   
                                when 'CENTIMETERS' then 'cm'   
                                when 'MILLIMETERS' then 'mm'   
                                else 'pt'   
                              end;   
      p_xslt := replace(p_xslt, '#UNITS#'                                            , nvl(L_PAPER_SIZE_UNITS          ,'pt'        ));   
      p_xslt := replace(p_xslt, '#BORDER_WIDTH#'                            , nvl(replace(L_BORDER_WIDTH, ',', '.')        ,'0.5'       ));   
      p_xslt := replace(p_xslt, '#BORDER_COLOR#'                            , nvl(L_BORDER_COLOR                            ,'solid'     ));   
      p_xslt := replace(p_xslt, '#PAGE_HEIGHT#'                                , nvl(replace(L_HEIGHT, ',', '.') ,    '792'       ));   
      p_xslt := replace(p_xslt, '#PAGE_WIDTH#'                                , nvl(replace(L_PAPER_SIZE_WIDTH, ',', '.'), '612' ));   
      p_xslt := replace(p_xslt, '#PAGE_HEADER_FONT_COLOR#'        , nvl(replace(L_PAGE_HEADER_FONT_COLOR,'#')    ,'000000'));   
      p_xslt := replace(p_xslt, '#PAGE_HEADER_FONT_FAMILY#'        , font(L_PAGE_HEADER_FONT_FAMILY     ,'Calibri', p_format ));   
      p_xslt := replace(p_xslt, '#PAGE_HEADER_FONT_SIZE#'            , fontsize(L_PAGE_HEADER_FONT_SIZE, 12, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#PAGE_HEADER_FONT_WEIGHT#'        , fontweight(L_PAGE_HEADER_FONT_WEIGHT, p_format, p_fileext, p_header_footer=>true));   
      p_xslt := replace(p_xslt, '#PAGE_HEADER_ALIGNMENT#'            , alignment(L_PAGE_HEADER_ALIGNMENT, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#PAGE_HEADER#'                        , text(L_PAGE_HEADER, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#HEADER_FONT_SIZE#'                    , fontsize(L_HEADER_FONT_SIZE, 12, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#HEADER_FONT_FAMILY#'                , font(L_HEADER_FONT_FAMILY, 'Calibri', p_format));   
      p_xslt := replace(p_xslt, '#HEADER_FONT_WEIGHT#'                , fontweight(nvl(L_HEADER_FONT_WEIGHT,'bold') , p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#HEADER_BG_COLOR#'                        , nvl(replace(L_HEADER_BACKGROUND_COLOR, '#')    ,'ffffff'));   
      p_xslt := replace(p_xslt, '#HEADER_FONT_COLOR#'                    , nvl(replace(L_HEADER_FONT_COLOR, '#'), '000000'));   
      p_xslt := replace(p_xslt, '#BODY_FONT_FAMILY#'                    , font(L_BODY_FONT_FAMILY, 'Calibri', p_format));   
      p_xslt := replace(p_xslt, '#BODY_FONT_SIZE#'                        , fontsize(L_BODY_FONT_SIZE, 10, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#BODY_FONT_WEIGHT#'                    , fontweight(L_BODY_FONT_WEIGHT, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#BODY_BG_COLOR#'                            , nvl(replace(L_BODY_BACKGROUND_COLOR, '#'), 'ffffff'));   
      p_xslt := replace(p_xslt, '#BODY_FONT_COLOR#'                        , nvl(replace(L_BODY_FONT_COLOR, '#'), '000000'));   
      p_xslt := replace(p_xslt, '#PAGE_FOOTER_FONT_COLOR#'        , nvl(replace(L_FOOTER_FONT_COLOR, '#'), '000000'));   
      p_xslt := replace(p_xslt, '#PAGE_FOOTER_FONT_FAMILY#'        , font(L_FOOTER_FONT_FAMILY, 'Calibri', p_format));   
      p_xslt := replace(p_xslt, '#PAGE_FOOTER_FONT_SIZE#'            , fontsize(L_FOOTER_FONT_SIZE, 12, p_format, p_fileext));   
      p_xslt := replace(p_xslt, '#PAGE_FOOTER_FONT_WEIGHT#'        , fontweight(L_FOOTER_FONT_WEIGHT, p_format, p_fileext, p_header_footer=>true));   
      p_xslt := replace(p_xslt, '#PAGE_FOOTER_ALIGNMENT#'            , alignment(L_FOOTER_ALIGNMENT, p_format, p_fileext));     
      p_xslt := replace(p_xslt, '#PAGE_FOOTER#'                        , text(L_FOOTER, p_format, p_fileext));   
         
      ---Replace APEX APPLICATION ITEMS   
      for r_cur_ai in (select item_name from apex_application_items where application_id = p_app_id)   
      loop   
        p_xslt := replace(p_xslt, '#'||r_cur_ai.item_name||'#', V(r_cur_ai.item_name));   
      end loop;   
      if REGEXP_INSTR(p_xslt, '#P\d+?_') > 0 then --at least one item must be in standard APEX format - like P1_MY_ITEM   
        ---Replace APEX APPLICATION ITEMS   
        for r_cur_api in (select item_name from apex_application_page_items where application_id = p_app_id)   
        loop   
          p_xslt := replace(p_xslt, '#'||r_cur_api.item_name||'#', V(r_cur_api.item_name));   
        end loop;   
      end if;   
    end if; --exists # in XSLT   
  exception   
  when others then   
  pak_xslt_log.WriteLog(   
    'Error p_app_id: '||p_app_id|| ' p_page_id: '||p_page_id||' p_region_name: '||p_region_name||' l_region_name: '||l_region_name,   
    p_log_type => pak_xslt_log.g_error,   
    p_procedure => 'PAK_XSLT_REPLACESTR.SmartReplace',   
    P_SQLERRM => sqlerrm   
  );   
  raise;   
  end;   
END PAK_XSLT_REPLACESTR; 

/
