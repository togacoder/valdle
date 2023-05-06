#!/usr/bin/perl
use v5.36;
use Mojolicious::Lite;
use Data::Dumper;
use lib "$FindBin::Bin/lib";
use db_manager;
use game_manager;
use utf8;
use Encode;

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
    $self->render('list', 'characters_array' => game_manager::get_all());
};

get 'game' => sub {
    my $self = shift;
    $self->render('game', 
        answer_id => game_manager::set_answer(), 
        name_list => game_manager::get_name_list()
    );
};

get 'send_answer' => sub {
    my $self = shift;
    my $params = $self->req->params->to_hash;
    my $name = $params->{'name'};
    my $id = $params->{'id'};
    $self->render(text => game_manager::send_answer($id, $name));
};

get 'get_answer' => sub {
    my $self = shift;
    my $params = $self->req->params->to_hash;
    my $id = $params->{'id'};
    $self->render(text => game_manager::get_answer($id));
};

app->start;