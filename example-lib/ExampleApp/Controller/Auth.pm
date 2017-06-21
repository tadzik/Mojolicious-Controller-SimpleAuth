package ExampleApp::Controller::Auth;
use Mojo::Base 'Mojolicious::Controller::SimpleAuth';

# a simplistic storage, mapping usernames to passwords
my %users;

sub register_user {
    my ($self, $username, $password) = @_;

    $users{$username} = $password;
}

# in this example app we don't distinguish userid from username
sub load_user {
    my ($app, $uid) = @_;

    return {
        username => $uid,
    };
}

sub validate_user {
    my ($app, $username, $password, $extra) = @_;

    if ($users{$username} and $users{$username} eq $password) {
        return $username;
    }
}

1;
