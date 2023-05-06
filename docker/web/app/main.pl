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
    my $characters = db_manager::get_all();
    my @characters_array;
    foreach my $values (@{$characters}) {
        push(@{$characters_array[$#characters_array + 1]}, (
            decode('utf8', $values->[0]),
            decode('utf8', $values->[1]),
            decode('utf8', $values->[2]),
            decode('utf8', $values->[3]),
            decode('utf8', $values->[4]),
            decode('utf8', $values->[5]),
            decode('utf8', $values->[6]),
            decode('utf8', $values->[7]),
            decode('utf8', $values->[8]),
            decode('utf8', $values->[9]),
            decode('utf8', $values->[10])
        ));
    }
    $self->render('list', 'characters_array' => \@characters_array);
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
    my $data = db_manager::get_answer_name($name)->[0];
    my $ans = db_manager::get_answer($id)->[0];
    my @color_array; 
    for(my $i = 0; $i < 11; $i++) {
        if($data->[$i] eq $ans->[$i]) {
            push(@color_array, 'GREEN');
        } else {
            push(@color_array, 'RED');
        }
    }

    my $text = join(',', (@{$data}, @color_array));
    $text = decode('utf8', $text);
    $self->render(text => $text);
};

get 'get_answer' => sub {
    my $self = shift;
    my $params = $self->req->params->to_hash;
    my $id = $params->{'id'};
    chomp $id;
    my $data = db_manager::get_answer($id)->[0];
    my $text = join(',', @{$data});
    $text = decode('utf8', $text);
    $self->render(text => $text);
};

app->start;