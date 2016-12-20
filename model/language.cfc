component  persistent="true"
{
	property name="languageId" fieldtype="id" ormtype="integer" generator="native" setter="false";
	property name="shortlanguage"  ormtype="string";
	property name="language"  ormtype="string" length="20";
	property name="lastModified" sqltype="timestamp" ormtype="timestamp";
    property name="createDate" sqlType="timestamp" ormType="timestamp";  
	property name="defaultlanguage" ormtype="boolean";
}