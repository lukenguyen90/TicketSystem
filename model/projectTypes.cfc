component persistent="true" table="projectTypes" {
	property name="projectTypeID" fieldtype="id" generator="native" setter="false";
	property name="typeName"  ormtype="string" length=50;
	property name="charge"  ormtype="boolean";
}