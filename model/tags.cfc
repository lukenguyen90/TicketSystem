component  persistent="true"
{
	property name="tagId" fieldtype="id" ormtype="integer" generator="native" setter="false";
	property name="tagName"  ormtype="string" length="20";
	property name="ticket" 		fieldtype="many-to-many" cfc="tickets" 	singularname="ticket" 	linktable="ticketTags" 	type="array";
}