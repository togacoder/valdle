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

1;