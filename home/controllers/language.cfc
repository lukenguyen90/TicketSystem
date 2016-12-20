component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}

	function label(struct rc)
	{
		rc.lang = QueryExecute("SELECT * FROM label WHERE languageId = "&rc.id);
		rc.list = QueryExecute("SELECT * FROM language WHERE languageId = "&rc.id);
	}

	function default(struct rc)
	{
		rc.list = QueryExecute("SELECT * FROM language");
	}

	function changekeyword(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE label 
									SET keyword = '"&rc.key&"' 
									WHERE  labelId = "&id);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function autofill(struct rc)
	{
  		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn)
  		{
			var query=QueryExecute("INSERT INTO label(keyword,value,createDate,lastModified,languageId,tag) 
									SELECT keyword, 'value', #now()#, #now()#,"&rc.language&",tag
									FROM label
									WHERE languageId != "&rc.language&"
									AND label.keyword NOT IN (SELECT label.keyword FROM label WHERE languageId = "&rc.language&")
									GROUP BY keyword");
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function changevalue(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE label 
									SET value = '"&rc.key&"' 
									WHERE  labelId = "&id);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function changetag(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE label 
									SET tag = '"&rc.key&"' 
									WHERE  labelId = "&id);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function addLanguage(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("INSERT INTO language(shortlanguage, language, lastModified, createDate, defaultlanguage) 
									VALUES('"&rc.shortname&"','"&rc.languagename&"' , now() , now() , 0)");
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function changelanguageid(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE label 
									SET languageId = '"&rc.languageId&"' 
									WHERE  labelId = "&id);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function addnewlabel(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			// var query=QueryExecute("INSERT INTO label(keyword, value, languageId) VALUES('"&rc.keyword&"','"&rc.value&"',"&rc.languageId&")");
			var label 		 = entityNew("label",{
				keyword 	 = rc.keyword,
				lastModified = now(),
				createDate	 = now(),
				value 		 = rc.value,
				language 	 = entityLoadbyPK("language",rc.languageId)
			});
			entitySave(label);
			var rs = {success:true, labelId:label.labelId}
			variables.fw.renderData("json",rs);
		}
		else variables.fw.renderData("text",false);
	}

	function deletelabel(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("DELETE FROM label WHERE  labelId = "&rc.labelId);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}
}