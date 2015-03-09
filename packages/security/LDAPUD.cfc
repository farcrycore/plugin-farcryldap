<cfcomponent displayname="LDAP User Directory" hint="LDAP User Directory" extends="farcry.core.packages.security.UserDirectory" output="false">

	<cffunction name="getLoginForm" access="public" output="false" returntype="string" hint="Returns the form component to use for login">
		
		<cfreturn "ldapLogin" />
	</cffunction>
	
	<cffunction name="authenticate" access="public" output="true" returntype="struct" hint="Attempts to process a user. Runs every time the login form is loaded.">
		<cfset var stProperties = structnew() />
		<cfset var stResult = structnew() />
		<cfset var qResult = "" />
		
		<cfimport taglib="/farcry/core/tags/formtools/" prefix="ft" />
	
		<!--- Return struct --->
		
		<ft:processform>
			<ft:processformObjects typename="#getLoginForm()#">
				<cfset stResult.userid = "" />
				<cfset stResult.authenticated = false />
				<cfset stResult.message = "" />
				<cfset userDN = getUserDN(stProperties.username) />
		
				<!--- Find the user --->
				<cftry>
					<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#userDN#" scope="base" attributes="*" filter="objectClass=*" username="#userDN#" password="#stProperties.password#" />
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
		<cfset var memberOf = "" />
		<cfset var i = 0 />
		
		<cfif len(application.config.ldap.username) and len(application.config.ldap.password)>
			<cfldap server="#application.config.ldap.host#" username="#application.config.ldap.username#" password="#application.config.ldap.password#" action="query" name="qResult" start="#getUserDN(arguments.UserID)#" scope="subtree" attributes="memberOf" filter="#replace(application.config.ldap.groupfilter,'{userid}',arguments.userid)#" />
		<cfelse>
			<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#getUserDN(arguments.UserID)#" scope="subtree" attributes="memberOf" filter="#replace(application.config.ldap.groupfilter,'{userid}',arguments.userid)#" />
		</cfif>

		<cfif qResult.recordCount>
			<!--- ensure memeberOf is a string so that we can use split() --->
			<cfset memberOf = "#qResult.memberOf#">
			<cfset aGroups = memberOf.split(", ")>
			<cfloop from="1" to="#arrayLen(aGroups)#" index="i">
				<cfset aGroups[i] = replaceNoCase(listFirst(aGroups[i]), "CN=", "")>
			</cfloop>
		</cfif>
		
		<cfreturn aGroups />
	</cffunction>

	<cffunction name="getUserDN" access="public" output="false" returntype="string" hint="Returns the distinguished name of the given username">
		<cfargument name="UserID" type="string" required="true" hint="The user being queried" />

		<cfset var qResult = "" />
		<cfset var dn = replaceNoCase(application.config.ldap.userdn,'{userid}',arguments.userid)>

		<cfif NOT len(dn)>
			<cfldap 
				server="#application.config.ldap.host#" 
				username="#application.config.ldap.username#" 
				password="#application.config.ldap.password#" 
				action="query" 
				name="qResult" 
				scope="subtree" 
				start="#application.config.ldap.userstart#" 
				attributes="distinguishedName" 
				filter="sAMAccountName=#arguments.userid#" />
			<cfset dn = qResult.distinguishedName>
		</cfif>

		<cfreturn dn />
	</cffunction>

	<cffunction name="getAllGroups" access="public" output="false" returntype="array" hint="Returns all the groups that this user directory supports">
		<cfset var qResult = "" />
		<cfset var aGroups = arraynew(1) />
		
		<cfif len(application.config.ldap.username) and len(application.config.ldap.password)>
			<cfldap server="#application.config.ldap.host#" username="#application.config.ldap.username#" password="#application.config.ldap.password#" action="query" name="qResult" start="#application.config.ldap.groupstart#" scope="subtree" attributes="#application.config.ldap.groupidattribute#" filter="#application.config.ldap.allgroupsfilter#" />
		<cfelse>
			<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#application.config.ldap.groupstart#" scope="subtree" attributes="#application.config.ldap.groupidattribute#" filter="#application.config.ldap.allgroupsfilter#" />
		</cfif>
		
		<cfquery name="qResult" dbtype="query">
		select #application.config.ldap.groupidattribute# from qResult order by #application.config.ldap.groupidattribute#
		</cfquery>
		
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
		<cfset var userDN = getUserDN(arguments.userid) />

		<cfif listlen(application.config.ldap.usertoprofile)>
			<cfloop list="#application.config.ldap.usertoprofile#" index="attr">
				<cfset stUserToProfile[listlast(attr,"=")] = listfirst(attr,"=") />
			</cfloop>

			<cfif len(application.config.ldap.username) and len(application.config.ldap.password)>
				<cfldap server="#application.config.ldap.host#" username="#application.config.ldap.username#" password="#application.config.ldap.password#" action="query" name="qResult" start="#userdn#" scope="base" attributes="#structkeylist(stUserToProfile)#" filter="objectClass=*"/>
			<cfelse>
				<cfldap server="#application.config.ldap.host#" action="query" name="qResult" start="#userdn#" scope="base" attributes="#structkeylist(stUserToProfile)#" />
			</cfif>

			<cfloop list="#qResult.columnlist#" index="attr">
				<cfset stResult[stUserToProfile[attr]] = qResult[attr][1] />
			</cfloop>
			<cfset stResult.override = application.config.ldap.overrideprofile />
		</cfif>
		
		<cfreturn stResult />
	</cffunction>

	<cffunction name="getGroupUsers" access="public" output="false" returntype="array" hint="Returns all the users in a specified group">
		<cfargument name="group" type="string" required="true" hint="The group to query" />
		
		<!--- query ad for the members of a group --->
		<cfldap
			action="query"
			name="qUsers"
			server="#application.config.ldap.host#"
			username="#application.config.ldap.username#"
			password="#application.config.ldap.password#"
			start="#application.config.ldap.groupstart#"
			scope="subtree"
			attributes="member"
			filter="(&(objectclass=group)(cn=#arguments.group#))" />

		<!--- Build an array of users from each comma-separated element of "member" beginning with "cn=" --->
		<cfset aUsers = ArrayNew(1) />
		<cfloop list="#qUsers.member#" index="i">
			<cfif findnocase("CN=",i)>
				<cfset arrayappend(aUsers,ReplaceNoCase(i,"CN=","")) />
			</cfif>
		</cfloop>
		
		<!--- Convert the array to a string which will be used in a subsequent LDAP filter --->
		<cfsavecontent variable="tmpfilter">
			<cfsetting enableCFoutputOnly = "yes">
				<cfloop from="1" to="#ArrayLen(aUsers)#" index="i">
					<cfoutput>(cn=#Trim(aUsers[i])#)</cfoutput>
				</cfloop>
			</cfsetting>
		</cfsavecontent>
		
		<cfset userfilter = "(&(objectClass=user)(|#trim(tmpfilter)#))">
		
		<!--- query the userids of the CNs returned from the members of group query--->
		<cfldap username="#application.config.ldap.username#"
			password="#application.config.ldap.password#"
			server="#application.config.ldap.host#"
			action="query"
			name="qUsers"
			start="#application.config.ldap.userstart#"
			scope="subtree"
			attributes="sAMAccountName"
			filter="#userfilter#" />
		
		<cfreturn listtoarray(valuelist(qUsers.sAMAccountName))>
	</cffunction> 

</cfcomponent>