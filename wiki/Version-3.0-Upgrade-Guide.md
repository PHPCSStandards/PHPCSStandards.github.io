PHP_CodeSniffer version 3 contains a large number of core changes and breaks backwards compatibility for all custom sniffs and reports. The aim of this guide is to help developers upgrade their custom sniffs, unit tests, and reports from PHP_CodeSniffer version 2 to version 3.

If you only use the built-in coding standards, or you have a custom ruleset.xml file that only makes use of the sniffs and reports distributed with PHP_CodeSniffer, you do not need to make any changes to begin using PHP_CodeSniffer version 3.

> Note: This guide is a work in progress. Large sections are not yet complete.

## Upgrading Custom Sniffs

All sniffs must now be namespaced.

> Note: It doesn't really matter what namespace you use for your sniffs, but the examples below use a basic namespace based on the standard and category names. If you aren't sure what to use, try using this format.

Internal namespace changes to core classes require changes to all sniff class definitions. The old definition looked like this:
```php
class StandardName_Sniffs_Category_TestSniff implements PHP_CodeSniffer_Sniff {}
```

The sniff class definition above should now be rewritten as this:
```php
namespace StandardName\Sniffs\Category;

use PHP_CodeSniffer\Sniffs\Sniff;
use PHP_CodeSniffer\Files\File;

class TestSniff implements Sniff {}
```

Any references to `PHP_CodeSniffer_File` in your sniff should be changed to `File`. This includes the type hint that is normally used in the `process()` function definition. The old definition looked like this:
```php
public function process(PHP_CodeSniffer_File $phpcsFile, $stackPtr) {}
```

The `process()` function declaration should now be rewritten as this:
```php
public function process(File $phpcsFile, $stackPtr) {}
```

If your sniff currently uses the `PHP_CodeSniffer_Tokens` class, you will also need to add a use statement for `PHP_CodeSniffer\Util\Tokens` and then change references of `PHP_CodeSniffer_Tokens::` to `Tokens::` inside your sniff. The below example shows a sniff that is registering the list of comment tokens using the new `Tokens` class. Note that additional `use` statement:
```php
namespace StandardName\Sniffs\Category;

use PHP_CodeSniffer\Sniffs\Sniff;
use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Util\Tokens;

class TestSniff implements Sniff
{

    public function register()
    {
        return Tokens::$commentTokens;
    }

    public function process(File $phpcsFile, $stackPtr) {}

}
```
