component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="isMoreday" 		ormtype="boolean";
	property name="timeOff" ormtype="string";
	property name="startDate" 	ormtype="timestamp";
	property name="endDate"   	ormtype="timestamp";
	property name="sicknessDay"		ormtype="float";
	property name="annualDay" 		ormtype="float";
	property name="dueToSickness" 	ormtype="string";
	property name="user"			ormtype="integer";
	property name="isTrash" 		ormtype="boolean" default="false";
}