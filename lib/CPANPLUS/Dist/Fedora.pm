#
# This file is part of CPANPLUS::Dist::RPM
#
# This program is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself.
#

package CPANPLUS::Dist::Fedora;

use strict;
use warnings;

use base 'CPANPLUS::Dist::RPM';

use SUPER;

our $VERSION = '0.1.1';

# check to see if we're on a fedora system; if not, return false, if so, then
# pass off to our ancestor method for its checks.

sub format_available {

    # Check Fedora release file
    if ( ! -f '/etc/fedora-release' ) {
        error( 'Not on a Fedora system' );
        return 0;
    }
    
    return super;
}

# my $bool = $self->_has_been_built;
#
# Returns true if there's already a package built for this module.
# 
sub _has_been_built {
    my ($self, $name, $vers) = @_;

    # FIXME this entire method should be overridden to first check the local
    # rpmdb, then check the yum repos via repoquery.  As is we're pretty
    # broken right now
    #
    # For now, just call super
    return super;
}


1;

__DATA__
__[ spec ]__

Name:       [% status.rpmname %] 
Version:    [% status.distvers %] 
Release:    [% status.rpmvers %]%{?dist}
License:    [% status.license %] 
Group:      Development/Libraries
Summary:    [% status.summary %] 
Source:     http://search.cpan.org/CPAN/[% module.path %]/[% status.distname %]-%{version}.[% module.package_extension %] 
Url:        http://search.cpan.org/dist/[% status.distname %]
BuildRoot:  %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n) 
Requires:  perl(:MODULE_COMPAT_%(eval "`%{__perl} -V:version`"; echo $version))
[% IF status.is_noarch %]BuildArch:  noarch[% END -%]

BuildRequires: perl(ExtUtils::MakeMaker) 
[% brs = buildreqs; FOREACH br = brs.keys.sort -%]
BuildRequires: perl([% br %])[% IF (brs.$br != 0) %] >= [% brs.$br %][% END %]
[% END -%]


%description
[% status.description -%]


%prep
%setup -q -n [% status.distname %]-%{version}

%build
[% IF (!status.is_noarch) -%]
%{__perl} Makefile.PL INSTALLDIRS=vendor OPTIMIZE="%{optflags}"
[% ELSE -%]
%{__perl} Makefile.PL INSTALLDIRS=vendor
[% END -%]
make %{?_smp_mflags}

%install
rm -rf %{buildroot}

make pure_install PERL_INSTALL_ROOT=%{buildroot}
find %{buildroot} -type f -name .packlist -exec rm -f {} ';'
[% IF (!status.is_noarch) -%]
find %{buildroot} -type f -name '*.bs' -a -size 0 -exec rm -f {} ';'
[% END -%]
find %{buildroot} -depth -type d -exec rmdir {} 2>/dev/null ';'

%{_fixperms} %{buildroot}/*

%check
make test

%clean
rm -rf %{buildroot} 

%files
%defattr(-,root,root,-)
%doc [% docfiles %] 
[% IF (status.is_noarch) -%]
%{perl_vendorlib}/*
[% ELSE -%]
%{perl_vendorarch}/*
%exclude %dir %{perl_vendorarch}/auto
[% END -%]
%{_mandir}/man3/*.3*

%changelog
* [% date %] [% packager %] [% status.distvers %]-[% status.rpmvers %]
- initial Fedora packaging
- generated with cpan2dist (CPANPLUS::Dist::Fedora version [% packagervers %])

__[ pod ]__

__END__

=head1 NAME

CPANPLUS::Dist::Fedora - a cpanplus backend to build Fedora/RedHat rpms



=head1 SYNOPSIS

    cpan2dist --format=CPANPLUS::Dist::Fedora Some::Random::Package



=head1 DESCRIPTION

CPANPLUS::Dist::Fedora is a distribution class to create Fedora packages
from CPAN modules, and all its dependencies. This allows you to have
the most recent copies of CPAN modules installed, using your package
manager of choice, but without having to wait for central repositories
to be updated.

You can either install them using the API provided in this package, or
manually via rpm.

Note that these packages are built automatically from CPAN and are
assumed to have the same license as perl and come without support.
Please always refer to the original CPAN package if you have questions.



=head1 CLASS METHODS

=head2 $bool = CPANPLUS::Dist::Fedora->format_available;

Return a boolean indicating whether or not you can use this package to
create and install modules in your environment.

It will verify if you are on a mandriva system, and if you have all the
necessary components avialable to build your own mandriva packages. You
will need at least these dependencies installed: C<rpm>, C<rpmbuild> and
C<gcc>.



=head1 PUBLIC METHODS

=head2 $bool = $fedora->init;

Sets up the C<CPANPLUS::Dist::Fedora> object for use. Effectively creates
all the needed status accessors.

Called automatically whenever you create a new C<CPANPLUS::Dist> object.


=head2 $bool = $fedora->prepare;

Prepares a distribution for creation. This means it will create the rpm
spec file needed to build the rpm and source rpm. This will also satisfy
any prerequisites the module may have.

Note that the spec file will be as accurate as possible. However, some
fields may wrong (especially the description, and maybe the summary)
since it relies on pod parsing to find those information.

Returns true on success and false on failure.

You may then call C<< $fedora->create >> on the object to create the rpm
from the spec file, and then C<< $fedora->install >> on the object to
actually install it.


=head2 $bool = $fedora->create;

Builds the rpm file from the spec file created during the C<create()>
step.

Returns true on success and false on failure.

You may then call C<< $fedora->install >> on the object to actually install it.


=head2 $bool = $fedora->install;

Installs the rpm using C<rpm -U>.

B</!\ Work in progress: not implemented.>

Returns true on success and false on failure



=head1 TODO

There are no TODOs of a technical nature currently, merely of an
administrative one;

=over

=item o Scan for proper license

Right now we assume that the license of every module is C<the same
as perl itself>. Although correct in almost all cases, it should 
really be probed rather than assumed.


=item o Long description

Right now we provided the description as given by the module in it's
meta data. However, not all modules provide this meta data and rather
than scanning the files in the package for it, we simply default to the
name of the module.


=back



=head1 BUGS

Please report any bugs or feature requests to C<< < cpanplus-dist-fedora at
rt.cpan.org> >>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=CPANPLUS-Dist-Fedora>.  I
will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.



=head1 SEE ALSO

L<CPANPLUS::Backend>, L<CPANPLUS::Module>, L<CPANPLUS::Dist>,
C<cpan2dist>, C<rpm>, C<yum>


C<CPANPLUS::Dist::Fedora> development takes place on
L<https://svn.berlios.de/svnroot/repos/web-cpan/CPANPLUS-Dist/trunk/> 
- feel free to join us.


You can also look for information on this module at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/CPANPLUS-Dist-Fedora>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/CPANPLUS-Dist-Fedora>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=CPANPLUS-Dist-Fedora>

=back



=head1 AUTHOR

Originally based on CPANPLUS-Dist-Mdv by:

Jerome Quelin, C<< <jquelin at cpan.org> >>

Shlomi Fish ( L<http://www.shlomifish.org/> ) changed it into 
CPANPLUS-Dist-Fedora.

Chris Weyl C<< <cweyl@alumni.drew.edu> >> changed it again to
CPANPLUS-Dist-RPM.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2007 Jerome Quelin, Shlomi Fish, Chris Weyl.

This program is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

Modified by Shlomi Fish, 2008 - all ownership disclaimed.

Modified again by Chris Weyl <cweyl@alumni.drew.edu> 2008.

=cut

