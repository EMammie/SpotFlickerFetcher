//
//  RecentPhotos.h
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 4/1/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecentPhotos : NSObject

+ (NSArray *)allPhotos;
+ (void) addPhoto:(NSDictionary *)photo;

@end
