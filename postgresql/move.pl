#!/usr/bin/perl -w

use strict;

use DBI;
use moveconf

# This tels DBD::Sybase to connect to blower
$ENV{DSQUERY} = 'BLOWER';

my $syb = DBI->connect("DBI:Sybase:dbname=$ARGV[0]", $moveconf::syb_user, $moveconf::syb_password) or die;
my $pgsql = DBI->connect("DBI:Pg:dbname=$ARGV[0]", $moveconf::pg_user) or die;

my $s = $syb->prepare("select * from $ARGV[1]");
$s->execute;
my $n = $s->{NUM_OF_FIELDS};
die "no result set" if $n == 0;

my $ins = "INSERT INTO $ARGV[1] (";
foreach (0..$n-2) {
    $ins .= "$s->{NAME}[$_], ";
}
$ins .= "$s->{NAME}[$n-1]";

$ins .= ") VALUES(";
foreach (0..$n-2) {
    $ins .= "?, ";
}
$ins .= "?)";

print "Executing $ins\n";

my $sth = $pgsql->prepare($ins);

$pgsql->{AutoCommit} = 0;

my $counter = 0;
while (my @a = $s->fetchrow) {
    $sth->execute(@a) or die;
    $counter++;
}

print "\r$counter rows inserted, doing commit...";

$pgsql->commit;

print "done!\n";

$syb->disconnect;
$pgsql->disconnect;
