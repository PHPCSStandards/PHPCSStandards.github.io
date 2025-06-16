In this tutorial, we will create a new coding standard with a single sniff. Our sniff will prohibit the use of Perl style hash comments.

Sniffs need to follow [strict directory layout and naming conventions](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/About-Standards-for-PHP_CodeSniffer#naming-conventions).

## Table of contents

<!-- START doctoc -->
<!-- END doctoc -->

***

## Creating the Coding Standard Directory

All sniffs in PHP_CodeSniffer must belong to a coding standard. A coding standard is a directory with a specific sub-directory structure and a `ruleset.xml` file, so creating a standard is straight-forward.
Let's call our coding standard _MyStandard_. Run the following commands to create the coding standard directory structure:

```bash
$ mkdir MyStandard
$ mkdir MyStandard/Sniffs
```

As this coding standard directory sits outside the main PHP_CodeSniffer directory structure, PHP_CodeSniffer will not show it as an installed standard when using the `-i` command line argument. If you want your standard to be shown as installed, [register the MyStandard directory as an external standards with PHP_CodeSniffer](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Configuration-Options#setting-the-installed-standard-paths):

```bash
$ phpcs --config-set installed_paths /path/to/MyStandard
```

The `MyStandard` directory represents our coding standard. The `Sniffs` sub-directory is used to store all the sniff files for this coding standard.

Now that our directory structure is created, we need to add our `ruleset.xml` file. This file will allow PHP_CodeSniffer to ask our coding standard for information about itself, and also identify this directory as one that contains code sniffs.

```bash
$ cd MyStandard
$ touch ruleset.xml
```

The content of the `ruleset.xml` file should, at a minimum, be the following:

```xml
<?xml version="1.0"?>
<ruleset name="MyStandard">
  <description>A custom coding standard.</description>
</ruleset>
```

> [!NOTE]
> The ruleset.xml can be left quite small, as it is in this example coding standard. For information about the other features that the `ruleset.xml` provides, see the [[Annotated ruleset]].

## Creating the Sniff

A sniff requires a single PHP file that must be placed into a sub-directory to categorise the type of check it performs. Its name should clearly describe the standard that we are enforcing and must end with `Sniff.php`. For our sniff, we will name the PHP file `DisallowHashCommentsSniff.php` and place it into a `Commenting` sub-directory to categorise this sniff as relating to commenting. Run the following commands to create the category and the sniff:

```bash
$ cd Sniffs
$ mkdir Commenting
$ touch Commenting/DisallowHashCommentsSniff.php
```

> [!NOTE]
> It does not matter what sub-directories you use for categorising your sniffs. Just make them descriptive enough so you can find your sniffs again later when you want to modify them.

Each sniff must implement the `PHP_CodeSniffer\Sniffs\Sniff` interface so that PHP_CodeSniffer knows that it should instantiate the sniff once it's invoked. The interface defines two methods that must be implemented; `register` and `process`.

## The `register` and `process` Methods

The `register` method allows a sniff to subscribe to one or more token types that it wants to process. Once PHP_CodeSniffer encounters one of those tokens, it calls the `process` method with the `PHP_CodeSniffer\Files\File` object (a representation of the current file being checked) and the position in the stack where the token was found.

For our sniff, we are interested in single line comments. The `token_get_all` method that PHP_CodeSniffer uses to acquire the tokens within a file distinguishes doc comments and normal comments as two separate token types. Therefore, we don't have to worry about doc comments interfering with our test. The `register` method only needs to return one token type, `T_COMMENT`.

## The Token Stack

A sniff can gather more information about a token by acquiring the token stack with a call to the `getTokens` method on the `PHP_CodeSniffer\Files\File` object. This method returns an array and is indexed by the position where the token occurs in the token stack. Each element in the array represents a token. All tokens have a `code`, `type` and a `content` index in their array. The `code` value is a unique integer for the type of token. The `type` value is a string representation of the token (e.g., `'T_COMMENT'` for comment tokens). The `type` has a corresponding globally defined integer with the same name. Finally, the `content` value contains the content of the token as it appears in the code.

> [!NOTE]
> Depending on the token, the token array may contain various additional indexes with further information on a token.

## Reporting Errors

Once an error is detected, a sniff should indicate that an error has occurred by calling the `addError` method on the `PHP_CodeSniffer\Files\File` object, passing in an appropriate error message as the first argument, the position in the stack where the error was detected as the second, a code to uniquely identify the error within this sniff and an array of data used inside the error message.
Alternatively, if the violation is considered not as critical as an error, the `addWarning` method can be used.

## DisallowHashCommentsSniff.php

We now have to write the content of our sniff. The content of the `DisallowHashCommentsSniff.php` file should be the following:

```php
<?php

namespace MyStandard\Sniffs\Commenting;

use PHP_CodeSniffer\Sniffs\Sniff;
use PHP_CodeSniffer\Files\File;

/**
 * This sniff prohibits the use of Perl style hash comments.
 */
final class DisallowHashCommentsSniff implements Sniff
{

    /**
     * Returns the token types that this sniff is interested in.
     *
     * @return array<int|string>
     */
    public function register()
    {
        return [T_COMMENT];
    }

    /**
     * Processes this sniff, when one of its tokens is encountered.
     *
     * @param \PHP_CodeSniffer\Files\File $phpcsFile The current file being checked.
     * @param int                         $stackPtr  The position of the current token in the
     *                                               stack passed in $tokens.
     *
     * @return void
     */
    public function process(File $phpcsFile, $stackPtr)
    {
        $tokens = $phpcsFile->getTokens();
        if ($tokens[$stackPtr]['content'][0] === '#') {
            $error = 'Hash comments are prohibited; found %s';
            $data  = [trim($tokens[$stackPtr]['content'])];
            $phpcsFile->addError($error, $stackPtr, 'Found', $data);
        }
    }
}
```

By default, PHP_CodeSniffer assumes all sniffs are designed to check PHP code only. You can specify a list of tokenizers that your sniff supports, allowing it to be used with PHP, JavaScript or CSS files, or any combination of the three. You do this by setting the `$supportedTokenizers` property in your sniff. Adding the following code to your sniff will tell PHP_CodeSniffer that it can be used to check both PHP and JavaScript code:

```php
/**
 * A list of tokenizers this sniff supports.
 *
 * @var array<string>
 */
public $supportedTokenizers = [
    'PHP',
    'JS',
];
```


## Results

Now that we have defined a coding standard, let's validate a file that contains hash comments. The test file we are using has the following contents:

```php
<?php

// Slash comments should be ignored.

/* Star comments should also be ignored. */

# Hash comments should be flagged.
if ($obj->contentsAreValid($array)) {
    $value = $obj->getValue();

    # Value needs to be an array.
    if (is_array($value) === false) {
        # Error.
        $obj->throwError();
        exit();
    }
}
```

When PHP_CodeSniffer is run on the file using our new coding standard, 3 errors will be reported:
```bash
$ phpcs --standard=MyStandard test.php

FILE: test.php
--------------------------------------------------------------------------------
FOUND 3 ERROR(S) AFFECTING 3 LINE(S)
--------------------------------------------------------------------------------
  7 | ERROR | Hash comments are prohibited; found # Hash comments should be flagged.
 11 | ERROR | Hash comments are prohibited; found # Value needs to be an array.
 13 | ERROR | Hash comments are prohibited; found # Error.
--------------------------------------------------------------------------------
```
