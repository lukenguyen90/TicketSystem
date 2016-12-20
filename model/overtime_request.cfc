component persistent="true" {

	property name="id" fieldtype="id" generator="native" setter="false";

	property name="createTime" 	ormtype="timestamp";
	property name="requestTime" 	ormtype="timestamp";

	property name="hours" ormtype="float" default = 1 ;

	property name="status" ormtype="integer" default = 0 ;
	property name="acceptTime" 	ormtype="timestamp";

	property name="tasks" ormtype="string";

	property name="userId" ormtype="integer";
	property name="projectId" ormtype="integer";

	property name="comment" ormtype="text";

	property name="from" ormtype="string";
	property name="to" ormtype="string";

}