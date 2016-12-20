component persistent="true" {
	property name="Id" fieldtype="id" generator="native" setter="false";

	property name="title" 		ormtype="string";
	property name="start"   	ormtype="timestamp";
	property name="end"		ormtype="timestamp";
	property name="allDay" ormtype="boolean";
	property name="repeatEvent" ormtype="integer" default=0;
	property name="endRepeat" ormtype="timestamp";
	property name="warningType" ormtype="integer";
	property name="teamId" ormtype="integer";
	property name="colorEvent" ormtype="string";
	property name="isNotice" ormtype="boolean" default=false;
	property name="typeEvent" ormtype="integer" default="0";
	property name="userCreated" 		fieldtype="many-to-one" cfc="users" 	 fkcolumn="userID";
}