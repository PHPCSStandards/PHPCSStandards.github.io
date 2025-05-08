## Table of contents

* [A Project ruleset or a standard ?](#a-project-ruleset-or-a-standard-)
* [About standards](#about-standards)
* [Creating an external standard for PHP_CodeSniffer](#creating-an-external-standard-for-php_codesniffer)
* [Creating new rules](#creating-new-rules)
   * [Naming conventions](#naming-conventions)

***

## A Project ruleset or a standard ?

The terminology used for coding standards in the context of PHP_CodeSniffer can be confusing.
When do you use a project ruleset ? When should you use a standard ?

Let's try and clarify this.

As a general rule of thumb: individual projects should use a project ruleset to document the rules enforced for the project.
Project rulesets may _include_ one or more predefined standards.

If a group of projects should use the same rules, you could create an external standard to define the common rules. This external standard can then be included in the project specific ruleset for each individual project.

The typical differences between project-specific rulesets and standards are:

|                                                                               | Project specific ruleset | External standard              |
|-------------------------------------------------------------------------------|--------------------------|--------------------------------|
| File name                                                                     | `[.]phpcs.xml[.dist]`    | `ruleset.xml`                  |
| Location                                                                      | Project root directory   | Standard directory (see below) |
| Will automatically be used when no standard is provided on the command line ? | Yes                      | No                             |
| Can have custom sniffs ?                                                      | No                       | Yes                            |
| Can be installed ?                                                            | No                       | Yes                            |
| Reusability by other projects ?                                               | Limited                  | Yes                            |

For optimal reusability, it is in most cases a good idea for a standard to be in its own repository and to be maintained as a separate project.

A `[.]phpcs.xml[.dist]` file and a `ruleset.xml` file can largely contain the same type of directives.
The [Annotated ruleset](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Annotated-Ruleset) page contains information on all the directives you can use.

Keep in mind that for a _standard_ to be optimally reusable, it should not contain project specific information, such as `<file>` directives or `<exclude-patterns>`, while a project specific `[.]phpcs.xml[.dist]` ruleset file _can_ contain that information.

You may also find the [Customisable Sniff Properties](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties) page a handy reference for customisations which can be made to PHP_CodeSniffer native sniffs.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## About standards

In the context of PHP_CodeSniffer, a _"standard"_ is a predefined collection of rules for code to follow.
Examples of standards are: PSR2 and PSR12, but a standard can also be eco-system specific, such as a Joomla or Doctrine standard, company specific or specific to a group of (related) projects.

PHP_CodeSniffer has a number of built-in standards. However, if you want to define your own standard, you can.
In terms of PHP_CodeSniffer, this is regarded as an _"external standard"_ and the path to the standard can be registered with PHP_CodeSniffer using the `--config-set installed_paths path/to/standard` command.

A standard _may_ contain sniffs, but it doesn't have to. More about this below.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Creating an external standard for PHP_CodeSniffer

The first thing to do is to think of a name for the standard.

Rules to keep in mind:
* The standard name CANNOT contain spaces, `.` characters or slashes.
* The standard name CANNOT be named "Internal".
* IF the standard will contain custom sniffs, the standard name MUST be a name which can be used in a PHP namespace, i.e. it is not allowed to start with a number, not allowed to contain dashes etc.

Once you have a good name:
* Create a directory with that name (case-sensitive).
* Create a file in that directory called `ruleset.xml` with the following contents and replace `StandardName` in the below code snippet with your chosen name.
```xml
<?xml version="1.0"?>
<ruleset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="StandardName" xsi:noNamespaceSchemaLocation="https://raw.githubusercontent.com/PHPCSStandards/PHP_CodeSniffer/master/phpcs.xsd">

</ruleset>
```

If your chosen standard name is `MyCompanyStandard`, the directory structure would now look like this:
```text
- MyCompanyStandard (directory)
  - ruleset.xml (file)
```

Now you can start adding rules to the standard.

For example, if your standard wants to enforce space indentation, you can add the `Generic.WhiteSpace.DisallowTabIndent` sniff to your ruleset:
```xml
<?xml version="1.0"?>
<ruleset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="YourStandardName" xsi:noNamespaceSchemaLocation="https://raw.githubusercontent.com/PHPCSStandards/PHP_CodeSniffer/master/phpcs.xsd">

    <rule ref="Generic.WhiteSpace.DisallowTabIndent"/>

</ruleset>
```

As mentioned before, have a look at the [Annotated ruleset](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Annotated-Ruleset) and the [Customisable Sniff Properties](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties) pages for inspiration on what directives and customisations you can add to your ruleset.

<p align="right"><a href="#table-of-contents">back to top</a></p>


## Creating new rules

There may be rules you want to enforce for which you cannot find an existing sniff, either in the PHP_CodeSniffer built-in standards or in any of the available generic external standards.

In that case, you can write your own sniff to enforce that rule.

> If the sniff could be generically usable, please be a good open source citizen and consider opening an issue in PHP_CodeSniffer, or in one of the external standards repositories, and offer to contribute the sniff, making it available for others to use as well.

> [!IMPORTANT]
> All sniffs in a standard are automatically included. There is no need to include the sniff(s) in the `ruleset.xml` via a `<rule ref=.../>`.


There is a [Coding Standard Tutorial](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki/Coding-Standard-Tutorial) available on how to write a sniff.

<p align="right"><a href="#table-of-contents">back to top</a></p>


### Naming conventions

Sniffs need to follow strict directory layout and naming conventions to allow for PHP_CodeSniffer to autoload sniff files correctly, translate between sniff codes and sniff class names, and to set any customisations indicated in a ruleset for a particular sniff.

#### 1. Directory structure

A sniff MUST belong to a standard and MUST be in a category.

The directory structure MUST be as follows:
```text
[StandardName]/Sniffs/[CategoryName]/
```

* The `[StandardName]` directory MAY be nested deeper inside a project.
* No directories should exist under the `[CategoryName]` directory.

#### 2. Sniff file name

All sniff file names MUST end with `Sniff.php` and be located within a `[CategoryName]` directory.

All sniffs MUST have a name, so a sniff class called just and only `Sniff` is not allowed.

Both the sniff name and the category name MUST be valid symbol names in PHP.

The name "Sniffs" MUST NOT be used as a category name.


#### 3. Namespace and class name

The namespace and class name MUST follow [PSR-4](https://www.php-fig.org/psr/psr-4/).

This means that - taking the example directory structure above into account - the namespace name MUST end with `[StandardName]\Sniffs\[CategoryName]` and the class name MUST be exactly the same as the file name (minus the `.php` file extension).

> [!NOTE]
> As long as an external standard is registered with PHP_CodeSniffer via `installed_paths` and the standard follows the directory layout and naming conventions, PHP_CodeSniffer can, and will, automatically handle the sniff autoloading.
>
> As the PHP_CodeSniffer autoloader is essential for the translation between sniff codes (as used in rulesets) and sniff class names, it is strongly discouraged to set up autoloading of sniff classes via Composer, as this can interfere with the _error code to sniff class_ translation.


#### Examples


##### Valid:
```php
<?php
// File: MyStandard/Sniffs/Operators/OperatorSpacingSniff.php

namespace MyStandard\Sniffs\Operators;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacingSniff implements Sniff {...}
```

Prefixing the namespace is allowed:
```php
<?php
// File: MyStandard/Sniffs/Operators/OperatorSpacingSniff.php

namespace NS\Prefix\MyStandard\Sniffs\Operators;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacingSniff implements Sniff {...}
```

Be sure to inform PHP_CodeSniffer about the namespace prefix by annotating it in the `ruleset.xml` file in the `namespace` attribute on the `ruleset` node:
```xml
<?xml version="1.0"?>
<ruleset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" name="MyStandard" namespace="NS\Prefix\MyStandard" xsi:noNamespaceSchemaLocation="https://raw.githubusercontent.com/PHPCSStandards/PHP_CodeSniffer/master/phpcs.xsd">

</ruleset>
```

Nesting the standard directory deeper inside a project is allowed:
```php
<?php
// File: src/Tools/PHPCS/MyStandard/Sniffs/Operators/OperatorSpacingSniff.php

namespace Vendor\Tools\PHPCS\MyStandard\Sniffs\Operators;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacingSniff implements Sniff {...}
```
The same note about setting the `namespace` attribute in the `ruleset.xml` file applies.

Also make sure that the `installed_paths` configuration option is set correctly and points to the `MyStandard` directory.


##### Invalid:

:x: Sniff name not ending on `Sniff`:
```php
<?php
// File: MyStandard/Sniffs/Operators/OperatorSpacing.php

namespace MyStandard\Sniffs\Operators;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacing implements Sniff {...}
```

:x: Sniff not placed in a (sub-)directory under a `Sniffs` directory:
```php
<?php
// File: MyStandard/Operators/OperatorSpacing.php

namespace MyStandard\Operators;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacingSniff implements Sniff {...}
```

:x: Not following the required directory structure (missing `[CategoryName]` subdirectory):
```php
<?php
// File: MyStandard/Sniffs/OperatorSpacingSniff.php

namespace MyStandard\Sniffs;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacingSniff implements Sniff {...}
```

:x: Not following the required directory structure (missing `[StandardName]` top-level directory):
```php
<?php
// File: src/Sniffs/Operators/OperatorSpacingSniff.php

namespace Sniffs\Operators;

use PHP_CodeSniffer\Files\File;
use PHP_CodeSniffer\Sniffs\Sniff;

class OperatorSpacingSniff implements Sniff {...}
```

<p align="right"><a href="#table-of-contents">back to top</a></p>
