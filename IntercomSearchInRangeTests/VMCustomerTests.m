/*
 * @author Andrey Panfilov
 * @description VMCustomer class tests
 */

#import <XCTest/XCTest.h>
#import "VMCustomer.h"

@interface VMCustomerTests : XCTestCase

@end

@implementation VMCustomerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCustomerCreation {
    // Given
    int64_t identifier = 1200;
    NSString *name = @"John Appleseed";
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    // When
    VMCustomer *resultCustomer = [[VMCustomer alloc] init];
    resultCustomer.identifier = identifier;
    resultCustomer.name = name;
    resultCustomer.coordinates = coordinates;
    // Then
    XCTAssertNotNil(resultCustomer, @"Customer shouldn't be nil");
    XCTAssertEqual(resultCustomer.identifier, identifier, @"Customer ID should be equal to the provided one");
    XCTAssertEqualObjects(resultCustomer.name, name, @"Customer Name should be equal to the provided one");
    XCTAssertEqual(resultCustomer.latitude, latitude, @"Customer latitude should be equal to the provided one");
    XCTAssertEqual(resultCustomer.longitude, longitude, @"Customer longitude should be equal to the provided one");
}

- (void)testCustomerCreationByCustomInitializer {
    // Given
    int64_t identifier = 1200;
    NSString *name = @"John Appleseed";
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    NSDictionary *initParameters = @{
            kVMCustomerIDKey : @(identifier),
            kVMCustomerNameKey : name,
            kVMCustomerLatitudeKey : @(latitude),
            kVMCustomerLongitudeKey : @(longitude)
    };
    // When
    VMCustomer *resultCustomer = [[VMCustomer alloc] initWithParameters:initParameters];
    // Then
    XCTAssertNotNil(resultCustomer, @"Customer shouldn't be nil");
    XCTAssertEqual(resultCustomer.identifier, identifier, @"Customer ID should be equal to the provided one");
    XCTAssertEqualObjects(resultCustomer.name, name, @"Customer Name should be equal to the provided one");
    XCTAssertEqual(resultCustomer.latitude, latitude, @"Customer latitude should be equal to the provided one");
    XCTAssertEqual(resultCustomer.longitude, longitude, @"Customer longitude should be equal to the provided one");
}

- (void)testCustomerValidity {
    // Given
    int64_t identifier = 1200;
    NSString *name = @"John Appleseed";
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    VMCustomer *resultCustomer = [[VMCustomer alloc] init];
    resultCustomer.identifier = identifier;
    resultCustomer.name = name;
    resultCustomer.coordinates = coordinates;
    // When
    BOOL isCustomerValid = resultCustomer.isValid;
    // Then
    XCTAssertTrue(isCustomerValid, @"Customer should be valid");
}

- (void)testCustomerInvalidityById {
    // Given
    NSString *name = @"John Appleseed";
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    VMCustomer *resultCustomer = [[VMCustomer alloc] init];
    resultCustomer.name = name;
    resultCustomer.coordinates = coordinates;
    // When
    BOOL isCustomerValid = resultCustomer.isValid;
    // Then
    XCTAssertFalse(isCustomerValid, @"Customer shouldn't be valid without an ID");
}

- (void)testCustomerInvalidityByName {
    // Given
    int64_t identifier = 1200;
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    VMCustomer *resultCustomer = [[VMCustomer alloc] init];
    resultCustomer.identifier = identifier;
    resultCustomer.coordinates = coordinates;
    // When
    BOOL isCustomerValid = resultCustomer.isValid;
    // Then
    XCTAssertFalse(isCustomerValid, @"Customer shouldn't be valid without a name");
}

- (void)testCustomerInvalidityByCoordinates {
    // Given
    int64_t identifier = 1200;
    NSString *name = @"John Appleseed";
    double_t latitude = DBL_MAX;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    VMCustomer *resultCustomer = [[VMCustomer alloc] init];
    resultCustomer.identifier = identifier;
    resultCustomer.name = name;
    resultCustomer.coordinates = coordinates;
    // When
    BOOL isCustomerValid = resultCustomer.isValid;
    // Then
    XCTAssertFalse(isCustomerValid, @"Customer shouldn't be valid with invalid coordinates");
}

- (void)testCustomerInvalidityByCoordinatesUnknown {
    // Given
    int64_t identifier = 1200;
    NSString *name = @"John Appleseed";
    VMCoordinates coordinates = VMCoordinatesUnknown;
    VMCustomer *resultCustomer = [[VMCustomer alloc] init];
    resultCustomer.identifier = identifier;
    resultCustomer.name = name;
    resultCustomer.coordinates = coordinates;
    // When
    BOOL isCustomerValid = resultCustomer.isValid;
    // Then
    XCTAssertFalse(isCustomerValid, @"Customer shouldn't be valid with unknown coordinates");
}

@end
