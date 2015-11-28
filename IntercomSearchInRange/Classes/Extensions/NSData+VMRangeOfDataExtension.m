#import "NSData+VMRangeOfDataExtension.h"

@implementation NSData (VMRangeOfDataExtension)

- (NSRange)vm_rangeForByteSequence:(NSData *)bytesToSearch {
    const char *sourceBytes = [self bytes];
    NSUInteger sourceLength = [self length];

    const char *sequenceBytes = [bytesToSearch bytes];
    NSUInteger sequenceLength = [bytesToSearch length];

    NSUInteger searchOffset = 0;
    NSRange resultRange = {NSNotFound, searchOffset};

    for (NSUInteger index = 0; index < sourceLength; index++) {
        if (sourceBytes[index] == sequenceBytes[searchOffset]) {
            if (NSNotFound == resultRange.location) {
                resultRange.location = index;
            }
            searchOffset++;
            if (searchOffset >= sequenceLength) {
                return resultRange;
            }
        } else {
            searchOffset = 0;
            resultRange.location = NSNotFound;
        }
    }
    return resultRange;
}

@end