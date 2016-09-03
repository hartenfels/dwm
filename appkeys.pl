#!/usr/bin/env perl
use strict;
use warnings;

my %apps;

sub app {
    my ($key, @args) = @_;
    $key = lc $key;
    if (exists $apps{$key}) {
        die "Key '$key' is already bound with '@{$apps{$key}}'\n";
    }
    $apps{$key} = \@args;
}

sub sh {
    my ($key, $cmd) = @_;
    app($key, 'sh', '-c', $cmd);
}


do 'apps.pl';
die $@ if $@;

my ($cmds, $appkeys);

for my $key (sort keys %apps) {
    my @args = @{$apps{$key}};
    for (@args) {
        s/\\/\\\\/g;
        s/"/\\"/g;
        s/^|$/"/g;
    }

    $cmds .= "static const char *${key}cmd[] = { "
           . join(', ', @args) . ", NULL };\n";

    $appkeys .= "\tAPPKEY(XK_$key, ${key}cmd)\n";
}


while (<>) {
    s!\s*/\*\s*\{\{\s*APPCOMMANDS\s*\}\}\s*\*/\s*!$cmds!g;
    s!\s*/\*\s*\{\{\s*APPKEYS\s*\}\}\s*\*/\s*!$appkeys!g;
    print;
}
