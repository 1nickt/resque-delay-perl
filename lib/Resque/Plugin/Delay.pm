package Resque::Plugin::Delay;
use 5.008001;
use strict;
use warnings;

our $VERSION = "0.01";

use Resque::Plugin;

add_to resque => 'Delay::Dequeue';
add_to job    => 'Delay::Job';


1;
__END__

=encoding utf-8

[![Build Status](https://travis-ci.org/meru-akimbo/resque-delay-perl.svg?branch=master)](https://travis-ci.org/meru-akimbo/resque-delay-perl)

=head1 NAME

Resque::Plugin::Delay - Delay the execution of job

=head1 SYNOPSIS

    use Resque;

    my $start_time = time + 100;

    my $resque = Resque->new(redis => $redis_server, plugins => ['Delay']);
    $resque->push('test-job' => +{
            class => 'Hoge',
            args  => [+{ cat => 'nyaaaa' }, +{ dog => 'bow' }],
            start_time => $start_time,
        }
    );

=head1 DESCRIPTION

Passing epoch to the start_time attribute of payload makes it impossible to execute work until that time.

=head1 LICENSE

Copyright (C) meru_akimbo.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

meru_akimbo E<lt>merukatoruayu0@gmail.comE<gt>

=cut

