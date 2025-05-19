/**
* @File Name : Logiincontroller.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : April 22, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | April 22, 2025 |   | Initial Version
**/

public class Logiincontroller {
	
    public String username { get; set; }
    public String password { get; set; }

    public PageReference login() {
        // Authenticate user using Site.login for Experience Cloud
        String startUrl = '/home?fromLogin=true';
        PageReference loginPage = Site.login(username, password, startUrl);
        
        if (loginPage != null) {
            return loginPage;
        } else {
            // Handle login failure (e.g., show error message)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid username or password'));
            return null;
        }
    }
}