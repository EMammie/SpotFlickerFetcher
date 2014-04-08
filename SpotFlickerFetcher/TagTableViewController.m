//
//  TagTableViewController.m
//  SpotFlickerFetcher
//
//  Created by Eugene Mammie on 1/12/14.
//  Copyright (c) 2014 Eugene Mammie. All rights reserved.
//

#import "TagTableViewController.h"
#import "FlickrFetcher.h"
//#import "RecentPhotos.h"

@interface TagTableViewController ()

@end

@implementation TagTableViewController

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    [self updatePhotosByTag];
    [self.tableView reloadData];
}

- (void)updatePhotosByTag
{
    NSMutableDictionary *photosByTag = [NSMutableDictionary dictionary];
    for (NSDictionary *photo in self.photos)
    {
        for (NSString *tag in [photo[FLICKR_TAGS] componentsSeparatedByString:@" "])
        {
            if ([tag isEqualToString:@"cs193pspot"]) continue;
            if ([tag isEqualToString:@"portrait"]) continue;
            if ([tag isEqualToString:@"landscape"]) continue;
            NSMutableArray *photos = [photosByTag objectForKey:tag];
            if (!photos) {
                photos = [NSMutableArray array];
                photosByTag[tag] = photos;
            }
            [photos addObject:photo];
        }
    }
    self.photosByTag = photosByTag;
}

#pragma mark - View Lifecycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    dispatch_queue_t queue = dispatch_queue_create("Image Downloader", NULL);
    
    dispatch_async(queue, ^{
    
        NSArray *photos = [FlickrFetcher stanfordPhotos];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.photos = photos;
            
            }
        );
        }
    );
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;


}

#pragma mark - Table view data source

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
   return [self.photosByTag count];
}

- (NSString *)tagForRow:(NSUInteger)row
{
    return [[self.photosByTag allKeys] objectAtIndex:row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Tag Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    NSString *tag = [[self.photosByTag allKeys] objectAtIndex:indexPath.row];
    NSUInteger photoCount = [self.photosByTag[tag] count];
    cell.textLabel.text = [tag capitalizedString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu photo%@", (unsigned long)photoCount, photoCount > 1 ? @"s" : @""];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath)
        {
            if ([segue.identifier isEqualToString:@"Show Photos"])
            {
                if ([segue.destinationViewController respondsToSelector:@selector(setPhotos:)])
                {
                    //[RecentPhotos addPhoto:self.photos[indexPath.row]];
                    NSString *tag = [self tagForRow:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setPhotos:)
                                                          withObject:self.photosByTag[tag]];
                    [segue.destinationViewController setTitle:[tag capitalizedString]];
                    
                }
            }
        }
    }
}



@end
