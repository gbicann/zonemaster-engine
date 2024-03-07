use Cwd qw(abs_path);
use List::Util qw(any);
use File::Spec;
use File::Basename qw(dirname);
use Test::More;
use strict;
use vars qw($module);
use warnings;

BEGIN {
    use_ok( q{Zonemaster::Engine::Profile} );

    $module = q{Custom::Module};

    push @INC, abs_path( File::Spec->catfile( dirname( __FILE__ ), q{custom}, q{lib} ) );

    my $modules = Zonemaster::Engine::Profile->effective->get( q{custom_modules} );
    push @{ $modules }, $module;

    Zonemaster::Engine::Profile->effective->set( q{custom_modules}, $modules );

    my $cases = Zonemaster::Engine::Profile->effective->get( q{test_cases} );
    push @{ $cases }, q{test01};

    Zonemaster::Engine::Profile->effective->set( q{test_cases}, $cases );

    use_ok( q{Zonemaster::Engine} );
}

ok any { $_ eq $module } Zonemaster::Engine::Test->modules();

my @results = Zonemaster::Engine->test_module( $module, q{example.com} );

ok scalar @results > 0;

ok scalar ( grep { 'THIS_IS_A_TEST' eq $_->tag } @results ) > 0;

done_testing;
