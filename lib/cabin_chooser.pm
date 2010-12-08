{

    package cabin_chooser::User;
    use Moose;

    has name   => ( isa => 'Str', is => 'ro', required => 1 );
    has choice => ( isa => 'Int', is => 'ro', required => 1 );
}

{

    package cabin_chooser;
    use Dancer ':syntax';
    use KiokuX::Model;
    our $VERSION = '0.1';

    use constant target => int( rand 100 + 1 );

    sub kioku {
        KiokuX::Model->new(
            dsn        => config->{kioku_dsn},
            extra_args => { create => 1, }
        );
    }

    get '/' => sub {
        my $k     = kioku();
        my $scope = $k->new_scope;
        template 'index',
          {
            user       => session->{user},
            target     => target,
            everything => $k->all_objects,
          };
    };

    post '/' => sub {
        my $k     = kioku();
        my $scope = $k->new_scope;
        session user => cabin_chooser::User->new(
            name   => params->{user},
            choice => params->{choice},
        );
        $k->store( session->{user} );
        template 'results',
          {
            user       => session->{user},
            target     => target,
            everything => $k->all_objects,
          };
    };

    true;
}
