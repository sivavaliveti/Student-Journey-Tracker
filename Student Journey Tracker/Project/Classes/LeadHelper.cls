public class LeadHelper {
    @future
    public static void updateLeadDescriptions(Set<Id> leadIds) {
        // Fetch newly inserted Leads
        List<Lead> leadsToUpdate = [SELECT Id, Name, MobilePhone, Company, Title FROM Lead WHERE Id IN :leadIds];

        // Prepare updates
        for (Lead des: leadsToUpdate) {
            des.Description = 'Name: ' + (des.Name != null ? des.Name : 'N/A') + 
                            ', Mobile: ' + (des.MobilePhone != null ? des.MobilePhone : 'N/A') + 
                            ', Company: ' + (des.Company != null ? des.Company : 'N/A') + 
                            ', Title: ' + (des.Title != null ? des.Title : 'N/A');
        }

        // Bulk update all Leads
        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
        }
    }
}