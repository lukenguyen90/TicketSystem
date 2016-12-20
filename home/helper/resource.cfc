component output="false" displayname=""  {

	public function init(required any fw){
		variables.fw =fw;
		return this;
	}

	public void function loadResource()
	{
		var qrylabel = QueryExecute("select lb.*, l.shortlanguage as lang 
										from label lb 
										inner join language l on lb.languageId = l.languageId");
		APPLICATION.labels = [];
		for(item in qrylabel)
		{
			var label  = {};
			label.keyword = item.keyword;
			label.value = item.value;
			label.languageId = item.languageId;
			label.labelId = item.labelId;
			arrayPrepend(APPLICATION.labels, label);
		}
	}
}	