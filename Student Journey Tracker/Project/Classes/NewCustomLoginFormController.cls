public with sharing class NewCustomLoginFormController {

    @AuraEnabled
    public static String login(String username, String password, String startUrl) {
        try {
            ApexPages.PageReference loginPage = Site.login(username, password, startUrl);

            if (loginPage != null && loginPage.getUrl() != null) {
                return loginPage.getUrl(); // Redirect to this URL in LWC
            } else {
                return 'fail';
            }
        } catch (Exception e) {
            return 'fail: ' + e.getMessage();
        }
    }
}