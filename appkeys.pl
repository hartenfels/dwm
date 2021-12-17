#!/usr/bin/env perl
use strict;
use warnings;
use FindBin;

my (%apps, %syms);

sub _set {
    my ($hash, $default_mods, $key, @args) = @_;

    my %mods_used = %$default_mods;
    if (ref $args[0]) {
        for my $mod (@{shift @args}) {
            if ($mod =~ /\A\+(.+)\z/s) {
                $mods_used{"$1Mask"} = 1;
            }
            elsif ($mod =~ /\A-(.+)\z/s) {
                delete $mods_used{"$1Mask"};
            }
            else {
                die "Unknown modifier '$mod'\n";
            }
        }
    }

    my $mods = %mods_used ? join('|', sort keys %mods_used) : '0';
    $key = lc $key;
    my $id = "$mods:$key";
    if (exists $hash->{$id}) {
        die "'$id' is already bound\n";
    }

    $hash->{$id} = {
        key  => $key,
        mods => $mods,
        args => \@args,
    };
}

sub app { _set(\%apps, {Mod1Mask => 1, Mod4Mask => 1}, @_) }
sub sym { _set(\%syms, {},                             @_) }

sub sh {
    my ($key, $cmd) = @_;
    app($key, 'sh', '-c', $cmd);
}


do "$FindBin::Bin/apps.pl";
die $@ if $@;

my ($cmds, $appkeys);

sub _key {
    my ($type, $prefix, $hash, $id) = @_;

    my $spec = $hash->{$id};
    my $key  = $spec->{key};
    my $mods = $spec->{mods};
    my @args = @{$spec->{args}};
    for (@args) {
        s/\\/\\\\/g;
        s/"/\\"/g;
        s/^|$/"/g;
    }

    my $lt = lc $type;
    my $ut = uc $type;

    my $cmd = join '_', $lt, $mods, $key;
    $cmd =~ s/\W/_/g;
    $cmds .= "static const char *$cmd\[] = { "
           . join(', ', @args) . ", NULL };\n";

    $appkeys .= "\t${ut}KEY($mods, $prefix$key, $cmd)\n";
}

_key('app', 'XK_', \%apps, $_) for sort keys %apps;
_key('sym', '',    \%syms, $_) for sort keys %syms;


while (<>) {
    s!\s*/\*\s*\{\{\s*APPCOMMANDS\s*\}\}\s*\*/\s*!$cmds!g;
    s!\s*/\*\s*\{\{\s*APPKEYS\s*\}\}\s*\*/\s*!$appkeys!g;
    print;
}
