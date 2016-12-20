component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="al_remain" 	ormtype="float";
	property name="sl_remain" 	ormtype="float";
	property name="ot_remain" 	ormtype="float";
	property name="userid" 		ormtype="integer";
	property name="year" 		ormtype="string";
	property name="updated" 	ormtype="timestamp";
}