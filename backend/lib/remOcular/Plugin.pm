package remOcular::Plugin;

use warnings;
use strict;
use Fcntl ':flock'; # import LOCK_* constants

use base 'Mojo::Base';

=head1 NAME

remOcular::Plugin - Base Class for implementing SmokeTrace Plugins

=head1 SYNOPSIS

 package remOcular::Plugin::Traceroute;
 use base qw(remOcular::Plugin);
 __PACKAGE__->attr('argA');
     
=head1 DESCRIPTION

Base class for all remOcular plugins. The base class is based on L<Mojo::Base>

=cut

'$Revision: 363 $ ' =~ /Revision: (\S*)/;
our $VERSION = "0.$1";

=head1 METHODS

All the methods from L<Mojo::Base> and the following

=head2 $x->B<get_config>();

The plugin can ask the user to provide configuration parameters. By default,
no parameters are specified.

=cut

sub get_config {
    my $self = shift;
    return {};
}

=head2 my ($title,$interval,$error) = $x->B<check_params>(param_hash);

Check the parameter set provided. Return the title of the window and the interval
the browser should poll for new values. If there is a problem with the parameters,
return an error.

=cut

sub check_params {
    my $self = shift;
    my $params = shift;
    die "implement your own check_params in your plugin";
}


=head2 $x->B<start_plugin>(filename,param_hash);

the server has forked us. All the plugin has todo now, is to run its data
gathering operation according to the parameters provided and write the
results to the filename provided.

The master process will read that file for new information whenever the
browser polls.

=cut

sub start_instance {
    my $self = shift;
    my $outfile = shift;
    my $params = shift;    
    die "provide your own!"
}


=head2 my ($ratio,$start_size,$end_size) = $x->append_data($output,$data);

Adds the $data to the output file. Locking the file in the process
to make sure the reading and writing will not interfear with each other.

The ratio is the part of the file size contributed by this update.

=cut

sub append_data {
    my $self = shift;
    my $output = shift;
    my $data = shift;    
    open(my $fh,">>$output") or return "Opening $output: $!\n";
    flock($fh,LOCK_EX);
    # maybe the file got trunkated in the meantime
    seek($fh,0,2); 
    my $start = tell($fh);    
    if ($data){
        print $fh $data;
        my $end = tell($fh);
        close $fh;
        my $ratio = ($end-$start)/$end; 
        return wantarray ? ($ratio,$start,$end) : $ratio;
    }
    close $fh;
    return wantarray ? (0,$start,$start) : 0;
}

1;

__END__

=back

=head1 COPYRIGHT

Copyright (c) 2010 by OETIKER+PARTNER AG. All rights reserved.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

=head1 AUTHOR

S<Tobias Oetiker E<lt>tobi@oetiker.chE<gt>>

=head1 HISTORY

 2010-11-04 to 1.0 initial

=cut

# Emacs Configuration
#
# Local Variables:
# mode: cperl
# eval: (cperl-set-style "PerlStyle")
# mode: flyspell
# mode: flyspell-prog
# End:
#
# vi: sw=4 et
