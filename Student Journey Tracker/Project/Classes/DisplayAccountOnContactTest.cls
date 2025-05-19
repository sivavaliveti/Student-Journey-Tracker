@isTest
public class DisplayAccountOnContactTest {
    @isTest
    static void testTrigger() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Contact con = new Contact(LastName = 'Doe', AccountId = acc.Id);
        insert con;

        System.assertEquals('Test Account', [SELECT FirstName FROM Contact WHERE Id = :con.Id].FirstName);
    }
}