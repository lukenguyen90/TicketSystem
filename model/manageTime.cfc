component persistent="true" table="manageTime" {
	property name="Id" fieldtype="id" generator="native" setter="false";

	property name="slug"		ormtype="string";
	property name="isMoreday"	ormtype="boolean";
	property name="timeOff"     ormtype="string";
	property name="startTime"	ormtype="timestamp";
	property name="endTime"		ormtype="timestamp";
	property name="startHour"	ormtype="string";
	property name="endHour"		ormtype="string";
	property name="reason"		ormtype="string";
	property name="numberDay"	ormtype="float";
	property name="status"		ormtype="integer";
	property name="createTime" 	ormtype="timestamp";
	property name="updateTime" 	ormtype="timestamp";
	property name="acceptTime" 	ormtype="timestamp";
	property name="isNotice" 	ormtype="boolean" default=false;

	property name="user" 		fieldtype="many-to-one" cfc="users" 	fkcolumn="userID";
	property name="offtype"  	fieldtype="many-to-one"  cfc="dayofftype" fkcolumn="typeId";

	// first checking by leader or admin
	// 0 = new, 1 = approve , -1 = reject
	property name="firstCheck"			ormtype="interger" default=0;
	property name="firstCheckUser"		ormtype="interger" ;
}