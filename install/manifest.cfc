<cfcomponent extends="farcry.core.webtop.install.manifest" name="manifest">

	<cfset this.name = "FarCry LDAP" />
	<cfset this.description = "Provides LDAP Integration" />
	<cfset this.lRequiredPlugins = "" />
	
	<cfset addSupportedCore(majorVersion="5", minorVersion="2", patchVersion="8") />
	<cfset addSupportedCore(majorVersion="6", minorVersion="0", patchVersion="6") />
	<cfset addSupportedCore(majorVersion="6", minorVersion="1", patchVersion="0") />

</cfcomponent>