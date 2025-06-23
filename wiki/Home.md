PHP_CodeSniffer is a set of two PHP scripts:
1. the main [`phpcs` script](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Usage) that tokenizes PHP, JavaScript and CSS files to detect violations of a defined coding standard; and
2. a [`phpcbf` script](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Fixing-Errors-Automatically) to automatically correct detected coding standard violations.

PHP_CodeSniffer is an essential development tool that ensures your code remains clean and consistent.

A coding standard in PHP_CodeSniffer is a collection of sniff files. Each sniff file checks one part of the coding standard only. Each sniff can yield multiple error codes, a different one for each aspect of the code which was checked and found non-compliant.

Multiple coding standards can be used within PHP_CodeSniffer so that the one installation can be used across multiple projects. The default coding standard used by PHP_CodeSniffer is the PEAR coding standard.

## Example

To check a file against the PEAR coding standard, simply specify the file's location.

```bash
$ phpcs path/to/code/myfile.php
{{COMMAND-OUTPUT "phpcs --parallel=1 --basepath=build/wiki-code-samples --no-colors --standard=PEAR build/wiki-code-samples/path/to/code/myfile.php"}}
```

Or, if you wish to check an entire directory, you can specify the directory location instead of a file.

```bash
$ phpcs /path/to/code

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

FILE: /path/to/code/yourfile.php
--------------------------------------------------------------------------------
FOUND 1 ERROR(S) AND 1 WARNING(S) AFFECTING 1 LINE(S)
--------------------------------------------------------------------------------
 21 | ERROR   | PHP keywords must be lowercase; expected "false" but found
    |         | "FALSE"
 21 | WARNING | Equals sign not aligned with surrounding assignments
--------------------------------------------------------------------------------
```
