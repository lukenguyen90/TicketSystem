component persistent="true" table="timeentries" {
	property name="timeEntryID" fieldtype="id" generator="native" setter="false";
	property name="dateEntered" ormtype="timestamp";
	property name="entryDate"  	ormtype="date";
	property name="hours" 		ormtype="double";
	property name="minute" 		ormtype="integer";
	property name="description" ormtype="text";
	property name="ticket" 		fieldtype="many-to-one" cfc="tickets" 	fkcolumn="ticketID";
	property name="user" 		fieldtype="many-to-one" cfc="users" 	fkcolumn="userID";
	property name="workType" 	fieldtype="many-to-one" cfc="workType" 	fkcolumn="workTypeID";
	property name="type" 		fieldtype="many-to-one" cfc="typeTimeEntries" 	fkcolumn="typeTimeEntriesID";
	property name="logTracker" 	fieldtype="many-to-one" cfc="logWorkTracker" 	fkcolumn="logTrackerID";
}