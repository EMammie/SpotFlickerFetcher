//
//  ImageViewController.m
//  scrollViewDemo
//
//  Created by Eugene Mammie on 3/26/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import "ImageViewController.h"
#import "NetworkActivityIndicator.h"
#import "FlickerCache.h"

@interface ImageViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController


-(UIActivityIndicatorView *)setSpinner
{
    if (!_spinner) {
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _spinner.color = [UIColor blueColor];
        
        [self.view addSubview:_spinner];
        [_spinner setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *variables = NSDictionaryOfVariableBindings(_spinner);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_spinner]-|" options:0 metrics:nil views:variables]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_spinner]-|" options:0 metrics:nil views:variables]];
    }
    return _spinner;
}

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
    
}

-(void)resetImage
{
  
    if (self.scrollView)
    {
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image = nil;
        
        
        if (!self.imageURL) return;
        [self.spinner startAnimating];
        
        NSURL *imageURL = self.imageURL;
        
        NSData *imageData;
        
        NSURL *cachedURL = [FlickerCache cachedURLforURL:imageURL];
        
        if (cachedURL)
        {
             imageData = [[NSData alloc] initWithContentsOfURL:cachedURL];
        }
        else
        {
        dispatch_queue_t queue = dispatch_queue_create("Image Downloadeer", NULL);
        dispatch_async(queue,
            ^{
                [NetworkActivityIndicator start];
                NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
                [NetworkActivityIndicator stop];
            if (imageURL == self.imageURL)
            {
                dispatch_async(dispatch_get_main_queue(),
                ^{
                  UIImage *image = [[UIImage alloc] initWithData:imageData];
                    
            if (image)
            {
                [self.spinner stopAnimating];
                self.scrollView.zoomScale = 1.0;
                self.scrollView.contentSize = image.size;
                self.imageView.image = image;
                self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
                
            }
                   
                });//main queue Dispatch
                 [FlickerCache cacheData:imageData forURL:self.imageURL];
            }
            });
        }
    }
        
}

-(UIImageView *)imageView
{
    if (!_imageView) _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    return _imageView;
}


#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
   
    
    [self.scrollView addSubview:self.imageView];
    self.scrollView.minimumZoomScale= .2;
    self.scrollView.maximumZoomScale =.5;
    
    self.scrollView.delegate = self;
    self.titleBarButtonItem.title = self.title;
    self.splitViewController.delegate = self;
    [self handleSplitViewBarButtonItem:self.splitViewBarButtonItem];
    
    
    
    
    [self resetImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.scrollView.bounds = self.view.bounds;
    [self resetImage];

}

- (void)setZoomScaleToFillScreen
{
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    double wScale = self.scrollView.bounds.size.width / self.imageView.image.size.width;
    double hScale = self.scrollView.bounds.size.height / self.imageView.image.size.height;
    if (wScale > hScale) self.scrollView.zoomScale = wScale;
    else self.scrollView.zoomScale = hScale;
    [self setZoomScaleToFillScreen];
}

#pragma mark - SplitViewController Delegate methods

- (void)splitViewController:(UISplitViewController *)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.splitViewBarButtonItem = nil;
}

- (void)splitViewController:(UISplitViewController *)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)pc
{
    UIBarButtonItem *button = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                               target:barButtonItem.target
                               action:barButtonItem.action];
    barButtonItem = button;
    self.splitViewBarButtonItem = barButtonItem;
}

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (_splitViewBarButtonItem != splitViewBarButtonItem) {
        [self handleSplitViewBarButtonItem:splitViewBarButtonItem];
    }
}

- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) {
        [toolbarItems removeObject:_splitViewBarButtonItem];
    }
    if (splitViewBarButtonItem) {
        [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    }
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}


@end
