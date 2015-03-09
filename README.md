# FarCry LDAP Plugin

The LDAP user directory plugin hooks up existing LDAP directories with the internal FarCry securiety model. Active Directory is well supported through the Active Directory LDAP interface.

- Use the latest version of this plugin is for use with FarCry 7.x and above.
- Use the `1.0 tag` for installations up to FarCry 6.x


## Installation

Install the pluginfor the project:

- copy/clone the codebase to `/farcry/plugins/farcryldap`
- add the plugin to the project's plugin list (locate `<yourProject>/www/farcryConstructor.cfm` and update the `THIS.plugins` list)
- restart the application (ie. updateapp!) to register the plugin

## Configuration

In the webtop, open the configuration settings for 'LDAP' (Webtop -> Admin -> Edit Config -> LDAP), and update the following settings:

| Setting | Description |
| ------------- | ----------- |
| Host | The ip or domain of the LDAP server |
| Username | If the server doesn't allow anonymous access, put the username here. Leave empty for anonymous access |
| Password | If the server doesn't allow anonymous access, put the password here. Leave empty for anonymous access |
| User start DN | The distinguished name of the node that contains all users |
| User DN | The distinguished name to use to retrieve a particular user. Insert {userid} where the login should be inserted. NOTE: userid should not contain a '_' |
| profileProp=LDAPattr list | Maps LDAP attributes to profile properties. Should be in the form [property 1]=[attribute 1],...,[property n]=[property n] |
| Override profile values | If checked, a user's profile is updated every time they log in. If not, the LDAP values specified above are only used when the profile is created on first login |
| Group Start | The distinguished name of the node that contains all groups |
| Group Filter | The LDAP query that will return the groups a particular user is member of |
| All Groups Filter | The LDAP query that will return every groups |
| Group ID Attribute | The LDAP attribute to use as the group id in FarCry. Group id's should not contain a '_' |

Enjoy!
