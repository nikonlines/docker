#!/usr/bin/perl

use LWP::UserAgent;

my $ua = LWP::UserAgent->new;

my $server_endpoint = "http://localhost/cgi-bin/write_db.pl";

# set custom HTTP request header fields
my $req = HTTP::Request->new(GET => $server_endpoint);
$req->header('content-type' => 'application/json');
$req->header('x-auth-token' => 'token');

my $resp = $ua->request($req);
if ($resp->is_success) {
    my $message = $resp->decoded_content;
    print "Received reply: $messagen";
}
else {
    print "HTTP GET error code: ", $resp->code, "n";
    print "HTTP GET error message: ", $resp->message, "n";
}

