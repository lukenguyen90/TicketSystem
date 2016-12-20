component persistent="true" {
	property name="priceID" fieldtype="id" generator="native" setter="false";
	property name="price" ormtype="double";
	property name="project" 	fieldtype="many-to-one" cfc="projects" fkcolumn="projectID";
	property name="workType" 	fieldtype="many-to-one" cfc="workType" fkcolumn="workTypeID";
}