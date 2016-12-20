component persistent="true" {
	property name="tableID" fieldtype="id" generator="native" setter="false";
	property name="tableName" ormtype="string" length=50;
	property name="pkName"  ormtype="string" length=50;
	property name="histories" fieldtype="one-to-many" cfc="history" fkcolumn="tableID" singularname="history";
}