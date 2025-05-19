public class AccountDetails {
   @AuraEnabled(cacheable=true)
public static Map<String, Object> getAccountsAndContacts() {
    Map<String, Object> response = new Map<String, Object>();
    List<Map<String, Object>> accountList = new List<Map<String, Object>>();

    List<Account> accounts = [
        SELECT Name, 
               (SELECT Name FROM Contacts) 
        FROM Account
        WHERE Id IN (SELECT AccountId FROM Contact)
    ];

    for (Account acc : accounts) {
        Map<String, Object> accountData = new Map<String, Object>();
        List<String> contactNames = new List<String>();

        for (Contact c : acc.Contacts) {
            contactNames.add(c.Name);
        }

        accountData.put('accountName', acc.Name);
        accountData.put('contacts', contactNames);
        accountList.add(accountData);
    }

    response.put('accounts', accountList);
    response.put('totalAccounts', accountList.size());
    return response;
}

}