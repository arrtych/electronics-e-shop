<?php
require_once('include/functions.php');
/*
	try {
		session_start();
		require_once('include/functions.php');
		global $db;
		if(!isLoggedIn()){
			header('Location: ./');
		}
	} catch (Exception $e) {
		print_r($e);
	}*/
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Add Kaup</title>
	
	<!-- Owner style-->
	<link href="assets/css/style.css" rel="stylesheet">
	<!--Font Awesome CDN-->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">

    <!-- Bootstrap -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
	
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script type="text/javascript" src="assets/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery.form.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="assets/js/bootstrap.min.js"></script>
	<script src="assets/js/main.js"></script>
	
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>
   <?php printMenu(); 
	?>
	

	
	<!-- Content -->
	<div class="container">
		<div class="row" style="padding: 62px;">
		<!--<div class="col-md-4 col-sm-4 col-xs-4">
			<div class="list-group">
			  <a class="list-group-item" href="#"><i class="fa fa-home fa-fw"></i>&nbsp; Home</a>
			  <a class="list-group-item" href="#"><i class="fa fa-book fa-fw"></i>&nbsp; List</a>
			  <a class="list-group-item" href="#"><i class="fa fa-cog fa-fw"></i>&nbsp; Settings</a>
			</div>
		</div>-->
			<!-- <div class="col-md-8 col-sm-8 col-xs-8">
			
				
			</div> -->
		</div>
		
		<?php
	echo '<table class="table table-hover">';
	echo '<thead>';
    echo '<tr class="active">';
    echo '<td>#</td>';
	echo '<td>Seisund</td>';
    echo '<td>Nimetus</td>';
	echo '<td>Hetke hind</td>';
	echo '<td>Kogus</td>';
	echo '<td>Kirjeldus</td>';
    echo '<td>Tootja</td>';
    echo '<td>Kategooria nimetus</td>';
    echo '<td>Kategooria kirjeldus</td>';
	echo '<td>Loomise aeg</td>';
	
    echo '</tr>';
    echo '</thead>';
    echo '<tbody>';
	foreach($items = $db->get_detail_products() as $product)
	if(!empty($items)) {
	
	echo '<tr>';
    echo '<td>' . $product['kaup_id'] . '</td>';
	echo '<td>' . $product['seisundi_nimetus'] . '</td>';
    echo '<td>' . $product['nimetus'] . '</td>';
	echo '<td>' . $product['hetke_hind'] . '</td>';
	echo '<td>' . $product['kogus'] . '</td>';
	echo '<td>' . $product['kirjeldus'] . '</td>'; 
    echo '<td>' . $product['tootja'] . '</td>';
    echo '<td>' . $product['kategooria_nimetus'] . '</td>';
    echo '<td>' . $product['kategooria_kirjeldus'] . '</td>';       
	echo '<td>' . $product['loomise_aeg'] . '</td>';
	
	// echo '<td>' . $product['kogus'] . '</td>';
    echo '</tr>';
	}
	echo '</tbody>';
	echo '<table>';
	
	?>
	</div>
	<!-- End Content -->
  </body>
</html>