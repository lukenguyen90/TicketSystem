component persistent="true" {
	property name="labelId" fieldtype="id" ormtype="integer" generator="native" setter="false";
	property name="keyword"  ormtype="string";
	property name="value" ormtype="string";
	property name="tag" ormtype="string";
	property name="lastModified" sqltype="timestamp" ormtype="timestamp";
    property name="createDate" sqlType="timestamp" ormType="timestamp";
	property name="language" fieldtype="many-to-one" cfc="language" fkcolumn="languageId";
}	
