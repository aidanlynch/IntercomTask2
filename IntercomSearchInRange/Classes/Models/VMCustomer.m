#import "VMCustomer.h"

NSString *const kVMCustomerIDKey = @"user_id";
NSString *const kVMCustomerNameKey = @"name";
NSString *const kVMCustomerLatitudeKey = @"latitude";
NSString *const kVMCustomerLongitudeKey = @"longitude";

@implementation VMCustomer

- (instancetype)init {
    if (self = [super init]) {
        self.coordinates = VMCoordinatesUnknown;
    }
    return self;
}

- (instancetype)initWithParameters:(NSDictionary *)parameters {
    if (self = [super init]) {
        [self vm_mergeParameters:parameters];
    }
    return self;
}

- (void)vm_mergeParameters:(NSDictionary *)parameters {
    if (nil == parameters) {
        return;
    }
    self.identifier = [parameters[kVMCustomerIDKey] longLongValue];
    self.name = parameters[kVMCustomerNameKey];
    self.coordinates = VMCoordinatesUnknown;
    NSNumber *latitude = parameters[kVMCustomerLatitudeKey];
    NSNumber *longitude = parameters[kVMCustomerLongitudeKey];
    if ((nil != latitude) && (nil != longitude)) {
        self.coordinates = VMCoordinatesMake([latitude doubleValue], [longitude doubleValue]);
    }
}

- (double_t)latitude {
    return self.coordinates.latitude;
}

- (double_t)longitude {
    return self.coordinates.longitude;
}

- (BOOL)isValid {
    BOOL hasID = (0 != self.identifier);
    BOOL hasName = (nil != self.name);
    BOOL isCoordinatesValid = VMCoordinatesValid(self.coordinates);
    return hasID && hasName && isCoordinatesValid;
}

- (NSUInteger)hash {
    return (NSUInteger)self.identifier;
}

- (BOOL)isEqual:(id)object {
    typeof(self) customerObject = object;
    return [object isKindOfClass:[self class]] &&
            customerObject.identifier == self.identifier &&
            fabs(customerObject.latitude - self.latitude) < DBL_EPSILON &&
            fabs(customerObject.longitude - self.longitude) < DBL_EPSILON &&
            [customerObject.name isEqualToString:self.name];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%lld] %@ (%f, %f)", self.identifier, self.name, self.latitude, self.longitude];
}

- (void)dealloc {
    self.name = nil;
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end