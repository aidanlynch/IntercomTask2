#import "AppDelegate.h"
#import "VMCustomersDatasource.h"
#import "VMDistanceCalculator.h"
#import "VMCustomersReader.h"
#import "VMCustomer.h"
#import "VMMeasureHelpers.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    VMCustomersDatasource *datasource = [[VMCustomersDatasource alloc] init];

    VMDistanceCalculator *distanceCalculator = [[VMDistanceCalculator alloc] init];
    datasource.distanceCalculator = distanceCalculator;

    VMCustomersReader *customersReader = [VMCustomersReader new];
    customersReader.fileManager = [NSFileManager defaultManager];
    customersReader.strict = NO;
    datasource.reader = customersReader;

    NSString *customersFilePath = [[NSBundle mainBundle] pathForResource:@"customers" ofType:@"json"];
    datasource.filePath = customersFilePath;

    VMCoordinates dublinOfficeCoordinates = VMCoordinatesMake(53.3381985, -6.2592576);
    double_t distanceThreshold = KM_TO_METERS(100.0);
    NSComparator customersSorting = ^NSComparisonResult(VMCustomer *left, VMCustomer *right) {
        if (left.identifier > right.identifier) {
            return NSOrderedDescending;
        } else if (left.identifier == right.identifier) {
            return NSOrderedSame;
        }
        return NSOrderedAscending;
    };

    NSError *error = nil;
    NSArray<VMCustomer *> *customers = [datasource customersNear:dublinOfficeCoordinates
                                                        distance:distanceThreshold
                                                      sortedWith:customersSorting
                                                           error:&error
    ];

    if (nil != customers) {
        for (VMCustomer *customer in customers) {
            double_t distance = [distanceCalculator distanceFrom:dublinOfficeCoordinates to:customer.coordinates];
            NSLog(@"%@ | Distance: %.2fkm", customer, METERS_TO_KM(distance));
        }
    } else {
        NSLog(@"Error happened: [%ld] %@", error.code, error.localizedDescription);
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

@end
