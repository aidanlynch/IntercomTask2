/*
 * @author Andrey Panfilov
 * @description Model class representing Customer entity
 */

#import <Foundation/Foundation.h>
#import "VMCoordinates.h"

FOUNDATION_EXTERN NSString *const kVMCustomerIDKey;
FOUNDATION_EXTERN NSString *const kVMCustomerNameKey;
FOUNDATION_EXTERN NSString *const kVMCustomerLatitudeKey;
FOUNDATION_EXTERN NSString *const kVMCustomerLongitudeKey;

@interface VMCustomer : NSObject
@property (nonatomic, assign) int64_t identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) VMCoordinates coordinates;
@property (nonatomic, readonly) double_t latitude;
@property (nonatomic, readonly) double_t longitude;
@property (nonatomic, readonly, getter=isValid) BOOL valid;

/*!
 * @description Parametrized init method that instantiates model object with predefined parameters
 * @param parameters Parameters to initialize model object with
 * @return Customer model object
 */
- (instancetype)initWithParameters:(NSDictionary *)parameters;

@end
