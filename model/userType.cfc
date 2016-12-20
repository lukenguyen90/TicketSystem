component persistent="true" table="usertype" {
	property name="userTypeID" fieldtype="id" generator="native" setter="false";
	property name="userType" ormtype="string" length=50;
	property name="users" fieldtype="one-to-many" cfc="users" 	fkcolumn="userTypeID" singularname="user";
}