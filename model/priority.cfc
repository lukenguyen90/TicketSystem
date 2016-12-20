component persistent="true" {
	property name="priorityID" 	fieldtype="id" generator="native" setter="false";
	property name="priorityName"ormtype="string" length=50;
	property name="color"  		ormtype="string" length=10;
	property name="tickets"  	fieldtype="one-to-many" cfc="tickets" fkcolumn="priorityID" singularname="ticket" ;
}