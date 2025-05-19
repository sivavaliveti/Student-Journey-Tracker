public class AccountContactController {
    public List<SelectOption> accountOptions { get; set; }
    public List<Contact> contacts { get; set; }
    public String selectedAccountId { get; set; }

    public Boolean showAccountModal { get; set; }
    public Boolean showContactModal { get; set; }
    public Account newAccount { get; set; }
    public Contact newContact { get; set; }

    public AccountContactController() {
        accountOptions = new List<SelectOption>();
        accountOptions.add(new SelectOption('', '-- Select Account --'));
        for (Account acc : [SELECT Id, Name FROM Account LIMIT 50]) {
            accountOptions.add(new SelectOption(acc.Id, acc.Name));
        }
        contacts = new List<Contact>();
        newAccount = new Account();
        newContact = new Contact();
        showAccountModal = false;
        showContactModal = false;
    }

    public void loadContacts() {
        if (selectedAccountId != null && selectedAccountId != '') {
            contacts = [SELECT Id, Name, Email, Phone FROM Contact WHERE AccountId = :selectedAccountId];
        } else {
            contacts.clear();
        }
    }

    public void showAccountPopup() {
        showAccountModal = true;
    }

    public void showContactPopup() {
        if (selectedAccountId != null && selectedAccountId != '') {
            showContactModal = true;
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an account before creating a contact.'));
        }
    }

    public void hidePopups() {
        showAccountModal = false;
        showContactModal = false;
    }



}