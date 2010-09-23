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
				<!--- --------------------- --->
				<!--- SELECT USER DIRECTORY --->
				<!--- --------------------- --->
				<cfif listlen(application.security.getAllUD()) GT 1>
		
					<ft:fieldset>
						<ft:field label="Select User Directory" for="selectuserdirectories">
						
							<cfoutput><select name="selectuserdirectories" id="selectuserdirectories" class="selectInput" onchange="window.location='#application.url.farcry#/login.cfm?ud='+this.value;"></cfoutput>
							
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