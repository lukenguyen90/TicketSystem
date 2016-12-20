component persistent="true" {
	property name="emailID" fieldtype="id" generator="native" setter="false";
	property name="emailKey" 	ormtype="string";
	property name="subject"		ormtype="string";
	property name="container"   ormtype="text";
	property name="description" ormtype="text";
}