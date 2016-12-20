component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="startDate" 	ormtype="timestamp";
	property name="endDate"   	ormtype="timestamp";
	property name="sicknessDay"		ormtype="integer";
	property name="annualDay" 		ormtype="integer";
	property name="dueToSickness" 	ormtype="string";
	property name="user"			ormtype="integer";
	property name="isTrash" 		ormtype="boolean" default="false";
}