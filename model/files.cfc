component persistent="true" {
	property name="fileID" fieldtype="id" generator="native" setter="false";
	property name="fileLocation" ormtype="string";
	property name="description"  ormtype="string";
	property name="group"		 ormtype="string";
	property name ="tickets" fieldtype="many-to-many" cfc="tickets" type="array" linktable="ticketFiles" singularname="ticket";
}