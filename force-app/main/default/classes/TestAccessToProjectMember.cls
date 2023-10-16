@isTest
public with sharing class TestAccessToProjectMember {
    @isTest
    static void testAccessToProjectMember() {

        Contact testContact = new Contact(
            FirstName = 'Test', 
            LastName = 'Contact', 
            Email = 'test@gmail.com.invalid',
            Phone = '(51) 768493865'
        );
        insert testContact;

        Project3__c testProject3 = new Project3__c(
            Name = 'Project3 Test',
            Status__c = 'New'            
        );
        insert testProject3;

        Project_Member__c pmTest = new Project_Member__c(
            Name = 'Project Member Test',
            Junction_Contact__c = testContact.Id,
            Junction_Project3__c = testProject3.Id
        );
        insert pmTest;

        testProject3.Status__c = 'Assigned';
        update testProject3;

        List<Project_Member_Visible__c> pmv = [SELECT Name, Contact__c, Project3__c FROM Project_Member_Visible__c WHERE Contact__c = :pmTest.Junction_Contact__c AND Project3__c = :pmTest.Junction_Project3__c];
    
        System.assertEquals(true, !pmv.isEmpty(), 'El objeto no existe.');

        testProject3.Status__c = 'Completed';
        update testProject3;

        List<Project_Member_Visible__c> pmv2 = [SELECT Name, Contact__c, Project3__c FROM Project_Member_Visible__c WHERE Contact__c = :pmTest.Junction_Contact__c AND Project3__c = :pmTest.Junction_Project3__c];
        System.assertEquals(true, pmv2.isEmpty(), 'El objeto no debería existir.');

        try {
            testProject3.Status__c = 'New';
            update testProject3;

            testProject3.Status__c = 'Completed';
            update testProject3;
        } catch (DmlException e) {
            System.assert(e.getDmlMessage(0).contains('No se puede cambiar el estado directamente de "New" a "Completed".'), 'verificando si debe salir un error');
        }
    }
}