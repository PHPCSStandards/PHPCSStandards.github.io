
Commands to run:

Home page:

phpcs --standard=PSR12 --no-cache ./build/wiki-code-samples/ --basepath=./build/wiki-code-samples/ --extensions=php --report-width=100

Usage page:

phpcs --report-width=110 --no-colors -h

phpcs --standard=PSR12 --no-cache ./build/wiki-code-samples/path/to/code/myfile.php --basepath=./build/wiki-code-samples/ --report-width=100
phpcs --standard=PSR12 --no-cache ./build/wiki-code-samples/path/to/code/myfile.php --basepath=./build/wiki-code-samples/ --report-width=100 -n

phpcs --standard=PSR12 --no-cache ./build/wiki-code-samples/ --basepath=./build/wiki-code-samples/ --report-width=100 --report=summary
phpcs --standard=PSR12 --no-cache ./build/wiki-code-samples/ --basepath=./build/wiki-code-samples/ --report-width=100 --report=summary -n

phpcs ./src/Standards/Generic/ --standard=PSR12 --no-cache --extensions=php --report-width=100 -v

phpcs -i

Fixing:

phpcbf --report-width=110 --no-colors -h

