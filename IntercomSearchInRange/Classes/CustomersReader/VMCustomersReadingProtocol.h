/*
 * @author Andrey Panfilov
 * @description Protocol supporting Customer models reading from file
 */

#import <Foundation/Foundation.h>

@class VMCustomer;

@protocol VMCustomersReadingProtocol <NSObject>

/*!
 * @description Retrieves list of Customers from file on specified path or returns error if failed
 * @param filePath Path to Customers list file
 * @param error Error object that will contain error description if read operation've failed
 * @return List of Customer model objects
 */
- (NSArray<VMCustomer *> *)readFromFile:(NSString *)filePath error:(NSError **)error;

@end