component persistent="true" table="survey" {

	property name = "surveyID" fieldtype="id" generator="native" setter="false";
	property name = "developer" ormtype="string" length=91;
	property name = "VoteID" ormtype = "integer";
	property name = "surveyDate" ormtype="datetime";
	property name="users" fieldtype="many-to-one"  cfc="users" fkcolumn="userID" ;
}