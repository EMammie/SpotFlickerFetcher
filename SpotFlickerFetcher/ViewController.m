//
//  ViewController.m
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 1/12/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import "ViewController.h"
#import "FlickrFetcher.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"%@", [FlickrFetcher stanfordPhotos]);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
