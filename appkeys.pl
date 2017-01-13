#!/usr/bin/env perl
use strict;
use warnings;

my (%apps, %syms);

sub _set {
    my ($hash, $key, @args) = @_;
    $key = lc $key;
    if (exists $hash->{$key}) {
        die "'$key' is already bound with '@{$hash->{$key}}'\n";
    }
    $hash->{$key} = \@args;
}

sub app { _set(\%apps, @_) }
sub sym { _set(\%syms, @_) }

sub sh {
    my ($key, $cmd) = @_;
    app($key, 'sh', '-c', $cmd);
}


do 'apps.pl';
die $@ if $@;

my ($cmds, $appkeys);

sub _key {
    my ($type, $prefix, $hash, $key) = @_;

    my @args = @{$hash->{$key}};
    for (@args) {
        s/\\/\\\\/g;
        s/"/\\"/g;
        s/^|$/"/g;
    }

    my $lt = lc $type;
    my $ut = uc $type;

    $cmds .= "static const char *$lt${key}cmd[] = { "
           . join(', ', @args) . ", NULL };\n";

    $appkeys .= "\t${ut}KEY($prefix$key, $lt${key}cmd)\n";
}

_key('app', 'XK_', \%apps, $_) for sort keys %apps;
_key('sym', '',    \%syms, $_) for sort keys %syms;


while (<>) {
    s!\s*/\*\s*\{\{\s*APPCOMMANDS\s*\}\}\s*\*/\s*!$cmds!g;
    s!\s*/\*\s*\{\{\s*APPKEYS\s*\}\}\s*\*/\s*!$appkeys!g;
    print;
}
