//
//  FlickerCache.h
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 4/16/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLICKRCACHE_MAXSIZE_IPHONE 1024*1024*3
#define FLICKRCACHE_MAXSIZE_IPAD 1024*1024*10
#define FLICKRCACHE_FOLDER @"flickrPhotos"

@interface FlickerCache : NSObject

+ (NSURL *)cachedURLforURL:(NSURL*)localURL;

+ (void)cacheData:(NSData *)cachedData forURL:(NSURL*)cachedURL;

@end
