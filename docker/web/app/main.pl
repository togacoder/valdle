#!/usr/bin/perl
use v5.36;
use Mojolicious::Lite;
use lib "$FindBin::Bin/lib";
use db_manager;

get '/' => sub {
    my $self = shift;
    $self->render('index');
};

get 'init_data' => sub {
    my $self = shift;
    opne(FILE, "< /app/scraper/scrape_data.csv") or die("$!");
    foreach my $line (<FILE>) {
        chomp $line;
        db_manager::init_data($line);
        $self->render( text => 'init_data' );
    }
    close(FILE);
};

app->start;