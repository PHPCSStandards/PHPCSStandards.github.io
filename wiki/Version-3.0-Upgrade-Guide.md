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

### Extending Other Sniffs

If your custom sniff extends another sniff, the class definition needs to change a bit more. Previously, a `class_exists()` call may have been used to autoload the sniff. Now, a `use` statement is used for autoloading, and the extended class name also changes.

The old class definition for a sniff extending another looked like this:
```php
if (class_exists('OtherStandardName_Sniffs_Category_TestSniff', true) === false) {
    throw new PHP_CodeSniffer_Exception('Class OtherStandardName_Sniffs_Category_TestSniff not found');
}

class StandardName_Sniffs_Category_TestSniff extends OtherStandardName_Sniffs_Category_TestSniff {}
```

The sniff class definition above should now be rewritten as this:
```php
namespace StandardName\Sniffs\Category;

use OtherStandardName\Sniffs\Category\TestSniff as OtherTestSniff;
use PHP_CodeSniffer\Sniffs\Sniff;
use PHP_CodeSniffer\Files\File;

class TestSniff extends OtherTestSniff {}
```

### Extending the Included Abstract Sniffs

#### AbstractVariableSniff
If you previously extended the `AbstractVariableSniff`, your class definition will now look like this:
```php
namespace StandardName\Sniffs\Category;

use PHP_CodeSniffer\Sniffs\AbstractVariableSniff;
use PHP_CodeSniffer\Files\File;

class TestSniff extends AbstractVariableSniff {}
```
#### AbstractPatternSniff
If you previously extended the `AbstractPatternSniff`, your class definition will now look like this:
```php
namespace StandardName\Sniffs\Category;

use PHP_CodeSniffer\Sniffs\AbstractPatternSniff;

class TestSniff extends AbstractPatternSniff {}
```
> Note: `PHP_CodeSniffer\Files\File` is not typically needed in a sniff that extends AbstractPatternSniff because these sniffs normally override the `getPatterns()` method only. If you are overriding a method that needs `File`, include the `use` statement as you would for any other sniff.

#### AbstractScopeSniff
If you previously extended the `AbstractScopeSniff`, your class definition will now look like this:
```php
namespace StandardName\Sniffs\Category;

use PHP_CodeSniffer\Sniffs\AbstractScopeSniff;
use PHP_CodeSniffer\Files\File;

class TestSniff extends AbstractScopeSniff {}
```

If you did not previously define the optional `processTokenOutsideScope()` method, you must now do so as it has been marked as abstract. Include the empty method below if you do not need to process tokens outside the specified scopes:
```php
protected function processTokenOutsideScope(File $phpcsFile, $stackPtr)
{
}
```

### New Class Names

#### PHP_CodeSniffer_File
Any references to `PHP_CodeSniffer_File` in your sniff should be changed to `File`. This includes the type hint that is normally used in the `process()` function definition. The old definition looked like this:
```php
public function process(PHP_CodeSniffer_File $phpcsFile, $stackPtr) {}
```

The `process()` function declaration should now be rewritten as this:
```php
public function process(File $phpcsFile, $stackPtr) {}
```

#### PHP_CodeSniffer_Tokens
If your sniff currently uses the `PHP_CodeSniffer_Tokens` class, you will need to add a use statement for `PHP_CodeSniffer\Util\Tokens` and then change references of `PHP_CodeSniffer_Tokens::` to `Tokens::` inside your sniff. The below example shows a sniff that is registering the list of comment tokens using the new `Tokens` class. Note that additional `use` statement:
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
#### PHP_CodeSniffer
If your sniff currently uses the `PHP_CodeSniffer` class to access utility functions such as `isCamelCaps()` and `suggestType()`, you will need to add a use statement for `PHP_CodeSniffer\Util\Common` and then change references of `PHP_CodeSniffer::` to `Common::` inside your sniff. Your class definition will look like this:
```php
namespace StandardName\Sniffs\Category;

use PHP_CodeSniffer\Sniffs\Sniff;
use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Util\Common;

class TestSniff implements Sniff {}
```

## Upgrading Unit Tests

## Upgrading Custom Reports
