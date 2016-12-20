component persistent="true" table="company" {
	property name="companyID" fieldtype="id" generator="native" setter="false";
	property name="companyName"  ormtype="string" length=50;
	property name="address"  ormtype="string" length=150;
	property name="phone"  ormtype="string" length=50;
	property name="description" ormtype="text";
	property name="email"  ormtype="string" length=50;
}