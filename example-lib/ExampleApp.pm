package ExampleApp;
use Mojo::Base 'Mojolicious';

use Mojolicious::Plugin::Authentication;
use ExampleApp::Controller::Auth;

sub startup {
    my $self = shift;

    $self->plugin(authentication => ExampleApp::Controller::Auth->config());

    my $r = $self->routes;
    $r->get('/')->to('root#index');

    $r->any('/login')   ->to('auth#login');
    $r->any('/register')->to('auth#register');
    $r->get('/logout')  ->to('auth#logout');

    my $auth = $r->under('/private')->to('auth#check');
    $auth->get('/')->to('root#private');
}

1;
