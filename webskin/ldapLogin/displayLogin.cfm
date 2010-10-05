<cfsetting enablecfoutputonly="Yes">
<!--- @@displayname: Farcry UD login form --->

<cfimport taglib="/farcry/core/tags/webskin" prefix="skin" />
<cfimport taglib="/farcry/core/tags/formtools/" prefix="ft" />
<cfimport taglib="/farcry/core/tags/security/" prefix="sec" />

<skin:view typename="farLogin" template="displayHeaderLogin" />
	
			
		<cfoutput>
		<div class="loginInfo">
		</cfoutput>	
		
			<ft:form>
				
				<!--- -------------- --->
				<!--- SELECT PROJECT --->
				<!--- -------------- --->
				<cfif structKeyExists(server, "stFarcryProjects") AND structcount(server.stFarcryProjects) GT 1>
					<cfset aDomainProjects = arraynew(1) />
					<cfloop collection="#server.stFarcryProjects#" item="thisproject">
						<cfif isstruct(server.stFarcryProjects[thisproject]) and listcontains(server.stFarcryProjects[thisproject].domains,cgi.http_host)>
							<cfset arrayappend(aDomainProjects,thisproject) />
						</cfif>
					</cfloop>
					
					<cfif arraylen(aDomainProjects) gt 1>
						<ft:fieldset>
							<ft:field label="Project Selection" for="selectFarcryProject">
								<cfoutput>
								<select name="selectFarcryProject" id="selectFarcryProject" class="selectInput" onchange="window.location='#application.url.webtop#/login.cfm?<cfif structKeyExists(url,'returnurl') and len(trim(url.returnurl))>returnurl=#urlEncodedFormat(url.returnurl)#&</cfif>farcryProject='+this.value;">						
									<cfloop from="1" to="#arraylen(aDomainProjects)#" index="i">
										<cfif len(aDomainProjects[i])>
											<option value="#aDomainProjects[i]#"<cfif cookie.currentFarcryProject eq aDomainProjects[i]> selected="selected"</cfif>>#server.stFarcryProjects[aDomainProjects[i]].displayname#</option>
										</cfif>
									</cfloop>						
								</select>
								</cfoutput>
							</ft:field>
						</ft:fieldset>	
					</cfif>
				</cfif>			
				
				<!--- --------------------- --->
				<!--- SELECT USER DIRECTORY --->
				<!--- --------------------- --->
				<cfif listlen(application.security.getAllUD()) GT 1>
		
					<ft:fieldset>
						<ft:field label="Select User Directory" for="selectuserdirectories">
						
							<cfoutput><select name="selectuserdirectories" id="selectuserdirectories" class="selectInput" onchange="window.location='#application.url.farcry#/login.cfm?<cfif structKeyExists(url,'returnurl') and len(trim(url.returnurl))>returnurl=#urlEncodedFormat(url.returnurl)#&</cfif>ud='+this.value;"></cfoutput>
							
							<cfloop list="#application.security.getAllUD()#" index="thisud">
								<cfoutput>
									<option value="#thisud#"<cfif structKeyExists(arguments.stParam, "ud") AND arguments.stParam.ud eq thisud> selected</cfif>>#application.security.userdirectories[thisud].title#</option>
								</cfoutput>
							</cfloop>
							
							<cfoutput></select></cfoutput>	
						</ft:field>
					</ft:fieldset>	
				</cfif>
	
				
				<ft:object typename="ldapLogin" />
				
				
				<ft:buttonPanel>
					<cfif isdefined("arguments.stParam.message") and len(arguments.stParam.message)>
						<skin:bubble message="#arguments.stParam.message#" />
					</cfif>
					
					<ft:button value="Log In" rbkey="security.buttons.login" />
				</ft:buttonPanel>

				
				
			</ft:form>
			

			
		<cfoutput>
		</div>
		</cfoutput>		
				
	

<skin:view typename="farLogin" template="displayFooterLogin" />


<cfsetting enablecfoutputonly="false">