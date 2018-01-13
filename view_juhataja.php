<?php
	try {
		session_start();
		require_once('include/functions.php');
		global $db;
		if(!isLoggedIn()){
			header('Location: ./');
		}
	} catch (Exception $e) {
		print_r($e);
	}
?>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <title>Elektroonika catalog</title>
	
	<!-- Owner style-->
	<!--Font Awesome CDN-->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css">
    <!-- Bootstrap -->
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
	<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
	<link href="assets/css/style.css" rel="stylesheet">
	<!--Google Fonts -->
	<link href='https://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
	<link href="assets/css/style.css" rel="stylesheet" type="text/css"/>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->

    <style>
    .marketing{
	
      text-align: center;
      margin-bottom: 20px;
	  padding-top:70px;
	  
    }
	
	
    .divider{
      margin: 80px 0;
    }
    hr{
      border: solid 1px #eee;
    }
    .thumbnail img{
      width: 100%;
    }
	.navbar {
		border-radius: 0;
	}
	.categories .category.selected{
		border: 1px solid #ccc;
		height: 300px;
		background: #EEEEEE;		
	}
	.products .product{
		padding: 5px;
		width: 20%;
	}
	.products .product.status-3{
		background: #DDDDDD;
	}
	.products .product.status-2{
		background: #dca7a7;
	}
	.products .product.status-1{
		background: #D2EAC9;
	}
	.ui-autocomplete {
		z-index: 9999;
	}
	/*
	.products {
		padding: 48px;
		position: relative;
		text-align: center;
		margin: 0 auto;
		display: block;
	}
	*/
    </style>
  </head>
  <body>
  <?php printMenu() ?>
<?php
	echo '<table class="table table-hover">';
	echo '<thead>';
    echo '<tr class="active">';
    echo '<td>#</td>';
    echo '<td>Nimetus</td>';
    echo '<td>Hind</td>';
	echo '<td>Kirjeldus</td>';
	echo '<td>Loomise aeg</td>';
	echo '<td>Kogus</td>';
    echo '</tr>';
    echo '</thead>';
    echo '<tbody>';
	foreach($products = $db->get_all_products() as $product)
	if(!empty($products)) {
	
	echo '<tr>';
    echo '<td>' . $product['kaup_id'] . '</td>';
    echo '<td>' . $product['nimetus'] . '</td>';
    echo '<td>' . $product['hetke_hind'] . '</td>';
	echo '<td>' . $product['kirjeldus'] . '</td>';
	echo '<td>' . $product['loomise_aeg'] . '</td>';
	echo '<td>' . $product['kogus'] . '</td>';
    echo '</tr>';
	}
	echo '</tbody>';
	echo '<table>';
	
	?>
	</div>
	<!-- End Content -->

    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="jquery.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="assets/js/bootstrap.min.js"></script>
	<script src="assets/js/bootstrap-datepicker.js"></script>
  </body>
</html>