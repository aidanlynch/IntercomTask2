/*
 * @author Andrey Panfilov
 * @description VMDistanceCalculator class tests
 */

#import <XCTest/XCTest.h>
#import "VMDistanceCalculator.h"

@interface VMDistanceCalculatorTests : XCTestCase
@property (nonatomic, strong) id<VMDistanceCalculatingProtocol> calculator;
@end

@implementation VMDistanceCalculatorTests

- (void)setUp {
    [super setUp];
    self.calculator = [[VMDistanceCalculator alloc] init];
}

- (void)tearDown {
    self.calculator = nil;
    [super tearDown];
}

- (void)testDistanceCalculatorResultValidity {
    // Given
    VMCoordinates coordinatesFrom = VMCoordinatesMake(53.245102, -6.238335);
    VMCoordinates coordinatesTo = VMCoordinatesMake(53.3381985, -6.2592576);
    double_t distance = 10447.0;
    // When
    double_t resultDistance = floor([self.calculator distanceFrom:coordinatesFrom to:coordinatesTo]);
    // Then
    XCTAssertEqual(resultDistance, distance, @"Calculated distance should be equal to expected one");
}

- (void)testDistanceCalculatorResultInvariativity {
    // Given
    VMCoordinates coordinatesFrom = VMCoordinatesMake(53.245102, -6.238335);
    VMCoordinates coordinatesTo = VMCoordinatesMake(53.3381985, -6.2592576);
    // When
    double_t resultDistance = [self.calculator distanceFrom:coordinatesFrom to:coordinatesTo];
    double_t resultInvariantDistance = [self.calculator distanceFrom:coordinatesTo to:coordinatesFrom];
    // Then
    XCTAssertEqual(resultDistance, resultInvariantDistance, @"Calculated distance should not depend on coordinates order");
}

- (void)testDistanceCalculatorResultInvalidityWithUnknownStartCoordinate {
    // Given
    VMCoordinates coordinatesFrom = VMCoordinatesUnknown;
    VMCoordinates coordinatesTo = VMCoordinatesMake(53.3381985, -6.2592576);
    double_t distance = DBL_MAX;
    // When
    double_t resultDistance = [self.calculator distanceFrom:coordinatesFrom to:coordinatesTo];
    // Then
    XCTAssertEqual(resultDistance, distance, @"Calculated distance should be invalid");
}

- (void)testDistanceCalculatorResultInvalidityWithUnknownEndCoordinate {
    // Given
    VMCoordinates coordinatesFrom = VMCoordinatesMake(53.245102, -6.238335);
    VMCoordinates coordinatesTo = VMCoordinatesUnknown;
    double_t distance = DBL_MAX;
    // When
    double_t resultDistance = [self.calculator distanceFrom:coordinatesFrom to:coordinatesTo];
    // Then
    XCTAssertEqual(resultDistance, distance, @"Calculated distance should be invalid");
}

@end
