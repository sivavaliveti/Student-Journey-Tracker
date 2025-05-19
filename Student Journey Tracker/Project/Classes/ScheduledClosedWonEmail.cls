global class ScheduledClosedWonEmail implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Opportunity> closedWonOpps = [SELECT Id, Name, Amount, Owner.Name
                                           FROM Opportunity
                                           WHERE StageName = 'Closed Won'];

        if (!closedWonOpps.isEmpty()) {
            sendEmail(closedWonOpps);
        }
    }

    private void sendEmail(List<Opportunity> oppList) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('Closed Won Opportunities - Daily Update');
        
        // Email Body
        String body = 'The following Opportunities were marked as Closed Won:\n\n';
        for (Opportunity opp : oppList) {
            body += '✔ ' + opp.Name + ' | Amount: $' + opp.Amount + ' | Owner: ' + opp.Owner.Name + '\n';
        }
        
        mail.setPlainTextBody(body);
        mail.setToAddresses(new List<String>{'manager@example.com'}); // Change to actual email
        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{mail});
    }
}