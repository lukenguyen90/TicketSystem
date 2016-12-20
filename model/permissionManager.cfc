component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="userId" 	ormtype="integer";
	property name="isActive"		ormtype="boolean" default=true;
}