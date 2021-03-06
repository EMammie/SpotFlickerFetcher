//
//  RecentPhotoTableViewController.m
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 4/1/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import "RecentPhotoTableViewController.h"
#import "RecentPhotos.h"


@interface RecentPhotoTableViewController ()

@end

@implementation RecentPhotoTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.photos = [RecentPhotos allPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
