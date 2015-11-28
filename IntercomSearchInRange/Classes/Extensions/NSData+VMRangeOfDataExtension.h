/*
 * @author Andrey Panfilov
 * @description NSData extension that supports bytes sequence inclusion range searching
 */

#import <Foundation/Foundation.h>

@interface NSData (VMRangeOfDataExtension)

/*!
 * @description Scans through NSData bytes to search for bytes sequence
 * @param bytesToSearch Bytes sequence to search for
 * @return Range of found bytes sequence. If location property is equal to NSNotFound then search failed
 */
- (NSRange)vm_rangeForByteSequence:(NSData *)bytesToSearch;

@end