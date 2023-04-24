#!/usr/bin/perl
package db_manager;
use v5.36;
use DBI;

sub init {
    my $user = 'root';
    my $pass = 'root';
    my $database = 'valdle_db';
    my $hostname = 'db';
    my $dbh = DBI->connect(
        "DBI:mysql:$database:$hostname",
        $user,
        $pass
    ) or die "cannot connect to MYSQL:$DBI::errstr";
    return $dbh;
}

sub get_all {
    my $dbh = &init();
    my $sth = $dbh->prepare('SELECT * FROM valdle_db.character ORDER BY id');
    $sth->execute();
    my $arrayref = $sth->fetchall_arrayref;
    $sth->finish;
    undef $sth;
    $dbh->disconnect;
    return $arrayref;
}

1;