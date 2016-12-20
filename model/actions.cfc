component persistent="true" {
	property name="actionID" fieldtype="id" generator="native" setter="false";
	property name="actionDate" 	ormtype="timestamp";
	property name="comments"   	ormtype="string" length=1024;
	property name="isNew"		ormtype="boolean";
	property name="user" 		fieldtype="many-to-one" cfc="users" 	 fkcolumn="userID";
	property name="activity" 	fieldtype="many-to-one" cfc="activities" fkcolumn="activityID";
}