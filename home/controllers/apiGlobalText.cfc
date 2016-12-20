/**
*
* @file  /C/railo-ex/webapps/ticket/home/controllers/apiGlobalText.cfc
* @author  Do duc tin
* @description
*
*/

component persistent="true"  {
	property name= "normal" 	default="Normal";
	property name= "high" 		default="High";
	property name= "low" 		default="Low";
	property name= "highest"	default="Highest";
	
	property name= "backlog"	default="Backlog";
	property name= "icebox"		default="Icebox";



	public function init(){
		return this;
	}
}