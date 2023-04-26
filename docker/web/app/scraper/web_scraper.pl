#!/usr/bin/perl

use strict;
use warnings;
use URI;
use Encode;
use Web::Scraper;
use Data::Dumper;

my $enc = find_encoding 'utf8';
my $url = 'http://jam-capture-vcon.ateamid.com/character_list.html';
my $uri = new URI($url);
my $scraper = scraper {
    process 'a', 'ref[]' => '@href';
};

my $res = $scraper->scrape($uri);
my $ref = $res->{'ref'};
my @ids;
foreach my $line (@{$ref}) {
    if($line =~ /character_detail\/([0-9]+)/) {
        push(@ids, $1);
    }
}

foreach my $id (@ids) {
    $url = "http://jam-capture-vcon.ateamid.com/character_detail/$id.html";
    $uri = new URI($url);
    $scraper = scraper {
        process 'p.name__text', 'name[]' => 'TEXT';
        process 'dd.detail__data--rare-content', 'rarity[]' => 'TEXT';
        process 'dd', 'dd[]', => 'TEXT';
        process 'img.type-img', 'type' => '@src';
        process 'img.attribute-img', 'attribute' => '@src';
        process 'dl.detail__skill--txt', 'dl[]' => 'TEXT';
    };
    $res = $scraper->scrape($uri);
    my %data = ( 'id' => $id );
    my $dd_array = $res->{'dd'};
    my $src_array = $res->{'src'};
    my $dl_array = $res->{'dl'};
    $data{'name'} = $enc->encode($res->{'name'}->[0]);
    $data{'rarity'} = $enc->encode($res->{'rarity'}->[0]);
    $data{'type'} = $enc->encode($res->{'type'});
    $data{'type'} =~ s/^.*\/(.*)$/$1/;
    $data{'attribute'} = $enc->encode($res->{'attribute'});
    $data{'attribute'} =~ s/^.*\/(.*)$/$1/ if(defined $data{'attribute'});
    $data{'sex'} = '';
    foreach my $value (@{$dd_array}) {
        $value = $enc->encode($value);
        $data{'attack'} = $value if($value =~ /^(物理|魔法)攻撃$/);
        $data{'tribe'} = $value if($value =~ /^(神|人間|エルフ|ドワーフ|亜人|巨人|神獣)$/);
        $data{'position'} = $value if($value =~ /^(地上|空中)$/);
        $data{'sex'} = $value if($value =~ /^(♂|♀)$/);
    }
    foreach my $value (@{$dl_array}) {
        $value = $enc->encode($value);
        if($value =~ /^名前(.*?)効果.*$/) {
            #$value =~ s/^名前(.*?)効果.*$/$1/;
            $data{'action_name'} = $1;
            last;
        }
    }
    
    my $sql = 'INSERT INTO valdle_db.character VALUES ( ';
    $sql .= $data{'id'} . ", ";
    $sql .= "'" . $data{'rarity'} . "', ";
    $sql .= "'" . $data{'name'} . "', ";
    $sql .= "'" . $data{'type'} . "', ";
    $sql .= "'" . $data{'attack'} . "', ";
    $sql .= "'" . $data{'tribe'} . "', ";
    if(defined $data{'sex'}) {
        $sql .= "'" . $data{'sex'} . "', ";
    } else {
        $sql .= "'', ";
    }
    $sql .= "'" . $data{'position'} . "', ";
    if(defined $data{'attribute'}) {
        $sql .= "'" . $data{'attribute'} . "', ";
    } else {
        $sql .= "' - ', ";
    }
    $sql .= "'" . $data{'action_name'} . "' );";
    print $sql . "\n";
}
exit;
