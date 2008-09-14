use Test::More tests => 2;

diag( "Testing CPANPLUS::Dist::RPM $CPANPLUS::Dist::RPM::VERSION" );
use ok 'CPANPLUS::Dist::RPM';

diag( "Testing CPANPLUS::Dist::Fedora $CPANPLUS::Dist::Fedora::VERSION" );
use ok 'CPANPLUS::Dist::Fedora';

