//
//  TagTableViewController.h
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 1/12/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagTableViewController : UITableViewController


@property (nonatomic, weak) NSArray *photos;
@property (nonatomic, strong) NSDictionary *photosByTag; // of NSArray of NSDictionary

@end
