/* REXX - Screen Generator for COBOL                                 */
/* Author: Simon Sulser                                              */
/* Versions:                                                         */
/* 0.1 - 06. Oktober 2025: first try                                 */

signal on novalue name novalue

parse arg filename .

if filename = '' then
do
    parse source . . prgname
    prgname = substr(prgname, lastpos("/",prgname)+1)
    say 'USAGE:' prgname '<filename>'
    exit 8
end

x_count = 0
y_count = 0
report_literal = "        01  GENERATED-SCR BLANK SCREEN."
report_literal_len = length(report_literal)
line_literal =   "            03 FILLER PIC X"
line_literal_len = length(line_literal)
remaining_width = 72 - line_literal_len - 9          /* 8 characters for (03) "". */

output_file = left(filename, lastpos('.',filename)-1) || ".scr"
output_line = report_literal
call lineout output_file, output_line, 1

do while lines(filename)
    output_line = ''
    actual_line = linein(filename)
    do while length(actual_line) > 0
        if length(actual_line) > remaining_width then
        do
            output_line = line_literal || "(" || remaining_width || ") " || '"' || substr(actual_line,1,remaining_width) || '".'
            actual_line = substr(actual_line, remaining_width + 1)
        end
        else
        do
            output_line = line_literal || "(" || length(actual_line) || ") " || '"' || actual_line || '".'
            actual_line = ''
        end
        call lineout output_file, output_line
    end
end

call lineout output_file,

exit 0

novalue:
    say condition('D') "on line" sigl "not defined."
    exit 16
