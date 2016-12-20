<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
		<meta charset="utf-8" />
		<title>Login</title>

		<meta name="description" content="User login page" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />

		<!-- bootstrap & fontawesome -->
    <link rel="stylesheet" href="/ACEAdmin/assets/css/bootstrap.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/font-awesome.min.css" />

    <!-- page specific plugin styles -->

    <!-- text fonts -->
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-fonts.css" />

    <!-- ace styles -->
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace.min.css" />

    <!--[if lte IE 9]>
        <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-part2.min.css" />
    <![endif]-->
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-skins.min.css" />
    <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-rtl.min.css" />

    <!--[if lte IE 9]>
      <link rel="stylesheet" href="/ACEAdmin/assets/css/ace-ie.min.css" />
    <![endif]-->

    <!-- inline styles related to this page -->

    <!-- ace settings handler -->
    <script src="/ACEAdmin/assets/js/ace-extra.min.js"></script>
    <script src="/js/md5.js"></script>

    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->

    <!--[if lte IE 8]>
    <script src="../assets/js/html5shiv.js"></script>
    <script src="../assets/js/respond.min.js"></script>
    <![endif]-->
	</head>

	<body class="login-layout light-login">
		<div class="main-container">
			#body#
		</div>
		<!-- basic scripts -->

		<!--[if !IE]> -->
		<script type="text/javascript">
			window.jQuery || document.write("<script src='/ACEAdmin/assets/js/jquery.min.js'>"+"<"+"/script>");
		</script>

		<!-- <![endif]-->

		<!--[if IE]>
		<script type="text/javascript">
		 window.jQuery || document.write("<script src='/ACEAdmin/assets/js/jquery1x.min.js'>"+"<"+"/script>");
		</script>
		<![endif]-->
		<script type="text/javascript">
			if('ontouchstart' in document.documentElement) document.write("<script src='/ACEAdmin/assets/js/jquery.mobile.custom.min.js'>"+"<"+"/script>");
		</script>

		<!-- inline scripts related to this page -->
		<script type="text/javascript">
			jQuery(function($) {
			 $(document).on('click', '.toolbar a[data-target]', function(e) {
				e.preventDefault();
				var target = $(this).data('target');
				$('.widget-box.visible').removeClass('visible');//hide others
				$(target).addClass('visible');//show target
			 });
			});
			
			
			
			//you don't need this, just used for changing background
			jQuery(function($) {
			 $('##btn-login-dark').on('click', function(e) {
				$('body').attr('class', 'login-layout');
				$('##id-text2').attr('class', 'white');
				$('##id-company-text').attr('class', 'blue');
				
				e.preventDefault();
			 });
			 $('##btn-login-light').on('click', function(e) {
				$('body').attr('class', 'login-layout light-login');
				$('##id-text2').attr('class', 'grey');
				$('##id-company-text').attr('class', 'blue');
				
				e.preventDefault();
			 });
			 $('##btn-login-blur').on('click', function(e) {
				$('body').attr('class', 'login-layout blur-login');
				$('##id-text2').attr('class', 'white');
				$('##id-company-text').attr('class', 'light-blue');
				
				e.preventDefault();
			 });
			 
			});
		</script>
	</body>
</html>
</cfoutput>