# Contributing to the PHP_CodeSniffer documentation

## PHP_CodeSniffer Wiki

For now, the documentation for the PHP_CodeSniffer project is available via the [project Wiki](https://github.com/PHPCSStandards/PHP_CodeSniffer/wiki).

### Contributing to the Wiki

If you would like to improve the documentation:
1. Fork this repo.
2. Create a new branch off the `main` branch.
3. Make your changes. The Wiki source files are in the `/wiki` subdirectory.
4. Commit your changes with a meaningful commit message.
5. Push your changes to your fork.
6. Submit a pull request from your fork to this repository.

When in doubt, open an issue first to discuss your change proposal.

### How does the wiki get updated ?

* The source of the Wiki was imported into this repository to maintain the commit history.
* A [GitHub Actions workflow](https://github.com/PHPCSStandards/PHP_CodeSniffer-documentation/blob/main/.github/workflows/publish-wiki.yml) was added to automatically push changes made in the Wiki files to the upstream Wiki repo.
* Prior to pushing the changes, the workflow will make various changes to the files:
    * Replace `<!-- START doctoc --> <!-- END doctoc -->` placeholders with a Table of Contents for the page in Markdown.
    * Replace `{{ .... }}` CLI output placeholders with actual CLI output.
        The code samples used for this can be found in the `build/wiki/code-samples` directory.

### Guidelines

* Always use fully qualified links. This ensures that the links will work when pages are viewed/edited in this repo, as well as when the pages are viewed from the PHPCS wiki.


### Frequently Asked Questions

#### Why not make the Wiki publicly editable ?

Publicly editable Wiki pages for big projects get vandalized pretty often and we don't want to risk this type of vandalism leading to users getting incorrect information.

As a secondary reason, there are parts of the wiki (especially the output examples) which were pretty out of date.
By having the wiki source in this repo, it allows for automating certain updates which would otherwise have to be done manually.
