<?php
	error_reporting(E_ERROR | E_PARSE);
	session_start();
	class DBException extends Exception {
		private $_db_error;
		public function __construct($message, $db_error, $code = 0, Exception $previous = null) {
			$this->_db_error = $db_error;
			parent::__construct($message, $code, $previous);
		}
		public function __toString() {
			return __CLASS__ . "{$this->message}: {$this->_db_error}\n";
		}
	}
	class DB {
		private $_string;
		public $connection;
        /**
         * The Constructor
         */
        public function __construct($string) {
			$this->_string = $string;
			$this->connection = pg_connect($this->_string);
			if(!$this->connection) throw new DBException("Can't connect to database", "");
		}
		
		public function query($query) {
			$result = pg_query($this->connection, $query);
			//print_r($result);
			if(!$result) throw new DBException(pg_last_error($this->connection));
			return $result;
		}
	}
	class DBHelperClass {
		public $_db;
		public function __construct() {
			$this->_db = new DB("host=apex.ttu.ee dbname=elektronika_katalog user=t120949 password=d63034b");//last DB
			//print_r($this);
		}
		function isAdmin($login, $password) {
			if(isset($_SESSION['isAdmin']) && !empty($_SESSION['isAdmin'])) return $_SESSION['isAdmin'] == 't' ? true : false;
			else {
				$userID = NULL;
				$login = trim(strip_tags(stripslashes($login)));
				$password = trim(strip_tags(stripslashes($password)));
				if(!empty($login) && !empty($password)) {
					//$password = md5($password);
					//SELECT UserID FROM t121088_Usersv2 WHERE Login='axive' AND Password='123';
					$query = "SELECT * FROM f_on_admin('{$login}','{$password}')";
					//die($query);
					if ($result = $this->_db->query($query)) {
						while($row = pg_fetch_assoc($result)) {
							//return $row;
							$_SESSION['isAdmin'] = $row['f_on_admin'];
							if($row['f_on_admin'] == 't') return true;
							else return false;
						}
						//$result->close();
					}
				} else return false;
			}
		}
		function isWorker($login, $password) {
			$userID = NULL;
			$login = trim(strip_tags(stripslashes($login)));
			$password = trim(strip_tags(stripslashes($password)));
			//$password = md5($password);
			//SELECT UserID FROM t121088_Usersv2 WHERE Login='axive' AND Password='123';
			$query = "SELECT * FROM f_on_tootaja('{$login}','{$password}')";
			//die($query);
			if($result = $this->_db->query($query)) {
				while($row = pg_fetch_assoc($result)) {
					//return $row;
					if($row['f_on_admin'] == 't') return true;
					else return false;
				}
				//$result->close();
			}
		}
		function get_detail_products() {
			$items = array();
			$query = 'select * from kogu_kaupade_nimekiri;';
			if ($result = $this->_db->query($query)) {
				while ($row = pg_fetch_assoc($result)) {
					//$photoID = (int)$row['ID'] + 1;
					$items[] = $row;
				}
				//$result->close();
			}
			return $items;
		}
		function get_all_products() {
			$products = array();
			$query = 'SELECT * FROM Kaup';
			if ($result = $this->_db->query($query)) {
				while ($row = pg_fetch_assoc($result)) {
					//$photoID = (int)$row['ID'] + 1;
					$products[] = $row;
				}
				//$result->close();
			}
			return $products;
		}
		function get_all_categories(){
			$categorys=array();
			$query = 'SELECT * FROM Kauba_kategooria';
			if ($result = $this->_db->query($query)) {
				while ($row = pg_fetch_assoc($result)) {
					//$photoID = (int)$row['ID'] + 1;
					$categorys[] = $row;
				}
				//$result->close();
			}
			return $categorys;
		}

		function editProduct($post, $files) {
			$post = array_filter($post);
			$data = array();
			$dic = array(
				'kaup_id'					=>	"%d",
				'kauba_seisundi_liik_kood'	=>	"%d::SMALLINT",
				'kauba_kategooria_kood'		=>	"%d::SMALLINT",
				'tootja_kood'				=>	"%d::SMALLINT",
				'isikukood'					=>	"'39212233718'",
				'nimetus'					=>	"'%s'",
				'hetke_hind'				=>	"%d",
				'kirjeldus'					=>	"'%s'",
				//'loomis_aeg'				=>	"date_trunc('minute',localtimestamp(0))",
				'kogus'						=>	"%d::SMALLINT",
				'pilt'  					=>  "'no_product.png'",
				// 'qty'  				=>  'kogus',
				// 'comments'  		=>  'komentaar',
				// 'rating' 			=>  'hinnang'				
			);
			foreach($dic as $key => &$value) {
				$value = $key . " = " . sprintf($value, $post[$key]);
			}
			//print_r($dic);
			$product_id = is_numeric($post['kaup_id']) ? $post['kaup_id'] : NULL;
			if(!empty($product_id)) {
				unset($dic['kaup_id']);
				if(isset($_FILES['photoUploader']) && !empty(isset($_FILES['photoUploader']['name']))) {
					print_r($_FILES['photoUploader']);
					$saved_file = upload_my_file(urlencode(explode('.', $_FILES['photoUploader']['name'])[0]));
					//var_dump($saved_file);
					print_r($saved_file);
					if($saved_file !== FALSE) {
						$dic['pilt'] = "pilt = '{$saved_file}'";
						//$saved_file
					}
					//$dic['pilt'];
				}
				$query = "UPDATE kaup
					SET " . implode(',', $dic) . "
					WHERE kaup_id='{$product_id}';";
				//$query = "SELECT * FROM f_kaupade_muutmine(" . implode(',', $dic) . ")";
				//print_r($query);
				//SELECT * FROM f_kaupade_muutmine(78747474,'LLenox',18.00,'vana version','hgjh',3::SMALLINT);
				return $result = $this->_db->query($query);
				// if($result) {
					// echo '!!!';
				// }
				// while ($row = pg_fetch_assoc($result)) {
					// print_r($row);
					// ////555555555555555555555555555
					// //	$dic['kaup_id'] = $row[''];
					// //555555555555555555555555555
				// }
				//return $dic['kaup_id'];
			} return false;
			//print_r();
		}
		function deleteProduct($product_id) {
			print_r($product_id);
			$result = $this->_db->query("select * from f_kaupade_kustutamine({$product_id})");
			$deleted = false;
			while ($row = pg_fetch_assoc($result)) {
				if($row['f_kaupade_kustutamine'] == 'f') $deleted = true;
				//$row['src'] = getImageSrc($row['Filename'], $row['Description']);
				////555555555555555555555555555
				//	$dic['kaup_id'] = $row[''];
				//555555555555555555555555555
				//print_r(array($row));
			
			}
			return $added;
		}
		function updateImageToProduct($product_id, $img_path) {
			$result = $this->_db->query("select * from f_kaup_pildi_lisamine({$product_id}::smallint,'{$img_path}')");
			$added = false;
			while ($row = pg_fetch_assoc($result)) {
				if($row['f_kaup_pildi_lisamine'] == 't') $added = true;
				//$row['src'] = getImageSrc($row['Filename'], $row['Description']);
				////555555555555555555555555555
				//	$dic['kaup_id'] = $row[''];
				//555555555555555555555555555
				print_r(array($row));
			
			}
		}
		function addProduct($post, $files) {
			$post = array_filter($post);
			$data = array();
			//$post['pilt'] = '';
			//$NEXT_ID;
			$dic = array(
				'kauba_seisundi_liik_kood'	=>	"%d::SMALLINT",
				'kauba_kategooria_kood'		=>	"%d::SMALLINT",
				'tootja_kood'				=>	"%d::SMALLINT",
				'isikukood'					=>	"'39212233718'",
				'nimetus'					=>	"'%s'",
				'hetke_hind'				=>	"%d",
				'kirjeldus'					=>	"'%s'",
				'kogus'						=>	"%d::SMALLINT",
				'pilt'  					=>  "'no_product.png'",
				//'pilt'  					=>  "''",
				// 'comments'  		=>  'komentaar',
				// 'rating' 			=>  'hinnang'				
			);
			foreach($dic as $key => &$value) {
				$value = sprintf($value, $post[$key]);
			}
			$query = "SELECT * FROM f_lisa_kaup(" . implode(',', $dic) . ")";
			//print_r($query);
			//SELECT * FROM f_lisa_kaup1(
			//	1::SMALLINT,4::SMALLINT,2::SMALLINT,'39212233718','Asus computer S22',1000,'hea arvuti',5::smallint,''
			//);
			
			//$keys = implode(',')
			//$query = "INSERT INTO t121088_Comments (UserID, PhotoID, Text, CommentDate) VALUES ({$userID}, {$photoID}, '{$comment}', '" . date('Y-m-d') ."');";
			//if($this->_db->query($query) === TRUE) return true;
			//return false;
			$result = $this->_db->query($query);
			$inserted_id = '';
			while ($row = pg_fetch_assoc($result)) {
				//if($row['f_on_admin'] == 't') $added = true;
				if(isset($row['f_lisa_kaup'])) {
					$inserted_id = $row['f_lisa_kaup'];
				}
				//$row['src'] = getImageSrc($row['Filename'], $row['Description']);
				////555555555555555555555555555
				//	$dic['kaup_id'] = $row[''];
				//555555555555555555555555555
			
			}
			//print_r(pg_fetch_all($result));
			if(!empty($inserted_id)) {
				//print_r($_FILES);
				if(isset($_FILES['photoUploader']) && !empty(isset($_FILES['photoUploader']['name']))) {
					$saved_file = upload_my_file(urlencode(explode('.', $_FILES['photoUploader']['name'])[0]));
					//var_dump($saved_file);
					if($saved_file !== FALSE) {			
						$this->updateImageToProduct($inserted_id, $saved_file);
					}
					//$dic['pilt'];
				}
			}
			return $inserted_id;
			//print_r();
		}
	}
	$db = new DBHelperClass();
	//Image Functions
	function getImageInfo($img_path) {
		$size = getimagesize($img_path, $info);
		return $size;
	}
	function getImagePath($fileName) {
		return count(explode('.', $fileName)) > 1 ? $fileName : "data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9InllcyI/PjxzdmcgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB3aWR0aD0iMjQyIiBoZWlnaHQ9IjIwMCIgdmlld0JveD0iMCAwIDI0MiAyMDAiIHByZXNlcnZlQXNwZWN0UmF0aW89Im5vbmUiPjxkZWZzLz48cmVjdCB3aWR0aD0iMjQyIiBoZWlnaHQ9IjIwMCIgZmlsbD0iI0VFRUVFRSIvPjxnPjx0ZXh0IHg9IjkzIiB5PSIxMDAiIHN0eWxlPSJmaWxsOiNBQUFBQUE7Zm9udC13ZWlnaHQ6Ym9sZDtmb250LWZhbWlseTpBcmlhbCwgSGVsdmV0aWNhLCBPcGVuIFNhbnMsIHNhbnMtc2VyaWYsIG1vbm9zcGFjZTtmb250LXNpemU6MTFwdDtkb21pbmFudC1iYXNlbGluZTpjZW50cmFsIj4yNDJ4MjAwPC90ZXh0PjwvZz48L3N2Zz4=";
	}
	function getImageSrc($fileName, $alt = "", $styles = false) {
		$path = getImagePath($fileName);
		$image_sizes = getImageInfo($fileName);
		return "<img alt='{$alt}' src='{$path}' style='" . (count($image_sizes) > 0 && $styles === false  ? "max-width:" . $image_sizes[0] . "px" : $styles) . "'>";
	}
	function isLoggedIn() {
		return isset($_SESSION['username']);
	}
	function upload_my_file($fileid) {
		echo "starting";
		$target_dir = "uploads/";
		$target_file = $target_dir . basename($_FILES["photoUploader"]["name"]);

		echo "<p>$target_file " . $target_file;
		$uploadOk = 1;
		$info = pathinfo($_FILES['photoUploader']['name']);
		//die(print_r($_FILES, true));
		$ext = $info['extension'];
		$saved_file = $target_dir . $fileid . "." . $ext;
		$imageFileType = pathinfo($target_file, PATHINFO_EXTENSION);
		// Check if image file is a actual image or fake image
		if(isset($_POST["submit"])) {
			$check = getimagesize($_FILES["photoUploader"]["tmp_name"]);
			if($check !== false) {
				echo "File is an image - " . $check["mime"] . ".";
				$uploadOk = 1;
			} else {
				echo "File is not an image.";
				$uploadOk = 0;
			}
		}
		echo "all is fine before checks";
		// Check if file already exists
		if (file_exists($target_file)) {
			echo "Sorry, file already exists.";
			$uploadOk = 0;
		}
		// Check file size
		if ($_FILES["photoUploader"]["size"] > 5000000) {
			echo "Sorry, your file is too large.";
			$uploadOk = 0;
		}
		// Allow certain file formats
		if($imageFileType != "jpg" && $imageFileType != "png" && $imageFileType != "jpeg"
		&& $imageFileType != "gif" ) {
			echo "Sorry, only JPG, JPEG, PNG & GIF files are allowed.";
			$uploadOk = 0;
		}
		// Check if $uploadOk is set to 0 by an error
		if ($uploadOk == 0) {
			echo "Sorry, your file was not uploaded.";
			// if everything is ok, try to upload file
		} else {
			if (move_uploaded_file(
			$_FILES["photoUploader"]["tmp_name"], $saved_file)) {
				echo "<p>The file ". basename( $_FILES["photoUploader"]["name"]). " has been uploaded.";
			} else {
				echo "<p>Sorry, there was an error uploading your file.";
			}
		}
		return $saved_file;
	}
	function getRandomColorClass() {
		$colors = array('green', 'red', 'yellow', 'blue');
		return $colors[rand(0, count($colors) - 1)];
	}
	function getUserID() {
		return !empty($_SESSION['ID']) ? $_SESSION['ID'] : $_COOKIE['ID'];
	}
	function getToken() {
		return !empty($_SESSION['token']) ? $_SESSION['token'] : $_COOKIE['token'];
	}
	function checkToken($token, $exceptions = false) {
		if(!empty($token)) {
			if($token == $_SESSION['token']) {
				return true;
			} else {
				if($exceptions) throw new Exception('Token is invalid!');
				else return false;
			}
		} else {
			if($exceptions) throw new Exception('Token is empty!');
			else return false;
		}
	}
	function resetCookies() {
		if (isset($_SERVER['HTTP_COOKIE'])) {
			$cookies = explode(';', $_SERVER['HTTP_COOKIE']);
			foreach($cookies as $cookie) {
				$parts = explode('=', $cookie);
				$name = trim($parts[0]);
				setcookie($name, '', time()-1000);
				setcookie($name, '', time()-1000, '/');
			}
		}
	}
	function get_product_img($product) {
		$img = "assets/images/thumb253.jpg";
		//print_r($product);
		if(isset($product['pilt']) && is_file($product['pilt'])) {
			$img = "./" . $product['pilt'];
		}
		return $img;
	}
	function namesToColumns() {
		return array(
			'product_id'		=>	'kaup_id',
			'product_status'	=>	'kauba_seisundi_liik_kood',
			'product_category'  =>  'kauba_kategooria_kood',
			'manufacturer'  	=>  'tootja_kood',
			'title'  			=>  'nimetus',
			'qty'  				=>  'kogus',
			'price'  			=>  'hetke_hind',
			'description'  		=>  'kirjeldus',
			'comments'  		=>  'komentaar',
			'rating' 			=>  'hinnang',
			'photoUploader'		=>	'pilt'			
		);
	}
	function printMenu() {
	?>
	<!--Google Fonts-->
	<link href='https://fonts.googleapis.com/css?family=Lobster' rel='stylesheet' type='text/css'>
	<!-- Header -->
     <nav class="navbar navbar-default navbar-inverse top_nav">
        <div class="container">
          <!-- Brand and toggle get grouped for better mobile display -->
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
              <span class="sr-only">Toggle navigation</span>
              
            </button>
            <a class="navbar-brand" href="index.php" style="
			font-family: 'Lobster', cursive;
			color: #9D9D9D;
			font-size: 20px;">Elektroonika e-pood</a>
          </div>

          <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <ul class="nav navbar-nav">
              <li class="active"><a href="#"><i class="fa fa-home"></i><span class="sr-only">(current)</span></a></li>      
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><i class="fa fa-product-hunt"></i> Kaubad<span class="caret"></span></a>
                <ul class="dropdown-menu">
                <?php
				global $db;
				$isAdmin = $db->isAdmin();
				if($isAdmin) {
					echo '<li><a href="./all_products.php#status-0"><i class="fa fa-check-circle"></i> Kõik kaubad</a></li>
                  <li><a href="./all_products.php#status-1"><i class="fa fa-check-circle"></i> Aktiivne kaubad</a></li>
                  <li><a href="./all_products.php#status-2"><i class="fa fa-ban"></i> Mitteaktiivsed kaubad</a></li>
                  <li><a href="./all_products.php#status-3"><i class="fa fa-circle-o"></i> Kustutatud kaubad</a></li>
				  <li role="separator" class="divider"></li>
				  <li class="add-product"><a href="./product.php?add"><i class="fa fa-plus-circle"></i>Lisa kaup</a></li>';
					
				}else {
					echo '
					<li><a href="./all_products.php#status-1"><i class="fa fa-check-circle"></i> Aktiivne kaubad</a></li>
				  <li role="separator" class="divider"></li>
				  <li><a href="./report.php?report"><i class="fa fa-circle-o"></i>Kaubade detailaruande vaatamine</a></li>';
				}
				
                  				
							
				  
				  
				  ?>
                </ul>
              </li>
			  <li><a href="./about.php">Projektidest</a></li>
            </ul>
            <form class="navbar-form navbar-left" role="search">
              <div class="form-group">
                <input id="search" type="text" class="form-control" placeholder="Search">
              </div>
              <button type="submit" class="btn btn-default">Submit</button>
            </form>
            <ul class="nav navbar-nav navbar-right">
				<?php if(isLoggedIn()): ?>
					<li><a href="#"><i class="fa fa-user"></i><?php echo $_SESSION['username']; ?></a></li>
					<a href="./?log_out" class="btn btn-danger" style="margin-top:7px;">Log out</a>
				<?php endif; ?>
            </ul>
		</div><!-- /.navbar-collapse -->
        </div><!-- /.container-fluid -->
     </nav>
	<?php
	}
	function pAction() {
		if(isset($_GET['add'])) return  'add';
		if(isset($_GET['edit'])) return 'edit';
	}