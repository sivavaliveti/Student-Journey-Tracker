public class GetopData {

    @AuraEnabled
    public static List<Map<String, Object>> getUniversityWiseData(String selectedUniversity){
    String query = 'SELECT Id, Course_Offering__r.college_University__r.Name, Course_Offering__r.college_University__r.Id, '
                 + 'Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c, Contact__c '
                 + 'FROM CourseConnection__c '
                 + 'WHERE Type__c = \'Student\' AND Status__c = \'Active\' ';

    if (selectedUniversity !='' && selectedUniversity != null) {
     query += 'AND Course_Offering__r.college_University__r.Name LIKE \'%' + String.escapeSingleQuotes(selectedUniversity) + '%\'';
    } 
    
    List<CourseConnection__c> courseconnections=Database.query(query);
    
    Map<String, Map<String, Set<Id>>> universityDataMap=new Map<String, Map<String, Set<Id>>>(); 
    Map<String, Id> universityIdMap=new Map<String, Id>();
    
    for (CourseConnection__c cc : courseconnections) {
    
    String universityName=cc.Course_Offering__r.college_University__r.Name;
    
    Id universityId=cc.Course_Offering__r.college_University__r.Id;
    
    universityIdMap.put(universityName, universityId);
    
    if (!universityDataMap.containsKey(universityName)) {
        universityDataMap.put(universityName, new Map<String, Set<Id>>{ 
            'Mentors' => new Set<Id>(),
            'Contacts' => new Set<Id>(),
             'Programs'=> new Set<Id>() 
        });
    }
    
    if (cc.Course_Offering__r.Mentor__c != null) {
    universityDataMap.get(universityName).get('Mentors').add(cc.Course_Offering__r.Mentor__c);
   }
    
   if(cc.Contact__c!=null){
    universityDataMap.get(universityName).get('Contacts').add(cc.Contact__c);
   }

   if(cc.Course_Offering__r.Course__r.Program__c!=null){
    universityDataMap.get(universityName).get('Programs').add(cc.Course_Offering__r.Course__r.Program__c);
   }
}
List<Map<String, Object>> universityWiseDataList = new List<Map<String, Object>>();
Integer serialNumber = 1;
for (String university: universityDataMap.keySet()) {
        Map<String, Object> universityData = new Map<String, Object>();
        universityData.put('name', university);
        universityData.put('numbers',serialNumber);
        universityData.put('id', universityIdMap.get(university));
        universityData.put('mentors', universityDataMap.get(university).get('Mentors').size());
        universityData.put('students', universityDataMap.get(university).get('Contacts').size());
        universityData.put('programs', universityDataMap.get(university).get('Programs').size());
        universityWiseDataList.add(universityData);
        serialNumber++;
}
return universityWiseDataList;
}
}