#!/usr/bin/perl
use v5.36;
use Mojolicious::Lite;
use Data::Dumper;
use lib "$FindBin::Bin/lib";
use db_manager;
use game_manager;

get '/' => sub {
    my $self = shift;
    $self->redirect_to('index');
};

get 'index' => sub {
    my $self = shift;
    $self->render('index');
};

get 'list' => sub {
    my $self = shift;
    my $characters = db_manager::get_all();
    $self->render('list', 'characters' => $characters);
};

get 'game' => sub {
    my $self = shift;
    $self->render('game', answer_id => game_manager::set_answer());
};

app->start;