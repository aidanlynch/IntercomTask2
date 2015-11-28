/*
 * @author Andrey Panfilov
 * @description VMCoordinates struct tests
 */

#import <XCTest/XCTest.h>
#import "VMCoordinates.h"

@interface VMCoordinatesTests : XCTestCase

@end

@implementation VMCoordinatesTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCoordinatesCreation {
    // Given
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    // When
    VMCoordinates resultCoordinates = VMCoordinatesMake(latitude, longitude);
    // Then
    XCTAssertEqual(resultCoordinates.latitude, latitude, @"Latitude should be equal to the provided one");
    XCTAssertEqual(resultCoordinates.longitude, longitude, @"Longitude should be equal to the provided one");
}

- (void)testCoordinatesValidity {
    // Given
    double_t latitude = 100.0;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    // When
    BOOL isResultCoordinatesValid = VMCoordinatesValid(coordinates);
    // Then
    XCTAssertTrue(isResultCoordinatesValid, @"Coordinates should be valid");
}

- (void)testCoordinatesInvalidityByLatitude {
    // Given
    double_t latitude = DBL_MAX;
    double_t longitude = 60.0;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    // When
    BOOL isResultCoordinatesValid = VMCoordinatesValid(coordinates);
    // Then
    XCTAssertFalse(isResultCoordinatesValid, @"Coordinates should be invalid");
}

- (void)testCoordinatesInvalidityByLongitude {
    // Given
    double_t latitude = 100.0;
    double_t longitude = DBL_MAX;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    // When
    BOOL isResultCoordinatesValid = VMCoordinatesValid(coordinates);
    // Then
    XCTAssertFalse(isResultCoordinatesValid, @"Coordinates should be invalid");
}

- (void)testCoordinatesInvalidityByBothLatitudeAndLongitude {
    // Given
    double_t latitude = DBL_MAX;
    double_t longitude = DBL_MAX;
    VMCoordinates coordinates = VMCoordinatesMake(latitude, longitude);
    // When
    BOOL isResultCoordinatesValid = VMCoordinatesValid(coordinates);
    // Then
    XCTAssertFalse(isResultCoordinatesValid, @"Coordinates should be invalid");
}


- (void)testUnknownCoordinatesInvalidity {
    // Given
    VMCoordinates coordinates = VMCoordinatesUnknown;
    // When
    BOOL isResultCoordinatesValid = VMCoordinatesValid(coordinates);
    // Then
    XCTAssertFalse(isResultCoordinatesValid, @"Coordinates should be invalid");
}

@end