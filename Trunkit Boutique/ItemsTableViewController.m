//
//  ItemsTableViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/1/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "ItemsTableViewController.h"
#import "TKEditViewController.h"
#import "UILabel+UILabel_TKExtensions.h"
#import "ALAssetsLibrary+TKSingleton.h"


@interface ItemsTableViewController ()

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;

@property (strong, nonatomic) MerchandiseItem *itemToPassToDestinationController;
@property (strong, nonatomic) NSMutableDictionary *cachedImages;

@end

@implementation ItemsTableViewController

//@synthesize navBarHairlineImageView = _navBarHairlineImageView;

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
    self.cachedImages = [[NSMutableDictionary alloc] init];
    [self reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)reloadData
{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:progressHUD];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.labelText = @"Loading Items..";
    [progressHUD show:YES];

    TrunkitService *service = [[TrunkitService alloc] init];
    [service queryItems:^(BOOL success, NSArray *records, NSError *error){
        dispatch_async(dispatch_get_main_queue(), ^{
            [progressHUD hide:YES];
            self.merchandiseItems = [records mutableCopy];
            [self.tableView reloadData];
        });
    }];
}

- (void)addMerchandiseItem:(MerchandiseItem *)item
{
    [self.merchandiseItems addObject:item];
}


//- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
//{
//    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
//        return (UIImageView *)view;
//    }
//    for (UIView *subview in view.subviews) {
//        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
//        if (imageView) {
//            return imageView;
//        }
//    }
//    return nil;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    _navBarHairlineImageView.hidden = YES;
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    _navBarHairlineImageView.hidden = NO;
//}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.merchandiseItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"indexpath = %@", indexPath);
    
    static NSString *CellIdentifier = @"ItemReuseIdentifier";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
//	for (NSString* family in [UIFont familyNames])
//	{
//		if ([family hasPrefix:@"B"])
//		{
//			NSLog(@"%@", family);
//            
//			for (NSString* name in [UIFont fontNamesForFamilyName: family])
//			{
//				NSLog(@"  %@", name);
//			}
//		}
//	}
  
    UILabel *itemTitleLabel = (UILabel *)[cell.contentView viewWithTag:1001];
    UILabel *itemSubtitleLabel = (UILabel *)[cell.contentView viewWithTag:1002];
    UIButton *itemQuantityButton = (UIButton *)[cell.contentView viewWithTag:3001];
    
    UIFont *boldFont = [UIFont fontWithName:@"BebasNeue" size:18.0];
	UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:16.0];

    itemTitleLabel.font = boldFont;
    itemSubtitleLabel.font = regularFont;

    NSUInteger index = [indexPath indexAtPosition:1];
    MerchandiseItem *theItem = [self.merchandiseItems objectAtIndex:index];
    
    
    UIFont *quantityFont = [UIFont fontWithName:@"BebasNeue" size:19.0];
    itemQuantityButton.titleLabel.font = quantityFont;
    
    itemQuantityButton.contentEdgeInsets = UIEdgeInsetsMake(4.0, 2.0, 0.0, 0.0);
    
    NSInteger qty = 0;
    for (NSString *key in theItem.quantityPerSizes.allKeys)
    {
        qty += [[theItem.quantityPerSizes valueForKey:key] integerValue];
    }
    
    
    NSString *string = [NSString stringWithFormat:@"%ld", (long)qty];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    [itemQuantityButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    itemTitleLabel.text = theItem.title;
    [itemTitleLabel applyThemeAttribute];
    itemSubtitleLabel.text = [NSString stringWithFormat:@"Designed By %@", theItem.designerName];
    
    cell.merchandiseItem = theItem;
    cell.delegate = self;
    cell.productPhotoImageView.image = nil;
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                            (long)indexPath.row];
    
    if ([self.cachedImages objectForKey:identifier] != nil)
    {
        cell.productPhotoImageView.image = [self.cachedImages valueForKey:identifier];
    }
    else
    {
        char const * s = [identifier  UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            TrunkitService *service = [[TrunkitService alloc] init];
            [service queryItemWithId:theItem.itemId
                     completionBlock:^(BOOL success, NSArray *records, NSError *error){
                         if (!success) {
                             NSLog(@"ERROR in item request: %@", error);
                             return;
                         }
                         if (!records.count)
                         {
                             NSLog(@"Request returned no record.");
                         }
                         else
                         {
                             NSDictionary *itemDict = [records firstObject];
                             NSArray *photos = [itemDict objectForKey:@"photos"];
                             for (NSDictionary *aPhoto in photos) {
                                 NSDictionary *URLDict = [aPhoto objectForKey:@"url"];
                                 NSString *photoURLStr = [URLDict objectForKey:@"url"];
                                 NSURL *photoURL = [NSURL URLWithString:photoURLStr];
                                 [theItem.productPhotos addObject:photoURL];
//                                 theItem.productPhotos = [@[photoURL] mutableCopy];
                             }
                             
                             NSURL *url = theItem.mainProductPhoto;
                             if (!url)
                             {
                                 NSLog(@"WARNING: No photo URL found for item %@", theItem);
                             }
                             else
                             {
                                 UIImage *img = nil;
                                 NSData *data = [[NSData alloc] initWithContentsOfURL:url];
                                 img = [[UIImage alloc] initWithData:data];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     if ([tableView indexPathForCell:cell].row == indexPath.row)
                                     {
                                         [self.cachedImages setValue:img forKey:identifier];
                                         cell.productPhotoImageView.image = [self.cachedImages valueForKey:identifier];
                                     }
                                 });
                             }
                         }
                     }];
            
            
//            NSURL *url = nil;
//            
//            if ([theItem.mainProductPhoto isKindOfClass:[NSString class]])
//            {
//                url = [NSURL URLWithString:theItem.mainProductPhoto];
//            }
//            else if ([theItem.mainProductPhoto isKindOfClass:[NSURL class]])
//            {
//                url = theItem.mainProductPhoto;
//            }
//            
//            if (url)
//            {
//                UIImage *img = nil;
//                NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//                img = [[UIImage alloc] initWithData:data];
//                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if ([tableView indexPathForCell:cell].row == indexPath.row)
//                    {
//                        [self.cachedImages setValue:img forKey:identifier];
//                        cell.productPhotoImageView.image = [self.cachedImages valueForKey:identifier];
//                    }
//                });
//            }
//            else
//            {
//                NSLog(@"WARNING: We are executing code that should be soon deprecated. At this point, any product photo is expected to be a NSURL only.");
//                if ([theItem.mainProductPhoto isKindOfClass:[ALAsset class]])
//                {
//                    ALAsset *asset = (ALAsset *)theItem.mainProductPhoto;
//                    UIImage *img = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
//
//                    
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        if ([tableView indexPathForCell:cell].row == indexPath.row)
//                        {
//                            [self.cachedImages setValue:img forKey:identifier];
//                            cell.productPhotoImageView.image = [self.cachedImages valueForKey:identifier];
//                        }
//                    });
//                }
//            }
        });
    
    }

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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[TKEditViewController class]])
    {
        ((TKEditViewController *)vc).merchandiseItem = self.itemToPassToDestinationController;
    }
}

#pragma mark Cell Delegate

- (void)itemTableViewCellCountButtonTapped:(ItemTableViewCell *)cell
{
    MerchandiseItem *item = cell.merchandiseItem;
//    NSLog(@"%s - %@", __PRETTY_FUNCTION__, item);
    self.itemToPassToDestinationController = item;
    [self performSegueWithIdentifier:@"ItemsTableViewToSizingAndQuantitySegueIdentifier" sender:self];
}

- (void)itemTableViewCellProductImageTapped:(ItemTableViewCell *)cell
{
    MerchandiseItem *item = cell.merchandiseItem;
//    NSLog(@"%s - %@", __PRETTY_FUNCTION__, item);
    self.itemToPassToDestinationController = item;
    [self performSegueWithIdentifier:@"ItemsTableViewToItemFullViewSegueIdentifier" sender:self];
}

@end
