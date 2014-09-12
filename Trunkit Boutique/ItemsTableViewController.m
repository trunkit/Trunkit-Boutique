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
    [self setupMockModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)setupMockModel
{
    self.merchandiseItems = [@[] mutableCopy];

    NSString *mockFeedFile = [[NSBundle mainBundle] pathForResource:@"MockSuppliedItems" ofType:@"js"];
    NSString *mockItemPhotosFile = [[NSBundle mainBundle] pathForResource:@"MockItemPhotos" ofType:@"js"];
    NSData *feedData = [NSData dataWithContentsOfFile:mockFeedFile];
    NSError *error = nil;
    
    NSArray *feedArray = [NSJSONSerialization JSONObjectWithData:feedData options:NSJSONReadingMutableContainers error:&error];
    if (error)
    {
        NSLog(@"ERROR Serializing feed: %@", error);
    }
    else
    {
        for (NSDictionary *dict in feedArray)
        {
            MerchandiseItem *item = [[MerchandiseItem alloc] init];
            [item mts_setValuesForKeysWithDictionary:dict];
            
            if ([[dict objectForKey:@"id"] longValue] == 95)
            {
                NSData *itemPhotosData = [NSData dataWithContentsOfFile:mockItemPhotosFile];
                error = nil;
                NSArray *itemPhotos = [NSJSONSerialization JSONObjectWithData:itemPhotosData options:NSJSONReadingMutableContainers error:&error];
                
                if (error)
                {
                    NSLog(@"ERROR Serializing item photos: %@", error);
                }
                else
                {
                    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES];
                    itemPhotos = [itemPhotos sortedArrayUsingDescriptors:@[sort]];
                    
                    for (NSDictionary *photoDict in itemPhotos)
                    {
                        NSDictionary *urlDict = [photoDict objectForKey:@"url"];
                        NSString *photoURL = [urlDict objectForKey:@"url"];
                        //                    NSInteger photoPosition = [[urlDict objectForKey:@"position"] integerValue];
                        [item.productPhotos addObject:photoURL];
                    }
                }
            }
            else
            {
                NSArray *mockImages = [self _TEMP_randomPhotos];
                NSUInteger randomIndex1 = arc4random() % [mockImages count];
                NSURL *url1 = [NSURL URLWithString:[mockImages objectAtIndex:randomIndex1]];
                item.productPhotos = [@[url1] mutableCopy];
                NSUInteger randomIndex2 = arc4random() % [mockImages count];
                NSURL *url2 = [NSURL URLWithString:[mockImages objectAtIndex:randomIndex2]];
                [item.productPhotos addObject:url2];
                
            }
            
            [self.merchandiseItems addObject:item];
        }
    }
}

- (NSArray *)_TEMP_randomPhotos
{
    return @[@"http://assets.tobi.com/files/images/377/30827/37578/women/1/800x800.jpg",
             @"http://whatkatewore.com/wp-content/uploads/2011/09/Kate-Hudson-Jeans-Jeanography.jpg",
             @"http://www.eecloth.com/wp-content/uploads/2014/03/07/0/106-Hudson-Jeans-Palerme-Cuff-Knee-Short-for-Women-4.jpg",
             @"https://s3.amazonaws.com/assets.svpply.com/large/2614718.jpg?1402501163",
             @"http://www.stylegag.com/wp-content/uploads/2014/02/2012-women-new-designer-casual-dresses-gentlewomen-a-plus-size-bust-skirt-print-lace-decoration-bohemia.jpg",
             @"http://cache.net-a-porter.com/images/products/35202/35202_fr_xl.jpg",
             @"http://s7d2.scene7.com/is/image/DVF/S890401T14BBLACK?$Demandware%20Large%20Rectangle$",
             @"http://www.maykool.com/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/s/k/skirts-designer-asymmetric-hem-black-skirt-004705.jpg",
             @"http://1.bp.blogspot.com/-pz-VlK1GywY/TfdW5ul-rsI/AAAAAAAAAJg/gWt1i99FOS0/s400/summer_shoes_trehds_2011.jpg",
             @"http://cdn.shopify.com/s/files/1/0115/5332/products/1024_lyon_blue_1024x1024.jpg?v=1398297639",
             @"http://img.alibaba.com/wsphoto/v0/519213392/free-ship-EMS-luxury-trend-nackline-point-shirt-black-white-wedding-groom-shirt-M-L-XL.jpg",
             @"http://blog.youdesignit.com/images/prophecy_opt.jpg",
             @"https://trishsformalaffair.com/wp-content/uploads/2014/07/zagairi-boulevard-of-dreams-mens-long-sleeve-designer-shirt.jpg",
             @"http://i1.tribune.com.pk/wp-content/uploads/2012/08/423410-image-1345213752-109-640x480.JPG",
             @"http://c776239.r39.cf2.rackcdn.com/Gilli-5246-Black-White-1.jpg",
             @"http://cdn.is.bluefly.com/mgen/Bluefly/prodImage.ms?productCode=2070113&width=300&height=300.jpg"];

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
    UIImageView *itemImageView = (UIImageView *)[cell.contentView viewWithTag:2001];
    
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
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleItemPhotoTap:)];
    [itemImageView addGestureRecognizer:tap];
    
    //Enable the image to be clicked
    itemImageView.userInteractionEnabled = YES;
    
    
    
    
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
            NSURL *url = nil;
            
            if ([theItem.mainProductPhoto isKindOfClass:[NSString class]])
            {
                url = [NSURL URLWithString:theItem.mainProductPhoto];
            }
            else if ([theItem.mainProductPhoto isKindOfClass:[NSURL class]])
            {
                url = theItem.mainProductPhoto;
            }
            
            if (url)
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
            else
            {
                NSLog(@"WARNING: We are executing code that should be soon deprecated. At this point, any product photo is expected to be a NSURL only.");
                if ([theItem.mainProductPhoto isKindOfClass:[ALAsset class]])
                {
                    ALAsset *asset = (ALAsset *)theItem.mainProductPhoto;
                    UIImage *img = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];

                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if ([tableView indexPathForCell:cell].row == indexPath.row)
                        {
                            [self.cachedImages setValue:img forKey:identifier];
                            cell.productPhotoImageView.image = [self.cachedImages valueForKey:identifier];
                        }
                    });
                }
            }
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[TKEditViewController class]])
    {
        ((TKEditViewController *)vc).merchandiseItem = self.itemToPassToDestinationController;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)handleItemPhotoTap:(UITapGestureRecognizer *)recognizer
{
    ItemTableViewCell *cell = (ItemTableViewCell*)recognizer.view.superview.superview.superview.superview.superview;
    MerchandiseItem *item = cell.merchandiseItem;
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, item);
    self.itemToPassToDestinationController = item;
    [self performSegueWithIdentifier:@"ItemsTableViewToItemFullViewSegueIdentifier" sender:self];
}

- (IBAction)handleItemCountTap:(id)sender
{
    NSLog(@"%@", (id)((UIButton *)sender).superview.superview.superview.superview.superview);
//    NSLog(@"%@", (id)((UIButton *)sender).superview);
//    NSLog(@"%@", (id)((UIButton *)sender).superview.superview);
//    NSLog(@"%@", (id)((UIButton *)sender).superview.superview.superview);
//    NSLog(@"%@", (id)((UIButton *)sender).superview.superview.superview.superview.superview);
    
    ItemTableViewCell *cell = (id)((UIButton *)sender).superview.superview.superview.superview;
    MerchandiseItem *item = cell.merchandiseItem;
    NSLog(@"%s - %@", __PRETTY_FUNCTION__, item);
    self.itemToPassToDestinationController = item;
    [self performSegueWithIdentifier:@"ItemsTableViewToSizingAndQuantitySegueIdentifier" sender:self];
}

@end
