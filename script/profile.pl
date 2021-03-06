#
# $ perl -d:NYTProf script/profile.pl
# $ ntyprofhtml
#
use strict;
use warnings;
use lib 'lib';
use t::Util;
use File::Spec;
use Test::mysqld;

use DBIx::QueryLog ();

local $SIG{INT} = sub { exit 1 };

my $mysqld = t::Util->setup_mysqld;
my $dbh = DBI->connect(
    $mysqld->dsn(dbname => 'mysql'), '', '',
    {
        AutoCommit => 1,
        RaiseError => 1,
    },
) or die $DBI::errstr;

local *STDERR;
open STDERR, '>', File::Spec->devnull or die $!;

DBIx::QueryLog->begin;

for (1..1000) {
    $dbh->do('SELECT * FROM user WHERE User = ?', undef, 'root');
}
