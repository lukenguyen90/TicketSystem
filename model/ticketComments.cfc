component persistent="true" table="ticketcomments"{
	property name="ticketCommentID" fieldtype="id" generator="native" setter="false";
	property name="comment" 	ormtype="text";
	property name="commentDate" ormtype="timestamp";
	property name="internal" 	ormtype="boolean";
	property name="ticket"  		fieldtype="many-to-one" cfc="tickets" 		fkcolumn="ticketID" ;
	property name="user"  			fieldtype="many-to-one" cfc="users" 		fkcolumn="userID" ;
	property name="replyTicketCommentID" 	ormtype="integer";
}