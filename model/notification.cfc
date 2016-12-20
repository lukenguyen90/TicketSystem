component persistent="true" {
	property name="notificationID" fieldtype="id" generator="native" setter="false";
	property name="levelNumber" 	ormtype="integer";
	property name="levelString" 	ormtype="string";
	property name="description"   	ormtype="text";
}