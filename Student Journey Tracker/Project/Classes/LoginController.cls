public with sharing class LoginController {
    @AuraEnabled
    public static String login(String username, String password) {
        try {
            // Check if current user is Guest in Experience Cloud context
            if (UserInfo.getUserType() == 'Guest') {
                // Return a specific response that the LWC can use to redirect
                return JSON.serialize(new LoginResponse(null, 'guest_redirect', 'Guest users must log in through the standard login page'));
            }

            // Input validation
            if (String.isBlank(username) || String.isBlank(password)) {
                return JSON.serialize(new LoginResponse(null, 'error', 'Username and password are required'));
            }

            String safeUsername = String.escapeSingleQuotes(username.trim());
            String safePassword = String.escapeSingleQuotes(password);

            // Query user
            List<User> users = [SELECT Id, Username, IsActive 
                              FROM User 
                              WHERE Username = :safeUsername 
                              AND IsActive = true 
                              WITH SECURITY_ENFORCED 
                              LIMIT 1];
            
            if (users.isEmpty()) {
                return JSON.serialize(new LoginResponse(null, 'error', 'Invalid credentials'));
            }

            // In Experience Cloud, use Site.login for proper authentication
            String startUrl = '/'; // Adjust based on your site's home page
            PageReference ref = Site.login(safeUsername, safePassword, startUrl);
            if (ref == null) {
                return JSON.serialize(new LoginResponse(null, 'error', 'Authentication failed'));
            }

            // Successful login
            return JSON.serialize(new LoginResponse(users[0].Id, 'success', 'Login successful'));
        } catch (Exception e) {
            System.debug(LoggingLevel.ERROR, 'Login error for ' + username + ': ' + e.getMessage());
            return JSON.serialize(new LoginResponse(null, 'error', 'Login failed. Please contact support.'));
        }
    }

    public class LoginResponse {
        public String userId;
        public String status;
        public String message;

        public LoginResponse(String userId, String status, String message) {
            this.userId = userId;
            this.status = status;
            this.message = message;
        }
    }
}