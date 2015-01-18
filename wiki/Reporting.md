## Printing Full and Summary Reports
Both the full and summary reports can additionally show information about the source of errors and warnings. Source codes can be used with the `--sniffs` command line argument to only show messages from a specified list of sources. To include source codes in the report, use the `-s` command line argument.

    $ phpcs -s /path/to/code/myfile.php
    
    FILE: /path/to/code/myfile.php
    --------------------------------------------------------------------------------
    FOUND 5 ERROR(S) AND 1 WARNING(S) AFFECTING 5 LINE(S)
    --------------------------------------------------------------------------------
      2 | ERROR   | Missing file doc comment (PEAR.Commenting.FileComment)
     20 | ERROR   | PHP keywords must be lowercase; expected "false" but found
        |         | "FALSE" (Generic.PHP.LowerCaseConstant)
     47 | ERROR   | Line not indented correctly; expected 4 spaces but found 1
        |         | (PEAR.WhiteSpace.ScopeIndent)
     47 | WARNING | Equals sign not aligned with surrounding assignments
        |         | (Generic.Formatting.MultipleStatementAlignment)
     51 | ERROR   | Missing function doc comment
        |         | (PEAR.Commenting.FunctionComment)
     88 | ERROR   | Line not indented correctly; expected 9 spaces but found 6
        |         | (PEAR.WhiteSpace.ScopeIndent)
    --------------------------------------------------------------------------------

    $ phpcs -s --report=summary /path/to/code
    
    PHP CODE SNIFFER REPORT SUMMARY
    --------------------------------------------------------------------------------
    FILE                                                            ERRORS  WARNINGS
    --------------------------------------------------------------------------------
    /path/to/code/myfile.inc                                        5       0
    /path/to/code/yourfile.inc                                      1       1
    /path/to/code/ourfile.inc                                       0       2
    --------------------------------------------------------------------------------
    A TOTAL OF 6 ERROR(S) AND 3 WARNING(S) WERE FOUND IN 3 FILE(S)
    --------------------------------------------------------------------------------
    
    
    PHP CODE SNIFFER VIOLATION SOURCE SUMMARY
    --------------------------------------------------------------------------------
    SOURCE                                                                     COUNT
    --------------------------------------------------------------------------------
    PEAR.WhiteSpace.ScopeIndent                                                3
    PEAR.Commenting.FileComment                                                2
    Generic.PHP.LowerCaseConstant                                              2
    Generic.Formatting.MultipleStatementAlignment                              1
    PEAR.Commenting.FunctionComment                                            1
    --------------------------------------------------------------------------------
    A TOTAL OF 9 SNIFF VIOLATION(S) WERE FOUND IN 5 SOURCE(S)
    --------------------------------------------------------------------------------

## Printing a Source Report
PHP_CodeSniffer can output a summary report showing you the most common errors detected in your files so you can target specific parts of your coding standard for improvement. To print a source report, use the `--report=source` command line argument. The output will look like this:

    $ phpcs --report=source /path/to/code
    
    PHP CODE SNIFFER VIOLATION SOURCE SUMMARY
    --------------------------------------------------------------------------------
    STANDARD    CATEGORY            SNIFF                                      COUNT
    --------------------------------------------------------------------------------
    Generic     PHP                 Lower case constant                        4
    PEAR        White space         Scope indent                               3
    PEAR        Commenting          File comment                               1
    --------------------------------------------------------------------------------
    A TOTAL OF 8 SNIFF VIOLATION(S) WERE FOUND IN 3 SOURCE(S)
    --------------------------------------------------------------------------------

To show source codes instead of friendly names, use the `-s` command line argument.

    $ phpcs -s --report=source /path/to/code
    
    PHP CODE SNIFFER VIOLATION SOURCE SUMMARY
    --------------------------------------------------------------------------------
    SOURCE                                                                     COUNT
    --------------------------------------------------------------------------------
    Generic.PHP.LowerCaseConstant                                              4
    PEAR.WhiteSpace.ScopeIndent                                                3
    PEAR.Commenting.FileComment                                                1
    --------------------------------------------------------------------------------
    A TOTAL OF 8 SNIFF VIOLATION(S) WERE FOUND IN 3 SOURCE(S)
    --------------------------------------------------------------------------------

## Printing an Information Report
PHP_CodeSniffer can output an information report to show you how your code is written rather than checking that it conforms to a standard. This report will use one or more standards you pass to it and then use the sniffs within those standards to inspect your code. Sniffs must be written to support recording metrics for this feature, so not all sniffs will report back information. To print an information report, use the `--report=info` command line argument. The output will look like this:

    $ phpcs --report=info /path/to/code
    
    PHP CODE SNIFFER INFORMATION REPORT
    --------------------------------------------------------------------------------
    Class has doc comment: yes [10/10, 100%]

    Class opening brace placement: new line [10/10, 100%]

    Constant name case: upper [81/81, 100%]

    Control structure defined inline: no [863/863, 100%]

    EOL char: \n [10/10, 100%]

    File has doc comment: yes [10/10, 100%]

    Function has doc comment: yes [130/130, 100%]

    Function opening brace placement: new line [111/111, 100%]

    Inline comment style: // ... [585/594, 98.48%]
        /* ... */ => 9 (1.52%)

    Line indent: spaces [5099/5099, 100%]

    Line length: 80 or less [6723/7134, 94.24%]
        81-120 => 397 (5.56%)
        121-150 => 10 (0.14%)
        151 or more => 4 (0.06%)

    PHP constant case: lower [684/684, 100%]

    PHP short open tag used: no [10/10, 100%]

    Private method prefixed with underscore: yes [11/11, 100%]

    --------------------------------------------------------------------------------

When more than one variation is found for a particular coding convention, the most common variation is printed on the first line and the other variations that were found are indented on subsequent lines. Each convention is followed by a number and each variation followed by a percentage, indicating the number of times the convention was checked and the percentage of code using each variation.

In the example above, the `Inline comment style` convention was checked 594 times, indicating that 594 inline comments were found and checked. 585 of them (98.48%) used the `// ...` style variation and 9 of them (1.52%) used the `/* ... */` style variation.

> **Tip:** To check your code against a wide range of conventions, specify all included standards. This will take longer, but give you more information about your code: `phpcs --standard=Generic,PEAR,Squiz,PSR2,Zend --report=info /path/to/code`

## Printing an XML Report
PHP_CodeSniffer can output an XML report to allow you to parse the output easily and use the results in your own scripts. To print an XML report, use the `--report=xml` command line argument. The output will look like this:

    $ phpcs --report=xml /path/to/code
    
    <?xml version="1.0" encoding="UTF-8"?>
    <phpcs version="1.0.0">
     <file name="/path/to/code/myfile.php" errors="4" warnings="1">
      <error line="2" column="1" source="PEAR.Commenting.FileComment" severity="5">Missing file doc comment</error>
      <error line="20" column="43" source="Generic.PHP.LowerCaseConstant" severity="5">PHP keywords must be lowercase; expected &quot;false&quot; but found &quot;FALSE&quot;</error>
      <error line="47" column="1" source="PEAR.WhiteSpace.ScopeIndent" severity="5">Line not indented correctly; expected 4 spaces but found 1</error>
      <warning line="47" column="20" source="Generic.Formatting.MultipleStatementAlignment" severity="5">Equals sign not aligned with surrounding assignments</warning>
      <error line="51" column="4" source="PEAR.Commenting.FunctionComment" severity="5">Missing function doc comment</error>
     </file>
    </phpcs>

## Printing a Checkstyle Report
PHP_CodeSniffer can output an XML report similar to the one produced by Checkstyle, allowing you to use the output in scripts and applications that already support Checkstyle. To print a Checkstyle report, use the `--report=checkstyle` command line argument. The output will look like this:

    $ phpcs --report=checkstyle /path/to/code
    
    <?xml version="1.0" encoding="UTF-8"?>
    <checkstyle version="1.0.0">
     <file name="/path/to/code/myfile.php">
      <error line="2" column="1" severity="error" message="Missing file doc comment" source="PEAR.Commenting.FileComment"/>
      <error line="20" column="43" severity="error" message="PHP keywords must be lowercase; expected &quot;false&quot; but found &quot;FALSE&quot;" source="Generic.PHP.LowerCaseConstant"/>
      <error line="47" column="1" severity="error" message="Line not indented correctly; expected 4 spaces but found 1" source="PEAR.WhiteSpace.ScopeIndent"/>
      <error line="47" column="20" severity="warning" message="Equals sign not aligned with surrounding assignments" source="Generic.Formatting.MultipleStatementAlignment"/>
      <error line="51" column="4" severity="error" message="Missing function doc comment" source="PEAR.Commenting.FunctionComment"/>
     </file>
    </checkstyle>

## Printing a CSV Report
PHP_CodeSniffer can output a CSV report to allow you to parse the output easily and use the results in your own scripts. To print a CSV report, use the `--report=csv` command line argument. The output will look like this:

    $ phpcs --report=csv /path/to/code
    
    File,Line,Column,Type,Message,Source,Severity
    "/path/to/code/myfile.php",2,1,error,"Missing file doc comment",PEAR.Commenting.FileComment,5
    "/path/to/code/myfile.php",20,43,error,"PHP keywords must be lowercase; expected \"false\" but found \"FALSE\"",Generic.PHP.LowerCaseConstant,5
    "/path/to/code/myfile.php",47,1,error,"Line not indented correctly; expected 4 spaces but found 1",PEAR.WhiteSpace.ScopeIndent,5
    "/path/to/code/myfile.php",47,20,warning,"Equals sign not aligned with surrounding assignments",Generic.Formatting.MultipleStatementAlignment,5
    "/path/to/code/myfile.php",51,4,error,"Missing function doc comment",PEAR.Commenting.FunctionComment,5

**Note:** The first row of the CSV output defines the order of information. When using the CSV output, please parse this header row to determine the order correctly as the format may change over time or new information may be added.

## Printing an Emacs Report
PHP_CodeSniffer can output a report in a format the compiler built into the GNU Emacs text editor can understand. This lets you use the built-in complier to run PHP_CodeSniffer on a file you are editing and navigate between errors and warnings within the file. To print an Emacs report, use the `--report=emacs` command line argument. The output will look like this:

    $ phpcs --report=emacs /path/to/code
    
    /path/to/code/myfile.php:2:1: error - Missing file doc comment
    /path/to/code/myfile.php:20:43: error - PHP keywords must be lowercase; expected "false" but found "FALSE"
    /path/to/code/myfile.php:47:1: error - Line not indented correctly; expected 4 spaces but found 1
    /path/to/code/myfile.php:47:20: warning - Equals sign not aligned with surrounding assignments
    /path/to/code/myfile.php:51:4: error - Missing function doc comment

To use PHP_CodeSniffer with Emacs, make sure you have installed PHP mode for Emacs. Then put the following into your .emacs file, changing PHP_CodeSniffer options as required.

    (require 'compile)
    (defun my-php-hook-function ()
     (set (make-local-variable 'compile-command) (format "phpcs --report=emacs --standard=PEAR %s" (buffer-file-name))))
    (add-hook 'php-mode-hook 'my-php-hook-function)

Now you can use the compile command and associated shortcuts to move between error messages within your file.

## Printing an SVN Blame Report
PHP_CodeSniffer can make use of the svn blame command to try and determine who committed each error and warning to an SVN respository. To print an SVN Blame report, use the `--report=svnblame` command line argument. The output will look like this:

    $ phpcs --report=svnblame /path/to/code
    
    PHP CODE SNIFFER SVN BLAME SUMMARY
    --------------------------------------------------------------------------------
    AUTHOR                                                              COUNT (%)
    --------------------------------------------------------------------------------
    jsmith                                                              51 (40.8)
    jblogs                                                              44 (30)
    pdeveloper                                                          43 (10.33)
    jscript                                                             27 (19.84)
    --------------------------------------------------------------------------------
    A TOTAL OF 165 SNIFF VIOLATION(S) WERE COMMITTED BY 4 AUTHOR(S)
    --------------------------------------------------------------------------------

Each author is listed with the number of violations they committed and the percentage of error lines to clean lines. The example report above shows that the developer pdeveloper has 43 violations but they only make up 10% of all code they have committed, while jblogs has 44 violations but they make up 30% of all their committed code. So these developers have about the same number of total violations, but pdeveloper seems to be doing a better job of conforming to the coding standard.

To show a breakdown of the types of violations each author is committing, use the `-s` command line argument.

    $ phpcs -s --report=svnblame /path/to/code
    
    PHP CODE SNIFFER SVN BLAME SUMMARY
    --------------------------------------------------------------------------------
    AUTHOR   SOURCE                                                     COUNT (%)
    --------------------------------------------------------------------------------
    jsmith                                                              51 (40.8)
             Squiz.Files.LineLength                                     47
             PEAR.Functions.FunctionCallSignature                       4
    jblogs                                                              44 (30)
             Squiz.Files.LineLength                                     40
             Generic.CodeAnalysis.UnusedFunctionParameter               2
             Squiz.CodeAnalysis.EmptyStatement                          1
             Squiz.Formatting.MultipleStatementAlignment                1
    --------------------------------------------------------------------------------
    A TOTAL OF 95 SNIFF VIOLATION(S) WERE COMMITTED BY 2 AUTHOR(S)
    --------------------------------------------------------------------------------

To include authors with no violations, and perhaps shower them with praise, use the `-v` command line argument.

    $ phpcs -v --report=svnblame /path/to/code
    
    PHP CODE SNIFFER SVN BLAME SUMMARY
    --------------------------------------------------------------------------------
    AUTHOR                                                              COUNT (%)
    --------------------------------------------------------------------------------
    jsmith                                                              51 (40.8)
    jblogs                                                              44 (30)
    pdeveloper                                                          43 (10.33)
    jscript                                                             27 (19.84)
    toogood                                                             0 (0)
    --------------------------------------------------------------------------------
    A TOTAL OF 165 SNIFF VIOLATION(S) WERE COMMITTED BY 5 AUTHOR(S)
    --------------------------------------------------------------------------------

**Note:** You need to make sure the location of the `svn` command is in your path and that SVN is storing a username and password (if required by your repository). If the command is not in your path, the report will fail to generate. If SVN does not have a username and password stored, you'll need to enter it for each file being checked by PHP_CodeSniffer that contains violations.

## Printing a Git Blame Report
Like the SVN Blame report, PHP_CodeSniffer can make use of the git blame command to try and determine who committed each error and warning to a Git respository. To print a Git Blame report, use the `--report=gitblame` command line argument. The output and options are the same as those described in the SVN Blame report above.

**Note:** You need to make sure the location of the `git` command is in your path. If the command is not in your path, the report will fail to generate.

## Printing Multiple Reports
PHP_CodeSniffer can print any combination of the above reports to either the screen or to separate files. To print multiple reports, use the `--report-[type]` command line argument instead of the standard `--report=[type]` format. You can then specify multiple reports using multiple arguments. The reports will be printed to the screen in the order you specify them on the command line.

The following command will write both a full and summary report to the screen

    $ phpcs --report-full --report-summary /path/to/code

You can write the reports to separate files by specifying the path to the output file after each report argument.

    $ phpcs --report-full=/path/to/full.txt --report-summary=/path/to/summary.txt /path/to/code

You can print some reports to the screen and other reports to files. The following command will write the full report to a file and a summary report to the screen.

    $ phpcs --report-full=/path/to/full.txt --report-summary /path/to/code

## Running Interactively
Instead of producing a single report at the end of a run, PHP_CodeSniffer can run interactively and show reports for files one at a time. When using the interactive mode, PHP_CodeSniffer will show a report for the first file it finds an error or warning in. It will then pause and wait for user input. Once you have corrected the errors, you can press `ENTER` to have PHP_CodeSniffer recheck your file and continue if the file is now free of errors. You can also choose to skip the file and move to the next file with errors.

To run PHP_CodeSniffer interactively, use the `-a` command line argument.

    $ phpcs -a /path/to/code
    
    FILE: /path/to/code/myfile.php
    --------------------------------------------------------------------------------
    FOUND 5 ERROR(S) AND 1 WARNING(S) AFFECTING 5 LINE(S)
    --------------------------------------------------------------------------------
      2 | ERROR   | Missing file doc comment
     20 | ERROR   | PHP keywords must be lowercase; expected "false" but found
        |         | "FALSE"
     47 | ERROR   | Line not indented correctly; expected 4 spaces but found 1
     47 | WARNING | Equals sign not aligned with surrounding assignments
     51 | ERROR   | Missing function doc comment
     88 | ERROR   | Line not indented correctly; expected 9 spaces but found 6
    --------------------------------------------------------------------------------
    
    <ENTER> to recheck, [s] to skip or [q] to quit :

**Note:** PHP_CodeSniffer will always print the full error report for a file when running in interactive mode. Any report types you specify on the command line will be ignored.

## Specifying a Report Width
By default, PHP_CodeSniffer will print all screen-based reports 80 characters wide. File paths will be truncated if they don't fit within this limit and error messages will be wrapped across multiple lines. You can increase the report width to show longer file paths and limit the wrapping of error messages using the `--report-width` command line argument.

    $ phpcs --report-width=120 --report=summary /path/to/code/myfile.php

> Note: If you want reports to fill the entire terminal width (in supported terminals), set the `--report-width` command line argument to `auto`.
>
>    $ phpcs --report-width=auto --report=summary /path/to/code/myfile.php

## Writing a Report to a File
PHP_CodeSniffer always prints the specified report to the screen, but it can also be told to write a copy of the report to a file. When writing to a file, all internal parsing errors and verbose output PHP_CodeSniffer produces will not be included in the file. This feature is particularly useful when using report types such as XML and CSV that are often parsed by scripts or used with continuous integration software.

To write a copy of a report to a file, use the `--report-file` command line argument.

    $ phpcs --report=xml --report-file=/path/to/file.xml /path/to/code

**Note:** The report will not be written to the screen when using this option. If you still want to view the report, use the -v command line argument to print verbose output.