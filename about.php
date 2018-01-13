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
  
	<!-- Page Content -->
	<div class="container">
		<div class="row">
			<div class="row" style="padding: 62px;">
			<div class="col-md-4 col-sm-4 col-xs-4">
				<div class="list-group">
				  <a class="list-group-item" href="javascript:history.back()"><i class="fa fa-home"></i>&nbsp; Tagasi</a>
				  <a class="list-group-item" href="./all_products.php#status-1"><i class="fa fa-list"></i>&nbsp; Nimekiri</a>
				</div>
			</div>
			<div class="col-md-9 col-sm-9 col-xs-12" style="width: 717px;">
				<div class="thumbnail">
				  <img src="assets/images/computerimgthin800_300.jpg" alt="item image" style="width:100%;">
				  <div class="caption">
					<h3 class="loBster">Elektroonika e-pood kataloog</h3>
					<b>Aine: </b><p>Andmebaasid II, IDU0230 2015</p>
					<b>Loojad: </b><p>Artur Lipin 120949IAPB ,Aleksei Fjodorov 131055IABB</p>
					<b>Kirjeldus </b>
					<p>
					Elektroonika e-poe kataloog,mis realiseerib e-poe allsüsteemi kaupade arvestust.
					Rakendusel on mitu kasutaja tüüpi(Administraator,Külastaja,Omanik).
					Rakendus võimaldab kaupade nimekiri vaadata.
					Põhitegevus on seotud kauba andmete muutmisega ja lisamisega.Õigus sellega tegeleda on ainult administraatoril.
					
					</p>
		
					
				  </div>
				</div>
			</div>
		</div>
	</div>
	</div>
 <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script type="text/javascript" src="assets/js/jquery-1.10.2.min.js"></script>
	<script type="text/javascript" src="assets/js/jquery.form.min.js"></script>
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="assets/js/bootstrap.min.js"></script>
    <script src="assets/js/jquery.ba-hashchange.min.js"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.isotope/2.2.2/isotope.pkgd.min.js"></script>
	<script src="assets/js/main.js"></script>
	</body>
	</html>