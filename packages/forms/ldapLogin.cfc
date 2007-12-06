<cfcomponent displayname="LDAP Login" hint="The LDAP login form" extends="farcry.core.packages.forms.forms" output="false">
	<cfproperty name="username" type="string" default="" hint="The user login" ftSeq="1" ftFieldset="" ftLabel="User name" ftType="string" />
	<cfproperty name="password" type="string" default="" hint="The login password" ftSeq="2" ftFieldset="" ftLabel="Password" ftType="password" ftRenderType="enterpassword" />
	
</cfcomponent>