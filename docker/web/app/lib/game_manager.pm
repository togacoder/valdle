package game_manager;
use v5.36;
use db_manager;
use Encode;

sub set_answer {
    my $ids = db_manager::get_all_id();
    my $max_num = @{$ids};
    my $num = int(rand($max_num));
    my $id = $ids->[$num]->[0];
    return $id;
}

sub get_name_list {
    my $name_list_ref = db_manager::get_name_list();
    my @name_list;
    foreach my $value (@{$name_list_ref}) {
        push(@name_list, decode('utf8', $value->[0]));
    }
    return \@name_list;
}

sub get_all() {
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
    return \@characters_array;
}

sub send_answer($id, $name) {
    my $data = db_manager::get_answer_name($name)->[0];
    my $ans = db_manager::get_answer($id)->[0];
    my @color_array;
    for(my $i = 0; $i < 11; $i++) {
        if($data->[$i] eq $ans->[$i]) {
            push(@color_array, 'GREEN');
        } else {
            push(@color_array, "RED");
        }
    }
    my $text = join(',', (@{$data}, @color_array));
    $text = decode('utf8', $text);
    return $text;
}

sub get_answer($id) {
    my $data = db_manager::get_answer($id)->[0];
    my $text = join(',', @{$data});
    $text = decode('utf8', $text);
    return $text;
}

1;