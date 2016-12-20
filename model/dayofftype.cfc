component persistent="true" table="dayofftype"{

	property name = "Id" fieldtype = "id" generator = "native" setter = "false";
	property name = "statusName" ormtype="string";

	property name = "dayoff" fieldtype="one-to-many" cfc="dayoff" fkcolumn="typeId";
}