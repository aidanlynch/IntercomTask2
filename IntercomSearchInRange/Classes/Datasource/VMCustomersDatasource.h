/*
 * @author Andrey Panfilov
 * @description Customer datasource service class
 */

#import <Foundation/Foundation.h>
#import "VMCustomersDatasourceProtocol.h"

@protocol VMDistanceCalculatingProtocol;
@protocol VMCustomersReadingProtocol;

@interface VMCustomersDatasource : NSObject<VMCustomersDatasourceProtocol>

/*!
 * @description Object that provides distance calculation for datasource service
 */
@property (nonatomic, strong) id<VMDistanceCalculatingProtocol> distanceCalculator;

/*!
 * @description Customers list reader object
 */
@property (nonatomic, strong) id<VMCustomersReadingProtocol> reader;

/*!
 * @description Path to file to read customers list from
 */
@property (nonatomic, copy) NSString *filePath;
@end