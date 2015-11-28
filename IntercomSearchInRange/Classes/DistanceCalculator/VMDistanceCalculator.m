#import "VMDistanceCalculator.h"

static const double_t kVMEarthRadius = 6372797.560856;

static inline double_t vmConvertToRadians(double_t degrees) {
    return degrees * M_PI / 180.0f;
}

@implementation VMDistanceCalculator

- (double_t)distanceFrom:(VMCoordinates)startCoordinates to:(VMCoordinates)finishCoordinates {
    if (!VMCoordinatesValid(startCoordinates) || !VMCoordinatesValid(finishCoordinates)) {
        return DBL_MAX;
    }
    double_t latitudeArc  = vmConvertToRadians(startCoordinates.latitude - finishCoordinates.latitude);
    double_t longitudeArc = vmConvertToRadians(startCoordinates.longitude - finishCoordinates.longitude);
    double_t latitudeComponent = pow(sin(latitudeArc * 0.5), 2);
    double_t longitudeComponent = pow(sin(longitudeArc * 0.5), 2) *
            cos(vmConvertToRadians(startCoordinates.latitude)) *
            cos(vmConvertToRadians(finishCoordinates.latitude));
    double_t distance = fabs(kVMEarthRadius * 2.0 * asin(sqrt(latitudeComponent + longitudeComponent)));
    return distance;
}

@end