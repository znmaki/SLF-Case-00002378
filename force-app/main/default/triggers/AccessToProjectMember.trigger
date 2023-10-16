trigger AccessToProjectMember on Project3__c (before update) {

    List<Project_Member__c> projectMembersToUnrelate = new List<Project_Member__c>();
    List<Project_Member_Visible__c> listPMember = new List<Project_Member_Visible__c>();
    List<Project_Member_Visible__c> projectMembersToDelete = new List<Project_Member_Visible__c>();
    
    
    // Itera a través de los proyectos actualizados
    for (Project3__c project3 : Trigger.new) {
        Project3__c oldProject = Trigger.oldMap.get(project3.Id);
        
        // Comprueba si el estado ha cambiado a "Assigned"
        if (project3.Status__c == 'Assigned' && oldProject.Status__c != 'Assigned') {
            projectMembersToUnrelate = [SELECT Name, Junction_Project3__c, Junction_Contact__c FROM Project_Member__c WHERE Junction_Project3__c = :project3.Id];

            for (Project_Member__c pm : projectMembersToUnrelate) {
                Project_Member_Visible__c pMemberVisible = new Project_Member_Visible__c();
                pMemberVisible.Name = pm.Name;
                pMemberVisible.Project3__c = pm.Junction_Project3__c;
                pMemberVisible.Contact__c = pm.Junction_Contact__c;

                listPMember.add(pMemberVisible);
            }
        }
        
        // Comprueba si el estado ha cambiado a "Completed"
        if (project3.Status__c == 'Completed' && oldProject.Status__c != 'Completed') {            
            projectMembersToUnrelate = [SELECT Name, Junction_Project3__c, Junction_Contact__c FROM Project_Member__c WHERE Junction_Project3__c = :project3.Id];
            
            for (Project_Member__c pm : projectMembersToUnrelate) {
                projectMembersToDelete = [SELECT Id, Name, Contact__c, Project3__c FROM Project_Member_Visible__c WHERE Contact__c = :pm.Junction_Contact__c AND Project3__c = :pm.Junction_Project3__c];
                
                delete projectMembersToDelete;
            }
            System.debug(projectMembersToDelete);
        }

        if (project3.Status__c == 'Completed' && oldProject.Status__c == 'New') {
            project3.Status__c.addError('No se puede cambiar el estado directamente de "New" a "Completed".');
        }
    }

    if (!listPMember.isEmpty()) {
        insert listPMember;
    }
}