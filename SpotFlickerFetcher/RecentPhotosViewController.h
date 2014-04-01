//
//  RecentPhotosViewController.h
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 1/12/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickPhotoTableViewController.h"


@interface RecentPhotosViewController : FlickPhotoTableViewController

@property (nonatomic,strong) NSArray *recentPhotos;

@end
