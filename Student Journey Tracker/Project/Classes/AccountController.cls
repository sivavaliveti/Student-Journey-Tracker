public class AccountController {
    public String selectedAccountId { get; set; }
    public List<SelectOption> accountOptions { get; set; }
    public List<Contact> contactList { get; set; }
    public List<Opportunity> opportunityList { get; set; }

    // Constructor to load accounts in dropdown
    public AccountController() {
        accountOptions = new List<SelectOption>();
        accountOptions.add(new SelectOption('', '-- Select an Account --'));
        
        for (Account acc : [SELECT Id, Name FROM Account]) {
            accountOptions.add(new SelectOption(acc.Id, acc.Name));
        }
        
        contactList = new List<Contact>();
        opportunityList = new List<Opportunity>();
    }

    // Fetch contacts and opportunities when an account is selected
    public void fetchRelatedRecords() {
        if (selectedAccountId != null && selectedAccountId != '') {
            contactList = [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :selectedAccountId];
            opportunityList = [SELECT Id, Name, StageName, Amount FROM Opportunity WHERE AccountId = :selectedAccountId];
        } else {
            contactList.clear();
            opportunityList.clear();
        }
    }

    // Button Click Methods
    public void handleB1Click() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'B1 Clicked!'));
    }

    public void handleB2Click() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'B2 Clicked!'));
    }

    public void handleB3Click() {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'B3 Clicked!'));
    }
}