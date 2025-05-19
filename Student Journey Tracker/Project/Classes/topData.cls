public with sharing class topData {


    @AuraEnabled
    public static List<Map<String, Object>> getUniversityWiseData(String selectedUniversity, Boolean selectedCRTValue){
    // String query = 'SELECT Id, Course_Offering__r.college_University__r.Name, Course_Offering__r.college_University__r.Id, '
    //              + 'Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c, Contact__c '
    //              + 'FROM CourseConnection__c '
    //              + 'WHERE Type__c = \'Student\' AND Status__c = \'Active\' ';

                 String query ='SELECT Id, Course_Offering__r.college_University__c,Course_Offering__r.college_University__r.Name,  Contact__c,Course_Offering__r.Mentor__c, ' +
                 'Course_Offering__r.Course__c,Course_Offering__r.Course__r.Program__c FROM CourseConnection__c '+
                 'WHERE Type__c = \'Student\' AND Status__c = \'Active\'';
         
                 if(selectedCRTValue==true){
                    query +='AND Contact_r.CRT_c=true ';
                    if (selectedUniversity !='' && selectedUniversity != null) {
                        query += 'AND Course_Offering__r.college_University__r.Name LIKE \'%' + String.escapeSingleQuotes(selectedUniversity) + '%\'';
                       } 
                 }
                 List<CourseConnection__c> courseConnections =Database.query(query);


    // if (selectedUniversity !='' && selectedUniversity != null) {
    //  query += 'AND Course_Offering__r.college_University__r.Name LIKE \'%' + String.escapeSingleQuotes(selectedUniversity) + '%\'';
    // } 
    
    // List<CourseConnection__c> courseconnections=Database.query(query);
    
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




@AuraEnabled
public static List<Map<String, String>> getProgramsAndCourses() {
    System.debug('Fetching unique program and course names');

    List<CourseConnection__c> records = [
        SELECT Course_Offering__r.Course__r.Program__r.Name, 
               Course_Offering__r.Course__r.Name
        FROM CourseConnection__c
        WHERE Course_Offering__r.Course__r.Program__r.Name != null
        AND Course_Offering__r.Course__r.Name != null
    ];

    System.debug('Fetched Records: ' + records);

    Set<Map<String, String>> programsAndCourses = new Set<Map<String, String>>();
    
    for (CourseConnection__c cc : records) {
        Map<String, String> entry = new Map<String, String>();
        entry.put('programName', cc.Course_Offering__r.Course__r.Program__r.Name);
        entry.put('courseName', cc.Course_Offering__r.Course__r.Name);
        programsAndCourses.add(entry);
    }

    System.debug('Programs and Courses: ' + programsAndCourses);
    return new List<Map<String, String>>(programsAndCourses);
}




// @AuraEnabled
// public static List<String> getUniqueProgramNames() {
//     System.debug('Fetching all unique program names');

//     List<CourseConnection__c> programsList = [
//         SELECT Course_Offering__r.Course__r.Program__r.Name
//         Course_Offering__r.Course__r.Name
//         FROM CourseConnection__c
//         WHERE Course_Offering__r.Course__r.Program__r.Name != null
//         AND Course_Offering__r.Course__r.Name != null

//     ];

//     System.debug('Programs List: ' + programsList);

//     Set<String> programs = new Set<String>();
//     for (CourseConnection__c cc : programsList) {
//         programs.add(cc.Course_Offering__r.Course__r.Program__r.Name);
//     }

//     System.debug('Unique Program Names: ' + programs);
//     return new List<String>(programs);
// }


// @AuraEnabled
//   public static List<String> getUniqueProgramNames (String selectedUniversity) {
//     System.debug('getUniqueProgramNames selectedUniversity '+ selectedUniversity);   
//     List<CourseConnection__c> programsList = [
//         SELECT Course_Offering__r.Course__r.Program__r.Name
//         FROM CourseConnection__c
//         WHERE Course_Offering__r.Course__r.Program__r.Name != null
//     ];
//     System.debug('programsList:' + programsList);
//     Set<String> programs = new Set<String>();
//     for (CourseConnection__c cc: programsList) {
//         programs.add(cc.Course_Offering__r.Course__r.Program__r.Name);
//     }
//     System.debug('programNames:' + programs);
//   return new List<String>(programs);
// }


}


//     @AuraEnabled
//     public static Map<String, Integer> getTopHeadersData(){
//         List<CourseConnection__c> courseconnections = [
//             // SELECT Id,
//             //      Course_Offering__r.college_University__c,
//             //      Contact__c,
//             //      Course_Offering__r.Mentor__c,
//             //      Course_Offering__r.Course__c,
//             //      Course_Offering__r.Course__r.Program__c
//             // FROM CourseConnection__c
//             // WHERE Type__c='Student'
//             // AND Status__c='Active'
//             // AND Contact__r.CRT__c=true


//             SELECT Id, 
// Course_Offering__r.college_University__c,
// Course_Offering__r.college_University__r.Name,
//   Contact__c,
// Course_Offering__r.Mentor__c, 
// Course_Offering__r.Course__c,
// Course_Offering__r.Course__r.Program__c
//  FROM CourseConnection__c 
// WHERE Type__c ='STUDENT' 
// AND  Status__c='ACTIVE'
// AND Contact__r.CRT__c=true
//         ];
//         Set<Id> uniqueUniversities=new Set<Id>();
//         Set<Id> uniqueMentors=new Set<Id>();
//         Set<Id> uniqueContacts=new Set<Id>();
//         Set<Id> uniqueCourse=new Set<Id>();
//         Set<Id> uniquePrograms=new Set<Id>();

//         for(CourseConnection__c cc: courseconnections){
//             if(cc.Course_Offering__r.college_University__c!=null){
//                 uniqueUniversities.add(cc.Course_Offering__r.college_University__c);
//             }
//             if(cc.Contact__c != null){
//                 uniqueContacts.add(cc.Contact__c);
//             }
//             if(cc.Course_Offering__r.Mentor__c != null){
//                 uniqueMentors.add(cc.Course_Offering__r.Mentor__c);
//             }
//             if(cc.Course_Offering__r.Course__c!=null){
//                 uniqueCourse.add(cc.Course_Offering__r.Course__c);
//             }
//             if(cc.Course_Offering__r.Course__r.Program__c !=null){
//                 uniquePrograms.add(cc.Course_Offering__r.Course__r.Program__c);
//             }
//         }
//         Map<String, Integer> result = new Map<String, Integer>();
//         result.put('UniqueUniversities', uniqueUniversities.size());
//         result.put('UniqueContacts', uniqueContacts.size());
//         result.put('UniqueMentors', uniqueMentors.size());
//         result.put('UniqueCourses', uniqueCourse.size());
//         result.put('UniquePrograms', uniquePrograms.size());

//         return result;
//     }

//     @AuraEnabled
//     public static List<Map<String, Object>> getData(Boolean selectedCRTValue, String selectedUniversity) {
//         // String query = 'SELECT Id, Course_Offering__r.college_University__r.Name, Course_Offering__r.college_University__r.Id, '
//         //              + 'Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c, Contact__c '
//         //              + 'FROM CourseConnection__c '
//         //              + 'WHERE Type__c = \'Student\' AND Status__c = \'Active\' ';

        
//         // if (selectedCRTValue) {
//         //     query += ' AND Contact__r.CRT__c = TRUE';

//         String query ='SELECT Id,Course_Offering__r.college_University__r.Name,  Contact__c,Course_Offering__r.Mentor__c, ' +
//         'Course_Offering__r.Course__c,Course__Offering__r.Course__r.Program__c FROM CourseConnection__c '+
//         'WHERE Type_c =\'Student\' AND Status__c = \'Active\' ';

//         if(selectedCRTValue==true){
//            query +='AND Contact_r.CRT_c=:selectedCRTValue ';
           
//         if (selectedUniversity != null && selectedUniversity != '') {
//             query += ' AND Course_Offering__r.college_University__r.Name LIKE \'%' + String.escapeSingleQuotes(selectedUniversity) + '%\'';
//         }
//         }
//         List<CourseConnection__c> courseConnections =Database.query(query);
        
    
//         Map<String, Map<String, Set<Id>>> universityDataMap = new Map<String, Map<String, Set<Id>>>();
//         Map<String, Id> universityIdMap = new Map<String, Id>();
//     s
//         for (CourseConnection__c cc : courseConnections) {
//             String universityName = cc.Course_Offering__r.college_University__r.Name;
//             Id universityId = cc.Course_Offering__r.college_University__r.Id;
            
//             universityIdMap.put(universityName, universityId);
            
//             if (!universityDataMap.containsKey(universityName)) {
//                 universityDataMap.put(universityName, new Map<String, Set<Id>>{ 
//                     'Mentors' => new Set<Id>(),
//                     'Contacts' => new Set<Id>(),
//                     'Programs' => new Set<Id>() 
//                 });
//             }
            
//             if (cc.Course_Offering__r.Mentor__c != null) {
//                 universityDataMap.get(universityName).get('Mentors').add(cc.Course_Offering__r.Mentor__c);
//             }
    
//             if (cc.Contact__c != null) {
//                 universityDataMap.get(universityName).get('Contacts').add(cc.Contact__c);
//             }
    
//             if (cc.Course_Offering__r.Course__r.Program__c != null) {
//                 universityDataMap.get(universityName).get('Programs').add(cc.Course_Offering__r.Course__r.Program__c);
//             }
//         }
    
//         List<Map<String, Object>> universityWiseDataList = new List<Map<String, Object>>();
//         Integer serialNumber = 1;
    
//         for (String university : universityDataMap.keySet()) {
//             Map<String, Object> universityData = new Map<String, Object>();
//             universityData.put('name', university);
//             universityData.put('numbers', serialNumber);
//             universityData.put('id', universityIdMap.get(university));
//             universityData.put('mentors', universityDataMap.get(university).get('Mentors').size());
//             universityData.put('students', universityDataMap.get(university).get('Contacts').size());
//             universityData.put('programs', universityDataMap.get(university).get('Programs').size());
//             universityWiseDataList.add(universityData);
//             serialNumber++;
//         }
    
//         return universityWiseDataList;
//     }
    

//     //  @AuraEnabled
//     //     public static Map<String, Integer> getData(Boolean selectedCRTValue,string selectedUniversity) {
//     //         String query = 'SELECT Id, Course_Offering__r.college_University__r.Name, Course_Offering__r.college_University__r.Id, '
//     //              + 'Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c, Contact__c '
//     //              + 'FROM CourseConnection__c '
//     //              + 'WHERE Type__c = \'Student\' AND Status__c = \'Active\' ';
//     //       if (selectedCRTValue) {
//     //       query += ' AND Contact__r.CRT__c = TRUE';
          
//     //       if (selectedUniversity !='' && selectedUniversity != null) {
//     //         query += 'AND Course_Offering__r.college_University__r.Name LIKE \'%' + String.escapeSingleQuotes(selectedUniversity) + '%\'';
//     //        } 
//     //         }
//     //         // Executing SOQL Query
//     //         List<CourseConnection__c> courseConnections = Database.query(query);
    
//     //         Map<String, Map<String, Set<Id>>> universityDataMap=new Map<String, Map<String, Set<Id>>>(); 
//     //         Map<String, Id> universityIdMap=new Map<String, Id>();
            
//     //         for (CourseConnection__c cc : courseconnections) {
            
//     //         String universityName=cc.Course_Offering__r.college_University__r.Name;
            
//     //         Id universityId=cc.Course_Offering__r.college_University__r.Id;
            
//     //         universityIdMap.put(universityName, universityId);
            
//     //         if (!universityDataMap.containsKey(universityName)) {
//     //             universityDataMap.put(universityName, new Map<String, Set<Id>>{ 
//     //                 'Mentors' => new Set<Id>(),
//     //                 'Contacts' => new Set<Id>(),
//     //                  'Programs'=> new Set<Id>() 
//     //             });
//     //         }
            
//     //         if (cc.Course_Offering__r.Mentor__c != null) {
//     //         universityDataMap.get(universityName).get('Mentors').add(cc.Course_Offering__r.Mentor__c);
//     //        }
            
//     //        if(cc.Contact__c!=null){
//     //         universityDataMap.get(universityName).get('Contacts').add(cc.Contact__c);
//     //        }
        
//     //        if(cc.Course_Offering__r.Course__r.Program__c!=null){
//     //         universityDataMap.get(universityName).get('Programs').add(cc.Course_Offering__r.Course__r.Program__c);
//     //        }
//     //     }
//     //     List<Map<String, Object>> universityWiseDataList = new List<Map<String, Object>>();
//     //     Integer serialNumber = 1;
//     //     for (String university: universityDataMap.keySet()) {
//     //             Map<String, Object> universityData = new Map<String, Object>();
//     //             universityData.put('name', university);
//     //             universityData.put('numbers',serialNumber);
//     //             universityData.put('id', universityIdMap.get(university));
//     //             universityData.put('mentors', universityDataMap.get(university).get('Mentors').size());
//     //             universityData.put('students', universityDataMap.get(university).get('Contacts').size());
//     //             universityData.put('programs', universityDataMap.get(university).get('Programs').size());
//     //             universityWiseDataList.add(universityData);
//     //             serialNumber++;
//     //     }
//     //     return universityWiseDataList;
   
   
//     //     }

//     }
// //     @AuraEnabled
// //     public static Map<String, Integer>topData(){

// //             String query ='SELECT Id, CourseOffering_r.collegeOrUniversityc,CourseOfferingr.collegeOrUniversityr.name,  Contactc,CourseOfferingr.Mentor_c, ' +
// //         'CourseOffering_r.Coursec,CourseOfferingr.Courser.Programc FROM CourseConnection_c '+
// //         'WHERE Type_c =:type AND  Status_c=:ACTIVE_STATUS ';

// //         if(selectedCRTValue==true){
// //            query +='AND Contact_r.CRT_c=:selectedCRTValue ';
// //         }
// //         List<CourseConnection__c> courseConnections =Database.query(query);
// //         ];
// //         Set<Id> uniqueUniversities=new Set<Id>();
// //         Set<Id> uniqueMentors=new Set<Id>();
// //         Set<Id> uniqueContacts=new Set<Id>();
// //         Set<Id> uniqueCourse=new Set<Id>();
// //         Set<Id> uniquePrograms=new Set<Id>();

// //         for(CourseConnection__c cc: courseconnections){
// //             if(cc.CourseOffering__r.collegeOrUniversity__c!=null){
// //                 uniqueUniversities.add(cc.CourseOffering__r.collegeOrUniversity__c);
// //             }
// //             if(cc.Contact__c != null){
// //                 uniqueContacts.add(cc.Contact__c);
// //             }
// //             if(cc.CourseOffering__r.Mentor__c != null){
// //                 uniqueMentors.add(cc.CourseOffering__r.Mentor__c);
// //             }
// //             if(cc.CourseOffering__r.Course__c!=null){
// //                 uniqueCourse.add(cc.CourseOffering__r.Course__c);
// //             }
// //             if(cc.CourseOffering__r.Course__r.Program__c !=null){
// //                 uniquePrograms.add(cc.CourseOffering__r.Course__r.Program__c);
// //             }
// //         }
// //         Map<String, Integer> result = new Map<String, Integer>();
// //         result.put('UniqueUniversities', uniqueUniversities.size());
// //         result.put('UniqueContacts', uniqueContacts.size());
// //         result.put('UniqueMentors', uniqueMentors.size());
// //         result.put('UniqueCourses', uniqueCourse.size());
// //         result.put('UniquePrograms', uniquePrograms.size());

// //         return result;
// //     }
// // }



// //     @AuraEnabled
// //     public static List<Map<String, Object>> getUniversityWiseData(String selectedUniversity){
// //         String query ='SELECT Id, CourseOffering_r.collegeOrUniversityc,CourseOfferingr.collegeOrUniversityr.name,  Contactc,CourseOfferingr.Mentor_c, ' +
// //                 'CourseOffering_r.Coursec,CourseOfferingr.Courser.Programc FROM CourseConnection_c '+
// //                 'WHERE Type__c = \'Student\' AND Status__c = \'Active\'  ';
        
// //                 if(selectedCRTValue==true){
// //                    query +='AND Contact_r.CRT_c=:selectedCRTValue ';
// //                 }
// //     // String query = 'SELECT Id, Course_Offering__r.college_University__r.Name, Course_Offering__r.college_University__r.Id, '
// //     //              + 'Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c, Contact__c '
// //     //              + 'FROM CourseConnection__c '
// //     //              + 'WHERE Type__c = \'Student\' AND Status__c = \'Active\' ';

// //     // if (selectedCRTValue) {
// //     //  query += ' AND Contact__r.CRT__c = TRUE';
                     
// //     if (selectedUniversity !='' && selectedUniversity != null) {
// //      query += 'AND Course_Offering__r.college_University__r.Name LIKE \'%' + String.escapeSingleQuotes(selectedUniversity) + '%\'';
// //     } 
// // //}
// //     List<CourseConnection__c> courseconnections=Database.query(query);
    
// //     Map<String, Map<String, Set<Id>>> universityDataMap=new Map<String, Map<String, Set<Id>>>(); 
// //     Map<String, Id> universityIdMap=new Map<String, Id>();
    
// //     for (CourseConnection__c cc : courseconnections) {
    
// //     String universityName=cc.Course_Offering__r.college_University__r.Name;
    
// //     Id universityId=cc.Course_Offering__r.college_University__r.Id;
    
// //     universityIdMap.put(universityName, universityId);
    
// //     if (!universityDataMap.containsKey(universityName)) {
// //         universityDataMap.put(universityName, new Map<String, Set<Id>>{ 
// //             'Mentors' => new Set<Id>(),
// //             'Contacts' => new Set<Id>(),
// //              'Programs'=> new Set<Id>() 
// //         });
// //     }
    
// //     if (cc.Course_Offering__r.Mentor__c != null) {
// //     universityDataMap.get(universityName).get('Mentors').add(cc.Course_Offering__r.Mentor__c);
// //    }
    
// //    if(cc.Contact__c!=null){
// //     universityDataMap.get(universityName).get('Contacts').add(cc.Contact__c);
// //    }

// //    if(cc.Course_Offering__r.Course__r.Program__c!=null){
// //     universityDataMap.get(universityName).get('Programs').add(cc.Course_Offering__r.Course__r.Program__c);
// //    }
// // }
// // List<Map<String, Object>> universityWiseDataList = new List<Map<String, Object>>();
// // Integer serialNumber = 1;
// // for (String university: universityDataMap.keySet()) {
// //         Map<String, Object> universityData = new Map<String, Object>();
// //         universityData.put('name', university);
// //         universityData.put('numbers',serialNumber);
// //         universityData.put('id', universityIdMap.get(university));
// //         universityData.put('mentors', universityDataMap.get(university).get('Mentors').size());
// //         universityData.put('students', universityDataMap.get(university).get('Contacts').size());
// //         universityData.put('programs', universityDataMap.get(university).get('Programs').size());
// //         universityWiseDataList.add(universityData);
// //         serialNumber++;
// // }
// // return universityWiseDataList;
// // }





// // }
//         // @AuraEnabled
//         // public static Map<String, Integer> getTopHeadersData(Boolean selectedCRTValue) {
//             // String query = 'SELECT Id, Course_Offering__r.college_University__r.Name, Course_Offering__r.college_University__r.Id, '
//             //      + 'Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c, Contact__c '
//             //      + 'FROM CourseConnection__c '
//             //      + 'WHERE Type__c = \'Student\' AND Status__c = \'Active\' ';


//                  //String query ='SELECT Id, CourseOffering_r.collegeOrUniversityc,CourseOfferingr.collegeOrUniversityr.name,  Contactc,CourseOfferingr.Mentor_c, ' +
//                  //         'CourseOffering_r.Coursec,CourseOfferingr.Courser.Programc FROM CourseConnection_c '+
//                  //         'WHERE Type_c =:type AND  Status_c=:ACTIVE_STATUS ';
                 
//                  //         if(selectedCRTValue==true){
//                  //            query +='AND Contact_r.CRT_c=:selectedCRTValue ';
//                  //         }
//         //     String query = 'SELECT Id, Course_Offering__r.college_University__c, Course_Offering__r.college_University__r.Name, ' +
//         // 'Contact__c, Course_Offering__r.Mentor__c, Course_Offering__r.Course__c, Course_Offering__r.Course__r.Program__c ' +
//         // 'FROM CourseConnection__c WHERE Type__c = \'Student\' AND Status__c = \'Active\'';
    
//         //   if (selectedCRTValue) {
//         //   query += ' AND Contact__r.CRT__c = TRUE';
//         //     }
//         //     // Executing SOQL Query
//         //     List<CourseConnection__c> courseConnections = Database.query(query);
    
//         //     // Using Sets to store unique values
//         //     Set<Id> uniqueUniversities = new Set<Id>();
//         //     Set<Id> uniqueMentors = new Set<Id>();
//         //     Set<Id> uniqueContacts = new Set<Id>();
//         //     Set<Id> uniqueCourses = new Set<Id>();
//         //     Set<Id> uniquePrograms = new Set<Id>();
    
//         //     // Iterating through the results to extract unique values
//         //     for (CourseConnection__c cc : courseConnections) {
//         //         if (cc.Course_Offering__r.college_University__c != null) {
//         //             uniqueUniversities.add(cc.Course_Offering__r.college_University__c);
//         //         }
//         //         if (cc.Contact__c != null) {
//         //             uniqueContacts.add(cc.Contact__c);
//         //         }
//         //         if (cc.Course_Offering__r.Mentor__c != null) {
//         //             uniqueMentors.add(cc.Course_Offering__r.Mentor__c);
//         //         }
//         //         if (cc.Course_Offering__r.Course__c != null) {
//         //             uniqueCourses.add(cc.Course_Offering__r.Course__c);
//         //         }
//         //         if (cc.Course_Offering__r.Course__r.Program__c != null) {
//         //             uniquePrograms.add(cc.Course_Offering__r.Course__r.Program__c);
//         //         }
//         //     }
    
//         //     // Preparing the result map
//         //     Map<String, Integer> result = new Map<String, Integer>();
//         //     result.put('UniqueUniversities', uniqueUniversities.size());
//         //     result.put('UniqueContacts', uniqueContacts.size());
//         //     result.put('UniqueMentors', uniqueMentors.size());
//         //     result.put('UniqueCourses', uniqueCourses.size());
//         //     result.put('UniquePrograms', uniquePrograms.size());
    
//         //     return result;
//         // }

    
    
    
    
//     // public with sharing class crtDashboard {
//     //     @AuraEnabled
//     //     public static Map<String, Integer> getTopHeadersData(){
    
//     //             String query ='SELECT Id, CourseOffering_r.collegeOrUniversityc,CourseOfferingr.collegeOrUniversityr.name,  Contactc,CourseOfferingr.Mentor_c, ' +
//     //         'CourseOffering_r.Coursec,CourseOfferingr.Courser.Programc FROM CourseConnection_c '+
//     //         'WHERE Type_c =:type AND  Status_c=:ACTIVE_STATUS ';
    
//     //         if(selectedCRTValue==true){
//     //            query +='AND Contact_r.CRT_c=:selectedCRTValue ';
//     //         }
//     //         List<CourseConnection__c> courseConnections =Database.query(query);
//     //         ];
//     //         Set<Id> uniqueUniversities=new Set<Id>();
//     //         Set<Id> uniqueMentors=new Set<Id>();
//     //         Set<Id> uniqueContacts=new Set<Id>();
//     //         Set<Id> uniqueCourse=new Set<Id>();
//     //         Set<Id> uniquePrograms=new Set<Id>();
    
//     //         for(CourseConnection__c cc: courseconnections){
//     //             if(cc.CourseOffering__r.collegeOrUniversity__c!=null){
//     //                 uniqueUniversities.add(cc.CourseOffering__r.collegeOrUniversity__c);
//     //             }
//     //             if(cc.Contact__c != null){
//     //                 uniqueContacts.add(cc.Contact__c);
//     //             }
//     //             if(cc.CourseOffering__r.Mentor__c != null){
//     //                 uniqueMentors.add(cc.CourseOffering__r.Mentor__c);
//     //             }
//     //             if(cc.CourseOffering__r.Course__c!=null){
//     //                 uniqueCourse.add(cc.CourseOffering__r.Course__c);
//     //             }
//     //             if(cc.CourseOffering__r.Course__r.Program__c !=null){
//     //                 uniquePrograms.add(cc.CourseOffering__r.Course__r.Program__c);
//     //             }
//     //         }
//     //         Map<String, Integer> result = new Map<String, Integer>();
//     //         result.put('UniqueUniversities', uniqueUniversities.size());
//     //         result.put('UniqueContacts', uniqueContacts.size());
//     //         result.put('UniqueMentors', uniqueMentors.size());
//     //         result.put('UniqueCourses', uniqueCourse.size());
//     //         result.put('UniquePrograms', uniquePrograms.size());
    
//     //         return result;
//     //     }
//     // }