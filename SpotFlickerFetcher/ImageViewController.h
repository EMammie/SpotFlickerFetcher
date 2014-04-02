//
//  ImageViewController.h
//  scrollViewDemo
//
//  Created by Eugene Mammie on 3/26/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) NSURL *imageURL;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *titleBarButtonItem;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@property (nonatomic, strong) UIBarButtonItem *splitViewBarButtonItem;


@end
