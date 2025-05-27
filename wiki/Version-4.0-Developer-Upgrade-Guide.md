> [!CAUTION]
> PHP_CodeSniffer 4.0.0 is currently in the pre-release phase. The information in this upgrade guide is subject to change until PHP_CodeSniffer 4.0.0 has been released.
>
> If you find errors in this upgrade guide or would like to contribute improvements based on tests you've run with a PHP_CodeSniffer 4.0 pre-release, please [open an issue](https://github.com/PHPCSStandards/PHP_CodeSniffer/issues).


PHP_CodeSniffer version 4.0.0 contains a number of core changes and breaks backwards compatibility in select situations. The aim of this guide is to help **sniff developers and integrators** to upgrade from PHP_CodeSniffer version 3.x to version 4.x.

> [!NOTE]
> A certain level of technical understanding of PHP_CodeSniffer is presumed for readers of this upgrade guide.

There is a separate [[Upgrade Guide for Ruleset Maintainers and End-Users|Version 4.0 User Upgrade Guide]] available.


## Table of contents

* [Should I upgrade ?](#should-i-upgrade-)
    * [Upgrade strategies](#upgrade-strategies)
* [Upgrading the ruleset.xml file](#upgrading-the-rulesetxml-file)
* [Upgrading Standards](#upgrading-standards)
    * [Support for external standards named "Internal" has been removed](#support-for-external-standards-named-internal-has-been-removed)
* [Upgrading Custom Sniffs](#upgrading-custom-sniffs)
    * [Sniffs need to comply with the naming conventions](#sniffs-need-to-comply-with-the-naming-conventions)
    * [Sniffs must implement the `PHP_CodeSniffer\Sniffs\Sniff` interface](#sniffs-must-implement-the-php_codesniffersniffssniff-interface)
    * [Support for JS/CSS has been removed](#support-for-jscss-has-been-removed)
    * [Property type casting has been made more consistent](#property-type-casting-has-been-made-more-consistent)
    * [Changed Methods](#changed-methods)
        * [File::getDeclarationName()](#filegetdeclarationname)
        * [File::getMemberProperties()](#filegetmemberproperties)
        * [Config::setConfigData() is no longer static](#configsetconfigdata-is-no-longer-static)
    * [Tokens class changes](#tokens-class-changes)
        * [Token arrays are now class constants](#token-arrays-are-now-class-constants)
        * [Removed Tokens](#removed-tokens)
    * [Tokenizer Changes](#tokenizer-changes)
        * [T_USE (for closures), T_ISSET, T_UNSET, T_EMPTY, T_EVAL, T_EXIT are parenthesis owners](#t_use-for-closures-t_isset-t_unset-t_empty-t_eval-t_exit-are-parenthesis-owners)
        * [Namespaced Names](#namespaced-names)
        * [T_STATIC](#t_static)
        * [T_OPEN_TAG](#t_open_tag)
        * [`goto`](#goto)
        * [Other Tokenizer Changes](#other-tokenizer-changes)
    * [Changes to abstract sniffs](#changes-to-abstract-sniffs)
    * [Changes to PHPCS native sniffs](#changes-to-phpcs-native-sniffs)
        * [Various sniffs listen to fewer tokens](#various-sniffs-listen-to-fewer-tokens)
        * [PHP_CodeSniffer\Standards\Squiz\Sniffs\Classes\SelfMemberReferenceSniff](#php_codesnifferstandardssquizsniffsclassesselfmemberreferencesniff)
* [Miscellaneous other changes which may affect code extending PHP_CodeSniffer](#miscellaneous-other-changes-which-may-affect-code-extending-php_codesniffer)
* [Unit Tests](#unit-tests)
    * [For standards using their own test framework](#for-standards-using-their-own-test-framework)
    * [For standards using the PHPCS native test framework](#for-standards-using-the-phpcs-native-test-framework)

## Should I upgrade ?

It is highly recommended to upgrade external standards and integrations as soon as you are able.

Once PHP_CodeSniffer 4.0 has been released, the PHP_CodeSniffer 3.x branch will no longer receive updates, with the exception of security fixes and runtime compatibility fixes for new PHP versions.
This "limited support" will last a maximum of one year from the date of the PHP_Codesniffer 4.0.0 release.

> [!IMPORTANT]
> This also means that support for new PHP syntaxes will only land in PHP_CodeSniffer 4.x and will **NOT** be backported to the 3.x branch.


### Upgrade strategies

There are basically two upgrade strategies:
1. Drop support for PHP_CodeSniffer 3.x completely and adopt support for PHP_CodeSniffer 4.x.
2. Make your package cross-version compatible with both PHP_CodeSniffer 3.x as well as 4.x.

Which strategy is best suited for your project will depend on your userbase.

If your userbase is known to often combine multiple external standards, making the package PHPCS cross-version compatible may be preferred to allow users to upgrade as soon as possible, while still benefitting from updates to your package if they can't upgrade to PHPCS 4.x yet.

The vast majority of the below upgrade tasks will need to be executed in both cases, but there are some upgrade tasks which can only be executed once support for PHP_CodeSniffer 3.x is being dropped.


## Upgrading the ruleset.xml file

See the [[Upgrade Guide for Ruleset Maintainers and End-Users|Version 4.0 User Upgrade Guide]] for everything you need to know about upgrading the `ruleset.xml` file.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Upgrading Standards

### Support for external standards named "Internal" has been removed

In the exceptional situation that your custom PHP_CodeSniffer standard is called `Internal`, you will need to rename the standard and the namespace used by all sniffs in the standard.

When renaming, make sure to follow all naming conventions for standards and sniffs as outlined in [About Standards](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/About-Standards-for-PHP_CodeSniffer#naming-conventions).

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Upgrading Custom Sniffs

### Sniffs need to comply with the naming conventions

The naming conventions for sniffs have not changed, but will be enforced strictly as of PHP_CodeSniffer 4.0.

If any of your sniffs do not comply with the directory layout and naming conventions for external standards, PHPCS 3.13.x will alert you with a deprecation notice.

Please carefully read the naming conventions for standards and sniffs as outlined in [About Standards](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/About-Standards-for-PHP_CodeSniffer#naming-conventions) to find out how to fix your sniffs.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Sniffs must implement the `PHP_CodeSniffer\Sniffs\Sniff` interface

... either directly or indirectly via an abstract sniff. This is now actively enforced.

PHP_CodeSniffer 3.13.0 will throw a deprecation notice for any sniffs which don't implement the interface.
As of PHP_CodeSniffer 4.0.0, PHP_CodeSniffer will error out on such sniffs.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Support for JS/CSS has been removed

Support for the JS/CSS tokenizers has been removed. To cause the least amount of friction, this has been executed as follows:

* Sniffs which specify the `$supportedTokenizers` property and don't include `'PHP'` in the array value will no longer run on PHPCS 4.0.
    The end-user will be shown an error message about this and PHP_CodeSniffer will exit with this error.
    This error message can be silenced by implementing the `PHP_CodeSniffer\Sniffs\DeprecatedSniff` interface (PHPCS 3.9.0+) to mark the sniff as deprecated.
    In that case, the sniff will show a deprecation notice when running on PHPCS 3.x and the sniff will be silently ignored on PHPCS 4.x.
* Sniffs which specify the `$supportedTokenizers` property and include both `'PHP'` as well as something else, will run against the scanned files, with all files being treated as PHP, as of PHPCS 4.0.0 and will not cause any notices about the sniff to be shown to the end-user.

This has been implemented in this way to allow external standards to be cross-version compatible with PHPCS 3.x as well as 4.x for a while and to not force external standards to release a new major release to support PHPCS 4.0 (due to sniffs needing to be removed).

#### Upgrading

Search for sniffs which specify the `public $supportedTokenizers` property to find sniffs which may need updating.

Making sniffs cross-version compatible:
* Mark sniffs which are only aimed at CSS/JS files as deprecated by implementing the `PHP_CodeSniffer\Sniffs\DeprecatedSniff` interface (PHPCS 3.9.0+) if your standard still intends to support PHPCS 3.x for a while.
* The `$phpcsFile->tokenizerType` property has been removed in PHPCS 4.0. Make sure that any code which checks the `$phpcsFile->tokenizerType` property, first checks whether that property is available before accessing its value.

Dropping support for PHPCS 3.x:
* Remove sniffs which are only aimed at CSS/JS files.
* For mixed sniffs, which also scan PHP files, remove any code which is specific to the scanning of CSS/JS files, including removing the `public $supportedTokenizers` property declaration and checking of the `$phpcsFile->tokenizerType` property.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Property type casting has been made more consistent

Type casting for sniff property values set from within a ruleset has been made more consistent.
* `true` and `false` will now always be set to a boolean value, independently of the case in which the value was provided.
* `null` will now be set to an actual `null` value. Previously, the sniff property would have been set to string `'null'`.
* Array element values will now also get the type casting treatment. Previously, array values would always be strings.

#### Upgrading

Search for sniff which have `public` properties which can be changed from within a ruleset.

* If the sniff has work-arounds in place to handle non-lowercase string `'true'` or `'false'` values for boolean properties, those work-arounds can be removed.
* If the sniff has work-arounds in place to handle (any case) string `'null'` values, those work-arounds can be removed.
* If the sniff explicitly expects only string values for array elements, the sniff may need to be updated.
* If the sniff has work-arounds in place to handle the type casting of `true`, `false` and/or `null` for array elements, those work-arounds can be removed.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Changed Methods

#### File::getDeclarationName()

The `File::getDeclarationName()` method no longer accepts `T_ANON_CLASS` or `T_CLOSURE` tokens. Getting the "name" of an anonymous construct is an oxymoron. A `RuntimeException` will be thrown if the method receives these tokens.

Additionally, when a name could not be determined, like during live coding, the method used to return `null`. Now, it will return an empty string.

##### Upgrading

It is recommended to search your codebase for all uses of the `File::getDeclarationName()` method and to review whether the code needs updating.

Typically:
* Verify that the sniff does not pass anonymous constructs to the method.
    If necessary, either add guard-code to prevent this, or wrap the method call in a `try ... catch`.
* Verify if the return value of the method is checked correctly.
    For PHPCS cross-version compatibility, check the return value with `empty($name)`.
    If cross-version compatibility is not a concern, replace checks against `null` with a check against an empty string.
    ```diff
    $name = $phpcsFile->getDeclarationName($stackPtr);
    -if ($name === null) {
    +if ($name === '') { // PHPCS 4.0+
    +if (empty($name)) { // PHPCS cross-version compatible.
        return;
    }
    ```

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### File::getMemberProperties()

The `File::getMemberProperties()` method used to be inconsistent in how it handled variable tokens which were not property declarations.
* In most cases ("normal" variable, function parameter), it would throw a `RuntimeException` _"'$stackPtr is not a class member var'"_.
* However, for "properties" declared in an `enum` or `interface` construct, it would register a warning about a possible parse error and return an empty array.

This parse error warning has now been removed.

As, as of PHP 8.4, declaring (hooked) properties in an interface is no longer a parse error (see the [Property Hooks RFC](https://wiki.php.net/rfc/property-hooks)), properties declared in interfaces will now be accepted for analysis by the function and will return an array of information about the property.

For "properties" declared in enums, which is still not allowed in PHP, the method will throw the _"'$stackPtr is not a class member var'"_ `RuntimeException`.

##### Upgrading

The above is significant change in behaviour and how it needs to be handled will depend on the sniff calling the method.

It is recommended to search your codebase for all uses of the `File::getMemberProperties()` method and to review whether the code needs updating.

Typically:
* If the sniff itself already guards against passing non-properties to the method, you should be fine.
* If the sniff has the method call wrapped within a `try ... catch`, you should also be fine.
* If neither of the above is the case, apply one of the two above mentioned solutions.

In all cases, checking the return value of the method for being an empty array is no longer needed and such code can be removed.

Also, in all cases, the sniff may need to start taking PHP 8.4 properties on interfaces into account, but that's another matter altogether.

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### Config::setConfigData() is no longer static

... and the associated `private Config::$overriddenDefaults` property is also no longer static.

In practice, this means that two consecutively created `Config` objects without the same process will now contain the same settings. Previously, settings overridden in the first Config instance, could not be set for the second Config instance.

Typically, this may impact projects which call `new Config` consecutive times programmatically, whether it is for a custom integration or for a custom test suite.

##### Upgrading

Typical work-arounds for the old behaviour will use `Reflection` to reset the `Config::$overriddenDefaults` property between instantiations.
These type of work-arounds can now be removed.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Tokens class changes

#### Token arrays are now class constants

All token arrays declared as static properties in the `Tokens` class are now soft-deprecated.

##### Upgrading

When dropping support for PHP_CodeSniffer 3.x, start using the corresponding constants on the `Tokens` class instead.

| Search for                          | Replace with                         |
| ----------------------------------- | ------------------------------------ |
| `Tokens::$weightings`               | `Tokens::getHighestWeightedToken()`  |
| `Tokens::$assignmentTokens`         | `Tokens::ASSIGNMENT_TOKENS`          |
| `Tokens::$equalityTokens`           | `Tokens::EQUALITY_TOKENS`            |
| `Tokens::$comparisonTokens`         | `Tokens::COMPARISON_TOKENS`          |
| `Tokens::$arithmeticTokens`         | `Tokens::ARITHMETIC_TOKENS`          |
| `Tokens::$operators`                | `Tokens::OPERATORS`                  |
| `Tokens::$booleanOperators`         | `Tokens::BOOLEAN_OPERATORS`          |
| `Tokens::$castTokens`               | `Tokens::CAST_TOKENS`                |
| `Tokens::$parenthesisOpeners`       | `Tokens::PARENTHESIS_OPENERS`        |
| `Tokens::$scopeOpeners`             | `Tokens::SCOPE_OPENERS`              |
| `Tokens::$scopeModifiers`           | `Tokens::SCOPE_MODIFIERS`            |
| `Tokens::$methodPrefixes`           | `Tokens::METHOD_MODIFIERS`           |
| `Tokens::$blockOpeners`             | `Tokens::BLOCK_OPENERS`              |
| `Tokens::$emptyTokens`              | `Tokens::EMPTY_TOKENS`               |
| `Tokens::$commentTokens`            | `Tokens::COMMENT_TOKENS`             |
| `Tokens::$phpcsCommentTokens`       | `Tokens::PHPCS_ANNOTATION_TOKENS`    |
| `Tokens::$stringTokens`             | `Tokens::STRING_TOKENS`              |
| `Tokens::$textStringTokens`         | `Tokens::TEXT_STRING_TOKENS`         |
| `Tokens::$bracketTokens`            | `Tokens::BRACKET_TOKENS`             |
| `Tokens::$includeTokens`            | `Tokens::INCLUDE_TOKENS`             |
| `Tokens::$heredocTokens`            | `Tokens::HEREDOC_TOKENS`             |
| `Tokens::$functionNameTokens`       | `Tokens::FUNCTION_NAME_TOKENS`       |
| `Tokens::$ooScopeTokens`            | `Tokens::OO_SCOPE_TOKENS`            |
| `Tokens::$magicConstants`           | `Tokens::MAGIC_CONSTANTS`            |
| `Tokens::$contextSensitiveKeywords` | `Tokens::CONTEXT_SENSITIVE_KEYWORDS` |

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### Removed Tokens

The following tokens have been removed:

| Name                   | Remark                                                                        |
| ---------------------- | ----------------------------------------------------------------------------- |
| `T_ARRAY_HINT`         | This token was deprecated in PHPCS 3.3.0 and has been unused since that time. |
| `T_RETURN_TYPE`        | This token was deprecated in PHPCS 3.3.0 and has been unused since that time. |
| `T_PROTOTYPE`          | Token was specific to the JS tokenizer.                                       |
| `T_THIS`               | Token was specific to the JS tokenizer.                                       |
| `T_REGULAR_EXPRESSION` | Token was specific to the JS tokenizer.                                       |
| `T_PROPERTY`           | Token was specific to the JS tokenizer.                                       |
| `T_LABEL`              | Token was specific to the JS tokenizer.                                       |
| `T_OBJECT`             | Token was specific to the JS tokenizer.                                       |
| `T_CLOSE_OBJECT`       | Token was specific to the JS tokenizer.                                       |
| `T_TYPEOF`             | Token was specific to the JS tokenizer.                                       |
| `T_ZSR`                | Token was specific to the JS tokenizer.                                       |
| `T_ZSR_EQUAL`          | Token was specific to the JS tokenizer.                                       |
| `T_COLOUR`             | Token was specific to the CSS tokenizer.                                      |
| `T_HASH`               | Token was specific to the CSS tokenizer.                                      |
| `T_URL`                | Token was specific to the CSS tokenizer.                                      |
| `T_STYLE`              | Token was specific to the CSS tokenizer.                                      |
| `T_EMBEDDED_PHP`       | Token was specific to the CSS tokenizer.                                      |


##### Upgrading

If these tokens are used in PHP-only sniffs, they can be safely removed.
If these tokens are used in JS/CSS only sniffs, as mentioned in ["Support for JS/CSS has been removed"](#support-for-jscss-has-been-removed): deprecate or remove the sniff.
If these tokens are used in mixed sniffs, which also scan PHP files, remove the CSS/JS specific code or, for cross-version compatibility, check for the existance of the tokens before using them.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Tokenizer Changes

#### T_USE (for closures), T_ISSET, T_UNSET, T_EMPTY, T_EVAL, T_EXIT are parenthesis owners

These tokens have been added to the `Tokens::$parenthesisOpeners` array and will now get the `parenthesis_owner`, `parenthesis_opener` and `parenthesis_closer` token indexes if parentheses were found (i.e. not import/trait use, not exit/die without parentheses, not parse error).

##### Upgrading

* Check if any of your sniffs/code uses the `Tokens::$parenthesisOpeners` array.
    It is generally discouraged to use that token array as it is mostly intended for internal use by PHPCS itself, but if you do use it, be aware that the above mentioned tokens have been added to the array.
    You may want to exclude them from your sniff, or in case of `T_USE`, you may need to validate that it is a closure `use` token and not an import/trait `use` token before acting on the token.
* Search your codebase for `T_USE`, `T_ISSET`, `T_UNSET`, `T_EMPTY`, `T_EVAL`, `T_EXIT`.
    Anywhere the parentheses for those tokens are "manually" determined, either for use in the sniff or to skip over them, you can now use the `parenthesis_owner`, `parenthesis_opener` and `parenthesis_closer` keys instead.

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### Namespaced Names

The tokenization of identifier names has changed.

This change was made in PHP itself in 8.0 and was "undone" in PHP_CodeSniffer for the PHPCS 3.x releases.
As of PHPCS 4.0, identifier names will tokenize following the PHP 8.0+ tokenization.

The following type of code is affected:

| Code                    | PHPCS 3.x tokenization                                                   | PHPCS 4.x tokenization                 |
| ----------------------- | ------------------------------------------------------------------------ | -------------------------------------- |
| `functionName()`        | `T_STRING` + parentheses                                                 | `T_STRING` + parentheses               |
| `Partially\qualified()` | `T_STRING`, `T_NS_SEPARATOR`, `T_STRING` + parentheses                   | `T_NAME_QUALIFIED` + parentheses       |
| `\Fully\qualified()`    | `T_NS_SEPARATOR`, `T_STRING`, `T_NS_SEPARATOR`, `T_STRING` + parentheses | `T_NAME_FULLY_QUALIFIED` + parentheses |
| `namespace\qualified()` | `T_NAMESPACE`, `T_NS_SEPARATOR`, `T_STRING` + parentheses                | `T_NAME_RELATIVE` + parentheses        |

A new `Tokens::NAME_TOKENS` token array containing the set of tokens used for tokenizing identifier names in PHPCS 4.x has been introduced to assist with mitigating this change.

The `Tokens::FUNCTION_NAME_TOKENS` token array, as well as the deprecated `Tokens::$functionNameTokens`, now also contains all identifier name tokens.

##### Upgrading

Typically, search your code base for use of the `Tokens::$functionNameTokens` token array, `T_NS_SEPARATOR`, `T_NAMESPACE` and `T_STRING` tokens and review whether the sniff/code is examining identifier names. If so, update the code to allow for the new tokens.

You may also want to search for checks involving `T_TRUE`, `T_FALSE` and `T_NULL` tokens, as if these are used in a fully qualified form, they will now tokenize as `T_NAME_FULLY_QUALIFIED`, so sniffs may need to take this into account.

> [!TIP]
> If you want to forbid the use of the fully qualified form of `true`/`false`/`null`, PHPCSExtra offers the [`Universal.PHP.NoFQNTrueFalseNull` sniff](https://github.com/PHPCSStandards/PHPCSExtra?tab=readme-ov-file#universalphpnofqntruefalsenull-wrench-books), which will do just that.

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### T_STATIC

The `static` keyword is normally tokenized as `T_STATIC`. However, there was one (odd) exception: `instanceof static`. In that case, the `static` keyword was tokenized as `T_STRING`.

This re-tokenization has now been removed.

##### Upgrading

* Search your sniffs/code for `T_INSTANCEOF` and `'static'` to find any potential work-arounds in place for the old tokenization. Those can now be removed.

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### T_OPEN_TAG

Long open tags will no longer include any whitespace. Previously the `T_OPEN_TAG` when used for long open tags could potentially include a single space or a new line character.
Any potential whitespace previously included will now be tokenized as `T_WHITESPACE` following the normal whitespace tokenization rules.

> [!NOTE]
> Short open tags, whether `<?` with `short_open_tags=on`, or `<?=` (`T_OPEN_TAG_WITH_ECHO`) already didn't contain any whitespace in the token contents.

##### Upgrading

* Search your sniffs/code for any code specifically checking `T_OPEN_TAG` tokens and whitespace contained in the token.
* Search for `new PHP('<?php ...` to check if whatever is being done there needs to take the split off of the whitespace into account.

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### `goto`

The `T_GOTO_LABEL` token used to be joined with the `:` following it and would include the colon in the token `'content'`. This has been undone and the label and the colon will now be tokenized as separate tokens, `T_GOTO_LABEL` and `T_GOTO_COLON` respectively.

And loosely related to this, if a PHP keyword is used as a label in a `goto` statement (= parse error), it will now be tokenized as `T_STRING` to prevent confusing sniffs.
"Semi-keywords", which are allowed as labels, will now consistently be tokenized as `T_STRING` when used in a `goto` statement.

To illustrate:
```php
goto bar; // T_GOTO T_WHITESPACE T_STRING.
echo 'hi';

bar: // T_GOTO_LABEL T_GOTO_COLON (was one token, T_GOTO_LABEL, with the colon included in the content).
haveSomeWater();

goto true; // T_GOTO T_WHITESPACE T_STRING (was T_GOTO T_WHITESPACE T_TRUE).
echo 'hi';

true: // T_GOTO_LABEL T_GOTO_COLON (was one token, T_GOTO_LABEL, with the colon included in the content).
doSomething();
```

##### Upgrading

* Search your sniffs/code for any code looking for `T_GOTO` or `T_GOTO_LABEL` tokens and evaluate if the code needs updating.

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### Other Tokenizer Changes

* All `T_DOC_COMMENT_*` tokens will now have the `comment_opener` and `comment_closer` indexes set.
    This should allow for more flexibility for sniffs examining aspects of docblocks.

* The `Tokens::FUNCTION_NAME_TOKENS` token array, as well as the deprecated `Tokens::$functionNameTokens`, now also contains the `T_ANON_CLASS` token.
    If you use this token array in your sniffs, you will need to evaluate whether this is a desired change or will need excluding.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Changes to abstract sniffs

The `AbstractPatternSniff::__construct()` method no longer takes any arguments. The `$ignoreComments` parameter was deprecated in PHPCS 1.4.0.

Since PHPCS 1.4.0, the  AbstractPatternSniff sets the `ignoreComments` option using a `public` var rather than through the constructor.
This allows the setting to be overwritten in `ruleset.xml` files.

#### Upgrading

* Search for sniffs which extend the `AbstractPatternSniff`.
* If the sniff calls the `parent::__construct()` method with an argument, remove the argument.
* Overload the `public $ignoreComments` property instead.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Changes to PHPCS native sniffs

#### Various sniffs listen to fewer tokens

If you have a custom sniff which extends any of the following classes AND has a custom `processVariable()` or `processVariableInString()` method, the sniff will break as those methods will no longer be called.
* `PHP_CodeSniffer\Standards\PEAR\Sniffs\NamingConventions\ValidVariableNameSniff`
* `PHP_CodeSniffer\Standards\PSR2\Sniffs\Classes\PropertyDeclarationSniff`
* `PHP_CodeSniffer\Standards\Squiz\Sniffs\Commenting\VariableCommentSniff`
* `PHP_CodeSniffer\Standards\Squiz\Sniffs\Scope\MemberVarScopeSniff`
* `PHP_CodeSniffer\Standards\Squiz\Sniffs\WhiteSpace\MemberVarSpacingSniff`

##### Upgrading

* Search for the above mentioned sniff class names and check if any of your sniffs `extend` these.
* Check if the sniff has a non-empty `processVariable()` or `processVariableInString()` method.
* If so, add the following to the sniff to revert to the old behaviour:
    ```php
    public function __construct()
    {
        AbstractVariableSniff::__construct();
    }
    ```

<p align="right"><a href="#table-of-contents">back to top</a></p>


#### PHP_CodeSniffer\Standards\Squiz\Sniffs\Classes\SelfMemberReferenceSniff

The `protected` `getDeclarationNameWithNamespace()` and `getNamespaceOfScope()` methods have been removed.

##### Upgrading

* Search for the above mentioned sniff class name and check if any of your sniffs `extend` this and uses either of the two removed methods.
* Refactor your code to use the new `PHP_CodeSniffer\Standards\Squiz\Sniffs\Classes\SelfMemberReferenceSniff::getNamespaceName()` method instead.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Miscellaneous other changes which may affect code extending PHP_CodeSniffer

* The `PHP_CodeSniffer\Config::setSettings()` method no longer returns any value.
    It was always declared as a `void` method, but was previously returning the set value.

* The `PHP_CodeSniffer\Config::printConfigData()` method is deprecated and should no longer be used. Use `echo Config::prepareConfigDataForDisplay()` instead once support for PHPCS 3.x is being dropped.

* The signature of the `DummyFile::setErrorCounts()` method has changed and now expects the following parameters: `$errorCount, $warningCount, $fixableErrorCount, $fixableWarningCount, $fixedErrorCount, $fixedWarningCount`.

* The abstract `PHP_CodeSniffer\Filters\ExactMatch::getBlacklist()` and `PHP_CodeSniffer\Filters\ExactMatch::getWhitelist()` methods have been replaced with abstract `PHP_CodeSniffer\ExactMatch::getDisallowedFiles()` and `PHP_CodeSniffer\ExactMatch::getAllowedFiles()` methods.
    If you have custom classes which extend the `ExactMatch` class, implement the new `getDisallowedFiles()` and `getAllowedFiles()` methods instead.
    Note: this is a name change only. The functionality remains the same.

* Various `print*(): void` methods in the Generator classes have been removed in favour of `get*(): string` methods.
    If you extend any of the `Generator` classes...:

    | Search for                                                        | Replace with                                                             |
    | ----------------------------------------------------------------- | ------------------------------------------------------------------------ |
    | `PHP_CodeSniffer\Generators\Text::printTitle()`                   | `PHP_CodeSniffer\Generators\Text::getFormattedTitle()`                   |
    | `PHP_CodeSniffer\Generators\Text::printTextBlock()`               | `PHP_CodeSniffer\Generators\Text::getFormattedTextBlock()`               |
    | `PHP_CodeSniffer\Generators\Text::printCodeComparisonBlock()`     | `PHP_CodeSniffer\Generators\Text::getFormattedCodeComparisonBlock()`     |
    | `PHP_CodeSniffer\Generators\Markdown::printHeader()`              | `PHP_CodeSniffer\Generators\Markdown::getFormattedHeader()`              |
    | `PHP_CodeSniffer\Generators\Markdown::printFooter()`              | `PHP_CodeSniffer\Generators\Markdown::getFormattedFooter()`              |
    | `PHP_CodeSniffer\Generators\Markdown::printTextBlock()`           | `PHP_CodeSniffer\Generators\Markdown::getFormattedTextBlock()`           |
    | `PHP_CodeSniffer\Generators\Markdown::printCodeComparisonBlock()` | `PHP_CodeSniffer\Generators\Markdown::getFormattedCodeComparisonBlock()` |
    | `PHP_CodeSniffer\Generators\HTML::printHeader()`                  | `PHP_CodeSniffer\Generators\HTML::getFormattedHeader()`                  |
    | `PHP_CodeSniffer\Generators\HTML::printToc()`                     | `PHP_CodeSniffer\Generators\HTML::getFormattedToc()`                     |
    | `PHP_CodeSniffer\Generators\HTML::printFooter()`                  | `PHP_CodeSniffer\Generators\HTML::getFormattedFooter()`                  |
    | `PHP_CodeSniffer\Generators\HTML::printTextBlock()`               | `PHP_CodeSniffer\Generators\HTML::getFormattedTextBlock()`               |
    | `PHP_CodeSniffer\Generators\HTML::printCodeComparisonBlock()`     | `PHP_CodeSniffer\Generators\HTML::getFormattedCodeComparisonBlock()`     |

* The `PHP_CodeSniffer\Reporter::$startTime` property has been removed. This property was unused since PHPCS 3.0.0.

* The `PHP_CodeSniffer\Reporter::$totalFixable` and `Reporter::$totalFixed` properties are deprecated and should no longer be used.
    Use respectively `(Reporter::$totalFixableErrors + Reporter::$totalFixableWarnings)` and `(Reporter::$totalFixedErrors + Reporter::$totalFixedWarnings)` instead.

* `PHP_CodeSniffer\Ruleset::setSniffProperty()`: the BC-layer supporting the old array format for the `$settings` parameter for the method has been removed.
    The `$settings` parameter must be passed as an array with the following two keys: `'scope'` and `'value'`, with `'scope'` being set to either `'sniff'` or `'standard'`, and `'value'` containing the new property value.
    Also see https://github.com/squizlabs/PHP_CodeSniffer/pull/3629

* Various class properties have been replaced with class constants. Where these were in the public API (= the below list), the properties still exist, but are now (soft) deprecated and will be removed in PHP_CodeSniffer 5.0.
  The visibility of the (deprecated) properties and their class constant replacements is the same.
  If you previously overloaded one of these properties in a custom sniff extending one of the affected sniffs, you will now need to overload the class constant.
  To obtain cross-version compatibility with PHPCS 3.x as well as 4.x, you may need to overload both the property as well as the constant.

| Search for                          | Replace with                         | Notes    |
| ----------------------------------- | ------------------------------------ | -------- |
| (`public`) `PHP_CodeSniffer\Util\Common::$allowedTypes`               | `PHP_CodeSniffer\Util\Common::ALLOWED_TYPES`  | |
| (`public`) `PHP_CodeSniffer\Tokenizers\PHP::$tstringContexts`               | `PHP_CodeSniffer\Tokenizers\PHP::T_STRING_CONTEXTS`  | |
| (`protected`) `PHP_CodeSniffer\Sniffs\AbstractVariableSniff::$phpReservedVars` | `PHP_CodeSniffer\Sniffs\AbstractVariableSniff::PHP_RESERVED_VARS` | |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff::$magicMethods` | `PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff::MAGIC_METHODS` | This also affects the `PHP_CodeSniffer\Standards\PSR1\Sniffs\Methods\CamelCapsMethodNameSniff` class which extends the `CamelCapsFunctionNameSniff` |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff::$methodsDoubleUnderscore` | `PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff::DOUBLE_UNDERSCORE_METHODS` | This also affects the `PHP_CodeSniffer\Standards\PSR1\Sniffs\Methods\CamelCapsMethodNameSniff` class which extends the `CamelCapsFunctionNameSniff` |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff::$magicFunctions` | `PHP_CodeSniffer\Standards\Generic\Sniffs\NamingConventions\CamelCapsFunctionNameSniff::MAGIC_FUNCTIONS` | This also affects the `PHP_CodeSniffer\Standards\PSR1\Sniffs\Methods\CamelCapsMethodNameSniff` class which extends the `CamelCapsFunctionNameSniff` |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\Files\ByteOrderMarkSniff::$bomDefinitions` | `PHP_CodeSniffer\Standards\Generic\Sniffs\Files\ByteOrderMarkSniff::BOM_DEFINITIONS` | |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\Files\InlineHTMLSniff::$bomDefinitions` | `PHP_CodeSniffer\Standards\Generic\Sniffs\Files\InlineHTMLSniff::BOM_DEFINITIONS` | |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\PHP\CharacterBeforePHPOpeningTagSniff::$bomDefinitions` | `PHP_CodeSniffer\Standards\Generic\Sniffs\PHP\CharacterBeforePHPOpeningTagSniff::BOM_DEFINITIONS` | |
| (`protected`) `PHP_CodeSniffer\Standards\Generic\Sniffs\VersionControl\SubversionPropertiesSniff::$properties` | `PHP_CodeSniffer\Standards\Generic\Sniffs\VersionControl\SubversionPropertiesSniff::REQUIRED_PROPERTIES` | |
| (`protected`) `PHP_CodeSniffer\Standards\PEAR\Sniffs\Commenting\FileCommentSniff::$tags` | `PHP_CodeSniffer\Standards\PEAR\Sniffs\Commenting\FileCommentSniff::EXPECTED_TAGS` | This also affects the `PHP_CodeSniffer\Standards\PEAR\Sniffs\Commenting\ClassCommentSniff` class which extends the `FileCommentSniff` |
| (`protected`) `PHP_CodeSniffer\Standards\PEAR\Sniffs\NamingConventions\ValidFunctionNameSniff::$magicMethods` | `PHP_CodeSniffer\Standards\PEAR\Sniffs\NamingConventions\ValidFunctionNameSniff::MAGIC_METHODS` | |
| (`protected`) `PHP_CodeSniffer\Standards\PEAR\Sniffs\NamingConventions\ValidFunctionNameSniff::$magicFunctions` | `PHP_CodeSniffer\Standards\PEAR\Sniffs\NamingConventions\ValidFunctionNameSniff::MAGIC_FUNCTIONS` | This also affects the `PHP_CodeSniffer\Standards\Squiz\Sniffs\NamingConventions\ValidFunctionNameSniff` class which extends the PEAR `ValidFunctionNameSniff` |
| (`protected`) `PHP_CodeSniffer\Standards\Squiz\Sniffs\PHP\DisallowSizeFunctionsInLoopsSniff::$forbiddenFunctions` | `PHP_CodeSniffer\Standards\Squiz\Sniffs\PHP\DisallowSizeFunctionsInLoopsSniff::FORBIDDEN_FUNCTIONS` | |

* The visibility of the following class constants has changed from `public` to `private`. If you used these in your own code, you will need to create your own constants instead:
    - `PHP_CodeSniffer\Generators\HTML::STYLESHEET`
    - `PHP_CodeSniffer\Util\Timing::MINUTE_IN_MS`
    - `PHP_CodeSniffer\Util\Timing::SECOND_IN_MS`

* The `PHP_CodeSniffer\Util\Standards::printInstalledStandards()` method is deprecated and should no longer be used. Use `echo PHP_CodeSniffer\Util\Standards::prepareInstalledStandardsForDisplay()` instead once support for PHPCS 3.x is being dropped.

* The `PHP_CodeSniffer\Utils\Timing` class is now a `final` class.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Unit Tests

### For standards using their own test framework

The Ruleset class now respects sniff selection via `--sniffs=...`, even when in a test context.

#### Upgrading

If your own test framework contained work-arounds to get round the previous restriction, it should now be safe to remove those work-arounds and to use the `--sniffs=...` argument when initiating the `Config` class.

Typically, these type of work-around can be found by searching for calls to the `Ruleset::registerSniffs()` method.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### For standards using the PHPCS native test framework

External standards which use the PHP_CodeSniffer native test framework as the basis for the sniff tests need to be aware of the following changes.
If an external standard uses its own test framework, this section can be skipped.

* The test setup now supports PHPUnit 8, 9, 10 and 11, which is in line with the new minimum PHP version of 7.2.
    Please read the changelogs for PHPUnit itself for information about the changes.
    Most notable changes which will likely impact your tests:
    - The test suite may need a separate PHPUnit config file for PHPUnit < 10 and PHPUnit 10+.
* The custom `TestSuite` setup has been removed from the framework as it is no longer needed since PEAR support was dropped and was incompatible with PHPUnit 10.
* All abstract base test cases now use the `TestCase` class name suffix.
    | Old Name                                              | New Name                                              |
    | ----------------------------------------------------- | ----------------------------------------------------- |
    | PHP_CodeSniffer\Tests\Core\AbstractMethodUnitTest     | PHP_CodeSniffer\Tests\Core\AbstractMethodTestCase     |
    | PHP_CodeSniffer\Tests\Standards\AbstractSniffUnitTest | PHP_CodeSniffer\Tests\Standards\AbstractSniffTestCase |
* Fixture methods no longer use the `@before|after[Class]` annotations, but use the PHPUnit `setUp|tearDown[BeforeClass|AfterClass]()` methods again.
    These methods now have `void` return type declarations.
* The global `printPHPCodeSnifferTestOutput()` function, which printed a "# sniff test files generated # unique error codes; # were fixable (#%)" summary after the tests is no longer available.
* The following properties which were previously available in the `AbstractSniffUnitTest` class have been removed:
    - `protected $backupGlobals`
    - `public $standardsDir`
    - `public $testsDir`
    The first is (very) old-school PHPUnit and should not be used anyway.
    The last two were never intended to be overwritten by concrete test classes, so shouldn't have been public properties.
* The following property which was previously available in the `AbstractMethodUnitTest` class has been removed:
    - `protected static $fileExtension`
       This property is redundant now support for JS/CSS files has been dropped.
* The test framework no longer uses global variables. I.e. the following are no longer available:
    - `$GLOBALS['PHP_CODESNIFFER_STANDARD_DIRS']`
    - `$GLOBALS['PHP_CODESNIFFER_TEST_DIRS']`
    - `$GLOBALS['PHP_CODESNIFFER_CONFIG']`
    - `$GLOBALS['PHP_CODESNIFFER_RULESETS']`
    - `$GLOBALS['PHP_CODESNIFFER_SNIFF_CASE_FILES']`
    - `$GLOBALS['PHP_CODESNIFFER_SNIFF_CODES']`
    - `$GLOBALS['PHP_CODESNIFFER_FIXABLE_CODES']`
* Sniff tests which extend the `AbstractSniffTestCase` for which no test case files (`.inc` files) can be found, will now be marked as "incomplete".
* Sniff tests which extend the `AbstractSniffTestCase` for which no `.fixed` files can be found, while the sniff would make fixes to the test case file, will now fail.

For compatibility with the PHP_CodeSniffer native test framework, the directory layout conventions and class naming conventions for tests have to be strictly followed and external standards which want to use the PHPCS native test framework need to be registered in the PHP_CodeSniffer `CodeSniffer.conf` file.
This is not really any different from before, just even more important now.

#### Upgrading

In practice this means the following for most test suites for external standards which extend the PHP_CodeSniffer native test suite:
1. In `composer.json`: update the PHPUnit version requirements.
    The PHP_CodeSniffer native test framework supports PHPUnit `^8.0 || ^9.3.4 || ^10.5.32 || ^11.3.3` as of PHP_CodeSniffer 4.0.0.
2. In the `phpunit.xml[.dist]` file: ensure that this file contains a `<testsuites>` element which points to your test directory/directories.
3. In the test bootstrap file: register your own standard and any other external standards your standard needs with the autoloader.
    Typically, this can be done using the following code snippet after loading the PHPCS `autoload.php` file:
    ```php
    $installedStandards = Standards::getInstalledStandardDetails();
    foreach ($installedStandards as $details) {
        Autoload::addSearchPath($details['path'], $details['namespace']);
    }
    ```
    > [!NOTE]
    > If you load the PHPCS test `bootstrap.php` file from within _your_ test `bootstrap.php` file, this is not needed, as the PHPCS bootstrap will already do this for you.
4. There is no need anymore to set the `PHPCS_IGNORE_TESTS` environment variable in a PHPUnit config file.
5. Update the import use statements for the sniff tests to point to the `AbstractSniffTestCase` and update the `extends` in the class declaration, like so:
    ```diff
    -use PHP_CodeSniffer\Tests\Standards\AbstractSniffUnitTest;
    +use PHP_CodeSniffer\Tests\Standards\AbstractSniffTestCase;

    -final class YourSniffNameUnitTest extends AbstractSniffUnitTest {
    +final class YourSniffNameUnitTest extends AbstractSniffTestCase {
    ```
    External standards which want to support PHP_CodeSniffer 3 and 4 and run their tests on both could consider aliasing the name of the test case class in their test bootstrap file.
6. Make sure that all `inc` test case files which test fixers are accompanied by a `.inc.fixed` file.
    In PHPCS 3.x, the test framework would already warn about any missing `.fixed` files. This has now become an error which will fail a test run.
7. For running the tests: do not pass the `./vendor/squizlabs/php_codesniffer/tests/AllTests.php` file anymore and the `--filter ExternalStndName` argument should also no longer be needed. Run the tests for your external standard by calling plain `phpunit`.


Additional changes may still be needed depending on whether your test suite contains custom test methods; test classes which don't extend the PHPCS test framework and/or whether you overload methods from the PHPCS test cases.

<p align="right"><a href="#table-of-contents">back to top</a></p>
