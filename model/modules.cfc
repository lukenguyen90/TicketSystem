component persistent="true" {
	property name="moduleID" fieldtype="id" generator="native" setter="false";
	property name="moduleName" 	ormtype="string" length=50;
	property name="description" ormtype="text";
	property name="estimate" 	ormtype="double";
	property name="startDate" 	ormtype="datetime";
	property name="endDate" 	ormtype="datetime";
	property name="endDateEtm" 	ormtype="datetime";
	property name="status" 		ormtype="int";
	property name="isPrivate" 	ormtype="boolean" default=false ;
	property name="project"  	fieldtype="many-to-one" cfc="projects" 	fkcolumn="projectID" ;
	property name="leader" 		fieldtype="many-to-one" cfc="users" 	fkcolumn="moduleLeadID" ;
	property name="tickets"  	fieldtype="one-to-many" cfc="tickets" 	fkcolumn="moduleID" singularname="ticket" ;
	property name="users" 		fieldtype="many-to-many" cfc="users" 	singularname="user" 	linktable="moduleUsers" 	type="array";
}