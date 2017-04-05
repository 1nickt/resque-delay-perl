use strict;
use Test::More;

use Redis;
use Resque;
use Test::RedisServer;
use Test::MockTime qw/set_fixed_time restore_time/;
use Time::Strptime qw/strptime/;
use Time::Moment;
use Scope::Guard qw/scope_guard/;

my $redis_server;
eval {
    $redis_server = Test::RedisServer->new;
} or plan skip_all => 'redis-server is required to this test';

my $redis = Redis->new($redis_server->connect_info);

my $resque = Resque->new(redis => $redis, plugins => ['Delay']);
isa_ok $resque->plugins->[0], 'Resque::Plugin::Delay';

my ($working_time)  = strptime('%Y-%m-%d %H:%M:%S', '2017-04-01 12:00:00');

fixed_time($working_time - 1, sub {
    $resque->push('test-job' => +{
            class => 'hoge',
            args => [+{ resque_working_time => $working_time }]
        }
    );
    my $job = $resque->pop('test-job');
    is $job, undef, 'The time of work has not arrived';
});

fixed_time($working_time, sub {
    my $job = $resque->pop('test-job');
    is ref $job, 'Resque::Job', 'The time of work came';
});

done_testing;

sub fixed_time {
    my ($epoch, $code) = @_;

    set_fixed_time($epoch);
    $code->();
    restore_time();
}

