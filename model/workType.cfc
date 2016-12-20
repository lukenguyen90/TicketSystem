component persistent="true" table="worktype" {
	property name="workTypeID" fieldtype="id" generator="native" setter="false";
	property name="name" 		ormtype="string";
	property name="description" ormtype="text";
	property name="users" 		fieldtype="many-to-many" 	cfc="users"  	singularname="user" 	linktable="userWorkTypes"	 type="array";
	property name="projects" 	fieldtype="many-to-many" 	cfc="projects" 	singularname="project" 	linktable="projectWorkTypes" type="array";
	property name="price" 		fieldtype="one-to-many" 	cfc="prices" 	fkcolumn="workTypeID";
	property name="timeEntries" fieldtype="one-to-many" 	cfc="timeEntries" fkcolumn="workTypeID";
}