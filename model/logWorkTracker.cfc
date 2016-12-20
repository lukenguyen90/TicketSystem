component persistent="true" table="logworktracker" {
	property name="trackerID" fieldtype="id" generator="native" setter="false";

	property name="startTime" 	ormtype="timestamp";
	property name="finishTime" 	ormtype="timestamp";
	property name="updateTime" 	ormtype="timestamp";
	property name="acceptTime" 	ormtype="timestamp";

	property name="isPause"  	ormtype="boolean" default="false";
	property name="isFinish"  	ormtype="boolean" default="false";

	property name="totalPause" 	ormtype="integer" default=0 ;
	property name="totalWorked" ormtype="integer" default=0 ;

	property name="description" ormtype="text";

	property name="ticket" 	fieldtype="many-to-one" cfc="tickets" 	fkcolumn="ticketID";
	property name="user" 	fieldtype="many-to-one" cfc="users" 	fkcolumn="userID";
}