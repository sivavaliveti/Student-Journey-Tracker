public class AccountOpportunityController {
    public List<SelectOption> accountOptions { get; set; }
    public List<Opportunity> opportunities { get; set; }
    public String selectedAccountId { get; set; }

    public AccountOpportunityController() {
        accountOptions = new List<SelectOption>();
        accountOptions.add(new SelectOption('', '-- Select Account --'));
        for (Account acc : [SELECT Id, Name FROM Account LIMIT 50]) {
            accountOptions.add(new SelectOption(acc.Id, acc.Name));
        }
        opportunities = new List<Opportunity>();
    }

    public void loadOpportunities() {
        if (String.isNotBlank(selectedAccountId)) {
            opportunities = [SELECT Id, Name, StageName, Amount, CloseDate FROM Opportunity WHERE AccountId = :selectedAccountId];
        } else {
            opportunities.clear();
        }
    }
}