/*
 * @author Andrey Panfilov
 * @description Protocol for distance calculation
 */

#import <Foundation/Foundation.h>
#import "VMCoordinates.h"

@protocol VMDistanceCalculatingProtocol <NSObject>

/*!
 * @description Calculates distance between two geo points
 * @param startCoordinates Start geo point for distance calculation
 * @param finishCoordinates Finish geo point for distance calculation
 * @return Distance between to geo points (in meters)
 */
- (double_t)distanceFrom:(VMCoordinates)startCoordinates to:(VMCoordinates)finishCoordinates;

@end