#import "VMCoordinates.h"

const VMCoordinates VMCoordinatesUnknown = {DBL_MAX, DBL_MAX};

BOOL VMCoordinatesValid(VMCoordinates coordinates) {
    BOOL isLatitudeValid = fabs(coordinates.latitude - VMCoordinatesUnknown.latitude) > DBL_EPSILON;
    BOOL isLongitudeValid = fabs(coordinates.longitude - VMCoordinatesUnknown.longitude) > DBL_EPSILON;
    return isLatitudeValid && isLongitudeValid;
};

VMCoordinates VMCoordinatesMake(double_t latitude, double_t longitude) {
    VMCoordinates coordinates;
    coordinates.latitude = latitude;
    coordinates.longitude = longitude;
    return coordinates;
}
