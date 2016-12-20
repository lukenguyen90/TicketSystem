component persistent="true" {
	property name="historyID" fieldtype="id" generator="native" setter="false";
	property name="eventDate" ormtype="datetime";
	property name="pkValue"  ormtype="integer";
	property name="oldValue_d"  ormtype="datetime";
	property name="oldValue_c"  ormtype="text";
	property name="oldValue_n"  ormtype="integer";
	property name="oldValue_f"  ormtype="double";
	property name="value_d"  ormtype="datetime";
	property name="value_c"  ormtype="text";
	property name="value_n"  ormtype="integer";
	property name="value_f"  ormtype="double";
	property name="table" fieldtype="many-to-one" cfc="historytables" fkcolumn="tableID";
}