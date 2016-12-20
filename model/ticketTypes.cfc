component persistent="true" table="tickettypes" {
	property name="ticketTypeID" fieldtype="id" generator="native" setter="false";
	property name="typeName"  ormtype="string" length=50;
	property name="charge"  ormtype="boolean";
	property name="tickets"  fieldtype="one-to-many" cfc="tickets" 	fkcolumn="ticketTypeID" singularname="ticket";
}