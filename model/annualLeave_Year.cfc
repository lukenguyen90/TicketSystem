component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="alOffTotal" ormtype="float";
	property name="sloffTotal" ormtype="float";
	property name="alOff" ormtype="float" default=0;
	property name="sloff" ormtype="float" default=0;
	property name="userId" ormtype="integer";
	property name="overtimes" ormtype="integer" default=0 ;
	property name="year" ormtype="string";
	property name="numberPaid" ormtype="float";
	property name="datePaid" ormtype="timestamp";
	property name ="isMinus" ormtype="boolean" default="false";
}