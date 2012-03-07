<?php

include('connect.php');

if(!isset($_GET['UDID']) || !$_GET['design'] || !$_GET['vote']){
	echo '{"error":"Not enough parameters specified"}';
	return;
}

//check for an existing vote
$result = mysql_query("SELECT rowid FROM design_votes WHERE designId = " . $_GET['design'] . " AND udid = '" . $_GET['UDID']. "'");
$existing = -1;
if($result){
	$row = mysql_fetch_array($result);
	if($row)
	{
		$existing = $row['rowid'];
		//echo 'existing value found';
	}
}

//if this is true, no previous entry, make an update
if($existing >= 0){
	if (mysql_query("UPDATE design_votes SET vote = " . $_GET['vote'] . " WHERE rowid = " . $existing) ) {
		echo '{"result":"Your vote has been updated"}';
	} else {
		echo '{"error":"Server too busy, please try again later"}';
	}
	return;
}

//otherwise run an insert
$query = "INSERT INTO design_votes (designId, udid, vote) VALUES ('" . $_GET['design'] . "','" . $_GET['UDID'] . "'," . $_GET['vote'] . ")";
//echo $query;
if(mysql_query($query)) {
	echo '{"result":"Your vote has been placed"}';
} else {
	die('{"error":"' . mysql_error() . '"}');
}
?>