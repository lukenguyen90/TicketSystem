component persistent="true" table="projectStatus" {
	property name="projectStatusID" fieldtype="id" generator="native" setter="false";
	property name="statusName"  ormtype="string" length=50;
	property name="color"  ormtype="string" length=50;
}