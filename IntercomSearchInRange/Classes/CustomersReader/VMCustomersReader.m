//
// Created by uncured on 28.11.15.
// Copyright (c) 2015 VisualMyth. All rights reserved.
//

#import "VMCustomersReader.h"
#import "NSData+VMRangeOfDataExtension.h"
#import "VMCustomer.h"

const NSInteger kVMErrorCodeFileNotSpecified = 1000;
const NSInteger kVMErrorCodeFileManagerNotFound = 1001;
const NSInteger kVMErrorCodeFileNotExists = 1002;
const NSInteger kVMErrorCodeFileIsDirectory = 1003;
const NSInteger kVMErrorCodeFileNotReadable = 1004;
const NSInteger kVMErrorCodeCannotOpenFile = 1005;
const NSInteger kVMErrorCodeFileHandleNotFound = 1006;
const NSInteger kVMErrorCodeFileIsEmpty = 1007;
const NSInteger kVMErrorCodeFileCorrupted = 1008;
static NSString *const kLineDelimiter = @"\n";
static const NSUInteger kReadChunkSize = 128;

@implementation VMCustomersReader

- (NSArray<VMCustomer *> *)readFromFile:(NSString *)filePath error:(NSError **)error {
    if (nil == self.fileManager) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileManagerNotFound message:@"FileManager not specified"];
        }
        return nil;
    }

    if (![self vm_checkFileStateAtPath:filePath error:error]) {
        return nil;
    }

    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:filePath];
    if (nil == fileHandle) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeCannotOpenFile message:@"Can't open file at specified path"];
        }
        return nil;
    }

    NSArray<VMCustomer *> *customers = [self vm_readCustomersFromFileHandle:fileHandle error:error];
    [fileHandle closeFile];

    return customers;
}

- (BOOL)vm_checkFileStateAtPath:(NSString *)filePath error:(NSError **)error {
    if (nil == filePath) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileNotSpecified message:@"File not specified"];
        }
        return NO;
    }

    BOOL isDirectory = NO;
    BOOL fileExists = [self.fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (!fileExists) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileNotExists message:@"File not exists at specified path"];
        }
        return NO;
    }

    if (isDirectory) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileIsDirectory message:@"Directory found at specified path"];
        }
        return NO;
    }

    BOOL isFileReadable = [self.fileManager isReadableFileAtPath:filePath];
    if (!isFileReadable) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileNotReadable message:@"File not readable at specified path"];
        }
        return NO;
    }

    return YES;
}

- (NSError *)vm_errorWithCode:(NSInteger)code message:(NSString *)message {
    NSDictionary *userInfo = nil;
    if (nil != message) {
        userInfo = @{
                NSLocalizedDescriptionKey : message
        };
    }
    return [NSError errorWithDomain:NSStringFromClass([self class])
                               code:code
                           userInfo:userInfo];
}

- (NSArray<VMCustomer *> *)vm_readCustomersFromFileHandle:(NSFileHandle *)fileHandle error:(NSError **)error {
    if (nil == fileHandle) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileHandleNotFound message:@"FileHandle not specified"];
        }
        return nil;
    }

    [fileHandle seekToEndOfFile];
    uint64_t fileLength = [fileHandle offsetInFile];

    if (0 == fileLength) {
        if (error) {
            *error = [self vm_errorWithCode:kVMErrorCodeFileIsEmpty message:@"File is empty"];
        }
        return nil;
    }

    NSMutableArray<VMCustomer *> *customers = [NSMutableArray array];
    NSData *lineDelimiterSequence = [kLineDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    uint64_t currentFileOffset = 0;

    while (currentFileOffset < fileLength) {
        NSData *lineData = [self readLineFrom:fileHandle
                            withLineDelimiter:lineDelimiterSequence
                                   fileLength:fileLength
                                       offset:&currentFileOffset];

        VMCustomer *customer = [self vm_readCustomerDataFrom:lineData];
        if (self.isStrict && !customer.isValid) {
            if (error) {
                *error = [self vm_errorWithCode:kVMErrorCodeFileCorrupted message:@"Can't read valid record"];
            }
            return nil;
        }

        if (nil != customer && customer.isValid) {
            [customers addObject:customer];
        }
    }

#if __has_feature(objc_arc)
    return [customers copy];
#else
    return [[customers copy] autorelease];
#endif
}

- (VMCustomer *)vm_readCustomerDataFrom:(NSData *)customerData {
    if (!customerData) {
        return nil;
    }
    VMCustomer *customer = nil;
    NSError *jsonError = nil;
    id json = [NSJSONSerialization JSONObjectWithData:customerData options:0 error:&jsonError];
    if (json && [json isKindOfClass:[NSDictionary class]] && (nil == jsonError)) {
        customer = [[VMCustomer alloc] initWithParameters:json];
    }
#if __has_feature(objc_arc)
    return customer;
#else
    return [customer autorelease];
#endif
}


- (NSData *)readLineFrom:(NSFileHandle *)fileHandle
       withLineDelimiter:(NSData *)lineDelimiter
              fileLength:(uint64_t)fileLength
                  offset:(uint64_t *)offset {
    if (!offset) {
        return nil;
    }

    NSMutableData *lineData = [[NSMutableData alloc] init];
    BOOL isLineDataIncomplete = YES;
    uint64_t currentOffset = *offset;

    [fileHandle seekToFileOffset:currentOffset];

    while (isLineDataIncomplete) {
        if (currentOffset >= fileLength) {
            break;
        }
        NSData *chunk = [fileHandle readDataOfLength:kReadChunkSize];
        NSRange lineDelimiterRange = [chunk vm_rangeForByteSequence:lineDelimiter];
        if (NSNotFound != lineDelimiterRange.location) {
            NSUInteger chuckLength = lineDelimiterRange.location + lineDelimiter.length;
            chunk = [chunk subdataWithRange:NSMakeRange(0, chuckLength)];
            isLineDataIncomplete = NO;
        }
        [lineData appendData:chunk];
        currentOffset += chunk.length;
    }

    *offset = currentOffset;

#if __has_feature(objc_arc)
    return lineData;
#else
    return [lineData autorelease];
#endif
}

@end