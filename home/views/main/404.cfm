<cfset request.layout = false />
<!DOCTYPE html>
<html>
	<head>
		<title>Rasia Tickets System | 404 Page Not Found</title>
		<style type="text/css">
			body{
				background: rgba(221,221,221,1) no-repeat;
			}

			h1{
				/* Using the custom font we've included in the HTML tab: */
				font-family: Satisfy, cursive;
				font-weight:normal;
				font-size:80px;
				padding-top: 60px;
			}

			h2.small-quote{
				/* Using the custom font we've included in the HTML tab: */
				font-family: Satisfy, cursive;
				font-weight:normal;
				font-size:32px;
			}

			h3{
				/* Using the custom font we've included in the HTML tab: */
				font-family: Satisfy, cursive;
				font-weight:normal;
				font-size:32px;
			}

			.text-align-center{
				text-align: center;
			}

			.content-container{
				position: relative;
				width: 100%;
			}

			.logo{
				position: absolute;
				top: 0;
				right: 50%;
				z-index: -1;
				transform: translateX(-50%);	
			}

			@media (max-width: 1024px){
				h1{
					font-size: 65px;
				}

				h2.small-quote{
					font-size: 26px;
				}

				h3{
					font-size: 24px;
				}

			}

			@media (max-width: 768px){
				h1{
					font-size: 48px;
				}

				h2.small-quote{
					font-size: 20px;
				}

				h3{
					font-size: 20px;
				}

				.logo{
					top:5%;
					width: 72px;
				}
			}
		</style>

		<link href="http://fonts.googleapis.com/css?family=Satisfy" rel="stylesheet" />
	</head>
	<body>
		<div class="content-container text-align-center">
			<h1>404 Error</h1>
			<h2 class="small-quote">Page not found</h2>
			<h3>Sorry, the dog ate the page – the website is temporarily not available.</h3>
			<cfoutput>
				<img class="logo" src="http://#CGI.HTTP_HOST#/images/gallery/small-logo.png">
			</cfoutput>
		</div>
	</body>
	<div style="width: 50%; color: red; border: 2px dotted red; background-color: #f9f9f9; padding: 10px;">
		<h1 style="color: red;">ERROR!</h1>
		<div style="width: 100%; text-align: left;">
			<p><b>An error occurred!</b></p>
			<cfoutput>
				<cfif structKeyExists( request, 'failedAction' )>
					<b>Action:</b> #request.failedAction#<br/>
				<cfelse>
					<b>Action:</b> unknown<br/>
				</cfif>
				<b>Error:</b> #request.exception.cause.message#<br/>
				<b>Type:</b> #request.exception.cause.type#<br/>
				<b>Details:</b> #request.exception.cause.detail#<br/>
				<cfdump eval = request.exception>
			</cfoutput>
		</div>
	</div>
</html>