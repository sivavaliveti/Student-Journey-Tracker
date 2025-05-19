@isTest
public class RestrictOpportunityDeletionTest {
    @isTest
    static void testRestrictOpportunityDeletion() {
        // Create test Opportunity
        Opportunity testOpp = new Opportunity(Name = 'Test Opportunity', StageName = 'Closed Won', CloseDate = Date.today());
        insert testOpp;
        
        // Attempt to delete the Opportunity
        Test.startTest();
        Database.DeleteResult result = Database.delete(testOpp, false);
        Test.stopTest();
        
        // Verify that the deletion was blocked
        System.assert(result.isSuccess() == false, 'Deletion should be restricted.');
        System.assert(result.getErrors().size() > 0, 'There should be an error preventing deletion.');
    }
}