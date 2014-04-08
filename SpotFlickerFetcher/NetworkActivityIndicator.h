//
//  NetworkActivityIndicator.h
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 4/8/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivityIndicator : NSObject

//Public API
+(void)start;//starts a Network Activity Indicator in the status bar
+(void)stop;//stops a Network Activity Indicator in the status bar


@end
