#
# (c) Jan Gehring <jan.gehring@gmail.com>
# 
# vim: set ts=3 sw=3 tw=0:
# vim: set expandtab:

package ServerControl::Module::Cron;

use strict;
use warnings;

use ServerControl::Module;
use ServerControl::Commons::Process;

use base qw(ServerControl::Module);

our $VERSION = '0.93';

use Data::Dumper;

__PACKAGE__->Parameter(
   help  => { isa => 'bool', call => sub { __PACKAGE__->help; } },
);

sub help {
   my ($class) = @_;

   print __PACKAGE__ . " " . $ServerControl::Module::Cron::VERSION . "\n";

   printf "  %-20s%s\n", "--path=", "The path where the instance should be created";
   printf "  %-20s%s\n", "--min=", "Minute";
   printf "  %-20s%s\n", "--hour=", "Hour";
   printf "  %-20s%s\n", "--day=", "Day";
   printf "  %-20s%s\n", "--month=", "Month";
   printf "  %-20s%s\n", "--weekday=", "Day of week";
   printf "  %-20s%s\n", "--command=", "The Command to be executed";
   print "\n";
   printf "  %-20s%s\n", "--create", "Create the job";
   printf "  %-20s%s\n", "--start", "Start the job";

}

sub start {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);
   my $args = ServerControl::Args->get;
   my $cmd  = ServerControl::FsLayout->get_file("Exec", "job");
   my $log  = ServerControl::FsLayout->get_directory("Runtime", "log");

   spawn("$cmd >>$path/$log/$name.log");
}

sub create {
   my ($class) = @_;

   my ($name, $path) = ($class->get_name, $class->get_path);
   my $args = ServerControl::Args->get;

   my $cmd     = $args->{"command"} || "*";
   my $min     = $args->{"min"}     || "*";
   my $hour    = $args->{"hour"}    || "*";
   my $day     = $args->{"day"}     || "*";
   my $month   = $args->{"month"}   || "*";
   my $weekday = $args->{"weekday"} || "*";
   my $user    = $args->{"user"}    || "root";

   my $job_file = ServerControl::FsLayout->get_file("Configuration", "cronfile");
   open(my $fh, ">", "$path/$job_file") or die($!);
   print $fh "$min $hour $day $month $weekday $user $cmd\n";
   close($fh);

   symlink("$path/$job_file", "/etc/cron.d/$name");
}


