function writecell(C, filename, varargin)
%WRITECELL Write a cell array to a file.
%
%   WRITECELL(C) writes the cell array C to a comma-delimited text file.
%   The file name is the workspace name of the cell array C, appended with
%   ".txt".
%   If WRITECELL cannot construct the file name from the homogenous array
%   input, it writes to the file "cell.txt".
%
%   WRITECELL overwrites any existing file unless the "WriteMode" name-value
%   pair is provided as input.
%
%   WRITECELL(C, FILENAME) writes the cell array C to the file FILENAME as
%   column-oriented data. WRITECELL determines the file format from its
%   extension. The extension must be one of those listed below.
%
%   FILENAME can be one of these:
%
%       - For local files, FILENAME can contain an absolute file name with a
%         file extension. FILENAME can also be a relative path to the current
%         folder, or to a folder on the MATLAB path.
%         For example, to export to a file in the current folder:
%
%            writecell(C, "microscopy.txt");
%
%       - For remote files, FILENAME must be a full path specified as a
%         uniform resource locator (URL). For example, to export a remote
%         file to Amazon S3, specify the full URL for the file:
%
%            writecell(C, "s3://bucketname/path_to_file/microscopy.txt");
%
%         For more information on accessing remote data, see "Work with
%         Remote Data" in the documentation.
%
%   WRITECELL(C, FILENAME, "FileType", FILETYPE) specifies the file type,
%   where FILETYPE is one of "text" or "spreadsheet".
%
%   WRITECELL writes data to different file types as follows:
%
%   Delimited text files:
%   ---------------------
%
%   The following extensions are recognized: .txt, .dat, .csv, .log,
%                                            .text, .dlm
%
%   WRITECELL creates a column-oriented text file, i.e., each column of each
%   variable in C is written out as a column in the file.
%
%   Use the following optional parameter name/value pairs to control how data
%   are written to a delimited text file:
%
%   "Delimiter"    - The delimiter used in the file. Can be any of " ", "\t",
%                    ",", ";", "|" or their corresponding names "space", "tab",
%                    "comma", "semi", or "bar". Default is ",".
%
%   "QuoteStrings" - A logical value that specifies whether to write
%                    text out enclosed in double quotes ("..."). If
%                    "QuoteStrings" is true, any double quote characters that
%                    appear as part of a text variable are replaced by two
%                    double quote characters.
%
%   "DateLocale"   - The locale that WRITECELL uses to create month and day names
%                    when writing datetimes to the file. LOCALE must be a character
%                    vector or scalar string in the form xx_YY.
%                    See the documentation for DATETIME for more information.
%
%   "Encoding"     - The encoding to use when creating the file.
%                    Default is "UTF-8".
%
%   "WriteMode"    - Append to an existing file or overwrite an
%                    existing file.
%                    - "overwrite" - Overwrite the file, if it
%                                    exists. This is the default option.
%                    - "append"    - Append to the bottom of the file,
%                                    if it exists.
%
%   Spreadsheet files:
%   ------------------
%
%   The following extensions are recognized: .xls, .xlsx, .xlsb, .xlsm,
%                                            .xltx, .xltm
%
%   WRITECELL creates a column-oriented spreadsheet file, i.e., each column
%   of each variable in C is written out as a column in the file.
%
%   Use the following optional parameter name/value pairs to control how data
%   are written to a spreadsheet file:
%
%   "DateLocale"     - The locale that writecell uses to create month and day
%                      names when writing datetimes to the file. LOCALE must be
%                      a character vector or scalar string in the form xx_YY.
%                      Note: The "DateLocale" parameter value is ignored
%                      whenever dates can be written as Excel-formatted dates.
%
%   "Sheet"          - The sheet to write, specified the worksheet name, or a
%                      positive integer indicating the worksheet index.
%
%   "Range"          - A character vector or scalar string that specifies a
%                      rectangular portion of the worksheet to write, using the
%                      Excel A1 reference style.
%
%   "UseExcel"       - A logical value that specifies whether or not to create the
%                      spreadsheet file using Microsoft(R) Excel(R) for Windows(R).
%                      Set "UseExcel" to one of these values:
%                      - false -  Does not open an instance of Microsoft Excel
%                                 to write the file. This is the default setting.
%                                 This setting may cause the data to be
%                                 written differently for files with
%                                 live updates (e.g. formula evaluation or plugins).
%                      - true  -  Opens an instance of Microsoft Excel to write 
%                                 the file on a Windows system with Excel installed.
%
%   "WriteMode"      - Perform an in-place write, append to an existing
%                      file or sheet, overwrite an existing file or
%                      sheet.
%                      - "inplace"        - In-place replacement of
%                                           the data in the sheet.
%                                           This is the default
%                                           option.
%                      - "overwritesheet" - If sheet exists,
%                                           overwrite contents of sheet.
%                      - "replacefile"    - Create a new file. Prior
%                                           contents of the file and 
%                                           all the sheets are removed.
%                      - "append"         - Append to the bottom of
%                                           the occupied range within
%                                           the sheet.
%
%   "AutoFitWidth"   - A logical value that specifies whether or not to change
%                      column width to automatically fit the contents. Defaults to true.
%
%   "PreserveFormat" - A logical value that specifies whether or not to preserve
%                      existing cell formatting. Defaults to true.
%
%   In some cases, WRITECELL creates a file that does not represent C
%   exactly, as described below. If you use READCELL(FILENAME) to read that
%   file back in and create a new cell array, the result may not have exactly
%   the same format or contents as the original cell array.
%
%   *  WRITECELL writes out numeric data using long g format, and
%      categorical or character data as unquoted text.
%   *  WRITECELL writes out cell arrays that have more than two dimensions as two
%      dimensional cell array, with trailing dimensions collapsed.
%
%   See also READCELL, READTABLE, READMATRIX, WRITETABLE, WRITEMATRIX

%   Copyright 2018-2020 The MathWorks, Inc.

import matlab.io.internal.utility.suggestWriteFunctionCorrection
import matlab.io.internal.validators.validateSupportedWriteCellType
import matlab.io.internal.validators.validateWriteFunctionArgumentOrder

validateSupportedWriteCellType(C);

if nargin < 2
    cellname = inputname(1);
    if isempty(cellname)
        cellname = 'cell';
    end
    filename = [cellname '.txt'];
else
    for i = 1:2:numel(varargin)
        n = strlength(varargin{i});
        if n > 5 && strncmpi(varargin{i},'WriteVariableNames',n)
            error(message('MATLAB:table:write:WriteVariableNamesNotSupported','WRITECELL'));
        end
        if n > 5 && strncmpi(varargin{i},'WriteRowNames',n)
            error(message('MATLAB:table:write:WriteRowNamesNotSupported','WRITECELL'));
        end
    end
end

validateWriteFunctionArgumentOrder(C, filename, "writecell", "cell", @iscell);

if ~iscell(C)
    suggestWriteFunctionCorrection(C, "writecell");
end

% Error if odd number of arguments.
if nargin > 2 && mod(nargin, 2) ~= 0
    error(message("MATLAB:table:write:NoFileNameWithParams"));
end

% writecell does not support writing to XML files.
supportedFileTypes = "'text', 'spreadsheet'";
fileType = matlab.io.xml.internal.write.errorIfXML(filename, supportedFileTypes, varargin{:});

try
    T = table(C);
    writetable(T,filename,'WriteVariableNames', false, 'WriteRowNames', false, varargin{:});
catch ME
    if ME.identifier == "MATLAB:table:write:UnrecognizedFileType"
        error(message("MATLAB:table:write:SupportedFileTypes", fileType, supportedFileTypes));
    else
        throw(ME);
    end
end

end
