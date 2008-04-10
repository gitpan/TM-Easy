use 5.008008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
	      NAME              => 'TM::Easy',
	      VERSION_FROM      => 'lib/TM/Easy.pm', # finds $VERSION
              PREREQ_PM      => { # do a 'make dependencies' to get an update
		  'TM'            => '1.33',
		  "Test::More"    => 0.47,
	      },
	      ABSTRACT_FROM  => 'lib/TM/Easy.pm', # retrieve abstract from module
	      AUTHOR         => 'Robert Barta <rho@devc.at>');

package MY;

sub depend {
    return <<MAKE

dependencies:
	scandeps.pl `grep .pm MANIFEST` `grep bin/ MANIFEST`| grep -v undef

manifesto:
	find lib/ -iname '*.pm' | sort
	find t    -iname '*.t'  | sort

upload:
	cpan-upload-http TM-Easy-\$(VERSION).tar.gz

inject:
	mcpani --add --module TM --authorid DRRHO --modversion \$(VERSION) --file TM-Easy-\$(VERSION).tar.gz
	sudo mcpani --inject
	echo "reload index" | cpan

debian:
	(cd /usr/local/share/packages; rm -rf TM* ; dh-make-perl --cpan-mirror file:/usr/local/share/minicpan --build --cpan TM::Easy --notest)

MAKE
}
