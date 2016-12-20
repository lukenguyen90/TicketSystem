component persistent="true" table="typeTimeEntries" {
	property name="typeTimeEntriesID" fieldtype="id" generator="native" setter="false";
	property name="typeName"  ormtype="string" length=50;
	property name="parent"  ormtype="numeric";
}