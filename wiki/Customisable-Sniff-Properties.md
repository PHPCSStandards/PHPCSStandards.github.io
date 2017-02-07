> Note: This page is a work in progress. The content and structure may change but the information provided is accurate. It is not recommended to link to sections within this document until it has been completed.

The behaviour of some sniffs can be changed by setting certain sniff properties in your ruleset.xml file. On this page you will find the properties used in the various standards which are available for customisation.

For more information about changing sniff behaviour by customising your ruleset and how on how to pass different types of values via the ruleset, please read the [Annotated ruleset wiki page](https://github.com/squizlabs/PHP_CodeSniffer/wiki/Annotated-ruleset.xml).

## Table of contents

* [Generic properties used across standards](#generic-properties-used-across-standards)
    + [Changing the message type](#changing-the-message-type)
    + [Code indentation](#code-indentation)
    + [Spacing inside parenthesis for function calls and control structures](#spacing-inside-parenthesis-for-function-calls-and-control-structures)
    + [Ignoring comments in sniffs based on patterns](#ignoring-comments-in-sniffs-based-on-patterns)
* [Standard: Generic](#standard-generic)
    + [CodeAnalysis: Unused function parameters](#codeanalysis-unused-function-parameters)
    + [Debug: Google Closure JSLinter](#debug-google-closure-jslinter)
    + [Files: Line endings](#files-line-endings)
    + [Files: Line length](#files-line-length)
    + [Formatting: assignment alignment](#formatting-assignment-alignment)
    + [Functions: opening brace style for functions and closures](#functions-opening-brace-style-for-functions-and-closures)
    + [Metrics: Cyclomatic complexity](#metrics-cyclomatic-complexity)
    + [Metrics: nesting levels](#metrics-nesting-levels)
    + [Naming Conventions: CamelCaps function names](#naming-conventions-camelcaps-function-names)
    + [PHP: Forbidden PHP functions](#php-forbidden-php-functions)
    + [PHP: Deprecated PHP functions](#php-deprecated-php-functions)
    + [Strings: Unnecessary string concat](#strings-unnecessary-string-concat)
    + [Whitespace: Scope indent](#whitespace-scope-indent)
* [Standard: PEAR](#standard-pear)
    + [Functions: Function call signature / multi-line](#functions-function-call-signature-multi-line)
    + [Whitespace: Scope indent](#whitespace-scope-indent-1)
* [Standard: Squiz](#standard-squiz)
    + [Commenting: Long conditions closing comments](#commenting-long-conditions-closing-comments)
    + [Functions: Function declaration argument spacing](#functions-function-declaration-argument-spacing)
    + [PHP: Commented out code](#php-commented-out-code)
    + [PHP: Discouraged and Forbidden functions](#php-discouraged-and-forbidden-functions)
    + [Strings: Concatenation spacing](#strings-concatenation-spacing)
    + [Whitespace: Function spacing](#whitespace-function-spacing)
    + [Whitespace: Object operator spacing](#whitespace-object-operator-spacing)
    + [Whitespace: Operator spacing](#whitespace-operator-spacing)
    + [Whitespace: Superfluous whitespace](#whitespace-superfluous-whitespace)


**Note**: The `MySource`, `PSR1`, `PSR2` and `Zend` standards do not have any customizable properties at this moment.


## Generic properties used across standards

### Changing the message type

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.ControlStructures.InlineControlStructure` | `error` | bool | `true` | 1.2.2
`Generic.Formatting.MultipleStatementAlignment` | `error` | bool | `false` | 1.2.2
`Generic.PHP.ForbiddenFunctions` | `error` | bool | `true` | 1.2.2
`Generic.PHP.DeprecatedFunctions` | `error` | bool | `true` | 1.2.2
`Generic.PHP.NoSilencedErrors` | `error` | bool | `false` | 1.2.2
`Generic.Strings.UnnecessaryStringConcat` | `error` | bool | `true` | 1.2.2
`Squiz.CSS.ForbiddenStyles` | `error` | bool | `true` | 1.4.6
`Squiz.PHP.DiscouragedFunctions` | `error` | bool | `false` | 1.2.2
`Squiz.PHP.ForbiddenFunctions` | `error` | bool | `false` | 1.2.2

If the `error` property is set to `true`, an error will be thrown for violations found by these sniffs; otherwise a warning.

```xml
<rule ref="Generic.ControlStructures.InlineControlStructure">
	<properties>
		<property name="error" value="false" />
	</properties>
</rule>
```

**_Note_**: for individual error codes, _i.e. `Standard.Category.SniffName.ErrorCode`_, for these and all other sniffs, you can also change the message type using the `<type>warning</type>` syntax.


### Code indentation

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.WhiteSpace.ScopeIndent` | `indent` | int | `4` | 1.2.2
`PEAR.Classes.ClassDeclaration` | `indent` | int | `4` | 1.3.1
`PEAR.ControlStructures.MultiLineCondition` | `indent` | int | `4` | 1.4.7
`PEAR.Formatting.MultiLineAssignment` | `indent` | int | `4` | 1.4.7
`PEAR.Functions.FunctionCallSignature` | `indent` | int | `4` | 1.3.4
`PEAR.Functions.FunctionDeclaration` | `indent` | int | `4` | 1.4.7
`PEAR.WhiteSpace.ObjectOperatorIndent` | `indent` | int | `4` | 1.4.6
`PEAR.WhiteSpace.ScopeClosingBrace` | `indent` | int | `4` | 1.3.4
`PEAR.WhiteSpace.ScopeIndent` | `indent` | int | `4` | 1.2.2 (inherited from `Generic.WhiteSpace.ScopeIndent`)
`PSR2.Classes.ClassDeclaration` | `indent` | int | `4` | 1.3.5 (inherited from `PEAR.Classes.ClassDeclaration`)
`PSR2.ControlStructures.SwitchDeclaration` | `indent` | int | `4` | 1.4.5
`Squiz.Classes.ClassDeclaration` | `indent` | int | `4` | 1.3.5 (inherited from `PEAR.Classes.ClassDeclaration` via `PSR2.Classes.ClassDeclaration`)
`Squiz.ControlStructures.SwitchDeclaration` | `indent` | int | `4` | 1.4.7
`Squiz.CSS.Indentation` | `indent` | int | `4` | 1.4.7

Each of these sniffs verify code indentation for their target structures.

You can customize the number of spaces code should be indented by setting the `indent` property to the size of a single indent.

```xml
<rule ref="Generic.WhiteSpace.ScopeIndent">
	<properties>
		<property name="indent" value="8" />
	</properties>
</rule>
```


### Spacing inside parenthesis for function calls and control structures

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`PEAR.Functions.FunctionCallSignature` | `requiredSpacesAfterOpen` | int | `0` | 1.5.2
`PEAR.Functions.FunctionCallSignature` | `requiredSpacesBeforeClose` | int | `0` | 1.5.2
`PSR2.ControlStructures.ControlStructureSpacing` | `requiredSpacesAfterOpen` | int | `0` | 1.5.2
`PSR2.ControlStructures.ControlStructureSpacing` | `requiredSpacesBeforeClose` | int | `0` | 1.5.2
`Squiz.ControlStructures.ForEachLoopDeclaration` | `requiredSpacesAfterOpen` | int | `0` | 1.5.2
`Squiz.ControlStructures.ForEachLoopDeclaration` | `requiredSpacesBeforeClose` | int | `0` | 1.5.2
`Squiz.ControlStructures.ForLoopDeclaration` | `requiredSpacesAfterOpen` | int | `0` | 1.5.2
`Squiz.ControlStructures.ForLoopDeclaration` | `requiredSpacesBeforeClose` | int | `0` | 1.5.2
`Squiz.Functions.FunctionDeclarationArgumentSpacing` | `requiredSpacesAfterOpen` | int | `0` | 1.5.2
`Squiz.Functions.FunctionDeclarationArgumentSpacing` | `requiredSpacesBeforeClose` | int | `0` | 1.5.2

Each of these sniffs verify the spacing on the inside of parenthesis for their various targets.

For each of these, you can customize:
* How many spaces should follow the opening bracket.
* How many spaces should precede the closing bracket.

```xml
<rule ref="PEAR.Functions.FunctionCallSignature">
	<properties>
		<property name="requiredSpacesAfterOpen" value="1" />
		<property name="requiredSpacesBeforeClose" value="1" />
	</properties>
</rule>
```


### Ignoring comments in sniffs based on patterns

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
_`PHP_CodeSniffer_Standards_AbstractPatternSniff`_ | _`ignoreComments`_ | _bool_ | _`false`_ | _1.4.0_
`PEAR.ControlStructures.ControlSignature` | `ignoreComments` | bool | `true` | 1.4.0 (inherited from `AbstractPattern`)
`Squiz.Functions.FunctionDeclaration` | `ignoreComments` | bool | `false` | 1.4.0 (inherited from `AbstractPattern`)

These sniffs verify that their target code structures comply with a certain pattern.

You can customize the behaviour by setting the `ignoreComments` property.
If set to `true`, comments will be ignored if they are found in the target code.

This property is available to any sniff which extends the `PHP_CodeSniffer_Standards_AbstractPatternSniff`.


```xml
<rule ref="PEAR.ControlStructures.ControlSignature">
	<properties>
		<property name="ignoreComments" value="false" />
	</properties>
</rule>
```



## Standard: Generic


### CodeAnalysis: Unused function parameters

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.CodeAnalysis.UnusedFunctionParameter` | `ignore_extended_classes` | bool | `false` | 2.8.1
`Generic.CodeAnalysis.UnusedFunctionParameter` | `allow_for_callbacks` | bool | `false` | 2.8.1

The `Generic.CodeAnalysis.UnusedFunctionParameter` sniff checks for unused function parameters.
The sniff checks that all function parameters are used in the function body.

By default, an exception is made for empty function bodies or function bodies that only contain comments when they are in a class that implements an interface.
This is intended to prevent false positives for classes that implement an interface that defines multiple methods but the implementation only needs some of them.

Since PHPCS 2.8.1, there are two configurable options:
* Setting the `ignore_extended_classes` property to `true` will completely ignore unused function parameters for methods in classes that extend another class or implement an interface.

    The function signature of methods in extended classes has to mirror the method as defined in the parent class/interface, even though the overloaded/implemented method may not use all params.
* Setting the `allow_for_callbacks` property to `true` will only report on unused parameters which are declared after the last used parameter as callback functions may not use all parameters passed, but have to allow in their function signature for the ones they *do* use to be passed to them.

```xml
<rule ref="Generic.CodeAnalysis.UnusedFunctionParameter">
	<properties>
		<property name="ignore_extended_classes" value="true" />
		<property name="allow_for_callbacks" value="true" />
	</properties>
</rule>
```


### Debug: Google Closure JSLinter

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Debug.ClosureLinter` | `errorCodes` | array | - | 1.2.2
`Generic.Debug.ClosureLinter` | `ignoreCodes` | array | - | 1.2.2

The `Generic.Debug.ClosureLinter` sniff runs the `gjslint` tool over the files.

By default, it will throw warnings for any infractions found.

There are two configurable options:
* `errorCodes` allows you to pass a list of error codes that should show errors instead of warnings.
* `ignoreCodes` allows you to pass a list of error codes which should be ignored.

```xml
<rule ref="Generic.Debug.ClosureLinter">
	<properties>
		<property name="errorCodes" type="array" value="..." />
		<property name="ignoreCodes" type="array" value="..." />
	</properties>
</rule>
```


### Files: Line endings

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Files.LineEndings` | `eolChar` | string | `\n` | 1.2.2

The `Generic.Files.LineEndings` sniff checks that end of line characters are correct.

By setting the `eolChar` property, you can customize the end of line character which will be considered valid.

```xml
<rule ref="Generic.Files.LineEndings">
	<properties>
		<property name="eolChar" value="\r\n" />
	</properties>
</rule>
```


### Files: Line length

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Files.LineLength` | `lineLimit` | int | `80` | 1.2.2
`Generic.Files.LineLength` | `absoluteLineLimit` | int | `100` | 1.2.2

The `Generic.Files.LineLength` sniff checks all lines in the file, and throws warnings if they are over `lineLimit` (80) characters in length and errors if they are over `absoluteLineLimit` (100) in length.

Both line limites be configured:
* `lineLimit` allows you to customize the limit that the length of a line **_should_** not exceed (warning).
* `absoluteLineLimit` allows you to customize the limit that the length of a line **_must_** not exceed (error).

    Set this property to zero (0) to disable.

```xml
<rule ref="Generic.Files.LineLength">
	<properties>
		<property name="lineLimit" value="100" />
		<property name="absoluteLineLimit" value="135" />
	</properties>
</rule>
```



### Formatting: assignment alignment

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Formatting.MultipleStatementAlignment` | `maxPadding` | int | `1000` | 1.2.2

The `Generic.Formatting.MultipleStatementAlignment` sniff checks the alignment of assignments. If there are multiple adjacent assignments, it will check that the equals signs of each assignment are aligned.

However, sometimes the difference in alignment between two adjacent assignments is quite large and aligning would create extremely long lines.

By setting the `maxPadding` property, you can configure the maximum amount of padding required to align the assignment with the surrounding assignments before the alignment is ignored and no warnings will be thrown.

```xml
<rule ref="Generic.Formatting.MultipleStatementAlignment">
	<properties>
		<property name="maxPadding" value="50" />
	</properties>
</rule>
```


### Functions: opening brace style for functions and closures

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Functions.OpeningFunctionBraceBsdAllman` | `checkFunctions` | bool | `true` | 2.3.0
`Generic.Functions.OpeningFunctionBraceBsdAllman` | `checkClosures` | bool | `false` | 2.3.0
`Generic.Functions.OpeningFunctionBraceKernighanRitchie` | `checkFunctions` | bool | `true` | 2.3.0
`Generic.Functions.OpeningFunctionBraceKernighanRitchie` | `checkClosures` | bool | `false` | 2.3.0

The `Generic.Functions.OpeningFunctionBraceBsdAllman` and `Generic.Functions.OpeningFunctionBraceKernighanRitchie` sniffs check the position of the opening brace of a function and/or closure (anonymous function).

By default, both sniffs only check the opening brace position of functions.

You can customize the behaviour by toggling the value of the `checkFunctions` and `checkClosures` properties.

```xml
<rule ref="Generic.Functions.OpeningFunctionBraceBsdAllman">
	<properties>
		<!-- Don't check function braces, but check closure braces. -->
		<property name="checkFunctions" value="false" />
		<property name="checkClosures" value="true" />
	</properties>
</rule>
```


### Metrics: Cyclomatic complexity

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Metrics.CyclomaticComplexity` | `complexity` | int | `10` | 1.2.2
`Generic.Metrics.CyclomaticComplexity` | `absoluteComplexity` | int | `20` | 1.2.2

As the name implies, the `Generic.Metrics.CyclomaticComplexity` sniff checks the cyclomatic complexity (McCabe) for functions.

The cyclomatic complexity indicates the complexity within a function by counting the different paths the function includes.

You can configure this sniff as follows:
* `complexity` allows you to customize the cyclomatic complexity above which this sniff will start throwing warnings.
* `absoluteComplexity` allows you to customize the cyclomatic complexity above which this sniff will start throwing errors.

```xml
<rule ref="Generic.Metrics.CyclomaticComplexity">
	<properties>
		<property name="complexity" value="15" />
		<property name="absoluteComplexity" value="30" />
	</properties>
</rule>
```


### Metrics: nesting levels

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Metrics.NestingLevel` | `nestingLevel` | int | `5` | 1.2.2
`Generic.Metrics.NestingLevel` | `absoluteNestingLevel` | int | `10` | 1.2.2

As the name implies, the `Generic.Metrics.NestingLevel` sniff checks the nesting level for methods.

You can configure this sniff as follows:
* `nestingLevel` allows you to customize the nesting level above which this sniff will start throwing warnings.
* `absoluteNestingLevel` allows you to customize the nesting level above which this sniff will start throwing errors.

```xml
<rule ref="Generic.Metrics.NestingLevel">
	<properties>
		<property name="nestingLevel" value="8" />
		<property name="absoluteNestingLevel" value="12" />
	</properties>
</rule>
```


### Naming Conventions: CamelCaps function names

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.NamingConventions.CamelCapsFunctionName` | `strict` | bool | `true` | 1.3.5

The `Generic.NamingConventions.CamelCapsFunctionName` sniff ensures function and method names are in CamelCaps.

Stricly speaking, in CamelCaps format, a name cannot have two capital letters next to each other.

By setting the `strict` property to `false`, the sniff applies the rules more leniently and allows for two capital letters next to each other in function and method names.

```xml
<rule ref="Generic.NamingConventions.CamelCapsFunctionName">
	<properties>
		<property name="strict" value="false" />
	</properties>
</rule>
```


### PHP: Forbidden PHP functions

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.PHP.ForbiddenFunctions` | `forbiddenFunctions` | array | `array( 'sizeof' => 'count', 'delete' => 'unset' )` | 2.0.0

The `Generic.PHP.ForbiddenFunctions` sniff discourages the use of alias functions that are kept in PHP for compatibility with older versions.

The sniff can be used to forbid the use of any function by setting the `forbiddenFunctions` property in your ruleset.

The property is expected to be in array format. The array keys are the names of the function to forbid. The array values are the names of suggested alternative functions to use instead. Use `null` as the value if no alternative exists, i.e. the function should just not be used.

```xml
<rule ref="Generic.PHP.ForbiddenFunctions">
	<properties>
		<property name="forbiddenFunctions" type="array" value="delete=>unset,print=>echo,create_function=>null" />
	</properties>
</rule>
```

### PHP: Deprecated PHP functions

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.PHP.DeprecatedFunctions` | `forbiddenFunctions` | array | _will be automagically filled with all PHP deprecated functions in the PHP version you are using via the Reflection API_ | 2.0.0 (inherited from `Generic.PHP.ForbiddenFunctions`)

This sniff discourages the use of deprecated functions that are kept in PHP for compatibility with older versions.

**Overloading strongly discouraged!!!!! Overload the same property in the `Generic.PHP.ForbiddenFunctions` sniff instead.**


### Strings: Unnecessary string concat

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.Strings.UnnecessaryStringConcat` | `allowMultiline` | bool | `false` | 2.3.4

The `Generic.Strings.UnnecessaryStringConcat` sniff checks that two strings are not concatenated together and suggests  using one string instead.

By changing the `allowMultiline` property to `true`, you can make the sniff more lenient and allow strings concatenated over multiple lines.
This is particularly useful if you break strings over multiple lines to work within a maximum line length.

```xml
<rule ref="Generic.Strings.UnnecessaryStringConcat">
	<properties>
		<property name="allowMultiline" value="true" />
	</properties>
</rule>
```


### Whitespace: Scope indent

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Generic.WhiteSpace.ScopeIndent` | `exact` | bool | `false` | 1.2.2
`Generic.WhiteSpace.ScopeIndent` | `tabIndent` | bool | `false` | 2.0.0
`Generic.WhiteSpace.ScopeIndent` | `ignoreIndentationTokens` | array | - | 1.4.5

The `Generic.WhiteSpace.ScopeIndent` sniff checks that control structures are structured correctly, and their content is indented correctly. This sniff will throw errors if tabs are used for indentation rather than spaces.

This sniff has three properties you can use to constomize its behaviour:
* The `exact` property is used to determine whether an indent is treated as an exact number or as a minimum amount. I.e. if set to `false`, the indent needs to be at least $indent spaces (but can be more).
* If you prefer using tabs instead of spaces, you can indicate this by setting `tabIndent` to `true`.

    In that case, tabs will be accepted for indentation and fixes will be made using tabs instead of spaces.

    **Note**: The size of each tab is important, so it should be specified using the `--tab-width` CLI argument or by adding `<arg name="tab-width" value="4"/>` to your ruleset.
* By setting the `ignoreIndentationTokens` property, you can provide the sniff with a list of tokens which do not need to be checked for indentation.

    Useful to easily ignore/skip some tokens from verification. For example, inline HTML sections or PHP open/close tags.

    It is advised to ensure that tokens you ignore here will be checked for their own rules elsewhere.

```xml
<rule ref="Generic.WhiteSpace.ScopeIndent">
	<properties>
		<property name="exact" value="true" />
		<property name="tabIndent" value="true" />
		<property name="ignoreIndentationTokens" type="array" value="T_HEREDOC,T_NOWDOC" />
	</properties>
</rule>
```



## Standard: PEAR


### Functions: Function call signature / multi-line

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`PEAR.Functions.FunctionCallSignature` | `allowMultipleArguments` | bool | `true` | 1.3.6

According to the PEAR coding standards:
> Functions should be called with no spaces between the function name, the opening parenthesis, and the first parameter; and no space between the last parameter, the closing parenthesis, and the semicolon.

Setting the `allowMultipleArguments` property to `true`, allows for multiple arguments to be defined per line in a multi-line call.

```xml
<rule ref="PEAR.Functions.FunctionCallSignature">
	<properties>
		<property name="allowMultipleArguments" value="false" />
	</properties>
</rule>
```


### Whitespace: Scope indent

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`PEAR.WhiteSpace.ScopeIndent` | `exact` | bool | `false` | 1.2.2 (inherited from `Generic.WhiteSpace.ScopeIndent`)
`PEAR.WhiteSpace.ScopeIndent` | `tabIndent` | bool | `false` | 2.0.0 (inherited from `Generic.WhiteSpace.ScopeIndent`)
`PEAR.WhiteSpace.ScopeIndent` | `ignoreIndentationTokens` | array | - | 1.4.5 (inherited from `Generic.WhiteSpace.ScopeIndent`)

See: [Generic Standard - Whitespace: Scope indent](#whitespace-scope-indent)

```xml
<rule ref="PEAR.WhiteSpace.ScopeIndent">
	<properties>
		<property name="exact" value="true" />
		<property name="tabIndent" value="true" />
		<property name="ignoreIndentationTokens" type="array" value="T_HEREDOC,T_NOWDOC" />
	</properties>
</rule>
```



## Standard: Squiz


### Commenting: Long conditions closing comments

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.Commenting.LongConditionClosingComment` | `lineLimit` | int | `20` | 2.7.0
`Squiz.Commenting.LongConditionClosingComment` | `commentFormat` | string | `//end %s` | 2.7.0

The `Squiz.Commenting.LongConditionClosingComment` sniff checks that long blocks of code have a closing comment.

* The `lineLimit` property allows you to configure the length that a code block must be before requiring a closing comment.
* The `commentFormat` property allows you to configure the format the end comment should be in.

    The placeholder %s will be replaced with the type of condition opener.

```xml
<rule ref="Squiz.Commenting.LongConditionClosingComment">
	<properties>
		<property name="lineLimit" value="40" />
		<property name="commentFormat" value="// End %s()" />
	</properties>
</rule>
```


### Functions: Function declaration argument spacing

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.Functions.FunctionDeclarationArgumentSpacing` | `equalsSpacing` | int | `0` | 1.3.5

The `Squiz.Functions.FunctionDeclarationArgumentSpacing` sniff checks that arguments in function declarations are spaced correctly, including default parameter values.

By setting the `equalsSpacing` property, you can customize how many spaces should surround the equals signs.

```xml
<rule ref="Squiz.Functions.FunctionDeclarationArgumentSpacing">
	<properties>
		<property name="equalsSpacing" value="1" />
	</properties>
</rule>
```


### PHP: Commented out code

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.PHP.CommentedOutCode` | `maxPercentage` | int | `35` | 1.3.3

This sniff warns about commented out code.

By default, if a comment is more than 35% code, a warning will be shown.

By setting the `maxPercentage` property, you can customize the threshold used to determine whether a warning will be shown or not.

```xml
<rule ref="Squiz.PHP.CommentedOutCode">
	<properties>
		<property name="maxPercentage" value="50" />
	</properties>
</rule>
```


### PHP: Discouraged and Forbidden functions

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.PHP.DiscouragedFunctions` | `forbiddenFunctions` | array | `array( 'error_log' => null, 'print_r' => null, 'var_dump' => null )` | 2.0.0 (inherited from `Generic.PHP.ForbiddenFunctions`)
`Squiz.PHP.ForbiddenFunctions` | `forbiddenFunctions` | array | `array( 'sizeof' => 'count', 'delete' => 'unset', 'print' => 'echo', 'is_null' => null, 'create_function' => null )` | 2.0.0 (inherited from `Generic.PHP.ForbiddenFunctions`)

See: [Generic standard - PHP: Forbidden PHP functions](#php-forbidden-php-functions)

**Overloading strongly discouraged!!!!! Overload the same property in the `Generic.PHP.ForbiddenFunctions` sniff instead or extend that class like these sniffs do.**


### Strings: Concatenation spacing

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.Strings.ConcatenationSpacing` | `spacing` | int | `0` | 2.0.0
`Squiz.Strings.ConcatenationSpacing` | `ignoreNewlines` | bool | `false` | 2.3.1

The `Squiz.Strings.ConcatenationSpacing` sniff verifies the number of spaces between the concatenation operator `.` and the strings being concatenated.

There are two configurable options:
* `spacing` allows you set the number of spaces which should be before and after a string concat.
* Setting `ignoreNewlines` to `true` allows for newline characters to be ignored when checking for infractions.

    This is particularly useful if you break a concatenation sequence over multiple lines to work within a maximum line length.

```xml
<rule ref="Squiz.Strings.ConcatenationSpacing">
	<properties>
		<property name="spacing" value="1" />
		<property name="ignoreNewlines" value="true" />
	</properties>
</rule>
```


### Whitespace: Function spacing

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.WhiteSpace.FunctionSpacing` | `spacing` | int | `2` | 1.4.5

This sniff checks the separation between methods in a class or interface.

Using the `Squiz.WhiteSpace.FunctionSpacing` property, you can configure the number of blank lines required between functions.

```xml
<rule ref="Squiz.WhiteSpace.FunctionSpacing">
	<properties>
		<property name="spacing" value="1" />
	</properties>
</rule>
```


### Whitespace: Object operator spacing

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.WhiteSpace.ObjectOperatorSpacing` | `ignoreNewlines` | bool | `false` | 2.7.0

The `Squiz.WhiteSpace.ObjectOperatorSpacing` sniff ensures there is no whitespace before/after an object operator.

Setting `ignoreNewlines` to `true` allows for newline characters to be ignored when checking for infractions.
This is particularly useful if you break a chained object function call over multiple lines.


```xml
<rule ref="Squiz.WhiteSpace.ObjectOperatorSpacing">
	<properties>
		<property name="ignoreNewlines" value="true" />
	</properties>
</rule>
```

### Whitespace: Operator spacing

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.WhiteSpace.OperatorSpacing` | `ignoreNewlines` | bool | `false` | 2.2.0

The `Squiz.WhiteSpace.OperatorSpacing` sniff verifies that operators have valid spacing surrounding them.

Setting `ignoreNewlines` to `true` allows for newline characters to be ignored when checking for infractions.
This is particularly useful if you break up a long sequence, such as a calculation with a large number of parts, over multiple lines to work within a maximum line length.

```xml
<rule ref="Squiz.WhiteSpace.OperatorSpacing">
	<properties>
		<property name="ignoreNewlines" value="true" />
	</properties>
</rule>
```


### Whitespace: Superfluous whitespace

Sniff | Property name | Property type | Default: | Available since:
----- | ------------- | ------------- | -------- | ----------------
`Squiz.WhiteSpace.SuperfluousWhitespace` | `ignoreBlankLines` | bool | `false` | 1.4.2

The `Squiz.WhiteSpace.SuperfluousWhitespace` sniff checks that:
* No whitespace preceeds the first content of the file.
* Exists after the last content of the file.
* Resides after content on any line.
* There are no consecutive empty lines in functions.

When the `ignoreBlankLines` property is set to `true`, blank lines - i.e. lines that contain only whitespace - are not checked for these whitespace rules.

```xml
<rule ref="Squiz.WhiteSpace.SuperfluousWhitespace">
	<properties>
		<property name="ignoreBlankLines" value="true" />
	</properties>
</rule>
```
