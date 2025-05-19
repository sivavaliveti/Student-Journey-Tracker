@isTest
public class LeadTriggerTest {
    @isTest
    static void testLeadTrigger() {
        // Insert test Lead
        Lead testLead = new Lead(FirstName = 'John', LastName = 'Doe', Company = 'TestCorp', MobilePhone = '1234567890', Title = 'Manager');
        insert testLead;
        
        // Ensure @future method executes
        Test.startTest();
        Test.stopTest();
        
        // Verify Description update
        Lead updatedLead = [SELECT Description FROM Lead WHERE Id = :testLead.Id];
        System.assert(updatedLead.Description != null, 'Description should be updated.');
    }
}