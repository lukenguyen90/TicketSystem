component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="badgeNumber" ormtype="integer";	
	property name="userid" ormtype="integer";
	property name="firstname" ormtype="string" length="50";
}
