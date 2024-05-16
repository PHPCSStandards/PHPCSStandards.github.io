## Table of contents
  * [Getting Help from the Command Line](#getting-help-from-the-command-line)
  * [Checking Files and Folders](#checking-files-and-folders)
  * [Printing a Summary Report](#printing-a-summary-report)
  * [Printing Progress Information](#printing-progress-information)
  * [Specifying a Coding Standard](#specifying-a-coding-standard)
  * [Printing a List of Installed Coding Standards](#printing-a-list-of-installed-coding-standards)
  * [Listing Sniffs Inside a Coding Standard](#listing-sniffs-inside-a-coding-standard)

***

## Getting Help from the Command Line

Running PHP_CodeSniffer with the `-h` or `--help` command line arguments will print a list of commands that PHP_CodeSniffer will respond to. The output of `phpcs -h` is shown below.

```
Usage:
  phpcs [options] <file|directory>

Scan targets:
  <file|directory>               One or more files and/or directories to check, space separated.
  -                              Check STDIN instead of local files and directories.
  --stdin-path=<stdinPath>       If processing STDIN, the file path that STDIN will be processed as.
  --file-list=<fileList>         Check the files and/or directories which are defined in the file to which the
                                 path is provided (one per line).
  --filter=<filter>              Check based on a predefined file filter. Use either the "GitModified" or
                                 "GitStaged" filter, or specify the path to a custom filter class.
  --ignore=<patterns>            Ignore files based on a comma-separated list of patterns matching files
                                 and/or directories.
  --extensions=<extensions>      Check files with the specified file extensions (comma-separated list).
                                 Defaults to php,inc/php,js,css.
                                 The type of the file can be specified using: ext/type; e.g. module/php,es/js.
  -l                             Check local directory only, no recursion.

Rule Selection Options:
  --standard=<standard>          The name of, or the path to, the coding standard to use. Can be a
                                 comma-separated list specifying multiple standards. If no standard is
                                 specified, PHP_CodeSniffer will look for a [.]phpcs.xml[.dist] custom ruleset
                                 file in the current directory and those above it.
  --sniffs=<sniffs>              A comma-separated list of sniff codes to limit the scan to. All sniffs must
                                 be part of the standard in use.
  --exclude=<sniffs>             A comma-separated list of sniff codes to exclude from the scan. All sniffs
                                 must be part of the standard in use.

  -i                             Show a list of installed coding standards.
  -e                             Explain a standard by showing the names of all the sniffs it includes.
  --generator=<generator>        Show documentation for a standard. Use either the "HTML", "Markdown" or
                                 "Text" generator.

Run Options:
  -a                             Run in interactive mode, pausing after each file.
  --bootstrap=<bootstrap>        Run the specified file(s) before processing begins. A list of files can be
                                 provided, separated by commas.
  --cache[=<cacheFile>]          Cache results between runs. Optionally, <cacheFile> can be provided to use a
                                 specific file for caching. Otherwise, a temporary file is used.
  --no-cache                     Do not cache results between runs (default).
  --parallel=<processes>         The number of files to be checked simultaneously. Defaults to 1 (no parallel
                                 processing).
                                 If enabled, this option only takes effect if the PHP PCNTL (Process Control)
                                 extension is available.

  -d <key[=value]>               Set the [key] php.ini value to [value] or set to [true] if value is omitted.
                                 Note: only php.ini settings which can be changed at runtime are supported.

Reporting Options:
  --report=<report>              Print either the "full", "xml", "checkstyle", "csv", "json", "junit",
                                 "emacs", "source", "summary", "diff", "svnblame", "gitblame", "hgblame",
                                 "notifysend" or "performance" report or specify the path to a custom report
                                 class. By default, the "full" report is displayed.
  --report-file=<reportFile>     Write the report to the specified file path.
  --report-<report>=<reportFile> Write the report specified in <report> to the specified file path.
  --report-width=<reportWidth>   How many columns wide screen reports should be. Set to "auto" to use current
                                 screen width, where supported.
  --basepath=<basepath>          Strip a path from the front of file paths inside reports.

  -w                             Include both warnings and errors (default).
  -n                             Do not include warnings. Shortcut for "--warning-severity=0".
  --severity=<severity>          The minimum severity required to display an error or warning. Defaults to 5.
  --error-severity=<severity>    The minimum severity required to display an error. Defaults to 5.
  --warning-severity=<severity>  The minimum severity required to display a warning. Defaults to 5.

  -s                             Show sniff error codes in all reports.
  --ignore-annotations           Ignore all "phpcs:..." annotations in code comments.
  --colors                       Use colors in screen output.
  --no-colors                    Do not use colors in screen output (default).
  -p                             Show progress of the run.
  -q                             Quiet mode; disables progress and verbose output.
  -m                             Stop error messages from being recorded. This saves a lot of memory but stops
                                 many reports from being used.

Configuration Options:
  --encoding=<encoding>          The encoding of the files being checked. Defaults to "utf-8".
  --tab-width=<tabWidth>         The number of spaces each tab represents.

  Default values for a selection of options can be stored in a user-specific CodeSniffer.conf configuration
  file.
  This applies to the following options: "default_standard", "report_format", "tab_width", "encoding",
  "severity", "error_severity", "warning_severity", "show_warnings", "report_width", "show_progress", "quiet",
  "colors", "cache", "parallel".
  --config-show                  Show the configuration options which are currently stored in the applicable
                                 CodeSniffer.conf file.
  --config-set <key> <value>     Save a configuration option to the CodeSniffer.conf file.
  --config-delete <key>          Delete a configuration option from the CodeSniffer.conf file.
  --runtime-set <key> <value>    Set a configuration option to be applied to the current scan run only.

Miscellaneous Options:
  -h, -?, --help                 Print this help message.
  --version                      Print version information.
  -v                             Verbose output: Print processed files.
  -vv                            Verbose output: Print ruleset and token output.
  -vvv                           Verbose output: Print sniff processing information.
```

> [!NOTE]
> The `--standard` command line argument is optional, even if you have more than one coding standard installed. If no coding standard is specified, PHP_CodeSniffer will default to checking against the _PEAR_ coding standard, or the standard you have set as the default. [View instructions for setting the default coding standard](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Configuration-Options#setting-the-default-coding-standard).

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Checking Files and Folders

The simplest way of using PHP_CodeSniffer is to provide the location of a file or folder for PHP_CodeSniffer to check. If a folder is provided, PHP_CodeSniffer will check all files it finds in that folder and all its sub-folders. If you do not want sub-folders checked, use the `-l` command line argument to force PHP_CodeSniffer to run locally in the folders specified.

In the example below, the first command tells PHP_CodeSniffer to check the `myfile.inc` file for coding standard errors while the second command tells PHP_CodeSniffer to check all PHP files in the `my_dir` directory.

```bash
$ phpcs /path/to/code/myfile.inc
$ phpcs /path/to/code/my_dir
```

You can also specify multiple files and folders to check. The command below tells PHP_CodeSniffer to check the `myfile.inc` file and all files in the `my_dir` directory.

```bash
$ phpcs /path/to/code/myfile.inc /path/to/code/my_dir
```

After PHP_CodeSniffer has finished processing your files, you will get an error report. The report lists both errors and warnings for all files that violated the coding standard. The output looks like this:

```
$ phpcs /path/to/code/myfile.php

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
```

If you don't want warnings included in the output, specify the `-n` command line argument.

```
$ phpcs -n /path/to/code/myfile.php

FILE: /path/to/code/myfile.php
--------------------------------------------------------------------------------
FOUND 5 ERROR(S) AFFECTING 5 LINE(S)
--------------------------------------------------------------------------------
  2 | ERROR | Missing file doc comment
 20 | ERROR | PHP keywords must be lowercase; expected "false" but found "FALSE"
 47 | ERROR | Line not indented correctly; expected 4 spaces but found 1
 51 | ERROR | Missing function doc comment
 88 | ERROR | Line not indented correctly; expected 9 spaces but found 6
--------------------------------------------------------------------------------
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Printing a Summary Report

By default, PHP_CodeSniffer will print a complete list of all errors and warnings it finds. This list can become quite long, especially when checking a large number of files at once. To print a summary report that only shows the number of errors and warnings for each file, use the `--report=summary` command line argument. The output will look like this:

```
$ phpcs --report=summary /path/to/code

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
```

As with the full report, you can suppress the printing of warnings with the `-n` command line argument.

```
$ phpcs -n --report=summary /path/to/code

PHP CODE SNIFFER REPORT SUMMARY
--------------------------------------------------------------------------------
FILE                                                                      ERRORS
--------------------------------------------------------------------------------
/path/to/code/myfile.inc                                                  5
/path/to/code/yourfile.inc                                                1
--------------------------------------------------------------------------------
A TOTAL OF 6 ERROR(S) WERE FOUND IN 2 FILE(S)
--------------------------------------------------------------------------------
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Printing Progress Information

By default, PHP_CodeSniffer will run quietly, only printing the report of errors and warnings at the end. If you are checking a large number of files, you may have to wait a while to see the report. If you want to know what is happening, you can turn on progress or verbose output.

With progress output enabled, PHP_CodeSniffer will print a single-character status for each file being checked. The possible status characters are:

* `.` : The file contained no errors or warnings
* `E` : The file contained 1 or more errors
* `W` : The file contained 1 or more warnings, but no errors
* `S` : The file contained a [// phpcs:ignoreFile](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Advanced-Usage#ignoring-files-and-folders) comment and was skipped

Progress output will look like this:

```
$ phpcs /path/to/code/CodeSniffer -p

......................S.....................................  60 / 572
..........EEEE.E.E.E.E.E.E.E.E..W..EEE.E.E.E.EE.E.E.E.E.E.E. 120 / 572
E.E.E.E.E.WWWW.E.W..EEE.E.................E.E.E.E...E....... 180 / 572
E.E.E.E.....................E.E.E.E.E.E.E.E.E.E.W.E.E.E.E.E. 240 / 572
E.W......................................................... 300 / 572
..........................................E.E.E.E...E.E.E.E. 360 / 572
E.E.E.E.E.E..E.E.E..E..E..E.E.WW.E.E.EE.E.E................. 420 / 572
...................E.E.EE.E.E.E.S.E.EEEE.E...E...EE.E.E..EEE 480 / 572
.E.EE.E.E..E.E.E.E.E.E.E.E.E.E.E.E.E.E.E.E.E..E..E..E.E.E..E 540 / 572
.E.E....E.E.E...E.....E.E.ES....
```

> [!NOTE]
> You can configure PHP_CodeSniffer to show progress information by default using [the configuration option](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Configuration-Options#showing-progress-by-default)</link>.

With verbose output enabled, PHP_CodeSniffer will print the file that it is checking, show you how many tokens and lines the file contains, and let you know how long it took to process. The output will look like this:

```
$ phpcs /path/to/code/CodeSniffer -v

Registering sniffs in PEAR standard... DONE (24 sniffs registered)
Creating file list... DONE (572 files in queue)
Processing AbstractDocElement.php [1093 tokens in 303 lines]... DONE in < 1 second (0 errors, 1 warnings)
Processing AbstractParser.php [2360 tokens in 558 lines]... DONE in 2 seconds (0 errors, 1 warnings)
Processing ClassCommentParser.php [923 tokens in 296 lines]... DONE in < 1 second (2 errors, 0 warnings)
Processing CommentElement.php [988 tokens in 218 lines]... DONE in < 1 second (1 error, 5 warnings)
Processing FunctionCommentParser.php [525 tokens in 184 lines]... DONE in 1 second (0 errors, 6 warnings)
Processing File.php [10968 tokens in 1805 lines]... DONE in 5 seconds (0 errors, 5 warnings)
Processing Sniff.php [133 tokens in 94 lines]... DONE in < 1 second (0 errors, 0 warnings)
Processing SniffException.php [47 tokens in 36 lines]... DONE in < 1 second (1 errors, 3 warnings)
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Specifying a Coding Standard

PHP_CodeSniffer can have multiple coding standards installed to allow a single installation to be used with multiple projects. When checking PHP code, PHP_CodeSniffer can be told which coding standard to use. This is done using the `--standard` command line argument.

The example below checks the `myfile.inc` file for violations of the _PEAR_ coding standard (installed by default).

```bash
$ phpcs --standard=PEAR /path/to/code/myfile.inc
```

You can also tell PHP_CodeSniffer to use an external standard by specifying the full path to the standard's root directory on the command line. An external standard is one that is stored outside of PHP_CodeSniffer's `Standards` directory.

```bash
$ phpcs --standard=/path/to/MyStandard /path/to/code/myfile.inc
```

Multiple coding standards can be checked at the same time by passing a list of comma separated standards on the command line. A mix of external and installed coding standards can be passed if required.

```bash
$ phpcs --standard=PEAR,Squiz,/path/to/MyStandard /path/to/code/myfile.inc
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Printing a List of Installed Coding Standards

PHP_CodeSniffer can print you a list of the coding standards that are installed so that you can correctly specify a coding standard to use for testing. You can print this list by specifying the `-i` command line argument.

```
$ phpcs -i
The installed coding standards are MySource, PEAR, PSR1, PSR2, PSR12, Squiz and Zend
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Listing Sniffs Inside a Coding Standard

PHP_CodeSniffer can print you a list of the sniffs that a coding standard includes by specifying the `-e` command line argument along with the `--standard` argument. This allows you to see what checks will be applied when you use a given standard.

```
$ phpcs --standard=PSR1 -e

The PSR1 standard contains 8 sniffs

Generic (4 sniffs)
------------------
  Generic.Files.ByteOrderMark
  Generic.NamingConventions.UpperCaseConstantName
  Generic.PHP.DisallowAlternativePHPTags
  Generic.PHP.DisallowShortOpenTag

PSR1 (3 sniffs)
---------------
  PSR1.Classes.ClassDeclaration
  PSR1.Files.SideEffects
  PSR1.Methods.CamelCapsMethodName

Squiz (1 sniff)
---------------
  Squiz.Classes.ValidClassName
```
