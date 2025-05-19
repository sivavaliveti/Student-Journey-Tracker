public with sharing class GetAllUsersController {

    @AuraEnabled(cacheable=true)
    public static List<User> getAllUsers() {
        return [
            SELECT Id, Name, Username, Email
            FROM User
            WHERE IsActive = true AND Email != null
            ORDER BY Name ASC
        ];
    }
}