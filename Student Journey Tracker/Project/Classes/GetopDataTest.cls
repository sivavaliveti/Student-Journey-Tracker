@isTest
public class GetopDataTest {
    
    @testSetup
    static void setupTestData() {
        // Create Test University
        Account university1 = new Account(Name = 'Test University 1');
        Account university2 = new Account(Name = 'Test University 2');
        insert new List<Account>{university1, university2};

        // Create Mentors
        Contact mentor1 = new Contact(FirstName = 'Mentor', LastName = 'One');
        Contact mentor2 = new Contact(FirstName = 'Mentor', LastName = 'Two');
        insert new List<Contact>{mentor1, mentor2};

        // Create Programs
        Program__c program1 = new Program__c(Name = 'Program A');
        Program__c program2 = new Program__c(Name = 'Program B');
        insert new List<Program__c>{program1, program2};

        // Create Courses
        Course__c course1 = new Course__c(Name = 'Course 1', Program__c = program1.Id);
        Course__c course2 = new Course__c(Name = 'Course 2', Program__c = program2.Id);
        insert new List<Course__c>{course1, course2};

        // Create Course Offerings
        CourseOffering__c offering1 = new CourseOffering__c(
            college_University__c = university1.Id,
            Mentor__c = mentor1.Id,
            Course__c = course1.Id
        );

        CourseOffering__c offering2 = new CourseOffering__c(
            college_University__c = university2.Id,
            Mentor__c = mentor2.Id,
            Course__c = course2.Id
        );

        insert new List<CourseOffering__c>{offering1, offering2};

        // Create Students
        Contact student1 = new Contact(FirstName = 'Student', LastName = 'One');
        Contact student2 = new Contact(FirstName = 'Student', LastName = 'Two');
        insert new List<Contact>{student1, student2};

        // Create Course Connections (Students linked to Courses)
        CourseConnection__c cc1 = new CourseConnection__c(
            Course_Offering__c = offering1.Id,
            Contact__c = student1.Id,
            Type__c = 'Student',
            Status__c = 'Active'
        );

        CourseConnection__c cc2 = new CourseConnection__c(
            Course_Offering__c = offering2.Id,
            Contact__c = student2.Id,
            Type__c = 'Student',
            Status__c = 'Active'
        );

        insert new List<CourseConnection__c>{cc1, cc2};
    }

    @isTest
    static void testGetUniversityWiseData() {
        Test.startTest();
        List<Map<String, Object>> result = GetopData.getUniversityWiseData(null);
        Test.stopTest();

        // Validate the response
        System.assertNotEquals(result, null, 'Result should not be null');
        System.assertEquals(2, result.size(), 'Should return 2 universities');

        // Validate first university
        Map<String, Object> university1 = result[0];
        System.assertEquals('Test University 1', university1.get('name'), 'University name should match');
        System.assertEquals(1, university1.get('mentors'), 'Should have 1 mentor');
        System.assertEquals(1, university1.get('students'), 'Should have 1 student');
        System.assertEquals(1, university1.get('programs'), 'Should have 1 program');

        // Validate second university
        Map<String, Object> university2 = result[1];
        System.assertEquals('Test University 2', university2.get('name'), 'University name should match');
        System.assertEquals(1, university2.get('mentors'), 'Should have 1 mentor');
        System.assertEquals(1, university2.get('students'), 'Should have 1 student');
        System.assertEquals(1, university2.get('programs'), 'Should have 1 program');
    }

    @isTest
    static void testGetUniversityWiseDataWithFilter() {
        Test.startTest();
        List<Map<String, Object>> result = GetopData.getUniversityWiseData('Test University 1');
        Test.stopTest();

        // Validate response
        System.assertNotEquals(result, null, 'Result should not be null');
        System.assertEquals(1, result.size(), 'Should return 1 university');

        // Validate filtered university
        Map<String, Object> university1 = result[0];
        System.assertEquals('Test University 1', university1.get('name'), 'Filtered university should match');
        System.assertEquals(1, university1.get('mentors'), 'Should have 1 mentor');
        System.assertEquals(1, university1.get('students'), 'Should have 1 student');
        System.assertEquals(1, university1.get('programs'), 'Should have 1 program');
    }

    @isTest
    static void testGetUniversityWiseDataNoRecords() {
        Test.startTest();
        List<Map<String, Object>> result = GetopData.getUniversityWiseData('Non-Existing University');
        Test.stopTest();

        // Validate response
        System.assertNotEquals(result, null, 'Result should not be null');
        System.assertEquals(0, result.size(), 'Should return 0 universities');
    }
}