@isTest
public class AccountDetailsTest {
    @testSetup
    static void setupTestData() {
        // Create test Contacts
        Contact student1 = new Contact(FirstName = 'John', LastName = 'Doe');
        Contact student2 = new Contact(FirstName = 'Jane', LastName = 'Smith');
        insert new List<Contact>{ student1, student2 };

        // Create CourseConnection__c records
        CourseConnection__c cc1 = new CourseConnection__c(
            Contact__c = student1.Id,
            Type__c = 'Student',
            Status__c = 'Active'
        );

        CourseConnection__c cc2 = new CourseConnection__c(
            Contact__c = student2.Id,
            Type__c = 'Student',
            Status__c = 'Active'
        );

        insert new List<CourseConnection__c>{ cc1, cc2 };
    }

    @isTest
    static void testGetStudents() {
        Test.startTest();
        // ✅ Get the response as a Map<String, Object>
        Map<String, Object> response = AccountDetails.getStudents();
        Test.stopTest();

        // ✅ Ensure the response is not null
        System.assertNotEquals(response, null, 'Response should not be null');

        // ✅ Validate the student list
        System.assert(response.containsKey('students'), 'Response should contain students key');
        List<Map<String, String>> students = (List<Map<String, String>>) response.get('students');
        System.assertNotEquals(students, null, 'Student list should not be null');
        System.assertEquals(2, students.size(), 'Should return 2 students');

        // ✅ Validate the totalStudents count
        System.assert(response.containsKey('totalStudents'), 'Response should contain totalStudents key');
        Integer totalStudents = (Integer) response.get('totalStudents');
        System.assertEquals(2, totalStudents, 'Total students count should be 2');

        // ✅ Extract student names and verify
        List<String> studentNames = new List<String>();
        for (Map<String, String> student : students) {
            studentNames.add(student.get('studentName'));
        }

        System.assert(studentNames.contains('John Doe'), 'List should contain John Doe');
        System.assert(studentNames.contains('Jane Smith'), 'List should contain Jane Smith');
    }

    @isTest
    static void testGetStudentsNoRecords() {
        Test.startTest();
        // ✅ Get response when no records exist
        Map<String, Object> response = AccountDetails.getStudents();
        Test.stopTest();

        // ✅ Validate empty student list
        List<Map<String, String>> students = (List<Map<String, String>>) response.get('students');
        System.assertEquals(0, students.size(), 'Student list should be empty');

        // ✅ Validate totalStudents count
        Integer totalStudents = (Integer) response.get('totalStudents');
        System.assertEquals(0, totalStudents, 'Total students count should be 0');
    }
}