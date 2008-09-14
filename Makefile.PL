use inc::Module::Install;

name     'CPANPLUS-Dist-RPM';
all_from 'lib/CPANPLUS/Dist/RPM.pm';
author   'Chris Weyl <cweyl@alumni.drew.edu>';

test_requires 'Test::More';
test_requires 'Test::use::ok';

requires 'Cwd';
requires 'Template';
requires 'CPANPLUS::Dist::Base';
requires 'CPANPLUS::Error';
requires 'Data::Section';
requires 'File::Basename';
requires 'File::Copy';
requires 'File::Slurp';
requires 'IPC::Cmd';
requires 'List::Util';
requires 'POSIX';
requires 'Readonly';
# not implemented yet
#requires 'Software::License';

extra_tests;

auto_install;

WriteAll;

