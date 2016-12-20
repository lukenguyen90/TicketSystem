component persistent="true" {
	property name="statusID" fieldtype="id" generator="native" setter="false";
	property name="statusName" ormtype="string" length=50;
	property name="color"  ormtype="string" length=10;
	property name="userTypes" fieldtype="many-to-many" cfc="userType" type="array" linktable="statusUserType" singularname="userType";
	property name="tickets"  	fieldtype="one-to-many" cfc="tickets" fkcolumn="statusID" singularname="ticket";
}