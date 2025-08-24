//
//  MockToDoListPresenter.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 24.08.2025.
//

class MockToDoListPresenter: ToDoListPresenterOutput {
    
    // MARK: - Internal Properties
    
    var didFetchTasksCalled = false
    var tasksReceived: [ToDoTask]?
    
    var didUpdateTaskCalled = false
    var updatedTask: ToDoTask?
    var updatedIndex: Int?
    
    // MARK: - Internal Methods
    
    func didFetchTasks(_ tasks: [ToDoTask]) {
        didFetchTasksCalled = true
        tasksReceived = tasks
    }
    
    func didUpdateTask(task: ToDoTask, at index: Int) {
        didUpdateTaskCalled = true
        updatedTask = task
        updatedIndex = index
    }
}
