component persistent="true" {
	property name="ticketID" fieldtype="id" generator="native" setter="false";
	property name="code" 		ormtype="string" length=50;
	property name="title" 		ormtype="string";
	property name="cc" 			ormtype="string" length=1000;
	property name="description" ormtype="text";
	property name="dueDate" 	ormtype="datetime";
	property name="estimate" 	ormtype="double";
	property name="point" 		ormtype="numeric";
	property name="reportDate" 	ormtype="datetime";
	property name="startDate" 	ormtype="datetime";
	property name="resovldDate" ormtype="datetime";
	property name="closedDate" ormtype="datetime";
	property name="paid" 		ormtype="boolean";
	property name="isInDay" 		ormtype="boolean" default='false';
	// tracker
	property name="isLogStart" 	ormtype="boolean" default='false' ;

	property name="dorder" 		ormtype="numeric";
	property name="ticketType"  fieldtype="many-to-one" cfc="ticketTypes" 	fkcolumn="ticketTypeID" ;
	property name="priority"  	fieldtype="many-to-one" cfc="priority" 		fkcolumn="priorityID" ;
	property name="status"  	fieldtype="many-to-one" cfc="status" 		fkcolumn="statusID" ;
	property name="version"  	fieldtype="many-to-one" cfc="versions" 		fkcolumn="versionID" ;
	property name="assignedUser"fieldtype="many-to-one" cfc="users" 		fkcolumn="assignedUserID" ;
	property name="testerUser"	fieldtype="many-to-one" cfc="users" 		fkcolumn="testerUserID" ;
	property name="reportedUser"fieldtype="many-to-one" cfc="users" 		fkcolumn="reportedByUserID" ;
	property name="module"  	fieldtype="many-to-one" cfc="modules" 		fkcolumn="moduleID" ;
	property name="project"  	fieldtype="many-to-one" cfc="projects" 		fkcolumn="projectID" ;
	property name="epic"  		fieldtype="many-to-one" cfc="epic" 			fkcolumn="epicID" ;
	property name="ticketComments" 	fieldtype="one-to-many" cfc="ticketComments" fkcolumn="ticketID" singularname="ticketComment";
	property name="timeEntries" 	fieldtype="one-to-many" cfc="timeEntries" fkcolumn="ticketID" singularname="timeEntry";
	property name ="files" 		fieldtype="many-to-many" cfc="files" type="array" linktable="ticketFiles" singularname="file";
	property name="resolution" fieldtype="many-to-one" cfc="resolution" fkcolumn="solutionID";
	property name="tag" 	fieldtype="many-to-many" cfc="tags" singularname="tag" linktable="ticketTags" type="array";

	property name="table" 		fieldtype="many-to-many" cfc="ticketManage" singularname="table" linktable="ticketManageTable" type="array";
}