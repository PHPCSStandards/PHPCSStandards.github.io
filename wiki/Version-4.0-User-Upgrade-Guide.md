> [!CAUTION]
> PHP_CodeSniffer 4.0.0 is currently in the pre-release phase. The information in this upgrade guide is subject to change until PHP_CodeSniffer 4.0.0 has been released.
>
> If you find errors in this upgrade guide or would like to contribute improvements based on tests you've run with a PHP_CodeSniffer 4.0 pre-release, please [open an issue](https://github.com/PHPCSStandards/PHP_CodeSniffer/issues).


PHP_CodeSniffer version 4.0.0 contains a number of core changes and breaks backwards compatibility in select situations. The aim of this guide is to help **ruleset maintainers and end-users** to upgrade from PHP_CodeSniffer version 3.x to version 4.x.

There is a separate [[Upgrade Guide for Sniff Developers and Integrators|Version 4.0 Developer Upgrade Guide]] available.

## Table of contents

* [Should I upgrade ?](#should-i-upgrade-)
    * [External Standards](#external-standards)
* [How do I upgrade ?](#how-do-i-upgrade-)
    * [OMG BBQ, I'm inundated by deprecation notices from PHP_CodeSniffer 3.13.x!](#omg-bbq-im-inundated-by-deprecation-notices-from-php_codesniffer-313x)
* [Upgrading step by step](#upgrading-step-by-step)
    * [The minimum PHP version is now PHP 7.2.0](#the-minimum-php-version-is-now-php-720)
    * [Ruleset processing changes](#ruleset-processing-changes)
    * [Support for scanning JS/CSS files has been removed](#support-for-scanning-jscss-files-has-been-removed)
    * [Setting array properties for sniffs](#setting-array-properties-for-sniffs)
    * [Removed sniffs](#removed-sniffs)
    * [Removed error codes](#removed-error-codes)
    * [Changed error codes](#changed-error-codes)
    * [Removed sniff properties](#removed-sniff-properties)
    * [Ignore Annotation syntax](#ignore-annotation-syntax)
    * [Exit codes](#exit-codes)
    * [Branch rename in the PHP_CodeSniffer repo](#upcoming-branch-rename-in-the-php_codesniffer-repo)
* [Notable other changes and new features](#notable-other-changes-and-new-features)
    * [Progress, error and debug output is now send to STDERR](#progress-error-and-debug-output-is-now-send-to-stderr)
    * [Files without extension can now be scanned](#files-without-extension-can-now-be-scanned)
    * [Array properties can now extend default property values](#array-properties-can-now-extend-default-property-values)
    * [My scans are failing on a "No files were checked" error...](#my-scans-are-failing-on-a-no-files-were-checked-error)

## Should I upgrade ?

It is highly recommended to upgrade as soon as you are able.

The PHP_CodeSniffer 3.x branch will no longer receive updates, with the exception of security fixes and runtime compatibility fixes for new PHP versions.
This "limited support" will last a maximum of one year from the date of the PHP_Codesniffer 4.0.0 release.

### External Standards

If your project uses sniffs from external PHP_CodeSniffer standards, you will not be able to update until those external standards have been made compatible with PHP_CodeSniffer 4.0 and declared their compatibility.

This may take a little while. Please be patient and consider contributing to the project(s) if you get impatient (and even if you don't). :wink:

<p align="right"><a href="#table-of-contents">back to top</a></p>


## How do I upgrade ?

* Start by updating your PHP_CodeSniffer install to the most recent 3.x release, 3.13.0 or higher.
* Action any and all deprecation notices which you see when running a scan with PHP_CodeSniffer on that version. That should get you most of the way there.
* Next, read through the step-by-step upgrade information below and take any additional actions which may be needed for your project.

> [!IMPORTANT]
> PHP_CodeSniffer 4.0 will more strictly enforce certain conventions sniffs need to comply with, so you may need to contact the author(s) of custom sniffs you use and/or maintainer(s) of external standards you use, to inform them of any issues you encounter.

### OMG BBQ, I'm inundated by deprecation notices from PHP_CodeSniffer 3.13.x!

Deprecation notices are just _warnings_ about _upcoming_ changes. Nothing has changed yet and everything will still work the same as before.

If you are not ready to upgrade to PHP_CodeSniffer 4.0, you can safely ignore the deprecation notices until you are.

If you want, you can even silence them by running PHP_CodeSniffer in quiet mode by using the `-q` CLI flag.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Upgrading step by step

### The minimum PHP version is now PHP 7.2.0

This has no impact on the "code under scan", it just means that when running PHP_CodeSniffer, the minimum PHP version needs to be PHP 7.2.
As an example, you can run PHP_CodeSniffer on PHP 8.4 to scan a code base which is supposed to run on PHP 5.6.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Ruleset processing changes

Previously it was not possible to overrule a `<config>` directive set in an included ruleset from a top-level ("root") ruleset. Now you can.

For `<config>` directives, the highest level ruleset will now take precedence. When the `config` is set in two rulesets at the same inclusion level, the **_last_** included ruleset "wins".

Along the same lines, previously it was not possible to overrule a `<arg>` directive set in an included ruleset from a top-level ("root") ruleset. Now you can.

For `<arg>` directives, the highest level ruleset will now take precedence. When the `arg` is set in two rulesets at the same inclusion level, the **_first_** included ruleset "wins".

#### Upgrading

To get round the old limitations, it was previously recommended to add a second included ruleset and include it either before or after the ruleset causing the "problem", depending on whether the overruling problem was related to a `config` or an `arg` directive.

In both cases, this will still work, but is no longer needed. The secondary ruleset can be removed and the directive being overruled can be moved to the project root ruleset.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Support for scanning JS/CSS files has been removed

The capability for PHP_CodeSniffer to scan JS/CSS files has been removed completely.

* PHP_CodeSniffer native sniffs will now only target PHP files.
* All PHP_CodeSniffer native CSS/JS specific sniffs have been removed. See [Removed Sniffs](#removed-sniffs).

> [!WARNING]
> This also means that the `--extensions` command-line argument no longer takes a language "flavour" and that all files matching the (extension) criteria will now be scanned as if they were PHP files.

To continue running code style and code quality checks on JS and/or CSS files, use one of the many available dedicated JS/CSS scanning tools.

#### Upgrading

There are two kinds of sniffs which are affected by this:
1. Sniffs which are specific to JS/CSS and only target JS/CSS code.
    If you use JS/CSS specific sniffs from either PHP_CodeSniffer itself or from an external standard, remove references to these sniffs from your ruleset.
2. "Mixed" sniffs, i.e. sniffs which target both PHP as well as JS and/or CSS code.
    If an external standard you include in your ruleset contains these type of "mixed" sniffs, contact the maintainer of that standard about making the sniff compatible with PHP_CodeSniffer 4.0.

PHP_CodeSniffer >= 3.13.0 will show you deprecation notices for these sniffs to help you find them.

Secondly, review your `extensions` settings.
* If you have `extensions` set in a ruleset, like `<arg name="extensions" value="php,inc/php" />`, be sure to remove any non-PHP extensions.
    You can also remove the language part, i.e. `php,inc/php` becomes `php,inc`.
* Next, make sure to also check for any hard-coded commands which pass the `--extensions=...` CLI argument, like in continuous integration scripts.
    The same applies there: remove any non-PHP extensions and remove any potential language settings.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Setting array properties for sniffs

PHP_CodeSniffer 3.3.0 introduced a new syntax to set the value of array properties for sniffs by specifying array elements using a new `element` tag with `key` and `value` attributes. The old syntax was deprecated in the same PHP_CodeSniffer version.
Support for the old syntax has been removed in PHP_CodeSniffer 4.0.0.

#### Upgrading

If you haven't done so already, search your `[.]phpcs.xml[.dist]` file for `type="array"` to find all array property settings and verify if these have been updated to use the new syntax.

Example of what the old syntax looked like:
```xml
<property name="forbiddenFunctions" type="array" value="sizeof=>count,delete=>unset,print=>echo,is_null=>null,create_function=>null"/>
```

The above property setting should be rewritten to the new syntax like so:
```xml
<property name="forbiddenFunctions" type="array">
    <element key="sizeof" value="count"/>
    <element key="delete" value="unset"/>
    <element key="print" value="echo"/>
    <element key="is_null" value="null"/>
    <element key="create_function" value="null"/>
</property>
```

_Note: the `key` attribute on `element` nodes is optional._

See the [PHP_CodeSniffer 3.3.0 release notes](https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/3.3.0) for further information.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Removed sniffs

In PHP_CodeSniffer 4.0, all PHP_CodeSniffer native JS/CSS specific sniffs, as well as the sniffs from the `MySource` standard, have been removed.

Referencing a removed sniff from a (custom) ruleset will result in a "Referenced sniff does not exist" error.

#### Upgrading

If you haven't done so already, search your `[.]phpcs.xml[.dist]` file for...

| Search for                                  | Replace with                                                                            |
| ------------------------------------------- | --------------------------------------------------------------------------------------- |
| `Generic.Debug.*`                           | _(no replacement)_                                                                      |
| `Generic.Formatting.NoSpaceAfterCast`       | `Generic.Formatting.SpaceAfterCast` and set the [`spacing` property](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties#genericformattingspaceaftercast) of that sniff to 0`. |
| `Generic.Functions.CallTimePassByReference` | _(no replacement)_ Consider using the [PHPCompatibility](https://github.com/PHPCompatibility/PHPCompatibility) standard for detecting removed PHP features.                                                     |
| `MySource.*`                                | _(no replacement)_                                                                      |
| `Squiz.Classes.DuplicateProperty`           | _(no replacement)_                                                                      |
| `Squiz.CSS.*`                               | _(no replacement)_                                                                      |
| `Squiz.Debug.*`                             | _(no replacement)_                                                                      |
| `Squiz.Objects.DisallowObjectStringIndex`   | _(no replacement)_                                                                      |
| `Squiz.Objects.ObjectMemberComma`           | _(no replacement)_                                                                      |
| `Squiz.WhiteSpace.LanguageConstructSpacing` | `Generic.WhiteSpace.LanguageConstructSpacing`                                           |
| `Squiz.WhiteSpace.PropertyLabelSpacing`     | _(no replacement)_                                                                      |
| `Zend.Debug.CodeAnalyzer`                   | _(no replacement)_                                                                      |

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Removed error codes

As of PHP_CodeSniffer 4.0, PHP_CodeSniffer will no longer throw warnings about potential parse errors.
This was only done in a few places anyway, while the vast majority of sniffs would try to silently ignore code with parse errors.

> [!NOTE]
> _Results from PHP_CodeSniffer for code containing parse errors may not be correct or complete. It is strongly recommended to only run PHP_CodeSniffer on code which will compile without problems._

#### Upgrading

Search your `[.]phpcs.xml[.dist]` file for the below error codes. If these error codes are referenced in a ruleset, you should remove them.

| Search for and remove                                                    |
| ------------------------------------------------------------------------ |
| `Generic.Classes.OpeningBraceSameLine.MissingBrace`                      |
| `Internal.ParseError.InterfaceHasMemberVar`                              |
| `Internal.ParseError.EnumHasMemberVar`                                   |
| `PEAR.Classes.ClassDeclaration.MissingBrace`                             |
| `Squiz.Classes.ValidClassName.MissingBrace`                              |
| `Squiz.Commenting.ClosingDeclarationComment.Abstract`                    |
| `Squiz.Commenting.ClosingDeclarationComment.MissingBrace`                |
| `Squiz.ControlStructures.ForEachLoopDeclaration.MissingOpenParenthesis`  |
| `Squiz.ControlStructures.ForEachLoopDeclaration.MissingCloseParenthesis` |
| `Squiz.ControlStructures.ForEachLoopDeclaration.MissingAs`               |
| `Squiz.ControlStructures.ForLoopDeclaration.NoOpenBracket`               |
| `Squiz.ControlStructures.SwitchDeclaration.MissingColon`                 |

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Changed error codes

#### Upgrading

Search your `[.]phpcs.xml[.dist]` file for the below error codes. If these error codes are referenced in a ruleset, you should replace them.

| Search for                                                       | Replace with                                                                      |
| ---------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| `Generic.Formatting.MultipleStatementAlignment.IncorrectWarning` | `Generic.Formatting.MultipleStatementAlignment.Incorrect`                         |
| `Generic.Formatting.MultipleStatementAlignment.NotSameWarning`   | `Generic.Formatting.MultipleStatementAlignment.NotSame`                           |
| `Squiz.Classes.ValidClassName.NotCamelCaps`                      | `Squiz.Classes.ValidClassName.NotPascalCase`                                      |
| `Squiz.PHP.Heredoc.NotAllowed`                                   | `Squiz.PHP.Heredoc.HeredocNotAllowed` and/or `Squiz.PHP.Heredoc.NowdocNotAllowed` |
| `PSR12.Files.FileHeader.SpacingAfterBlock`                       | `PSR12.Files.FileHeader.SpacingAfterTagBlock`, `PSR12.Files.FileHeader.SpacingAfterDocblockBlock`, `PSR12.Files.FileHeader.SpacingAfterDeclareBlock`, `PSR12.Files.FileHeader.SpacingAfterNamespaceBlock`, `PSR12.Files.FileHeader.SpacingAfterUseBlock`, `PSR12.Files.FileHeader.SpacingAfterUseFunctionBlock` and/or `PSR12.Files.FileHeader.SpacingAfterUseConstBlock` |
| `PSR12.Files.FileHeader.SpacingInsideBlock`                      | `PSR12.Files.FileHeader.SpacingInsideUseBlock`, `PSR12.Files.FileHeader.SpacingInsideUseFunctionBlock` and/or `PSR12.Files.FileHeader.SpacingInsideUseConstBlock` |
| `Squiz.Commenting.VariableComment.TagNotAllowed`                 | `Squiz.Commenting.VariableComment.[TagName]TagNotAllowed` (`[TagName]` is dynamically generated based on the tags seen) |

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Removed sniff properties

The `error` property has been removed from the following sniffs:
* `Generic.Strings.UnnecessaryStringConcat`
* `Generic.Formatting.MultipleStatementAlignment`

#### Upgrading

Search your `[.]phpcs.xml[.dist]` file for the above mentioned sniffs and check if the `error` property has been set. If so, remove it.

Changing the message type for messages from these sniffs is still possible by using `<type>` instead, like so:
```xml
<rule ref="Generic.Strings.UnnecessaryStringConcat">
    <type>warning</type>
</rule>
```

> [!TIP]
> `<type>` can also be set for individual error codes, not just for the complete sniff.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Ignore Annotation syntax

PHP_CodeSniffer 3.2.0 introduced a new ignore annotation syntax and deprecated the old syntax. Support for the old syntax has been removed in PHP_CodeSniffer 4.0.

This means that any code violations which were previously ignored using the old syntax, will now no longer be ignored.

#### Upgrading

If you haven't done so already, execute a search & replace on your code base.

| Search for                      | Replace with       |
| ------------------------------- | ------------------ |
| `@codingStandardsIgnoreFile`    | `phpcs:ignoreFile` |
| `@codingStandardsIgnoreStart`   | `phpcs:disable`    |
| `@codingStandardsIgnoreEnd`     | `phpcs:enable`     |
| `@codingStandardsIgnoreLine`    | `phpcs:ignore`     |
| `@codingStandardsChangeSetting` | `phpcs:set`        |

> [!TIP]
> While doing the search & replace, also update the ignore annotations to be selective to prevent them ignoring too much.
>
> For more information about selectively ignoring parts of a file, see the [Advanced Usage page](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Advanced-Usage#ignoring-parts-of-a-file) and the [PHP_CodeSniffer 3.2.0 release notes](https://github.com/PHPCSStandards/PHP_CodeSniffer/releases/tag/3.2.0).

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Exit codes

The exit codes used by PHP_CodeSniffer have changed. This change was made primarily to allow for `phpcbf` to exit with a `0` exit code if all fixable issues were fixed and there are no non-auto-fixable issues remaining.

The pre-existing [`ignore_warnings_on_exit`](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Configuration-Options#ignoring-warnings-when-generating-the-exit-code) and [`ignore_errors_on_exit`](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Configuration-Options#ignoring-errors-when-generating-the-exit-code) config flags will still be respected.
Additionally, you can now use the new `ignore_non_auto_fixable_on_exit` config flag to ignore non-auto-fixable issues when the exit code is generated.

#### Upgrading

CI scripts or git pre-commit hooks may be checking explicitly for specific exit codes from PHP_CodeSniffer. If that's the case, these will need to be updated.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### [Upcoming] Branch rename in the PHP_CodeSniffer repo

Just before the final 4.0.0 release, the PHP_CodeSniffer `master` branch will be renamed to `3.x` and the default branch will change to `4.x`.

#### Upgrading

##### Referencing the PHP_CodeSniffer XSD file for rulesets

If your ruleset includes a reference to the PHP_CodeSniffer XSD file via a URL, that URL will become invalid.
As of mid May 2025, the current PHP_CodeSniffer ruleset XSD file can be referenced via the following permalink: `https://schema.phpcodesniffer.com/phpcs.xsd`.
Permalinks to the XSD file for specific minors are also available in the following format: `https://schema.phpcodesniffer.com/#.#/phpcs.xsd`.

Example changeset:
```diff
<ruleset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    name="Your ruleset name"
-   xsi:noNamespaceSchemaLocation="https://raw.githubusercontent.com/PHPCSStandards/PHP_CodeSniffer/master/phpcs.xsd">
+   xsi:noNamespaceSchemaLocation="https://schema.phpcodesniffer.com/phpcs.xsd">
```

Relative file references like `xsi:noNamespaceSchemaLocation="./vendor/squizlabs/php_codesniffer/phpcs.xsd"` will continue to be valid.

##### Referencing the main branches in the repo

If you reference a development version of PHP_CodeSniffer in your `composer.json` file or in CI scripts, those references will need to be updated.
What to update these to, depends on your use-case.

* If you want to use the latest development version of PHP_CodeSniffer, use the `4.x` branch. For Composer, references to the branch will need to look like this: `4.x-dev`.
* If you want the last development version of the `3.x` branch - previously `master`, use `3.x`.  For Composer, references to the branch will need to look like this: `3.x-dev`.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Notable other changes and new features

### Progress, error and debug output is now send to STDERR

This change should make it more straight-forward to pipe output from PHP_CodeSniffer to a file.

#### Upgrading

In odd cases, automated scripts piping PHP_CodeSniffer output to file may need updating and/or can be simplified.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Files without extension can now be scanned

Previously, files without extension were always ignored. Now, files without extension can be scanned, providing they are explicitly requested to be scanned.

#### Upgrading

If you want to start scanning a file without extension add it in a `<file>` directive in your ruleset, like so:
```xml
<file>file_without_extension</file>
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Array properties can now extend default property values

Previously a ruleset could already "extend" an array property for a sniff set by another ruleset.

As of PHP_CodeSniffer 4.0, a ruleset can also "extend" the default value of an array property as set in the sniff itself.

The upside of this is, that if you want to default value + some extras, you no longer need to duplicate the default values from sniff array properties in your ruleset.
The downside is, of course, that if the default value of the property in the sniff changes, your scans may start failing without warning.

#### Upgrading

Example of how to use this feature:

The current default value for the `forbiddenFunctions` property for the `Generic.PHP.ForbiddenFunctions` sniff is:
```php
$forbiddenFunctions = [
    'sizeof' => 'count',
    'delete' => 'unset',
];
```

Previously, if you wanted to add to this default value, you would need to duplicate it and then add your own values:
```xml
<property name="forbiddenFunctions" type="array">
    <!-- Original values -->
    <element key="sizeof" value="count"/>
    <element key="delete" value="unset"/>
    <!-- Your own values -->
    <element key="print" value="echo"/>
</property>
```

Now you can "inherit" the default value and add to it by using `extend="true"`:
```xml
<property name="forbiddenFunctions" type="array" extend="true">
    <element key="print" value="echo"/>
</property>
```

<p align="right"><a href="#table-of-contents">back to top</a></p>


### My scans are failing on a "No files were checked" error...

Between the extension filtering via `--extensions=...` (CLI) / `<arg name="extensions" value="..."/>` (ruleset), potential `--ignore=...` (CLI) / `<exclude-pattern>...` (ruleset) directives being followed, and potential `--filter=...` directives, there are no files eligible for scanning.

Review your CLI command/ruleset to ensure these directives are set correctly.

<p align="right"><a href="#table-of-contents">back to top</a></p>
