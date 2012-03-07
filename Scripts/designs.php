<?php

include('connect.php');

$result = mysql_query("SELECT uri, entity_id FROM file_managed INNER JOIN field_data_uc_product_image ON fid = uc_product_image_fid")
or die(mysql_error());

// Print out the contents of the entry 
echo "[";
while($row = mysql_fetch_array( $result )) {
	echo '{"file_name":"'.substr($row['uri'],9).'", "designId":"'.$row['entity_id'].'"},';
}
echo "]";
?>