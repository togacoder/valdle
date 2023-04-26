package game_manager;
use v5.36;
use db_manager;

sub set_answer {
    my $ids = db_manager::get_all_id();
    my $max_num = @{$ids};
    print "$max_num\n";
    my $num = int(rand($max_num));
    print "$num\n";
    my $id = $ids->[$num];
    print "$id\n";
    return $id; 
}

1;