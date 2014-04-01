//
//  RecentPhotos.m
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 4/1/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import "RecentPhotos.h"

@implementation RecentPhotos


#define RECENT_FLICKR_PHOTOS_KEY @"RecentWatchedPhotos_Key"
+ (NSArray *)allPhotos
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:RECENT_FLICKR_PHOTOS_KEY];
}


+ (void) addPhoto:(NSDictionary *)photo
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *recents = [[defaults objectForKey:RECENT_FLICKR_PHOTOS_KEY] mutableCopy];
    if (!recents) recents = [NSMutableArray array];
    NSUInteger key = [recents indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [photo[FLICKR_PHOTO_ID]
                isEqualToString:obj[FLICKR_PHOTO_ID]];
    }];
    if (key != NSNotFound) [recents removeObjectAtIndex:key];
    [recents insertObject:photo atIndex:0];
    while ([recents count] > RECENT_FLICKR_PHOTOS_NUMBER) {
        [recents removeLastObject];
    }
    [defaults setObject:recents forKey:RECENT_FLICKR_PHOTOS_KEY];
    [defaults synchronize];
}
}


@end
