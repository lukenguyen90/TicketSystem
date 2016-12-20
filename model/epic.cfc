component persistent="true" {
	property name="epicID" fieldtype="id" generator="native" setter="false";
	property name="epicName" ormtype="string" length=255;
	property name="epicDescription" ormtype="text" ;
	property name="epicColor"  ormtype="string" length=50;
	property name="epicPriority" ormtype="integer" ;
	property name="epicActive" ormtype="boolean" default=true ;

	property name="project" 	fieldtype="many-to-one" cfc="projects" fkcolumn="projectID";

	property name="tickets" 	fieldtype="one-to-many" cfc="tickets" fkcolumn="epicID" singularname="ticket";
}