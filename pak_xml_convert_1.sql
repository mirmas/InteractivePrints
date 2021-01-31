
CREATE OR REPLACE package body PAK_XML_CONVERT is

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


type excel_colors is VARRAY(16) OF VARCHAR2(6);

type word_colors is VARRAY(15) OF word_color;
TYPE StringMatrix IS VARRAY(200) OF APEX_APPLICATION_GLOBAL.vc_arr2;

g_base_formats constant PLS_INTEGER := 10;

g_excel_colors constant excel_colors :=
--APEX and MS Word Marker colors
excel_colors
(
'FFFF99',  --yellow
'99FF99',  --green
'99CCFF',  --blue
'FFDD44',  --orange not MS Word Marker color)
'FF7755',	 --red
--MS Word Marker colors
'006400',  --darkGreen
'8b008b',  --darkMagenta
'ff00ff',  --magenta
'8B0000',  --darkRed
'CDCD00',  --darkYellow
'D3D3D3',  --lightGray
'303030',  --darkGray
'000000',  --black
'00FFFF',  --cyan
'0000EE',  --darkBlue
'008B8B'   --darkCyan
);

g_word_colors constant word_colors :=
--APEX and MS Word Marker colors
word_colors
(
    word_color('FFFF99',  'yellow'),
    word_color('99FF99',  'green'  ),
    word_color('99CCFF',  'blue'   	),
    word_color('FF7755',  'red'    	),
    word_color('006400',  'darkGreen' ),
    word_color('8b008b',  'darkMagenta' ),
    word_color('ff00ff',  'magenta'),
    word_color('8B0000',  'darkRed' ),
    word_color('CDCD00',  'darkYellow'),
    word_color('D3D3D3',  'lightGray'),
    word_color('303030',  'darkGray'),
    word_color('000000',  'black' ),
    word_color('00FFFF',  'cyan'),
    word_color('0000EE',  'darkBlue'),
    word_color('008B8B',  'darkCyan')
);


c_table_delimiter constant varchar(21) := lpad('-', 20, '-')||chr(10);
c_line_delimiter constant varchar(1) := chr(10);
c_col_delimiter constant varchar(3) := '$#!';
c_table_cols constant number := 18;

/* function returns diference between two colors */
function colordiff(p_color1 varchar2, p_color2 varchar2)
return number
as
begin
    return abs(to_number(substr(p_color1, 1, 2),'xx') - to_number(substr(p_color2, 1, 2),'xx')) +
           abs(to_number(substr(p_color1, 3, 2),'xx') - to_number(substr(p_color2, 3, 2),'xx')) +
           abs(to_number(substr(p_color1, 5, 2),'xx') - to_number(substr(p_color2, 5, 2),'xx'));
end;

/* function returns zero based index of the most similar color from upper list to p_color.
   Parameter p_color is in RGB HEX format
*/
function findExcelColor(p_color varchar2)
return number
as
    l_index_min NUMBER;
    l_value_min NUMBER := 99999;
    l_value     NUMBER;


begin
    if p_color is null then
        return null;
    end if;
    for i in 1..g_excel_colors.count loop
        l_value := colordiff(p_color, g_excel_colors(i));
        if l_value < l_value_min then
            l_value_min := l_value;
            l_index_min := i;
        end if;
    end loop;
    return l_index_min - 1;
end;

/* function returns Word highlight name of the most similar color from upper list to p_color.
   Parameter p_color is in RGB HEX format
*/
function findWordColor(p_color varchar2)
return varchar2
as
    l_ret VARCHAR2(20);
    l_value_min NUMBER := 99999;
    l_value     NUMBER;


begin
    if p_color is null then
        return null;
    end if;
    for i in 1..g_word_colors.count loop
        l_value := colordiff(p_color, g_word_colors(i).color);
        if l_value < l_value_min then
            l_value_min := l_value;
            l_ret := g_word_colors(i).name;
        end if;
    end loop;
    return l_ret;
end;

/*
Function defines mapping between Oracle data types and format masks and excel base formats lists in 
ExcelXLSX.xml bellow the comment <!--Base Excel formats-->
*/				
function getbaseformat(
      P_ORA_TYPE IN VARCHAR2
      ,P_ORA_FORMAT_MASK IN VARCHAR2
) return NUMBER
as
l_ret NUMBER := 0;
begin
  l_ret :=
  case P_ORA_TYPE
      when 'DATE' then
          case when P_ORA_FORMAT_MASK like '%HH24:MI%' then 9 else 1 end
      when 'NUMBER' then
          case WHEN P_ORA_FORMAT_MASK like 'FML%G%990D00' then 8
              WHEN P_ORA_FORMAT_MASK like '%G990D00' then 3
              WHEN P_ORA_FORMAT_MASK like '%990D00' and nvl(instr(P_ORA_FORMAT_MASK,'G'),0) = 0 then 2
              WHEN P_ORA_FORMAT_MASK like '%990' and nvl(instr(P_ORA_FORMAT_MASK,'G'),0) = 0 then 4
              WHEN P_ORA_FORMAT_MASK like '%G990' and nvl(instr(P_ORA_FORMAT_MASK,'G'),0) = 0 then 5
              WHEN P_ORA_FORMAT_MASK like '%990D000' and nvl(instr(P_ORA_FORMAT_MASK,'G'),0) = 0 then 6
              --WHEN P_ORA_FORMAT_MASK like '999G999G999G999G999G999G990' then 7
              else 4 --default 999999999999990
          end
      else 0 --default string
  end;
  return l_ret;
end;

function ExcelVal(p_value VARCHAR2,
                  p_type VARCHAR2,
                  p_format_mask VARCHAR2,
                  p_aggregation VARCHAR2,
                  p_formula VARCHAR2,
                  p_excelcol VARCHAR2)
return varchar2
as
l_ret VARCHAR2(4000);
begin
    if p_aggregation is not null and p_formula is not null then
        l_ret := case p_aggregation when 'AVG' then 'AVERAGE' else p_aggregation end ||
        '('||    p_excelcol||replace(p_formula,':',':'||p_excelcol)    ||')';
    elsif p_value is not null then
        if nvl(p_type, 'VARCHAR2') = 'VARCHAR2' then
            l_ret := substr(p_value, 1, 4000);
        elsif p_type = 'NUMBER' then
            if p_format_mask is not null then
                l_ret := to_number(p_value, p_format_mask);
            else
                l_ret := to_number(p_value);
            end if;
			l_ret := replace(l_ret,',','.'); --excel needs dots
        elsif p_type = 'DATE' then
            if p_format_mask is not null then
                l_ret := to_char(round(to_date(p_value, p_format_mask)-to_date('01.01.1900','DD.MM.YYYY')+2,6));
            else
                l_ret := to_char(round(to_date(p_value)-to_date('01.01.1900','DD.MM.YYYY')+2, 6));
            end if;
			l_ret := replace(l_ret,',','.'); --excel needs dots
        end if;
    end if;
    return l_ret;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Napaka v konverziji',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'ExcelVal',
      p_sqlerrm => sqlerrm
    );
    return null;
end;


procedure EXCEL_VALUE_AND_FORMAT(
      P_VALUE IN VARCHAR2
      ,P_ORA_TYPE IN VARCHAR2
      ,P_ORA_FORMAT_MASK IN VARCHAR2
      ,P_HIGHLIGHT_BKG_COLOR IN VARCHAR2 default null
      ,P_HIGHLIGHT_FONT_COLOR IN VARCHAR2 default null
      ,p_aggregation in VARCHAR2 default null
      ,p_formula in VARCHAR2 default null
      ,p_excelcol in VARCHAR2 default null
      ,p_breakrow in number default null
      ,po_value OUT VARCHAR2
      ,po_print_settings_format OUT NUMBER
      ,po_format OUT NUMBER
)
as
l_baseformat NUMBER := getbaseformat(P_ORA_TYPE, P_ORA_FORMAT_MASK);
l_excel_bkg_color NUMBER := findExcelColor(P_HIGHLIGHT_BKG_COLOR);
l_excel_font_color NUMBER := findExcelColor(P_HIGHLIGHT_FONT_COLOR);

begin
     po_print_settings_format := l_baseformat;
     po_format := l_baseformat;
     po_value := ExcelVal(p_value, p_ora_type, p_ora_format_mask, p_aggregation, p_formula, p_excelcol);
     if p_aggregation is null and p_breakrow is null then
        if l_excel_bkg_color is not null then
            po_print_settings_format 	:= l_baseformat+g_base_formats*7+1+g_base_formats*4*l_excel_bkg_color;
            po_format					:= l_baseformat+g_base_formats*5+1+g_base_formats*4*l_excel_bkg_color;
        elsif l_excel_font_color is not null then
                po_print_settings_format	:= l_baseformat+g_base_formats*6+1+g_base_formats*4*l_excel_font_color;
                po_format					:= l_baseformat+g_base_formats*4+1+g_base_formats*4*l_excel_font_color;
        else
                po_print_settings_format	:= l_baseformat+g_base_formats*2+1;
                po_format					:= l_baseformat;
        end if;
    else
          po_print_settings_format		:= l_baseformat+g_base_formats*3+1;
          po_format					    := l_baseformat+g_base_formats;
    end if;

end EXCEL_VALUE_AND_FORMAT;

function GetStringMatrix(p_string varchar2, p_line_delimiter varchar2, p_col_delimiter varchar2, p_num_of_cols number)
  return StringMatrix
  as
  l_lines APEX_APPLICATION_GLOBAL.vc_arr2;
  l_cols APEX_APPLICATION_GLOBAL.vc_arr2;
  l_line varchar2(4000);
  l_ret StringMatrix := StringMatrix();
  begin
    l_lines := apex_util.string_to_table(p_string, p_line_delimiter);
    for i in 1..l_lines.count loop
        l_line := rtrim(l_lines(i), chr(13));
        if i < l_lines.count or length(l_line) > 0 then
            l_cols := apex_util.string_to_table(l_line, p_col_delimiter);
            for j in l_cols.count+1..p_num_of_cols loop
                l_cols(j) := null;
            end loop;
            l_ret.extend(1);
            l_ret(i) := l_cols;
        end if;
    end loop;
    return l_ret;
end;

function SerializeColTypes (p_reportTypes Query2Report.t_coltype_tables)
return varchar2
as
l_ret varchar2(32000);
begin
    for i in 1..p_reportTypes.count loop
        for j in 1..p_reportTypes(i).count loop
            l_ret := l_ret ||p_reportTypes(i)(j).colname                ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).coltype                ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).formatmask             ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).columnwidth            ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).fullname               ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).position               ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).excelcol               ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).break_on_col           ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).breakrow               ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).value                  ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).excelval               ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).aggregate              ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).formula                ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).highlight_name         ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).highlight_bkg_color    ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).highlight_font_color   ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).format                 ||c_col_delimiter;
            l_ret := l_ret ||p_reportTypes(i)(j).ps_format              ||c_line_delimiter;
        end loop;
        l_ret := l_ret || c_table_delimiter;
    end loop;
    return l_ret;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Napaka',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'SerializeColTypes',
      p_sqlerrm => sqlerrm
    );
    raise;    
end;

function DeserializeColTypes (p_reportTypes varchar2)
return  Query2Report.t_coltype_tables
as
l_ret Query2Report.t_coltype_tables := Query2Report.t_coltype_tables();
l_zacetek_tabele number := 1;
l_konec_tabele number;
l_string_matrix StringMatrix;
l_reportTypeTbl T_COLTYPE_TABLE;
l_reportTypeRow T_COLTYPE_ROW := T_COLTYPE_ROW(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
begin
    pak_xslt_log.WriteLog('START p_reportTypes: '||p_reportTypes, p_procedure => 'DeserializeColTypes');
    loop
        l_konec_tabele := instr(p_reportTypes, c_table_delimiter, l_zacetek_tabele);
        exit when nvl(l_konec_tabele, 0) = 0;
        l_string_matrix := GetStringMatrix(substr(p_reportTypes, l_zacetek_tabele, l_konec_tabele-l_zacetek_tabele), c_line_delimiter, c_col_delimiter, c_table_cols);
        l_reportTypeTbl := T_COLTYPE_TABLE();
        for i in l_string_matrix.first..l_string_matrix.last  loop
  
            l_reportTypeRow.colname               := l_string_matrix(i)(1);
            l_reportTypeRow.coltype               := l_string_matrix(i)(2);
            l_reportTypeRow.formatmask            := l_string_matrix(i)(3);
            l_reportTypeRow.columnwidth           := l_string_matrix(i)(4);
            l_reportTypeRow.fullname              := l_string_matrix(i)(5);
            l_reportTypeRow.position              := l_string_matrix(i)(6);
            l_reportTypeRow.excelcol              := l_string_matrix(i)(7);
            l_reportTypeRow.break_on_col          := l_string_matrix(i)(8);
            l_reportTypeRow.breakrow              := l_string_matrix(i)(9);
            l_reportTypeRow.value                 := l_string_matrix(i)(10);
            l_reportTypeRow.excelval              := l_string_matrix(i)(11);
            l_reportTypeRow.aggregate             := l_string_matrix(i)(12);
            l_reportTypeRow.formula               := l_string_matrix(i)(13);
            l_reportTypeRow.highlight_name        := l_string_matrix(i)(14);
            l_reportTypeRow.highlight_bkg_color   := l_string_matrix(i)(15);
            l_reportTypeRow.highlight_font_color  := l_string_matrix(i)(16);
            l_reportTypeRow.format                := l_string_matrix(i)(17);
            l_reportTypeRow.ps_format             := l_string_matrix(i)(18);
            
            l_reportTypeTbl.extend;
            l_reportTypeTbl(l_reportTypeTbl.count) := l_reportTypeRow;
        end loop;
        l_ret.extend;
        l_ret(l_ret.count) := l_reportTypeTbl;
        l_zacetek_tabele := l_konec_tabele + length(c_table_delimiter);
    end loop;
    return l_ret;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Napaka',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'DeserializeColTypes',
      p_sqlerrm => sqlerrm
    );
    raise;        
end;

function LogColTypes (p_reportTypes  Query2Report.t_coltype_tables)
return varchar2
as
l_ret varchar2(32000);
begin
    for i in 1..p_reportTypes.count loop
        l_ret := l_ret || '------------------p_reportTypes('||i||')-----------------------------------'||chr(10);
        for j in 1..p_reportTypes(i).count loop
            l_ret := l_ret || '-----row'||j||'-------'||chr(10);
            l_ret := l_ret || 'colname: '               ||     p_reportTypes(i)(j).colname                ||chr(10);
            l_ret := l_ret || 'coltype: '               ||     p_reportTypes(i)(j).coltype                ||chr(10);
            l_ret := l_ret || 'formatmask: '            ||     p_reportTypes(i)(j).formatmask             ||chr(10);
            l_ret := l_ret || 'columnwidth: '           ||     p_reportTypes(i)(j).columnwidth            ||chr(10);
            l_ret := l_ret || 'fullname: '              ||     p_reportTypes(i)(j).fullname               ||chr(10);
            l_ret := l_ret || 'position: '              ||     p_reportTypes(i)(j).position               ||chr(10);
            l_ret := l_ret || 'excelcol: '              ||     p_reportTypes(i)(j).excelcol               ||chr(10);
            l_ret := l_ret || 'break_on_col: '          ||     p_reportTypes(i)(j).break_on_col           ||chr(10);
            l_ret := l_ret || 'breakrow: '              ||     p_reportTypes(i)(j).breakrow               ||chr(10);
            l_ret := l_ret || 'value: '                 ||     p_reportTypes(i)(j).value                  ||chr(10);
            l_ret := l_ret || 'excelval: '              ||     p_reportTypes(i)(j).excelval               ||chr(10);
            l_ret := l_ret || 'aggregate: '             ||     p_reportTypes(i)(j).aggregate              ||chr(10);
            l_ret := l_ret || 'formula: '               ||     p_reportTypes(i)(j).formula                ||chr(10);
            l_ret := l_ret || 'highlight_name: '        ||     p_reportTypes(i)(j).highlight_name         ||chr(10);
            l_ret := l_ret || 'highlight_bkg_color: '   ||     p_reportTypes(i)(j).highlight_bkg_color    ||chr(10);
            l_ret := l_ret || 'highlight_font_color: '  ||     p_reportTypes(i)(j).highlight_font_color   ||chr(10);
            l_ret := l_ret || 'format: '                ||     p_reportTypes(i)(j).format                 ||chr(10);
            l_ret := l_ret || 'ps_format: '             ||     p_reportTypes(i)(j).ps_format              ||chr(10);
        end loop;
    end loop;
    return l_ret;
end;

function LogColType (p_reportType  t_coltype_table)
return varchar2
as
l_ret varchar2(32000);
begin
        for j in 1..p_reportType.count loop
            l_ret := l_ret || '------------------------------row'||j||'------------------------------'||chr(10);
            l_ret := l_ret || 'colname: '               ||     p_reportType(j).colname                ||chr(10);
            l_ret := l_ret || 'coltype: '               ||     p_reportType(j).coltype                ||chr(10);
            l_ret := l_ret || 'formatmask: '            ||     p_reportType(j).formatmask             ||chr(10);
            l_ret := l_ret || 'columnwidth: '           ||     p_reportType(j).columnwidth            ||chr(10);
            l_ret := l_ret || 'fullname: '              ||     p_reportType(j).fullname               ||chr(10);
            l_ret := l_ret || 'position: '              ||     p_reportType(j).position               ||chr(10);
            l_ret := l_ret || 'excelcol: '              ||     p_reportType(j).excelcol               ||chr(10);
            l_ret := l_ret || 'break_on_col: '          ||     p_reportType(j).break_on_col           ||chr(10);
            l_ret := l_ret || 'breakrow: '              ||     p_reportType(j).breakrow               ||chr(10);
            l_ret := l_ret || 'value: '                 ||     p_reportType(j).value                  ||chr(10);
            l_ret := l_ret || 'excelval: '              ||     p_reportType(j).excelval               ||chr(10);
            l_ret := l_ret || 'aggregate: '             ||     p_reportType(j).aggregate              ||chr(10);
            l_ret := l_ret || 'formula: '               ||     p_reportType(j).formula                ||chr(10);
            l_ret := l_ret || 'highlight_name: '        ||     p_reportType(j).highlight_name         ||chr(10);
            l_ret := l_ret || 'highlight_bkg_color: '   ||     p_reportType(j).highlight_bkg_color    ||chr(10);
            l_ret := l_ret || 'highlight_font_color: '  ||     p_reportType(j).highlight_font_color   ||chr(10);
            l_ret := l_ret || 'format: '                ||     p_reportType(j).format                 ||chr(10);
            l_ret := l_ret || 'ps_format: '             ||     p_reportType(j).ps_format              ||chr(10);
        end loop;
    return l_ret;
end;


function SerializeRegionAttrs (p_regionAttrs Query2Report.tab_string)
return varchar2
as
l_ret varchar2(32000);
begin
    for i in 1..p_regionAttrs.count loop
        l_ret := l_ret||p_regionAttrs(i)||c_col_delimiter;
    end loop;
    return l_ret;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Napaka',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'SerializeRegionAttrs',
      p_sqlerrm => sqlerrm
    );
    raise;        
end;


function DeserializeRegionAttrs (p_regionAttrs varchar2)
return  Query2Report.tab_string
as
l_ret Query2Report.tab_string := Query2Report.tab_string();
l_zacetek number := 1;
l_konec number;
begin
    loop
        l_konec := instr(p_regionAttrs, c_col_delimiter, l_zacetek);
        exit when nvl(l_konec, 0) = 0;
        l_ret.extend;
        l_ret(l_ret.count) := substr(p_regionAttrs, l_zacetek, l_konec - l_zacetek);
        l_zacetek := l_konec + length(c_col_delimiter);
    end loop;
    return l_ret;
 exception
    when others then
    pak_xslt_log.WriteLog(
      'Napaka',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'DeserializeRegionAttrs',
      p_sqlerrm => sqlerrm
    );
    raise;   
end;

/** Removes elements with name p_element from XML part p_xmlChunck
* @param p_xmlChunck part of XML
* @param p_element Name of elements to remove
* @return XML part without elements with name p_element
*/
function xmlRemoveElement(
  p_xmlChunck varchar2,
  p_element varchar2
)
return varchar2
as
l_ret varchar2(32000);
l_start number default 1;
l_end number default 1;
l_first_half varchar2(32000);
l_second_half varchar2(32000);
begin
  l_ret := p_xmlChunck;
  loop
    l_first_half :='';
    l_second_half :='';
    l_start := instr(l_ret, '<'||p_element||'>');
    exit when nvl(l_start, 0) = 0;
    l_end := instr(l_ret, '</'||p_element||'>');
    exit when nvl(l_end, 0) = 0;
    l_end := l_end + length('</'||p_element||'>');
    if l_start > 1 then
      l_first_half := substr(l_ret, 1, l_start - 1);
    end if;
    if l_end <= length(l_ret) then
      l_second_half := substr(l_ret, l_end);
    end if;
    l_ret := l_first_half||l_second_half;
  end loop;
  return l_ret;
end;

/*
function ReplaceWith_x005F_(
  p_xmlname varchar2,
  p_chars varchar2 default ' _#!$%&()*+,-.''"[]/<=>:;?@\^`{}|~'
)
return varchar2
as
l_ret varchar2(4000);
begin
  l_ret := p_xmlname;
  --l_ret:= translate(l_ret,' ()','_');
  for i in 1..length(p_chars) loop
    l_ret:= replace(l_ret, '_x'||trim(to_char(ascii(substr(p_chars,i, 1)),'xx')), '_x005F_x'||trim(to_char(ascii(substr(p_chars,i, 1)),'xx')));
  end loop;
  return l_ret;
end ReplaceWith_x005F_;
*/

--TODO for each col calculate and insert values l_reportTypes(l_column).highlight_bkg_color, highlight_font_color
function HighlightsToCols(p_reportTypes t_coltype_table, p_Highlights varchar2)
return t_coltype_table
as
l_ret t_coltype_table := p_reportTypes;
l_highlight_col varchar2(100);
l_highlight_col_start number;
l_highlight_col_end number;
l_highlight_cell varchar2(100);
l_highlight_cell_start number;
l_highlight_cell_end number;
l_highlight_bkg_color varchar2(6);
l_highlight_font_color varchar2(6);
l_highlight_name     varchar2(400);
l_highlight_name_start number;
l_highlight_name_end number;


l_highlights varchar2(4000);

begin
    --pak_xslt_log.WriteLog('p_row: '||p_row, p_procedure => 'HighlightsToCols');
    --pak_xslt_log.WriteLog('p_Highlights: '||p_Highlights, p_procedure => 'HighlightsToCols');
    l_highlight_name_start := instr(p_Highlights, 'highlight_name="') + length('highlight_name="');
    l_highlight_name_end := instr(p_Highlights, '"', l_highlight_name_start);
    l_highlight_name := substr(p_Highlights, l_highlight_name_start, l_highlight_name_end - l_highlight_name_start);

    l_highlight_col_start := instr(p_Highlights, 'highlight_col="');
    l_highlight_col_end := instr(p_Highlights, '"', l_highlight_col_start, 2);
    l_highlight_col := substr(p_Highlights, l_highlight_col_start + length('highlight_col="'), l_highlight_col_end - l_highlight_col_start - length('highlight_col="'));
    --pak_xslt_log.WriteLog('l_highlight_col: '||l_highlight_col, p_procedure => 'HighlightsToCols');

    l_highlight_cell_start := instr(p_Highlights, 'highlight_cell="');
    l_highlight_cell_end := instr(p_Highlights, '"', l_highlight_cell_start, 2);
    l_highlight_cell := substr(p_Highlights, l_highlight_cell_start + length('highlight_cell="'), l_highlight_cell_end - l_highlight_cell_start - length('highlight_cell="'));
    --pak_xslt_log.WriteLog('l_highlight_cell: '||l_highlight_cell, p_procedure => 'HighlightsToCols');

    l_highlights := replace(substr(p_Highlights, 1, l_highlight_col_start - 1)||substr(p_Highlights, l_highlight_cell_end + 1),'  ',' ');
    if nvl(instr(l_highlights, 'highlight_bkg_color="#'), 0) > 0 then
        l_highlight_bkg_color := substr(l_highlights, instr(l_highlights, 'highlight_bkg_color="#') + length('highlight_bkg_color="#'), 6);
    end if;
    if nvl(instr(l_highlights, 'highlight_font_color="#'), 0) > 0 then
        l_highlight_font_color := substr(l_highlights, instr(l_highlights, 'highlight_font_color="#') + length('highlight_font_color="#'), 6);
    end if;

    --pak_xslt_log.WriteLog('l_highlights: '||l_highlights, p_procedure => 'HighlightsToCols');
    for i in l_ret.first..l_ret.last loop
        if (l_highlight_cell = 'true' and l_ret(i).colname = l_highlight_col) or l_highlight_cell = 'false' then
            l_ret(i).highlight_name := l_highlight_name;
            l_ret(i).highlight_bkg_color := l_highlight_bkg_color;
            l_ret(i).highlight_font_color := l_highlight_font_color;
        end if;
    end loop;

    --pak_xslt_log.WriteLog('return: '||l_ret, p_procedure => 'HighlightsToCols');
    return l_ret;
end;

function ExcelVal(p_row VARCHAR2, p_reportTypes t_coltype_table, p_filename VARCHAR2, p_breakrow NUMBER)
return t_coltype_table
as
l_ret VARCHAR2(4000);
l_element_name VARCHAR2(400);
l_element VARCHAR2(4000);
l_start NUMBER;
l_end NUMBER;
--l_end_length NUMBER;
l_end1 NUMBER;
l_end2 NUMBER;
l_reportTypes t_coltype_table := p_reportTypes;
begin
    pak_xslt_log.WriteLog(
      'p_filename: '||p_filename||' p_row: '||p_row,
      p_procedure => 'ExcelVal'
    );
    l_ret := replace(replace(p_row, '<ROW>'), '</ROW>');

    loop
        l_element_name := null;
        l_element := null;
        l_start := instr(l_ret, '<');
        l_end1 := instr(l_ret, '/>');
        l_end2 := instr(l_ret, '>');
        if nvl(l_end1, 0) = 0 then
            l_end := nvl(l_end2, 0);
        elsif nvl(l_end2, 0) = 0 then
            l_end := nvl(l_end1, 0);
        else
            l_end := least(l_end1, l_end2);
        end if;
        exit when l_end = 0;
        l_element_name := substr(l_ret, l_start + 1, l_end - l_start - 1);

        if l_end = l_end2 then --value is not null
            l_end1 := instr(l_ret, '</'||l_element_name||'>');
            exit when nvl(l_end1, 0) = 0;
            l_element := substr(l_ret, l_end + 1, l_end1 - l_end - 1);
            l_ret := substr(l_ret, l_end1 + length('</'||l_element_name||'>'));
        else
            l_ret := substr(l_ret, l_end1 + 2);
        end if;
        for i in l_reportTypes.first..l_reportTypes.last loop
            --for each col calculate and insert values l_regionAttrs(l_column).excelval, value, ps_format, format
            if replace(l_reportTypes(i).colname, '_x005F') = replace(l_element_name, '_x005F')
                and (instr(l_reportTypes(i).colname, '_x005F') > 0 
                    or instr (l_element_name, '_x005F') > 0)  
            then
                pak_xslt_log.WriteLog(
                  'l_reportTypes(i).colname: '||l_reportTypes(i).colname||
                  ' l_element_name: '||l_element_name||
                  ' l_reportTypes(i).value: '||l_reportTypes(i).value,
                  p_procedure => 'ExcelVal',
                  p_sqlerrm => sqlerrm
                );
            end if;
            if l_reportTypes(i).colname = replace(l_element_name, '_x005F') then
                l_reportTypes(i).value := l_element;
                l_reportTypes(i).breakrow := p_breakrow;

                if lower(substr(substr(p_filename, instr(p_filename,'.',-1)), 1, 4)) in ('.xls','.xml') 
                    or  p_filename is null then
                    EXCEL_VALUE_AND_FORMAT(
                       l_reportTypes(i).value
                      ,l_reportTypes(i).coltype
                      ,l_reportTypes(i).formatmask
                      ,l_reportTypes(i).highlight_bkg_color
                      ,l_reportTypes(i).highlight_font_color
                      ,l_reportTypes(i).aggregate
                      ,l_reportTypes(i).formula
                      ,l_reportTypes(i).excelcol
                      ,l_reportTypes(i).breakrow
                      ,l_reportTypes(i).excelval
                      ,l_reportTypes(i).ps_format
                      ,l_reportTypes(i).format
                    );
                end if;
            end if;
        end loop;
    end loop;

    return l_reportTypes;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'ExcelVal',
      p_sqlerrm => sqlerrm
    );
    raise;
end;

function BreakOnCol(p_colname varchar2, p_regionAttr varchar2) return boolean
as
l_ret boolean := false;
begin
  for i in 1..9 loop
    if instr(p_regionAttr, 'break_on_col'||i||'="'||p_colname||'"') > 0 then
      l_ret := true;
      exit;
    end if;
  end loop;
  return l_ret;
end;

/**
* Delete null elements REGION_AGGREGATES and REGION_HIGHLIGHTS and then replace
* not null elements REGION_AGGREGATES and REGION_HIGHLIGHTS to attributes in XML part p_xml.
*
* @param p_xml Part of XML to convert
* @return Converted part of XML


*/
function xmlConvertRow(
  p_row varchar2,
  p_filename varchar2,
  pi_regionAttrs varchar2,
  pi_reportTypes t_coltype_table
)
return varchar2
as
l_ret VARCHAR2(32000) := p_row;
l_startRow  number default 1;
l_endRow    number default 1;

l_startAggregates number default 1;
l_endAggregates number default 1;
l_aggregates varchar2(4000);
l_aggregate varchar2(30);
l_formula varchar2(10);


l_startHighlights number default 1;
l_endHighlights number default 1;
l_Highlights varchar2(4000);

l_column varchar2(400);
l_start_pair number default 1;
l_start_time PLS_INTEGER := dbms_utility.get_time();
l_comma1_pos number default 1;
l_comma2_pos number default 1;
l_reportTypes t_coltype_table := t_coltype_table();
i number;
l_breakrow number;

function AddHeaderRow(p_formula VARCHAR2)
return VARCHAR2
as
l_ret_formula VARCHAR2(10)  := p_formula;
l_from_row NUMBER;
l_to_row NUMBER;
begin
    l_from_row := to_number(substr(l_ret_formula, 1, instr(l_ret_formula, ':') - 1));
    l_to_row := to_number(substr(l_ret_formula, instr(l_ret_formula, ':') + 1));
    l_from_row := l_from_row + 1;
    l_to_row := l_to_row + 1;
    l_ret_formula := to_char(l_from_row)||':'||to_char(l_to_row);
    return l_ret_formula;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Formula: '||p_formula,
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'AddHeaderRow',
      p_sqlerrm => sqlerrm
    );
    return p_formula;
end;


begin
   pak_xslt_log.WriteLog(
      'Start p_filename: '||p_filename||' pi_regionAttrs: '||pi_regionAttrs,
      p_procedure => 'xmlConvertRow'
    );

  --set l_reportTypes:= pi_reportTypes for not null columns;
  for l_column in pi_reportTypes.first..pi_reportTypes.last loop
      l_reportTypes.extend;
      l_reportTypes(l_column) := t_coltype_row(null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null);
      l_reportTypes(l_column).colname := pi_reportTypes(l_column).colname;
      l_reportTypes(l_column).coltype := pi_reportTypes(l_column).coltype;
      l_reportTypes(l_column).formatmask := pi_reportTypes(l_column).formatmask;
      l_reportTypes(l_column).columnwidth := pi_reportTypes(l_column).columnwidth;
      l_reportTypes(l_column).fullname := pi_reportTypes(l_column).fullname;
      l_reportTypes(l_column).position := pi_reportTypes(l_column).position;
      l_reportTypes(l_column).excelcol := pi_reportTypes(l_column).excelcol;
      l_reportTypes(l_column).break_on_col := pi_reportTypes(l_column).break_on_col;
  end loop;

    pak_xslt_log.WriteLog(
      'l_reportTypes po inicializaciji: '||LogColType(l_reportTypes),
      p_procedure => 'xmlConvertRow'
    );

    l_breakrow := null;
    --set l_regionAttrs(l_column).aggregate, formula, excelval, highlight_bck_color, highlight_font_color, ps_format, format to NULL for all cols
    for i in l_reportTypes.first..l_reportTypes.last loop
        l_reportTypes(i).aggregate := null;
        l_reportTypes(i).formula := null;
        l_reportTypes(i).value := null;
        l_reportTypes(i).excelval := null;
        l_reportTypes(i).highlight_name := null;
        l_reportTypes(i).highlight_bkg_color := null;
        l_reportTypes(i).highlight_font_color := null;
        l_reportTypes(i).ps_format := null;
        l_reportTypes(i).format := null;
    end loop;

    l_startAggregates := instr(l_ret, '<REGION_AGGREGATES>');
    l_endAggregates := instr(l_ret, '</REGION_AGGREGATES>', l_startAggregates);
    if nvl(l_startAggregates, 0) > 0 and nvl(l_endAggregates, 0) > 0 then
      l_startAggregates := l_startAggregates + length('<REGION_AGGREGATES>');
      l_aggregates := substr(l_ret, l_startAggregates, l_endAggregates-l_startAggregates);
      l_formula := substr(l_aggregates, 1, instr(l_aggregates, ',') - 1);
      l_aggregates := substr(l_aggregates, instr(l_aggregates, ',') + 1);

      l_start_pair := 1;
      loop --through agregates in single row
        l_comma1_pos := instr(l_aggregates, ',', l_start_pair, 1);
        exit when nvl(l_comma1_pos, 0)=0;
        l_comma2_pos := instr(l_aggregates, ',', l_start_pair, 2);
        exit when nvl(l_comma2_pos, 0)=0;
        l_aggregate := substr(l_aggregates, l_start_pair, l_comma1_pos - l_start_pair);
        l_column := substr(l_aggregates, l_comma1_pos+1, l_comma2_pos - l_comma1_pos - 1);
        l_start_pair := l_comma2_pos+1;
        --For each column insert values l_regionAttrs(l_column).aggregate, formula
        for i in l_reportTypes.first..l_reportTypes.last loop
            if l_reportTypes(i).colname = l_column then
                l_reportTypes(i).aggregate := l_aggregate;
                l_reportTypes(i).formula := AddHeaderRow(l_formula);
            end if;
        end loop;

      end loop;
    end if;

    if instr(l_ret, '<BREAKROW>1</BREAKROW>') > 0
    then
      l_breakrow := 1;
      l_ret := replace(l_ret, '<BREAKROW>1</BREAKROW>','');
    end if;

    if instr(l_ret, '<BREAKROW>2</BREAKROW>') > 0
    then
  	  l_breakrow := 2;
      l_ret := replace(l_ret, '<BREAKROW>2</BREAKROW>','');
    end if;

    l_startHighlights := instr(l_ret, '<REGION_HIGHLIGHTS>');
    l_endHighlights := instr(l_ret, '</REGION_HIGHLIGHTS>', l_startHighlights);

    if nvl(l_startHighlights, 0) > 0 and nvl(l_endHighlights, 0) > 0 then
      l_startHighlights := l_startHighlights + length('<REGION_HIGHLIGHTS>');
      --pak_xslt_log.WriteLog('l_row before highlights: '||l_row, p_procedure => 'ConvertXml');

      l_Highlights := substr(l_ret, l_startHighlights, l_endHighlights-l_startHighlights);
      --pak_xslt_log.WriteLog('l_Highlights '||l_Highlights, p_procedure => 'ConvertXml');
      l_Highlights := replace(l_Highlights,'&quot;','"');
      --for each col calculate and insert values l_reportTypes(l_column).highlight_bkg_color, highlight_font_color
      l_reportTypes := HighlightsToCols(l_reportTypes, l_Highlights);
    end if;

    l_reportTypes := ExcelVal(l_ret, l_reportTypes, p_filename, l_breakrow);

     pak_xslt_log.WriteLog(
      'l_reportTypes po ExcelVal: '||LogColType(l_reportTypes),
      p_procedure => 'xmlConvertRow'
    );

    l_ret := '<ROW'|| case when l_reportTypes(1).breakrow is not null then ' breakrow="'||l_reportTypes(1).breakrow||'"' else '' end || '>';
    for i in l_reportTypes.first..l_reportTypes.last loop
        l_column := l_reportTypes(i).colname;
        /*
        if instr(l_column, '_x') > 0 then
          l_column := ReplaceWith_x005F_(l_column);
        end if;
        */
       l_reportTypes(i).breakrow := l_breakrow;
       l_ret := l_ret||chr(10)
                             ||'<'||l_column||' TYPE="'||l_reportTypes(i).coltype||'"'
                             ||case when l_reportTypes(i).formatmask is not null then ' FORMAT_MASK="'||l_reportTypes(i).formatmask||'"' else '' end
                             ||case when l_reportTypes(i).columnwidth is not null then ' COLUMN_WIDTH="'||l_reportTypes(i).columnwidth||'"' else '' end
                             ||case when l_reportTypes(i).fullname is not null then ' FULL_NAME="'||l_reportTypes(i).fullname||'"' else '' end
                             ||case when l_reportTypes(i).position is not null then ' position="'||l_reportTypes(i).position||'"' else '' end
                             ||case when l_reportTypes(i).excelcol is not null then ' excelcol="'||l_reportTypes(i).excelcol||'"' else '' end
                             ||case when l_reportTypes(i).aggregate is not null then ' aggr_function="'||l_reportTypes(i).aggregate||'"' else '' end
                             ||case when l_reportTypes(i).formula is not null then ' formula="'||l_reportTypes(i).formula||'"' else '' end
                             ||case when l_reportTypes(i).highlight_name is not null then ' highlight_name="'||l_reportTypes(i).highlight_name||'"' else '' end
                             ||case when l_reportTypes(i).highlight_bkg_color is not null then ' highlight_bkg_color="'||l_reportTypes(i).highlight_bkg_color||'"' else '' end
                             ||case when l_reportTypes(i).highlight_font_color is not null then ' highlight_font_color="'||l_reportTypes(i).highlight_font_color||'"' else '' end
                             ||case when l_reportTypes(i).highlight_bkg_color is not null then ' text_highlight_color="'||findWordColor(l_reportTypes(i).highlight_bkg_color)||'"' else '' end
                             ||case when l_reportTypes(i).excelval is not null then ' excelval="'||l_reportTypes(i).excelval||'"' else '' end
                             ||case when l_reportTypes(i).break_on_col > 0 then ' break_on_col="'||l_reportTypes(i).break_on_col||'"' else '' end
                             ||case when l_reportTypes(i).breakrow is not null then ' breakrow="'||l_reportTypes(i).breakrow||'"' else '' end
                             ||case when l_reportTypes(i).format is not null then ' format="'||l_reportTypes(i).format||'"' else '' end
                             ||case when l_reportTypes(i).ps_format is not null then ' ps_format="'||l_reportTypes(i).ps_format||'"' else '' end
                             ||case when l_reportTypes(i).value is not null then '>'||l_reportTypes(i).value||'</'||l_column||'>' else '/>' end;
    end loop;
    l_ret := l_ret||chr(10)||'</ROW>';

  --Delete elements REGION_AGGREGATES and REGION_HIGHLIGHTS data is already in attributes
  l_ret := xmlRemoveElement(l_ret, 'REGION_AGGREGATES');
  l_ret := xmlRemoveElement(l_ret, 'REGION_HIGHLIGHTS');
  /*
  pak_xslt_log.WriteLog(
      'xmlConvertRow finished. size: '||length(l_ret),
      p_procedure => 'xmlConvertRow',
      p_start_time => l_start_time
  );
  */
  return l_ret;
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'xmlConvertRow',
      p_sqlerrm => sqlerrm
    );
    raise;
end xmlConvertRow;

procedure xmlConvertRowset(
  pio_rowset in out CLOB,
  p_filename varchar2,
  p_regionAttrs varchar2,
  pio_reportTypes in out t_coltype_table
)
as
l_temp clob;
l_row VARCHAR2(32000);
l_row_clob CLOB;
l_startrow NUMBER := 1;
l_endrow NUMBER;
begin
    pak_xslt_log.WriteLog(
      'Start p_filename: '||p_filename||' p_regionAttrs: '||p_regionAttrs,
      p_procedure => 'xmlConvertRowset'
    );

  pio_rowset := replace(pio_rowset, '<REGION_AGGREGATES/>','');
  pio_rowset := replace(pio_rowset, '<REGION_HIGHLIGHTS/>','');
  pio_rowset := replace(pio_rowset, '<BREAKROW/>','');

  --set l_reportTypes:= pi_reportTypes for not null columns;
  for l_column in pio_reportTypes.first..pio_reportTypes.last loop
      if BreakOnCol(pio_reportTypes(l_column).colname, p_regionAttrs) then
           pio_reportTypes(l_column).break_on_col := 1;
      end if;
  end loop;

  dbms_lob.createtemporary(l_temp, false);
  l_temp := '<ROWSET '||p_regionAttrs||'>';
  pak_xslt_log.WriteLog(
      'pio_rowset (first 200 chars): '||substr(pio_rowset, 1, 200),
      p_procedure => 'xmlConvertRowset'
  );
  loop --row by row
    l_startRow := instr(pio_rowset, '<ROW>', l_startRow);
    exit when nvl(l_startRow, 0)=0;
    l_endRow := instr(pio_rowset, '</ROW>', l_startRow);
    exit when nvl(l_endRow, 0) = 0;
    l_endRow := l_endRow + length('</ROW>');
    l_row := substr(pio_rowset, l_startRow, l_endRow - l_startRow);  --row is extracted

    pak_xslt_log.WriteLog(
      'Extracted l_row : '||l_row,
      p_procedure => 'xmlConvertRowset'
    );

    l_row := xmlConvertRow(l_row, p_filename, p_regionAttrs, pio_reportTypes);
    l_row_clob := chr(10)||l_row;
    l_temp := l_temp || l_row_clob;
    l_startRow := l_endRow;
  end loop;
  l_temp := l_temp ||chr(10)||'</ROWSET>';
  pio_rowset := l_temp;
  dbms_lob.freetemporary(l_temp);
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'xmlConvertRowset',
      p_sqlerrm => sqlerrm
    );
    raise;
end xmlConvertRowset;


/** Delete null elements REGION_AGGREGATES and REGION_HIGHLIGHTS and then replace
* not null elements REGION_AGGREGATES and REGION_HIGHLIGHTS to attributes in XML pio_clob.
*
* @param pio_clob XML to convert
*/
PROCEDURE xmlConvert(
  pio_clob        IN OUT NOCOPY CLOB,
  p_filename      IN VARCHAR2,
  pi_regionAttrs  in Query2Report.tab_string,
  pi_reportTypes  IN OUT Query2Report.t_coltype_tables
)
as
c_amount constant number := 20000;

l_start_rowset number default 1;
l_end_rowset number default 0;
l_start_time PLS_INTEGER := dbms_utility.get_time();
l_rowset clob;
l_temp clob;
i number := 1;




begin
  pak_xslt_log.WriteLog(
        ' pio_clob (first 200 chars) '||substr(pio_clob,1,200),
        p_procedure => 'xmlConvert');

    dbms_lob.createtemporary(l_temp, false);
    l_temp := '<?xml version="1.0" encoding="utf-8"?>'||chr(10)||'<DOCUMENT>';
    loop
        l_start_rowset := instr(pio_clob, '<ROWSET>', l_start_rowset);
        exit when nvl(l_start_rowset, 0) = 0;
        l_end_rowset := instr(pio_clob, '</ROWSET>', l_start_rowset);
        exit when nvl(l_end_rowset, 0) = 0;
        l_end_rowset := l_end_rowset + length('</ROWSET>');
        --l_rowset_intervals.extend;
        --l_rowset_intervals(l_rowset_intervals.count) := rowset_interval(l_start_rowset, l_end_rowset);
        l_rowset := substr(pio_clob, l_start_rowset, l_end_rowset - l_start_rowset);
        xmlConvertRowset(l_rowset, p_filename, pi_regionAttrs(i), pi_reportTypes(i));
        l_start_rowset := l_end_rowset;
        l_temp := l_temp||chr(10)||l_rowset;
        i := i +1;
    end loop;
    l_temp := l_temp||chr(10)||'</DOCUMENT>';
    pio_clob := l_temp;

    dbms_lob.freetemporary(l_temp);

    pak_xslt_log.WriteLog(
      'xmlConvert (CLOB) finished. ',
      p_procedure => 'xmlConvert',
      p_start_time => l_start_time
    );
exception
    when others then
    pak_xslt_log.WriteLog(
      'Error',
      p_log_type => pak_xslt_log.g_error,
      p_procedure => 'xmlConvert',
      p_sqlerrm => sqlerrm
    );
    raise;
end xmlConvert;


end PAK_XML_CONVERT;
/
