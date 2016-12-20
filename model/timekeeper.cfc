component persistent="true" table="timekeeper" {
	property name="timekeeperID" fieldtype="id" generator="native" setter="false";
	property name="userid" ormtype="integer";
	property name="badgenumber" ormtype="integer";
	property name="name" ormtype="string" length="50";
	property name="login" ormtype="timestamp";
	property name="logout" ormtype="timestamp";
	property name="import_date" ormtype="timestamp";
}


