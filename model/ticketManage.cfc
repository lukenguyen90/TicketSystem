component persistent="true" table="ticketManage" accessors="true" {
	property name="ticketManageID" fieldtype="id" generator="native" setter="false";

	property name="tickets" fieldtype="many-to-many" cfc="tickets" 
			singularname="ticket" linktable="ticketManageTable";
}