/*
 * @author Andrey Panfilov
 * @description Protocol supporting Customer datasource service
 */

#import <Foundation/Foundation.h>
#import "VMCoordinates.h"

@class VMCustomer;

@protocol VMCustomersDatasourceProtocol <NSObject>

/*!
 * @description Retrieves list of Customers near specified coordinates
 * @param coordinates Coordinates to select closest customers with
 * @param maxDistance Maximum distance to customer, in meters
 * @param comparator Comparator to sort customers with
 * @param error Error object that will contain error description if service fails
 * @return List of Customer model objects
 */
- (NSArray<VMCustomer *> *)customersNear:(VMCoordinates)coordinates
                                distance:(double_t)maxDistance
                              sortedWith:(NSComparator)comparator
                                   error:(NSError **)error;

@end