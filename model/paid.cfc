component persistent="true" table="paid" {
	property name="paidID" fieldtype="id" generator="native" setter="false";
	property name="company" 	 fieldtype="many-to-one" 	cfc="company" fkcolumn="companyID" ;
	property name="project" 	 fieldtype="many-to-one" 	cfc="projects" fkcolumn="projectID" ;
	property name="paidDate" 	ormtype="date";
}