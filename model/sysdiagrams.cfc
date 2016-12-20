component persistent="true" {
	property name="diagramID" fieldtype="id" generator="native" setter="false";
	property name="principalID" ormtype="integer";
	property name="name"  		ormtype="string" length=160;
	property name="version"  	ormtype="integer";
	property name="definition" 	ormtype="blob";
}