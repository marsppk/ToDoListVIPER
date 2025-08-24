//
//  ToDoListInteractorTests.swift
//  ToDoListViper
//
//  Created by Maria Slepneva on 24.08.2025.
//

import XCTest
@testable import ToDoListViper

final class ToDoListInteractorTests: XCTestCase {
    
    // MARK: - Properties
    
    var interactor: ToDoListInteractor!
    var mockCoreDataManager: MockCoreDataManager!
    var mockAPIManager: MockAPIManager!
    var mockPresenter: MockToDoListPresenter!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        mockAPIManager = MockAPIManager()
        mockPresenter = MockToDoListPresenter()
        
        CoreDataManager.shared = mockCoreDataManager
        APIManager.shared = mockAPIManager
    }
    
    override func tearDown() {
        interactor = nil
        mockCoreDataManager = nil
        mockAPIManager = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchTasksWithCoreData() {
        interactor = ToDoListInteractor()
        interactor.presenter = mockPresenter
    
        let localTasks = [ToDoTask].fixture(count: 3)
        mockCoreDataManager.tasks = localTasks
        
        interactor.fetchTasks()
        waitForAsyncOperations()
        
        XCTAssertTrue(mockCoreDataManager.fetchAllTasksCalled)
        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(mockPresenter.tasksReceived?.count, 3)
        XCTAssertFalse(mockAPIManager.getDataCalled)
    }
    
    func testFetchTasksFromAPI() {
        interactor = ToDoListInteractor()
        interactor.presenter = mockPresenter
        
        mockCoreDataManager.tasks = []
        mockAPIManager.resultToReturn = .success(ToDoListDTO.fixture(count: 2))

        interactor.fetchTasks()
        waitForAsyncOperations()
        
        XCTAssertTrue(mockCoreDataManager.fetchAllTasksCalled)
        XCTAssertTrue(mockAPIManager.getDataCalled)
        XCTAssertEqual(mockAPIManager.endpointPassed, .getTasks)
    }
    
    func testFetchTasksFromAPISavesAndPresents() {
        interactor = ToDoListInteractor()
        interactor.presenter = mockPresenter
        
        mockCoreDataManager.tasks = []
        mockAPIManager.resultToReturn = .success(ToDoListDTO.fixture(count: 2))
        
        interactor.fetchTasks()
        waitForAsyncOperations()

        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(mockPresenter.tasksReceived?.count, 2)
        XCTAssertEqual(mockCoreDataManager.tasks.count, 2)
    }
    
    func testFetchTasksFromAPIFailure() {
        interactor = ToDoListInteractor()
        interactor.presenter = mockPresenter
        
        mockCoreDataManager.tasks = []
        mockAPIManager.resultToReturn = .failure(NSError(domain: "Test", code: 500))
        
        interactor.fetchTasks()
        waitForAsyncOperations()
        
        XCTAssertTrue(mockAPIManager.getDataCalled)
        XCTAssertFalse(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(mockCoreDataManager.tasks.count, 0)
    }
    
    func testUpdateTaskCompletion() {
        let tasks = [ToDoTask].fixture(count: 2)
        interactor = ToDoListInteractor(tasks: tasks)
        interactor.presenter = mockPresenter
        
        let indexToUpdate = 0
        let initialCompletion = tasks[indexToUpdate].isCompleted
        
        interactor.updateTaskCompletion(at: indexToUpdate)
        waitForAsyncOperations()
        
        XCTAssertTrue(mockPresenter.didUpdateTaskCalled)
        XCTAssertEqual(mockPresenter.updatedIndex, indexToUpdate)
        XCTAssertEqual(mockPresenter.updatedTask?.isCompleted, !initialCompletion)
        XCTAssertTrue(mockCoreDataManager.updateTaskCalled)
        XCTAssertEqual(mockCoreDataManager.updatedTask?.id, tasks[indexToUpdate].id)
    }
    
    func testUpdateTaskCompletionInvalidIndex() {
        let tasks = [ToDoTask].fixture(count: 1)
        interactor = ToDoListInteractor(tasks: tasks)
        interactor.presenter = mockPresenter
        
        interactor.updateTaskCompletion(at: 5)
        waitForAsyncOperations()
        
        XCTAssertFalse(mockPresenter.didUpdateTaskCalled)
        XCTAssertFalse(mockCoreDataManager.updateTaskCalled)
    }
    
    func testDeleteTask() {
        let tasks = [ToDoTask].fixture(count: 3)
        interactor = ToDoListInteractor(tasks: tasks)
        interactor.presenter = mockPresenter
        
        let indexToDelete = 1
        let taskIdToDelete = tasks[indexToDelete].id
        
        interactor.deleteTask(at: indexToDelete)
        waitForAsyncOperations()
        
        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
        XCTAssertEqual(mockPresenter.tasksReceived?.count, 2)
        XCTAssertTrue(mockCoreDataManager.deleteTaskCalled)
        XCTAssertEqual(mockCoreDataManager.deletedTaskId, taskIdToDelete)
    }
    
    func testDeleteTaskInvalidIndex() {
        let tasks = [ToDoTask].fixture(count: 1)
        interactor = ToDoListInteractor(tasks: tasks)
        interactor.presenter = mockPresenter
        
        interactor.deleteTask(at: 5)
        waitForAsyncOperations()
        
        XCTAssertFalse(mockPresenter.didFetchTasksCalled)
        XCTAssertFalse(mockCoreDataManager.deleteTaskCalled)
    }
    
    func testGetCurrentTask() {
        let tasks = [ToDoTask].fixture(count: 2)
        interactor = ToDoListInteractor(tasks: tasks)
        interactor.presenter = mockPresenter
        
        let index = 1
        let task = interactor.getCurrentTask(index: index)
        
        XCTAssertNotNil(task)
        XCTAssertEqual(task?.id, tasks[index].id)
    }
    
    func testGetCurrentTaskInvalidIndex() {
        let tasks = [ToDoTask].fixture(count: 1)
        interactor = ToDoListInteractor(tasks: tasks)
        interactor.presenter = mockPresenter
        
        let task = interactor.getCurrentTask(index: 5)
        
        XCTAssertNil(task)
    }
    
    func testGetCurrentTaskWithEmptyTasksList() {
        interactor = ToDoListInteractor()
        interactor.presenter = mockPresenter
        
        let task = interactor.getCurrentTask(index: 0)
        
        XCTAssertNil(task)
    }
    
    // MARK: - Helper Methods
    
    private func waitForAsyncOperations() {
        let expectation = self.expectation(description: "Async operations")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}
