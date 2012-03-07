<?php

include('connect.php');

$result = mysql_query("SELECT node.title FROM node_revision INNER JOIN node ON node.vid = node_revision.vid WHERE node.status = 1 AND type = 'artist'")
or die(mysql_error());

// Print out the contents of the entry 
echo "[";
while($row = mysql_fetch_array( $result )) {
	echo '{"artist_title":"'.$row['title'].'"}';
}
echo "]";
?>