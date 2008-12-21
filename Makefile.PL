use inc::Module::Install;

name     'CPANPLUS-Dist-RPM';
all_from 'lib/CPANPLUS/Dist/RPM.pm';
author   'Chris Weyl <cweyl@alumni.drew.edu>';

no_index package => 'CPANPLUS::Dist::Fedora';

test_requires 'Test::More';
test_requires 'Test::use::ok';

requires 'Cwd';
requires 'Template';
requires 'CPANPLUS::Dist::Base';
requires 'CPANPLUS::Error';
requires 'Data::Section';
requires 'File::Basename';
requires 'File::Copy';
requires 'File::Find::Rule';
requires 'IPC::Cmd';
requires 'List::Util';
requires 'Path::Class';
requires 'Pod::POM';
requires 'Pod::POM::View::Text';
requires 'POSIX';
requires 'Readonly';
requires 'Software::License' => '0.008';
requires 'SUPER';
requires 'Text::Autoformat';
requires 'Template';

requires_external_bin 'gcc';
requires_external_bin 'rpm';
requires_external_bin 'rpmbuild';

extra_tests;

auto_install;

WriteAll;

