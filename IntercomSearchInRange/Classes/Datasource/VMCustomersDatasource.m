#import "VMCustomersDatasource.h"
#import "VMDistanceCalculatingProtocol.h"
#import "VMCustomersReadingProtocol.h"
#import "VMCustomer.h"

@implementation VMCustomersDatasource

- (NSArray<VMCustomer *> *)customersNear:(VMCoordinates)coordinates
                                distance:(double_t)maxDistance
                              sortedWith:(NSComparator)comparator
                                   error:(NSError **)error {
    NSArray<VMCustomer *> *customers = [self.reader readFromFile:self.filePath error:error];
    if (nil == customers) {
        return nil;
    }

    customers = [self vm_filterCustomers:customers near:coordinates distance:maxDistance];
    customers = [self vm_sortCustomers:customers with:comparator];

    return customers;
}

- (NSArray<VMCustomer *> *)vm_filterCustomers:(NSArray<VMCustomer *> *)customers
                                         near:(VMCoordinates)coordinates
                                     distance:(double_t)maxDistance {
    __weak typeof(self) weakSelf = self;
    NSPredicate *distancePredicate = [NSPredicate predicateWithBlock:^BOOL(VMCustomer *customer, NSDictionary *bindings) {
        double_t distanceToCustomer = [weakSelf.distanceCalculator distanceFrom:coordinates to:customer.coordinates];
        return distanceToCustomer < maxDistance;
    }];

    NSArray<VMCustomer *> *filteredCustomers = [customers filteredArrayUsingPredicate:distancePredicate];
    return filteredCustomers;
}

- (NSArray<VMCustomer *> *)vm_sortCustomers:(NSArray<VMCustomer *> *)customers with:(NSComparator)comparator {
    if (!comparator) {
        return customers;
    }
    NSArray<VMCustomer *> *sortedCustomers = [customers sortedArrayUsingComparator:comparator];
    return sortedCustomers;
}

@end