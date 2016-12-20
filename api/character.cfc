/**
*
* @file  /ticket/api/character.cfc
* @author  Do Duc Tin
* @description
*
* Help 
* 
* create object on cfc
*  nObj = new api.character();
* 
* create object on cfm
*  cfset nObj = new api.character()
* 
* used
* nObj.replaceSpecialCharacter(input);
*/

component accessors="true"  {

	public function init(){
		return this;
	}
	public string function replaceSpecialCharacter(string inputString){
		local.outputString = replace(inputString , " ", "&##32;", "all");
		local.outputString = replace(local.outputString , "!", "&##33;", "all");
		local.outputString = replace(local.outputString , '"', "&##34;", "all");
		local.outputString = replace(local.outputString , "$", "&##36;", "all");
		local.outputString = replace(local.outputString , "%", "&##37;", "all");
		local.outputString = replace(local.outputString , "'", "&##39;", "all");
		local.outputString = replace(local.outputString , "(", "&##40;", "all");
		local.outputString = replace(local.outputString , ")", "&##41;", "all");
		local.outputString = replace(local.outputString , "*", "&##42;", "all");
		local.outputString = replace(local.outputString , "+", "&##43;", "all");
		local.outputString = replace(local.outputString , ",", "&##44;", "all");
		local.outputString = replace(local.outputString , "-", "&##45;", "all");
		local.outputString = replace(local.outputString , ".", "&##46;", "all");
		local.outputString = replace(local.outputString , "/", "&##47;", "all");
		local.outputString = replace(local.outputString , ":", "&##58;", "all");
		local.outputString = replace(local.outputString , "<", "&##60;", "all");
		local.outputString = replace(local.outputString , "=", "&##61;", "all");
		local.outputString = replace(local.outputString , ">", "&##62;", "all");
		local.outputString = replace(local.outputString , "?", "&##63;", "all");
		local.outputString = replace(local.outputString , "@", "&##64;", "all");
		local.outputString = replace(local.outputString , "[", "&##91;", "all");
		local.outputString = replace(local.outputString , "\", "&##92;", "all");
		local.outputString = replace(local.outputString , "]", "&##93;", "all");
		local.outputString = replace(local.outputString , "^", "&##94;", "all");
		local.outputString = replace(local.outputString , "_", "&##95;", "all");
		local.outputString = replace(local.outputString , "`", "&##96;", "all");
		local.outputString = replace(local.outputString , "{", "&##123;", "all");
		local.outputString = replace(local.outputString , "|", "&##124;", "all");
		local.outputString = replace(local.outputString , "}", "&##125;", "all");
		local.outputString = replace(local.outputString , "~", "&##126;", "all");
		local.outputString = replace(local.outputString , "«", "&##171;", "all");
		local.outputString = replace(local.outputString , "»", "&##187;", "all");
		return local.outputString;
	}
}