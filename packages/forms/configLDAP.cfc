<cfcomponent displayname="LDAP Configuration" hint="Configuratin of LDAP user directory" extends="farcry.core.packages.forms.forms" output="false" key="ldap">
	<cfproperty name="host" type="string" default="127.0.0.1" hint="The LDAP server" ftSeq="1" ftFieldset="Server" ftLabel="Host" ftType="string" />
	<cfproperty name="port" type="string" default="" hint="Port for accessing server" ftSeq="2" ftFieldset="Server" ftLabel="Port" ftType="string" />
	<cfproperty name="bSSL" type="boolean" default="0" hint="Security to employ, and required information. If you specify this attribute, its value must be CFSSL_BASIC, which provides V2 SSL encryption and server authentication." 
				ftSeq="3" ftFieldset="Server" ftLabel="SSL" ftType="boolean"
				ftHint="Should the connection go over SSL" />
	<cfproperty name="username" type="string" default="" hint="Username for accessing server (empty for anonymous access)" ftSeq="5" ftFieldset="Server" ftLabel="Username" ftType="string" />
	<cfproperty name="password" type="string" default="" hint="Password for accessing server (empty for anonymous access)" ftSeq="6" ftFieldset="Server" ftLabel="Password" ftType="password" ftRenderType="editpassword" />
	
	<cfproperty name="userstart" type="string" default="o=Directory" hint="The DN of the node to look for users under" ftSeq="11" ftFieldset="Users" ftLabel="User start DN" ftType="string" />
	<cfproperty name="userdn" type="string" default="cn={userid},ou=users,o=Directory" hint="The DN for a user" ftSeq="12" ftFieldset="Users" ftLabel="User DN" ftType="string" />
	<cfproperty name="usertoprofile" type="string" default="firstName=givenName,lastName=sn" hint="Maps LDAP attributes to dmProfile properties" ftSeq="13" ftFieldset="Users" ftLabel="profileProp=LDAPattr list" ftType="string" />
	<cfproperty name="overrideprofile" type="boolean" default="1" hint="Indicates whether LDAP attributes should replace profile properties or only fill missing values" ftSeq="14" ftFieldset="Users" ftLabel="Override profile values" ftType="boolean" />
	
	<cfproperty name="groupstart" type="string" default="o=Directory" hint="The DN of the node to look for groups under" ftSeq="21" ftFieldset="Groups" ftLabel="Group start" ftType="string" />
	<cfproperty name="groupfilter" type="string" default="member=uid={userid},ou=users,o=Directory" hint="The filter to use to find groups a user is member of" ftSeq="22" ftFieldset="Groups" ftLabel="Group filter" ftType="string" />
	<cfproperty name="allgroupsfilter" type="string" default="objectClass=groupOfNames" hint="The filter to use to find all groups" ftSeq="23" ftFieldset="Groups" ftLabel="All groups filter" ftType="string" />
	<cfproperty name="groupidattribute" type="string" default="cn" hint="The attribute that is to be used as group id by FarCry" ftSeq="24" ftFieldset="Groups" ftLabel="Group ID attribute" ftType="string" />
	
</cfcomponent>