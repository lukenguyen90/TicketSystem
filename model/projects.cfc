component persistent="true" {
	property name="projectID" 	fieldtype="id" generator="native" setter="false";
	property name="projectName" ormtype="string";
	property name="code" 		ormtype="string";
	property name="shortName"  	ormtype="string" length=50;
	property name="Description" ormtype="text";
	property name="shortdes" ormtype="text";
	property name="color" 		ormtype="string" length=10;
	property name="dueDate" 	ormtype="date";
	property name="projectURL" 	ormtype="string";
	property name="projecySlackChanel" ormtype="string";
	property name="budget" 		ormtype="double";
	property name="totalEstimate" 	ormtype="double";
	property name="active" 		ormtype="boolean";
	property name="leader" 	 fieldtype="many-to-one" 	cfc="users" fkcolumn="projectLeadID" ;
	property name="type" 	 fieldtype="many-to-one" 	cfc="projectTypes" fkcolumn="projectTypeID" ;
	property name="status" 	 fieldtype="many-to-one" 	cfc="projectStatus" fkcolumn="projectStatusID" ;
	property name="company" 	 fieldtype="many-to-one" 	cfc="company" fkcolumn="companyID" ;

	property name="workTypes" 	fieldtype="many-to-many" cfc="workType" singularname="workType" linktable="projectWorkTypes"type="array";
	property name="users" 		fieldtype="many-to-many" cfc="users" 	singularname="user" 	linktable="projectUsers" 	type="array";
	property name="prices" 	 fieldtype="one-to-many" 	cfc="prices" 	fkcolumn="projectID";
	property name="modules"  fieldtype="one-to-many" 	cfc="modules" 	fkcolumn="projectID" ;
	property name="epic"  fieldtype="one-to-many" 	cfc="epic" 	fkcolumn="projectID" singularname="epic";
	property name="tickets"  fieldtype="one-to-many" 	cfc="tickets" 	fkcolumn="projectID" singularname="ticket" ;
	property name="versions" fieldtype="one-to-many" 	cfc="versions" 	fkcolumn="projectID" singularname="version" ;
}