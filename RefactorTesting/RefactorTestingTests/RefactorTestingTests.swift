import XCTest
@testable import RefactorTesting // Replace with your actual app target name

class UserManagerTests: XCTestCase {
    var userManager: UserManager!
    var mockValidator: MockUserValidationProtocol!
    var mockUserRepository: UserRepository!
    var mockEmailService: EmailService!
    
    override func setUp() {
        super.setUp()
        
        // Create mock dependencies
        mockValidator = MockUserValidationProtocol()
        mockUserRepository = MockUserRepositoryProtocol()
        mockEmailService = MockEmailServiceProtocol()
        
        // Initialize UserManager with mock dependencies
        userManager = UserManager(
            validator: mockValidator,
            userRepository: mockUserRepository,
            emailService: mockEmailService
        )
    }
    
    override func tearDown() {
        userManager = nil
        mockValidator = nil
        mockUserRepository = nil
        mockEmailService = nil
        
        super.tearDown()
    }
    
    // MARK: - Registration Tests
    
    func testSuccessfulUserRegistration() {
        // Arrange
        let firstName = "John"
        let lastName = "Doe"
        let email = "john.doe@example.com"
        let password = "StrongPassword123"
        let age = 25
        
        // Setup expectations
        mockValidator.shouldValidate = true
        
        // Act & Assert
        XCTAssertNoThrow(
            try userManager.registerUser(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                age: age
            )
        )
        
        // Verify method calls
        XCTAssertTrue(mockValidator.validateCalled)
    }
    
    func testRegistrationFailureDueToValidationError() {
        // Arrange
        let firstName = "John"
        let lastName = "Doe"
        let email = "john.doe@example.com"
        let password = "weak"
        let age = 25
        
        // Setup validation to throw an error
        mockValidator.shouldValidate = false
        mockValidator.validationError = UserRegistrationError.passwordTooShort
        
        // Act & Assert
        XCTAssertThrowsError(
            try userManager.registerUser(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                age: age
            )
        ) { error in
            XCTAssertTrue(error as? UserRegistrationError == .passwordTooShort)
        }
    }
    
    func testRegistrationFailureDueToRepositorySaveError() {
        // Arrange
        let firstName = "John"
        let lastName = "Doe"
        let email = "john.doe@example.com"
        let password = "StrongPassword123"
        let age = 25
        
        // Setup expectations
        mockValidator.shouldValidate = true
        
        // Act & Assert
        XCTAssertThrowsError(
            try userManager.registerUser(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                age: age
            )
        ) { error in
            // Assuming a generic error is thrown when save fails
            XCTAssertTrue(error is Error)
        }
    }
    
    // MARK: - Authentication Tests
    
    func testSuccessfulAuthentication() {
        // Arrange
        let email = "john.doe@example.com"
        let password = "StrongPassword123"
        let hashedPassword = password.secureHash()
        
        let user = User(
            firstName: "John",
            lastName: "Doe",
            email: email,
            password: hashedPassword,
            age: 25
        )
        
        
        // Act & Assert
        XCTAssertNoThrow(try {
            let result = try userManager.authenticateUser(email: email, password: password)
            XCTAssertTrue(result)
        }())
    }
    
    func testAuthenticationWithNonExistentUser() {
        // Arrange
        let email = "nonexistent@example.com"
        let password = "SomePassword123"
        
    
        // Act & Assert
        XCTAssertThrowsError(
            try userManager.authenticateUser(email: email, password: password)
        ) { error in
            XCTAssertTrue(error as? AuthenticationError == .userNotFound)
        }
    }
    
    func testAuthenticationWithInvalidCredentials() {
        // Arrange
        let email = "john.doe@example.com"
        let correctPassword = "StrongPassword123"
        let incorrectPassword = "WrongPassword456"
        
        let user = User(
            firstName: "John",
            lastName: "Doe",
            email: email,
            password: correctPassword.secureHash(),
            age: 25
        )
        
        // Act & Assert
        XCTAssertNoThrow(try {
            let result = try userManager.authenticateUser(email: email, password: incorrectPassword)
            XCTAssertFalse(result)
        }())
    }
    
    // MARK: - Edge Case Tests
    
    func testRegistrationWithUnicodeCharacters() {
        // Arrange
        let firstName = "José"
        let lastName = "García"
        let email = "jose.garcia@example.com"
        let password = "válidPássword123"
        let age = 30
        
        // Setup expectations
        mockValidator.shouldValidate = true
        
        // Act & Assert
        XCTAssertNoThrow(
            try userManager.registerUser(
                firstName: firstName,
                lastName: lastName,
                email: email,
                password: password,
                age: age
            )
        )
    }
}

// MARK: - Mock Implementations

class MockUserValidationProtocol: UserValidationProtocol {
    var validateCalled = false
    var shouldValidate = true
    var validationError: UserRegistrationError?
    
    func validateRegistration(
        firstName: String,
        lastName: String,
        email: String,
        password: String,
        age: Int
    ) throws {
        validateCalled = true
        
        if !shouldValidate {
            throw validationError ?? UserRegistrationError.emptyFields
        }
    }
}

class MockUserRepositoryProtocol: UserRepository{
    var saveUserCalled = false
    var shouldSaveSucceed = true
    var userToReturn: User?
    
    func saveUser(user: User) throws {
        saveUserCalled = true
        
        if !shouldSaveSucceed {
            throw NSError(domain: "MockUserRepositoryError", code: 0)
        }
    }
    
    func findUser(byEmail email: String) -> User? {
        return userToReturn
    }
}

class MockEmailServiceProtocol: EmailService {
    var sendWelcomeEmailCalled = false
    var shouldSendEmailSucceed = true
    
    func sendWelcomeEmail(to email: String) throws {
        sendWelcomeEmailCalled = true
        
        if !shouldSendEmailSucceed {
            throw NSError(domain: "MockEmailServiceError", code: 0)
        }
    }
}

// Note: You'll need to add an extension to String for secureHash()
extension String {
    func secureHash() -> String {
        // This is a mock implementation. In real code, use a proper hashing method
        return self.data(using: .utf8)?.base64EncodedString() ?? ""
    }
}
