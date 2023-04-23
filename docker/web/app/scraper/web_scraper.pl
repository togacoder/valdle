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
    };
    $res = $scraper->scrape($uri);
    my %data = ( 'id' => $id );
    my $dd_array = $res->{'dd'};
    my $src_array = $res->{'src'};
    $data{'name'} = $enc->encode($res->{'name'}->[0]);
    $data{'rarity'} = $enc->encode($res->{'rarity'}->[0]);
    $data{'type'} = $enc->encode($res->{'type'});
    $data{'type'} =~ s/^.*\/(.*)$/$1/;
    $data{'sex'} = '';
    foreach my $value (@{$dd_array}) {
        $value = $enc->encode($value);
        $data{'attack'} = $value if($value =~ /^(物理|魔法)攻撃$/);
        $data{'tribe'} = $value if($value =~ /^(神|人間|エルフ|ドワーフ|亜人|巨人|神獣)$/);
        $data{'position'} = $value if($value =~ /^(地上|空中)$/);
        $data{'sex'} = $value if($value =~ /^(♂|♀)$/);
    }
    
    my $sql = 'INSERT INTO valdle_db.character VALUES ( ';
    $sql .= $data{'id'} . ", ";
    $sql .= "'" . $data{'rarity'} . "', ";
    $sql .= "'" . $data{'name'} . "', ";
    $sql .= "'" . $data{'type'} . "', ";
    $sql .= "'" . $data{'attack'} . "', ";
    $sql .= "'" . $data{'tribe'} . "', ";
    if(defined $date{'sex'}) {
        $sql .= "'" . $data{'sex'} . "', ";
    } else {
        $sql .= "'', ";
    }
    $sql .= "'" . $data{'position'} . "');";
    print $sql . "\n";
}
exit;
