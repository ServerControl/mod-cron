use ExtUtils::MakeMaker;

WriteMakefile(
   NAME => 'ServerControl-Cron',
   VERSION_FROM => 'lib/ServerControl/Module/Cron.pm',
   PREREQ_PM => {'ServerControl' => '>0.93'},
   LICENSE => 'bsd'
);

