component persistent="true" {
	property name="solutionID" fieldtype="id" generator="native" setter="false";
	property name="solutionName" ormtype="string" length=50;
	property name="color"  ormtype="string" length=10;
	property name="des" ormtype="string";

	property name="tickets"  	fieldtype="one-to-many" cfc="tickets" fkcolumn="solutionID" singularname="ticket";
}