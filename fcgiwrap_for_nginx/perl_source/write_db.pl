#!/usr/bin/perl

$remote_ip = $ENV{ REMOTE_ADDR };
$remote_name = $ENV{ REMOTE_HOST };
$proxy_ip = $ENV{ HTTP_X_FORWARDED_FOR };
$cookie = $ENV{ HTTP_COOKIE };
$request_method = $ENV{ REQUEST_METHOD };

print "Content-type: text/html\n\n"; 
print "IP: $remote_ip <br>";
print "Hostname: $remote_host <br>";
print "IP proxy: $proxy_ip <br>";
print "Cookie: $cookie <br>";
print "Request method: $request_method <br>";

#----------------------------

use DBI;

#definition of variables
$db="db";
$host="mysql";
$user="root";
$password="root";

#connect to MySQL database
my $connection = DBI->connect ("DBI:mysql:database=$db:host=$host", $user, $password) 
  or die "Can't connect to database: $DBI::errstr\n";


# set the value of your SQL query
$query = "insert into hosts (REMOTE_ADDR, REMOTE_HOST, HTTP_X_FORWARDED_FOR, HTTP_COOKIE, REQUEST_METHOD)
          values (?, ?, ?, ?, ?)";

# prepare your statement for connecting to the database
$statement = $connection->prepare($query);

# execute your SQL statement
$statement->execute($remote_ip, $remote_name, $proxy_ip, $cookie, $request_method);

warn "Problem in retrieving results", $statement->errstr( ), "\n"
  if $statement->err( );

#disconnect  from database 
$connection->disconnect or warn "Disconnection error: $DBI::errstr\n";

exit;



