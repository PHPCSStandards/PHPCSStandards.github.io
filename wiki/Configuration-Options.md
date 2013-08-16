## Setting the Default Coding Standard
By default, PHP_CodeSniffer will use the PEAR coding standard if no standard is supplied on the command line. You can change the default standard by setting the default_standard configuration option.

    $ phpcs --config-set default_standard Squiz

## Setting the Default Report Format
By default, PHP_CodeSniffer will use the full report format if no format is supplied on the command line. You can change the default report format by setting the report_format configuration option.

    $ phpcs --config-set report_format summary

## Hiding Warnings by Default
By default, PHP_CodeSniffer will show both errors and warnings for your code. You can hide warnings for a single script run by using the `-n` command line argument, but you can also enable this by default if you prefer. To hide warnings by default, set the `show_warnings` configuration option to `0`.

    $ phpcs --config-set show_warnings 0

When warnings are hidden by default, you can use the `-w` command line argument to show them for a single script run.

## Showing Progress by Default
By default, PHP_CodeSniffer will run quietly and only print the report of errors and warnings at the end. If you want to know what is happening you can turn on progress output, but you can also enable this by default if you prefer. To show progress by default, set the `show_progress` configuration option to `1`.

    $ phpcs --config-set show_progress 1

## Changing the Default Severity Levels
By default, PHP_CodeSniffer will show all errors and warnings with a severity level of 5 or greater. You can change these settings for a single script run by using the `--severity`, `--error-severity` and `--warning-severity` command line arguments, but you can also change the default settings if you prefer.

To change the default severity level to show all errors and warnings:

    $ phpcs --config-set severity 1

To change the default severity levels to show all errors but only some warnings

    $ phpcs --config-set error_severity 1
    $ phpcs --config-set warning_severity 8

Setting the severity of warnings to 0 is the same as using the `-n` command line argument. If you set the severity of errors to `0` PHP_CodeSniffer will not show any errors, which may be useful if you just want to show warnings.

## Setting the Default Report Width
By default, PHP_CodeSniffer will print all screen-based reports 80 characters wide. File paths will be truncated if they don't fit within this limit and error messages will be wrapped across multiple lines. You can increase the report width to show longer file paths and limit the wrapping of error messages using the `--report-width` command line argument, but you can also change the default report width by setting the `report_width` configuration option.

    $ phpcs --config-set report_width 120

## Setting the Default Encoding
By default, PHP_CodeSniffer will treat all source files as if they use ISO-8859-1 encoding. This can cause double-encoding problems when generating UTF-8 encoded XML reports. To help PHP_CodeSniffer encode reports correctly, you can specify the encoding of your source files using the `--encoding` command line argument, but you can also change the default encoding by setting the `encoding` configuration option.

    $ phpcs --config-set encoding utf-8

## Setting the Default Tab Width
By default, PHP_CodeSniffer will not convert tabs to spaces in checked files. Specifying a tab width will make PHP_CodeSniffer replace tabs with spaces. You can force PHP_CodeSniffer to replace tabs with spaces by default by setting the `tab_width` configuration option.

    $ phpcs --config-set tab_width 4
    
When the tab width is set by default, the replacement of tabs with spaces can be disabled for a single script run by setting the tab width to zero.

    $ phpcs --tab-width=0 /path/to/code

## Generic Coding Standard Configuration Options

### Setting the Path to the Google Closure Linter
The Generic coding standard includes a sniff that will check each file using the [Google Closure Linter](http://code.google.com/p/closure-linter/), an open source JavaScript style checker from Google. Use the `gjslint_path` configuration option to tell the Google Closure Linter sniff where to find the tool.

    $ phpcs --config-set gjslint_path /path/to/gjslint

### Setting the Path to JSHint

The Generic coding standard includes a sniff that will check each JavaScript file using [JSHint](http://www.jshint.com/), a tool to detect errors and potential problems in JavaScript code. Use the `jshint_path` configuration option to tell the JSHint sniff where to find the tool.

    $ phpcs --config-set jshint_path /path/to/jshint.js

As JSHint is just JavaScript code, you also need to install [Rhino](http://www.mozilla.org/rhino/) to be able to execute it. Use the `rhino_path` configuration option to tell the JSHint sniff where to find the tool.

    $ phpcs --config-set rhino_path /path/to/rhino
 
## Squiz Coding Standard Configuration Options

### Setting the Path to JSLint
The Squiz coding standard includes a sniff that will check each JavaScript file using [JSLint](http://www.jslint.com/), a JavaScript program that looks for problems in JavaScript programs. Use the `jslint_path` configuration option to tell the JSLint sniff where to find the tool.

    $ phpcs --config-set jslint_path /path/to/jslint.js

As JSLint is just JavaScript code, you also need to install [Rhino](https://developer.mozilla.org/en-US/docs/Rhino) to be able to execute it. Use the `rhino_path` configuration option to tell the JSLint sniff where to find the tool.

    $ phpcs --config-set rhino_path /path/to/rhino

### Setting the Path to JavaScript Lint
The Squiz coding standard includes a sniff that will check each JavaScript file using [JavaScript Lint](http://www.javascriptlint.com/), a tool that checks all your JavaScript source code for common mistakes without actually running the script or opening the web page. Use the `jsl_path` configuration option to tell the JavaScript Lint sniff where to find the tool.

    $ phpcs --config-set jsl_path /path/to/jsl

## Zend Coding Standard Configuration Options
### Setting the Path to the Zend Code Analyzer
The Zend coding standard includes a sniff that will check each file using the Zend Code Analyzer, a tool that comes with Zend Studio. Use the `zend_ca_path` configuration option to tell the Zend Code Analyzer sniff where to find the tool.

    $ phpcs --config-set zend_ca_path /path/to/ZendCodeAnalyzer