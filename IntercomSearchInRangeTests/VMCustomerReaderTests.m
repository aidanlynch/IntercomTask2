/*
 * @author Andrey Panfilov
 * @description VMCustomersReader class tests
 */

#import <XCTest/XCTest.h>
#import "VMCustomersReader.h"

@interface VMCustomerReaderTests : XCTestCase
@property (nonatomic, strong) VMCustomersReader *reader;
@property (nonatomic, strong) NSBundle *mainBundle;
@end

@implementation VMCustomerReaderTests

- (void)setUp {
    [super setUp];
    VMCustomersReader *reader = [[VMCustomersReader alloc] init];
    reader.fileManager = [NSFileManager defaultManager];
    reader.strict = YES;
    self.reader = reader;

    self.mainBundle = [NSBundle bundleForClass:[self class]];
}

- (void)tearDown {
    self.reader = nil;
    self.mainBundle = nil;
    [super tearDown];
}

- (void)testValidCustomersListReading {
    // Given
    NSString *filePath = [self.mainBundle pathForResource:@"customersValid" ofType:@"json"];
    NSError *error = nil;
    NSUInteger customersCount = 32;
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNotNil(resultCustomers, @"Customers list shouldn't be nil");
    XCTAssertNil(error, @"There shouldn't be any error");
    XCTAssertEqual([resultCustomers count], customersCount, @"Customers count should be equal to expected");
}

- (void)testCustomersListReadingWithoutFileManager {
    // Given
    self.reader.fileManager = nil;
    NSString *filePath = [self.mainBundle pathForResource:@"customersValid" ofType:@"json"];
    NSError *error = nil;
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileManagerNotFound, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromNotSpecifiedFile {
    // Given
    NSError *error = nil;
    // When
    NSArray *resultCustomers = [self.reader readFromFile:nil error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileNotSpecified, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromNonExistingFile {
    // Given
    NSString *filePath = @"/some/fake/path/customersValid.json";
    NSError *error = nil;
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileNotExists, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromFolder {
    // Given
    NSError *error = nil;
    NSString *filePath = [[self.mainBundle pathForResource:@"customersValid" ofType:@"json"] stringByDeletingLastPathComponent];
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileIsDirectory, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromEmptyFile {
    // Given
    NSError *error = nil;
    NSString *filePath = [self.mainBundle pathForResource:@"customersEmpty" ofType:@"json"];
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileIsEmpty, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromCorruptedFileInStrictMode {
    // Given
    self.reader.strict = YES;
    NSError *error = nil;
    NSString *filePath = [self.mainBundle pathForResource:@"customersInvalidJSON" ofType:@"json"];
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileCorrupted, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromCorruptedFileInNonStrictMode {
    // Given
    self.reader.strict = NO;
    NSError *error = nil;
    NSString *filePath = [self.mainBundle pathForResource:@"customersInvalidJSON" ofType:@"json"];
    NSUInteger customersCount = 27;
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNotNil(resultCustomers, @"Customers list shouldn't be nil");
    XCTAssertNil(error, @"There shouldn't be any error");
    XCTAssertEqual([resultCustomers count], customersCount, @"Customers count should be equal to expected");
}

- (void)testCustomersListReadingFromNotFullyValidFileInStrictMode {
    // Given
    self.reader.strict = YES;
    NSError *error = nil;
    NSString *filePath = [self.mainBundle pathForResource:@"customersInvalidFormat" ofType:@"json"];
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNil(resultCustomers, @"Customers list should be nil");
    XCTAssertNotNil(error, @"There should be error");
    XCTAssertEqual(error.code, kVMErrorCodeFileCorrupted, @"Error should have proper error code.");
}

- (void)testCustomersListReadingFromNotFullyValidFileInNonStrictMode {
    // Given
    self.reader.strict = NO;
    NSError *error = nil;
    NSString *filePath = [self.mainBundle pathForResource:@"customersInvalidFormat" ofType:@"json"];
    NSUInteger customersCount = 27;
    // When
    NSArray *resultCustomers = [self.reader readFromFile:filePath error:&error];
    // Then
    XCTAssertNotNil(resultCustomers, @"Customers list shouldn't be nil");
    XCTAssertNil(error, @"There shouldn't be any error");
    XCTAssertEqual([resultCustomers count], customersCount, @"Customers count should be equal to expected");
}

@end
