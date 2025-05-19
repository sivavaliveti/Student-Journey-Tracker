@isTest
public class OpportunityStoreOldValuesTest {
    
    @isTest
    static void testOpportunityTrigger() {
        // Create and insert an Opportunity
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            Amount = 50000,
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting'
        );
        insert opp;

        // Update fields to trigger before update logic
        opp.Amount = 60000;
        opp.StageName = 'Negotiation';
        update opp;

        // Verify old values are stored in the Description field
        Opportunity updatedOpp = [SELECT Description FROM Opportunity WHERE Id = :opp.Id];
        System.assert(updatedOpp.Description.contains('Amount: 50000'), 'Old Amount should be stored');
        System.assert(updatedOpp.Description.contains('Stage: Prospecting'), 'Old Stage should be stored');
    }
}