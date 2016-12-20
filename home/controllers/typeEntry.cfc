component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}

	function default(struct rc)
	{
		rc.list = QueryExecute("SELECT * FROM typeTimeEntries");
		rc.listR = QueryExecute("SELECT * FROM typeTimeEntries WHERE parent = 0");
	}

	function changekeyword(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE typeTimeEntries 
									SET typeName = '"&rc.key&"' 
									WHERE  typeTimeEntriesID = "&id);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function changerootid(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("UPDATE typeTimeEntries 
									SET parent = '"&rc.root&"' 
									WHERE  typeTimeEntriesID = "&id);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}

	function addnewlabel(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var type 		 = entityNew("typeTimeEntries",{
				typeName 	 = rc.keyword,
				parent 	 	 = rc.root
			});
			entitySave(type);
			var rs = {success:true, labelId:type.typeTimeEntriesID}
			variables.fw.renderData("json",rs);
		}
		else variables.fw.renderData("text",false);
	}

	function deletelabel(struct rc)
	{
		if(CGI.REQUEST_METHOD eq "POST" AND SESSION.isLoggedIn){
			var query=QueryExecute("DELETE FROM typeTimeEntries WHERE  typeTimeEntriesID = "&rc.labelId);
			variables.fw.renderData("text",true);
		}
		else variables.fw.renderData("text",false);
	}
}