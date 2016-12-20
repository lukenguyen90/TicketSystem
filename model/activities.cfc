component persistent="true" {
	property name="activityID" fieldtype="id" generator="native" setter="false";
	property name="activityName" ormtype="string";
	property name="actions" fieldtype="one-to-many" cfc="actions" fkcolumn="activityID";
}