/*
 * @type
 * 1 : paid annul leave
 * 2 : add annul leave
 * 3 : add overtime
 * 4 : paid overtime
 */
component persistent="true" {
	property name="id" fieldtype="id" generator="native" setter="false";
	property name="createTime" ormtype="timestamp";
	property name="userCreate" ormtype="integer";
	property name="userPaid" ormtype="integer";
	property name="numberDay" ormtype="float";
	property name="action" ormtype="text";
	property name="type" ormtype="integer";
	property name="isSuccess" ormtype="boolean" delault="false";
}