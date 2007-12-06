<cfcomponent displayname="LDAP User Directory" hint="LDAP User Directory" extends="farcry.core.packages.security.UserDirectory" output="false">

	<cffunction name="getLoginForm" access="public" output="false" returntype="string" hint="Returns the form component to use for login">
		
		<cfreturn "ldapLogin" />
	</cffunction>
	
	<cffunction name="authenticate" access="public" output="true" returntype="struct" hint="Attempts to process a user. Runs every time the login form is loaded.">
		<cfset var stResult = structnew() />
		<cfset var qResult = "" />
		
		<cfimport taglib="/farcry/core/tags/formtools/" prefix="ft" />
	
		<!--- Return struct --->
		
		<ft:processform>
			<ft:processformObjects typename="#getLoginForm()#">
				<cfset stResult.userid = "" />
				<cfset stResult.authenticated = false />
				<cfset stResult.message = "" />
		
				<!--- Find the user --->
				<cftry>
					<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#application.config.ldap.userstart#" scope="base" attributes="*" username="#replace(application.config.ldap.userdn,'{userid}',stProperties.username)#" password="#stProperties.password#" />
					<cfset stResult.authenticated = true />
					<cfset stResult.userid = stProperties.username />
					
					<cfcatch>
						<cfset stResult.authenticated = false />
						<cfset stResult.userid = stProperties.username />
						<cfset stResult.message = "The username or password is incorrect" />
					</cfcatch>
				</cftry>
			</ft:processformObjects>
		</ft:processform>
		
		<cfreturn stResult />
	</cffunction>
	
	<cffunction name="getUserGroups" access="public" output="false" returntype="array" hint="Returns the groups that the specified user is a member of">
		<cfargument name="UserID" type="string" required="true" hint="The user being queried" />
		
		<cfset var qResult = "" />
		<cfset var aGroups = arraynew(1) />
		
		<cfif len(application.config.ldap.username) and len(application.config.ldap.password)>
			<cfldap server="#application.config.ldap.host#" username="#application.config.ldap.username#" password="#application.config.ldap.password#" action="query" name="qResult" start="#application.config.ldap.groupstart#" scope="subtree" attributes="#application.config.ldap.groupidattribute#" filter="#replace(application.config.ldap.groupfilter,'{userid}',arguments.userid)#" />
		<cfelse>
			<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#application.config.ldap.groupstart#" scope="subtree" attributes="#application.config.ldap.groupidattribute#" filter="#replace(application.config.ldap.groupfilter,'{userid}',arguments.userid)#" />
		</cfif>
		
		<cfloop query="qResult">
			<cfset arrayappend(aGroups,qResult[application.config.ldap.groupidattribute][currentrow]) />
		</cfloop>
		
		<cfreturn aGroups />
	</cffunction>
	
	<cffunction name="getAllGroups" access="public" output="false" returntype="array" hint="Returns all the groups that this user directory supports">
		<cfset var qResult = "" />
		<cfset var aGroups = arraynew(1) />
		
		<cfif len(application.config.ldap.username) and len(application.config.ldap.password)>
			<cfldap server="#application.config.ldap.host#" username="#application.config.ldap.username#" password="#application.config.ldap.password#" action="query" name="qResult" start="#application.config.ldap.groupstart#" scope="subtree" attributes="#application.config.ldap.groupidattribute#" filter="#application.config.ldap.allgroupsfilter#" />
		<cfelse>
			<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#application.config.ldap.groupstart#" scope="subtree" attributes="#application.config.ldap.groupidattribute#" filter="#application.config.ldap.allgroupsfilter#" />
		</cfif>
		
		<cfloop query="qResult">
			<cfset arrayappend(aGroups,qResult[application.config.ldap.groupidattribute][currentrow]) />
		</cfloop>
		
		<cfreturn aGroups />
	</cffunction>

	<cffunction name="getProfile" access="public" output="true" returntype="struct" hint="Returns profile data available through the user directory">
		<cfargument name="userid" type="string" required="true" hint="The user directory specific user id" />
		
		<cfset var attr = "" />
		<cfset var stUserToProfile = structnew() />
		<cfset var qResult = "" />
		<cfset var stResult = structnew() />
		
		<cfif listlen(application.config.ldap.usertoprofile)>
			<cfloop list="#application.config.ldap.usertoprofile#" index="attr">
				<cfset stUserToProfile[listlast(attr,"=")] = listfirst(attr,"=") />
			</cfloop>
			
			<cfif len(application.config.ldap.username) and len(application.config.ldap.password)>
				<cfldap server="#application.config.ldap.host#" username="#application.config.ldap.username#" password="#application.config.ldap.password#" action="query" name="qResult" start="#replace(application.config.ldap.userdn,'{userid}',arguments.userid)#" scope="base" attributes="#structkeylist(stUserToProfile)#" />
			<cfelse>
				<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#replace(application.config.ldap.userdn,'{userid}',arguments.userid)#" scope="base" attributes="#structkeylist(stUserToProfile)#" />
			</cfif>
	
			<cfloop list="#qResult.columnlist#" index="attr">
				<cfset stResult[stUserToProfile[attr]] = qResult[attr][1] />
			</cfloop>
			<cfset stResult.override = application.config.ldap.overrideprofile />
		</cfif>
		
		<cfreturn stResult />
	</cffunction>

</cfcomponent>