package game_manager;
use v5.36;
use db_manager;
use Data::Dumper;

sub set_answer {
    my $ids = db_manager::get_all_id();
    my $max_num = @{$ids};
    my $num = int(rand($max_num));
    my $id = $ids->[$num]->[0];
    print "id: $id\n";
    return $id;
}

1;