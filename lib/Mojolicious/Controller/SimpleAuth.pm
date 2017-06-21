package Mojolicious::Controller::SimpleAuth;
use Mojo::Base 'Mojolicious::Controller';

# Overload these in a subclass
sub register_user { ... }
sub load_user     { ... }
sub validate_user { ... }

sub config {
    my $class = shift;
    {
        no strict 'refs';
        return {
            autoload_user => 1,
            load_user     => sub { &{$class.'::load_user'}(@_)     },
            validate_user => sub { &{$class.'::validate_user'}(@_) },
        }
    }
}

sub check {
    my $self = shift;

    if ($self->is_user_authenticated) {
        return 1;
    } else {
        $self->redirect_to(
            $self->url_for('/login')->query(next => $self->req->url)
        ) and return 0;
    }
}

sub login {
    my $self = shift;

    if ($self->req->method eq 'GET') {
        my $next = $self->param('next') || '/';
        $self->render(next => $next);
    } else {
        my $ok = $self->authenticate(
            $self->param('email'),
            $self->param('password'),
            {},
        );
        if ($ok) {
            $self->redirect_to($self->param('next'));
        } else {
            $self->flash(message => ["error", "Invalid username or password"]);
            $self->redirect_to(
                $self->url_for('/login')->query(next => $self->req->url)
            );
        }
    }
}

sub register {
    my $self = shift;

    if ($self->req->method eq 'GET') {
        $self->render;
    } else {
        $self->register_user($self->param('email'), $self->param('password'));
        $self->flash(message => ["info", "You can now login with your credentials"]);
        $self->redirect_to($self->url_for('/login'));
    }
}

sub logout {
    my $self = shift;

    $self->helpers->logout;

    $self->redirect_to('/');
}

1;
