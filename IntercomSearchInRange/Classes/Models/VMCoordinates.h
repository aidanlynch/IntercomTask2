/*
 * @author Andrey Panfilov
 * @description Structure representing coordinates
 */

#import <Foundation/Foundation.h>

struct VMCoordinates {
    double_t latitude;
    double_t longitude;
};

typedef struct VMCoordinates VMCoordinates;

FOUNDATION_EXTERN const VMCoordinates VMCoordinatesUnknown;

BOOL VMCoordinatesValid(VMCoordinates coordinates);

VMCoordinates VMCoordinatesMake(double_t latitude, double_t longitude);
