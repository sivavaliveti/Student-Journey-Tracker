public class ToDoToggleController {
    public String newTask { get; set; }
    public String taskToToggle { get; set; }
    
    public List<Task> getTasks() {
        return [SELECT Id, Subject, Status FROM Task WHERE OwnerId = :UserInfo.getUserId() ORDER BY CreatedDate DESC];
    }
    
    public void addTask() {
        if (String.isNotBlank(newTask)) {
            Task t = new Task(
                Subject = newTask,
                OwnerId = UserInfo.getUserId(),
                Status = 'Not Started',
                Priority = 'Normal'
            );
            insert t;
            newTask = '';
        }
    }
    
    public void toggleTask() {
        if (String.isNotBlank(taskToToggle)) {
            Task t = [SELECT Id, Status FROM Task WHERE Id = :taskToToggle LIMIT 1];
            t.Status = (t.Status == 'Completed') ? 'Not Started' : 'Completed';
            update t;
        }
    }
}