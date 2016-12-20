component persistent="true" {

	property name="id" fieldtype="id" generator="native" setter="false";

	property name="startTime" ormtype="timestamp";
	property name="alOffTotal" ormtype="float";
	property name="sloffTotal" ormtype="float";
	property name="detailDateOff" ormtype="string";

	property name="alOff" ormtype="float" default=0;
	property name="sloff" ormtype="float" default=0;
	property name="userId" ormtype="integer";
	property name="late" ormtype="string";

	property name="overtimes" ormtype="float" default=0 ;

}