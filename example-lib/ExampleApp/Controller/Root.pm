package ExampleApp::Controller::Root;
use Mojo::Base 'Mojolicious::Controller';

sub index {
    my $self = shift;

    $self->render(text => 'Welcome to my site!');
}

sub private {
    my $self = shift;

    my $user = $self->current_user;
    $self->render(text => "Welcome, $user->{username}");
}

1;
