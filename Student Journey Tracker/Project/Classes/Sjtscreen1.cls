public class Sjtscreen1 {

    @AuraEnabled
    public static Map<String, Integer> getTopHeadersData(){
        List<CourseConnection__c> courseconnections = [
            SELECT Id,
                 Course_Offering__r.college_University__c,
                 Contact__c,
                 Course_Offering__r.Mentor__c,
                 Course_Offering__r.Course__c,
                 Course_Offering__r.Course__r.Program__c
            FROM CourseConnection__c
            WHERE Type__c='Student'
            AND Status__c='Active'
        ];
        Set<Id> uniqueUniversities=new Set<Id>();
        Set<Id> uniqueMentors=new Set<Id>();
        Set<Id> uniqueContacts=new Set<Id>();
        Set<Id> uniqueCourse=new Set<Id>();
        Set<Id> uniquePrograms=new Set<Id>();

        for(CourseConnection__c cc: courseconnections){
            if(cc.Course_Offering__r.college_University__c!=null){
                uniqueUniversities.add(cc.Course_Offering__r.college_University__c);
            }
            if(cc.Contact__c != null){
                uniqueContacts.add(cc.Contact__c);
            }
            if(cc.Course_Offering__r.Mentor__c != null){
                uniqueMentors.add(cc.Course_Offering__r.Mentor__c);
            }
            if(cc.Course_Offering__r.Course__c!=null){
                uniqueCourse.add(cc.Course_Offering__r.Course__c);
            }
            if(cc.Course_Offering__r.Course__r.Program__c !=null){
                uniquePrograms.add(cc.Course_Offering__r.Course__r.Program__c);
            }
        }
        Map<String, Integer> result = new Map<String, Integer>();
        result.put('UniqueUniversities', uniqueUniversities.size());
        result.put('UniqueContacts', uniqueContacts.size());
        result.put('UniqueMentors', uniqueMentors.size());
        result.put('UniqueCourses', uniqueCourse.size());
        result.put('UniquePrograms', uniquePrograms.size());

        return result;
    }



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

@AuraEnabled
  public static List<String> getUniqueProgramNames (String selectedUniversity) {
    System.debug('getUniqueProgramNames selectedUniversity '+ selectedUniversity);   
    List<CourseConnection__c> programsList = [
        SELECT Course_Offering__r.Course__r.Program__r.Name
        FROM CourseConnection__c
        WHERE Course_Offering__r.Course__r.Program__r.Name != null
    ];
    System.debug('programsList:' + programsList);
    Set<String> programs = new Set<String>();
    for (CourseConnection__c cc: programsList) {
        programs.add(cc.Course_Offering__r.Course__r.Program__r.Name);
    }
    System.debug('programNames:' + programs);
  return new List<String>(programs);
}

@AuraEnabled
public static List<Map<String, Object>> getAllStudentsData(
    String searchKey, 
    String selectedUniversity, 
    String selectedProgram, 
    String selectedYear, 
    String selectedSemester) 
{
    // Constructing SOQL query
    String query = 'SELECT Id,Student__c, Student__r.Name, CourseConnection__r.Semister__c, ' +
                   'CourseConnection__r.Batch_Year__c,Overall_grade__c, CourseConnection__r.Course_Offering__r.Course__r.Program__r.Skills_Gained__c ' + 
                   'FROM CourseProgress__c ' +
                   'WHERE CourseConnection__r.Type__c = \'Student\'';

    // Adding filters based on input parameters
    if (searchKey != null && searchKey != '') {
        query += ' AND Student__r.Name LIKE \'%' + String.escapeSingleQuotes(searchKey) + '%\'';
    }
    if (selectedUniversity != null && selectedUniversity != '') {
        query += ' AND CourseConnection__r.Course_Offering__r.College_University__c = \'' + String.escapeSingleQuotes(selectedUniversity) + '\'';
    }
    if (selectedProgram != null && selectedProgram != '') {
        query += ' AND CourseConnection__r.Course_Offering__r.Course__r.Program__r.Name = \'' + String.escapeSingleQuotes(selectedProgram) + '\'';
    }
    if (selectedYear != null && selectedYear != '') {
        query += ' AND CourseConnection__r.Batch_Year__c = \'' + String.escapeSingleQuotes(selectedYear) + '\'';
    }
    if (selectedSemester != 'All Sems' && selectedSemester != '') {
        query += ' AND CourseConnection__r.Semester__c = \'' + String.escapeSingleQuotes(selectedSemester) + '\'';
    }

    // Debugging the constructed query
    System.debug('Final Query: ' + query);

    // Executing the query
    List<CourseProgress__c> courseProgressList = Database.query(query);

    // Preparing the result list
    List<Map<String, Object>> studentsDataList = new List<Map<String, Object>>();
    Integer serialNumber = 1;
    for (CourseProgress__c cp : courseProgressList) {
        Map<String, Object> studentData = new Map<String, Object>();
        studentData.put('SerialNumber', serialNumber);
        studentData.put('Name', cp.Student__r.Name);
        studentData.put('StudentId', cp.Student__c);    
        studentData.put('Year', cp.CourseConnection__r.Batch_Year__c);
        studentData.put('Semester', cp.CourseConnection__r.Semister__c);
        studentData.put('Grade', cp.Overall_grade__c);
        studentData.put('Skill', cp.CourseConnection__r.Course_Offering__r.Course__r.Program__r.Skills_Gained__c);
        studentsDataList.add(studentData);
        serialNumber++;
    }

    // Debugging the final result
    System.debug('studentsDataList: ' + studentsDataList);
    

    // Returning the result
    return studentsDataList;
}












@AuraEnabled
public static List<Map<String, Object>> getProgramwiseData(String selectedUniversity) {
    System.debug('selectedUniversity: ' + selectedUniversity);

    // Corrected the query to ensure that the relationship names are correct and there are no spaces or missing values
    String query = 'SELECT Id, Course_Offering__r.college_University_r.Name, '
                 + 'Course_Offering__r.college_University__r.Id, '
                 + 'Course_Offering__r.Course__r.Name, '
                 + 'Course_Offering__r.Course__r.Program_c, '
                 + 'Course_Offering__r.Course__r.Program_r.Name, '
                 + 'Contact__c, Contact__r.Name '
                 + 'FROM CourseConnection__c '
                 + 'WHERE Course_Offering__r.college_University__r.Name = :selectedUniversity';

    // Run the dynamic query to fetch course connection data
    List<CourseConnection__c> courseConnections = Database.query(query);

    // Initialize data structures to store university data
    Map<String, Map<String, Set<String>>> universityDataMap = new Map<String, Map<String, Set<String>>>();
    Map<String, Id> universityIdMap = new Map<String, Id>();

    // Loop through course connections and populate the data maps
    for (CourseConnection__c cc : courseConnections) {
        String universityName = cc.Course_Offering__r.college_University__r.Name;
        Id universityId = cc.Course_Offering__r.college_University__r.Id;

        // Store the universityId against its name
        universityIdMap.put(universityName, universityId);

        // Initialize map for university if it doesn't already exist
        if (!universityDataMap.containsKey(universityName)) {
            universityDataMap.put(universityName, new Map<String, Set<String>>{
                'Programs' => new Set<String>(),
                'Courses' => new Set<String>(),
                'Contacts' => new Set<String>()
            });
        }

        // Add course, contact, and program data to the map
        if (cc.Course_Offering__r.Course__c != null) {
            universityDataMap.get(universityName).get('Courses').add(cc.Course_Offering__r.Course__r.Name);
        }

        if (cc.Contact__c != null) {
            universityDataMap.get(universityName).get('Contacts').add(cc.Contact__r.Name);
        }

        if (cc.Course_Offering__r.Course__r.Program__r.Name != null) {
            universityDataMap.get(universityName).get('Programs').add(cc.Course_Offering__r.Course__r.Program__r.Name);
        }
    }

    // Prepare the final list to return the data
    List<Map<String, Object>> universityWiseDataList = new List<Map<String, Object>>();
    Integer serialNumber = 1;

    // Loop through each university and collect the data
    for (String university : universityDataMap.keySet()) {
        Map<String, Object> universityData = new Map<String, Object>();
        universityData.put('name', university);
        universityData.put('id', universityIdMap.get(university));
        universityData.put('serialNumber', serialNumber);
        universityData.put('programs', new List<String>(universityDataMap.get(university).get('Programs')));
        universityData.put('Course', universityDataMap.get(university).get('Courses').size());
        universityData.put('students', universityDataMap.get(university).get('Contacts').size());
        universityWiseDataList.add(universityData);
        serialNumber++;
    }

    // Debug output for verification
    System.debug('universityWiseDataList: ' + universityWiseDataList);
    
    // Return the final list of data
    return universityWiseDataList;
}


}