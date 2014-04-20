//
//  FlickerCache.m
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 4/16/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import "FlickerCache.h"

@interface FlickerCache()


@property (nonatomic, strong) NSURL *cacheFolder;
@property (nonatomic, strong) NSFileManager *fileManager;

@end


@implementation FlickerCache




#pragma mark - Properties Inits

- (NSFileManager *)fileManager
{
    if (!_fileManager) {
        _fileManager = [[NSFileManager alloc] init];
    }
    return _fileManager;
}

- (NSURL *)cacheFolder
{
    if (!_cacheFolder) {
        _cacheFolder = [[[self.fileManager URLsForDirectory:NSCachesDirectory
                                                  inDomains:NSUserDomainMask] lastObject]
                        URLByAppendingPathComponent:FLICKRCACHE_FOLDER
                        isDirectory:YES];
        BOOL isDir = NO;
        if (![self.fileManager fileExistsAtPath:[_cacheFolder path]
                                    isDirectory:&isDir]) {
            [self.fileManager createDirectoryAtURL:_cacheFolder
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:nil];
        }
    }
    return _cacheFolder;
}

+ (NSURL *)cachedURLforURL:(NSURL*)url
{
    
    FlickerCache *cache = [[FlickerCache alloc] init];
    NSURL *cachedUrl = [cache getCachedURLforURL:url];
    if ([cache fileExistsAtURL:cachedUrl]) {
        return cachedUrl;
    }
    return nil;
}

+ (void)cacheData:(NSData *)data forURL:(NSURL*)url
{
    if (!data) return;
    FlickerCache *cache = [[FlickerCache alloc] init];
    NSURL *cachedUrl = [cache getCachedURLforURL:url];
    if ([cache fileExistsAtURL:cachedUrl]) {
        [cache.fileManager setAttributes:@{NSFileModificationDate:[NSDate date]}
                            ofItemAtPath:[cachedUrl path] error:nil];
    } else {
        [cache.fileManager createFileAtPath:[cachedUrl path]
                                   contents:data attributes:nil];
        [cache cleanupOldFiles];
    }

    
}

- (NSURL *)getCachedURLforURL:(NSURL *)url
{
    return [self.cacheFolder URLByAppendingPathComponent:
            [[url path] lastPathComponent]];
}

- (void)cleanupOldFiles
{
    NSDirectoryEnumerator *dirEnumerator =
    [self.fileManager enumeratorAtURL:self.cacheFolder
           includingPropertiesForKeys:@[NSURLAttributeModificationDateKey]
                              options:NSDirectoryEnumerationSkipsHiddenFiles
                         errorHandler:nil];
    NSNumber *fileSize;
    NSDate *fileDate;
    NSMutableArray *files = [NSMutableArray array];
    __block NSUInteger dirSize = 0;
    for (NSURL *url in dirEnumerator) {
        [url getResourceValue:&fileSize forKey:NSURLFileSizeKey error:nil];
        [url getResourceValue:&fileDate forKey:NSURLAttributeModificationDateKey error:nil];
        dirSize += [fileSize integerValue];
        [files addObject:@{@"url":url, @"size":fileSize, @"date":fileDate}];
    }
    int maxCacheSize = FLICKRCACHE_MAXSIZE_IPHONE;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        maxCacheSize = FLICKRCACHE_MAXSIZE_IPAD;
    }
    if (dirSize > maxCacheSize) {
        NSArray *sorted = [files sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            return [obj1[@"date"] compare:obj2[@"date"]];
        }];
        [sorted enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            dirSize -= [obj[@"size"] integerValue];
            NSError *error;
            [self.fileManager removeItemAtURL:obj[@"url"] error:&error];
            *stop = error || (dirSize < maxCacheSize);
        }];
    }
}

#pragma mark - Conveinience Method
- (BOOL)fileExistsAtURL:(NSURL *)url
{
    return [self.fileManager fileExistsAtPath:[url path]];
}




@end
