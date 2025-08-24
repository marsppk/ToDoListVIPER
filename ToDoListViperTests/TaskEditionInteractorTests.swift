//
//  TaskEditionInteractorTests.swift
//  ToDoListViperTests
//
//  Created by Mariya Slepneva on 15.08.2025.
//

import XCTest
@testable import ToDoListViper

final class TaskEditionInteractorTests: XCTestCase {
    
    // MARK: - Properties
       
    var interactor: TaskEditionInteractor!
    var mockCoreDataManager: MockCoreDataManager!
    var currentTask: ToDoTask?
    let nextID = 2
   
    // MARK: - Setup & Teardown

    override func setUpWithError() throws {
        super.setUp()
        mockCoreDataManager = MockCoreDataManager()
        CoreDataManager.shared = mockCoreDataManager
    }

    override func tearDownWithError() throws {
        interactor = nil
        mockCoreDataManager = nil
        currentTask = nil
        super.tearDown()
    }
    
    // MARK: - Tests

    func testGetCurrentExistingTask() {
        currentTask = ToDoTask.defaultTask
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let result = interactor.getCurrentTask()
        XCTAssertEqual(result, ToDoTask.defaultTask)
    }
        
    func testGetCurrentNonexistentTask() {
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let result = interactor.getCurrentTask()
        XCTAssertNil(result)
    }
    
    func testSaveNewTaskWithNonEmptyDescription() {
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let title = "New Task"
        let description = "New Description"

        interactor.saveTask(title: title, description: description)
        
        let expectation = self.expectation(description: "Background context perform")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockCoreDataManager.tasks.count, 1)
            
            let savedTask = self.mockCoreDataManager.tasks.first
            XCTAssertEqual(savedTask?.id, self.nextID)
            XCTAssertEqual(savedTask?.title, title)
            XCTAssertEqual(savedTask?.description, description)
            XCTAssertFalse(savedTask?.isCompleted ?? true)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testSaveNewTaskWithEmptyTitle() {
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let emptyTitle = ""
        let description = "Test Description"

        interactor.saveTask(title: emptyTitle, description: description)
        
        let expectation = self.expectation(description: "Background context perform")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let savedTask = self.mockCoreDataManager.tasks.first
            XCTAssertEqual(savedTask?.title, "Задача \(self.nextID)")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testSaveNewTaskWithEmptyDescription() {
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let title = "Test Task"
        let emptyDescription = ""
        
        interactor.saveTask(title: title, description: emptyDescription)

        let expectation = self.expectation(description: "Background context perform")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockCoreDataManager.tasks.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testSaveExistingTask() {
        currentTask = ToDoTask.defaultTask
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let newTitle = "Updated Title"
        let newDescription = "Updated Description"
        
        interactor.saveTask(title: newTitle, description: newDescription)
        
        let expectation = self.expectation(description: "Background context perform")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockCoreDataManager.tasks.count, 1)
            
            let updatedTask = self.mockCoreDataManager.tasks.first
            XCTAssertEqual(updatedTask?.id, ToDoTask.defaultTask.id)
            XCTAssertEqual(updatedTask?.title, newTitle)
            XCTAssertEqual(updatedTask?.description, newDescription)
            XCTAssertEqual(updatedTask?.isCompleted, ToDoTask.defaultTask.isCompleted)
            XCTAssertEqual(updatedTask?.creationDate, ToDoTask.defaultTask.creationDate)
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testSaveExistingTaskWithEmptyTitle() {
        currentTask = ToDoTask.defaultTask
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let emptyTitle = ""
        let newDescription = "Updated Description"
        
        interactor.saveTask(title: emptyTitle, description: newDescription)
        
        let expectation = self.expectation(description: "Background context perform")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let updatedTask = self.mockCoreDataManager.tasks.first
            XCTAssertEqual(updatedTask?.title, "Задача \(self.nextID)")
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
    
    func testSaveExistingTaskWithEmptyDescription() {
        currentTask = ToDoTask.defaultTask
        interactor = TaskEditionInteractor(
            currentTask: currentTask,
            nextID: nextID
        )
        let title = "Updated Title"
        let emptyDescription = ""
        
        interactor.saveTask(title: title, description: emptyDescription)
        
        let expectation = self.expectation(description: "Background context perform")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockCoreDataManager.tasks.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
    }
}

