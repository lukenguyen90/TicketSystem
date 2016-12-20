component persistent="true" {
	property name="versionID" fieldtype="id" generator="native" setter="false";
	property name="versionName" ormtype="string" length=50;
	property name="versionNumber"  ormtype="string" length=50;
	property name="versionDate" ormtype="date";
	property name="detail" ormtype="text";
	property name="project" fieldtype="many-to-one" cfc="projects" fkcolumn="projectID";
	property name="tickets"  fieldtype="one-to-many" cfc="tickets" fkcolumn="versionID" singularname="ticket" ;
}