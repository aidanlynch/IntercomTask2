/*
 * @author Andrey Panfilov
 * @description Customer list file reader object
 */

#import <Foundation/Foundation.h>
#import "VMCustomersReadingProtocol.h"

FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileNotSpecified;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileManagerNotFound;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileNotExists;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileIsDirectory;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileNotReadable;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeCannotOpenFile;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileHandleNotFound;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileIsEmpty;
FOUNDATION_EXTERN const NSInteger kVMErrorCodeFileCorrupted;

@interface VMCustomersReader : NSObject<VMCustomersReadingProtocol>

/*!
 * @description FileManager object that supports access to file system
 */
@property (nonatomic, strong) NSFileManager *fileManager;

/*!
 * @description Indicates if reader should fail on invalid Customer record reading or just skip [default = NO]
 */
@property (nonatomic, assign, getter=isStrict) BOOL strict;

@end