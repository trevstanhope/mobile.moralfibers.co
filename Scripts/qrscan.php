<?php

echo '<html><title>Yes</title><body>This is where it should point to.';
if ($_GET['serial'] == null) {
	echo '<br/>No Serial # provided';
} else {
	echo '<br/>Serial #: '. $_GET['serial'];
}

echo '</body></html>';

?>