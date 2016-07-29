#!/usr/bin/perl


#Ports to check for web server
my @portsToCheck = (80,443,5551,5552);
#Above port must open for our test.
for (my $i=0; $i < (scalar @portsToCheck); $i++) {
  my $port = $portsToCheck[$i];
  #print "Checking port: $portsToCheck[$i]\n";
  my $cmdOutput = `echo quit | nc 127.0.0.1 $port`;
  #print "Cmd out: $cmdOutput\b";
  my $rv = $?;
  my $responseString = $rv == 0? 'True' : 'False';
  print "Port $port Open: ".($rv == 0?'True':'False')."\n";
  if( $rv != 0) {
#If port is not opened then fail.
   print "Port $port must be open.\n";
   #exit 1;
  }
}




#Check if web page is returning correct data or not.
#curl -I -k -X GET  https://localhost:5552
my $httpPageUrl = "https://localhost:443";
my $pageResponse = `curl -I -k $httpPageUrl`;

if ($pageResponse =~ m/200/) {
  print "[OK] Page OK -> $httpPageUrl\n";
}else{
  print "Page not available. Seems like some problem with https port.\n";
}