component accessors="true" extends="lib.framework" output="false" displayname=""  {

	this.sessionmanagement = true;
    this.sessionTimeout = CreateTimeSpan(0,0,30,30);
    this.sessionStorage = "memory";
	this.datasource = "ticket";
	// this.datasources["ticket"] = {
	// 	  class: 'org.gjt.mm.mysql.Driver'
	// 	, connectionString: 'jdbc:mysql://172.16.0.68:3306/ticket?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=true'
	// 	, username: 'dev'
	// 	, password: "encrypted:59b05835de1cc7f26dafeb55463e26d7869be61191295fce"
	// };
	this.ormEnabled = true;
	this.ormSettings = { logsql : true,cfclocation:'/model' };
	this.invokeImplicitAccessor = true;


         
    
	// this.sessioncookie.httponly = true;
	this.tag.cflocation.addtoken = false;
	this.location.addtoken	= false;
	// config session
	this.sessionManagement="Yes";
	this.sessionTimeOut=CreateTimeSpan(1,0,0,0);
	

	 variables.framework = {};
	 // setup subsystems
	 variables.framework.usingSubsystems = true;
	 variables.framework.siteWideLayoutSybsystem = 'common';
	 variables.framework.defaultSubsystem = 'home';
	 variables.framework.defaultItem = 'default';
	 // variables.framework.reloadApplicationOnEveryRequest = true;
	// routes 
	// variables.framework.routes = [
	// 	{ "$GET/:lang/:controllers/:method/:id/:code/$" = "/:controllers/:method/lang/:lang/id/:id/code/:code" },
	// 	{ "/login/" = "/login:/" }
	  // { "/product/:id" = "/product/view/id/:id", "/user/:id" = "/user/view/id/:id",
	  //   hint = "Display a specific product or user" },
	  // { "/products" = "/product/list", "/users" = "/user/list" },
	  // { "/old/url" = "302:/new/url" },
	  // { "/login:" = "/login/", "$POST/login" = "/auth/login" }
	  // { "$RESOURCES" = { resources = "posts", subsystem = "blog", nested = "comments,tags" } },
	  // { "*" = "/not/found" }
	// ];

	function setupSession() {
	 	SESSION.isLoggedIn    = false;
	 	SESSION.userType    = 0;
    }
    


	function setupApplication() {
		var bf = new lib.ioc( "model, controllers" );
		setBeanFactory( bf );
		//multi language
		application.ListLanguage = entityLoad("language");
		var qgetdefaultLanguage = QueryExecute("select languageId from language where defaultlanguage = 1")
		application.languageId = LSParseNumber(qgetdefaultLanguage.languageId);

		var helper = createObject("component", "home.helper.resource");
		helper.loadResource();
		ORMReload();
		APPLICATION.Resources = {};
	}

    function setupRequest()
    {
		if(SESSION.isLoggedIn == false )
		{
			if(FindNoCase("login",rc.action) == 0){
				if(CGI.path_info != "")
					GetPageContext().getResponse().sendRedirect("/index.cfm/login:?redirect="&CGI.path_info&"&"&CGI.QUERY_STRING);
				else 
					GetPageContext().getResponse().sendRedirect("/index.cfm/login:");
			}			 
		}else{
			if(FindNoCase("login",rc.action) == 1){
				GetPageContext().getResponse().sendRedirect("/index.cfm");
			}
		}
    }
    function onMissingView( required rc ){
		return view('main/404');
	}
}
