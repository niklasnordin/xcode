//
//  searchTableViewController.m
//  twinstabook
//
//  Created by Niklas Nordin on 2014-02-03.
//  Copyright (c) 2014 Niklas Nordin. All rights reserved.
//

#import "searchTableViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface searchTableViewController ()

@end

@implementation searchTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIImage *)getImageForUserID:(NSString *)userID
{
    UIImage *image = nil;
    NSString *http = @"https://graph.facebook.com";
    NSString *page = [NSString stringWithFormat:@"%@/%@?fields=picture",http,userID];
    NSURL *url = [NSURL URLWithString:page];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"Error getting %@, HTTP status code %ld", url, [responseCode statusCode]);
    }
    
    NSError *jsonError;
    //NSString *svar = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (!jsonError)
    {
        NSDictionary *pictureData = [responseDict objectForKey:@"picture"];
        NSString *urlPicture = [pictureData objectForKey:@"url"];
        NSLog(@"rDict = %@",responseDict);
    }

    return image;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.names count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"aliasNameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    //FBProfilePictureCropping
    
    NSDictionary *dict = [self.names objectAtIndex:indexPath.row];
    NSString *name = [dict objectForKey:@"name"];
    NSString *userID = [dict objectForKey:@"id"];
    NSString *http = @"https://graph.facebook.com";
    NSString *page = [NSString stringWithFormat:@"%@/%@?fields=picture",http,userID];
    NSURL *url = [NSURL URLWithString:page];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200)
    {
        NSLog(@"Error getting %@, HTTP status code %ld", url, [responseCode statusCode]);
    }
    
    NSError *jsonError;
    //NSString *svar = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:oResponseData options:NSJSONReadingMutableContainers error:&jsonError];
    
    if (!jsonError)
    {
        NSDictionary *pictureData = [responseDict objectForKey:@"picture"];
        NSString *urlPicture = [pictureData objectForKey:@"url"];
        NSLog(@"rDict = %@",responseDict);
    }

    cell.textLabel.text = name;
    UIImage *img = [UIImage imageNamed:@"IMG_1414.jpg"];
    NSLog(@"img = %@",img);
    //CIImage *imgRef = [img CIImage];
    //CGSize imageSize = [cell.imageView.image size];
//    UIImage *scaledImage = [UIImage imageWithCIImage:imgRef scale:(CGFloat) orientation:;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    cell.imageView.image = img;
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
