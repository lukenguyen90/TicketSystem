component persistent="true" table="checkRequired"{

	property name = "Id" fieldtype = "id" generator = "native" setter = "false";
	
	property name = "createTime" ormType="timestamp";
	property name = "updateTime" ormType="timestamp";
	property name = "checkType" ormType="integer"; // 1 = approve ; 2 = reject 
	property name=  "user" ormType="integer"; // who approve or reject
	property name=  "required" ormType="integer"; // id manageTime
	property name=  "requireType" ormType="integer"; // 1 = annualeave ; 2 = overtime
}