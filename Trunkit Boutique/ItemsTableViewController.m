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

@interface ItemsTableViewController ()

@property (strong, nonatomic) UIImageView *navBarHairlineImageView;

@property (strong, nonatomic) MerchandiseItem *itemToPassToDestinationController;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    _navBarHairlineImageView = [self findHairlineImageViewUnder:navigationBar];
    [self setupMockModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (void)setupMockModel
{
    MerchandiseItem *item1 = [[MerchandiseItem alloc] init];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:10] forKey:@"Size-Test-1"];
    
    item1.itemName = @"Onyx-Dyed To Match Thread Super Skinny Ankle";
    item1.styleNumber = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    item1.productPhotos = @[[UIImage imageNamed:@"SampleSkinnyJeansWomen"]].mutableCopy;
    item1.designerName = @"Henry & Belle";
    item1.supplierName = @"Trunkit Boutique";
    item1.fitDescription = @"This is the text for describing how the clothes fit.";
    item1.materialsDescription = @"This is the text for describing the materials.";
    item1.unitPrice = 200.00;
    item1.itemLongDescription = @"This is the text for describing the item.";
    item1.quantityPerSizes = dict;
    
    MerchandiseItem *item2 = [[MerchandiseItem alloc] init];
    item2.itemName = @"Massimo Shirt Pink";
    item2.styleNumber = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    item2.designerName = @"Massimo";
    item2.productPhotos = @[[UIImage imageNamed:@"SamplePinkShirt"]].mutableCopy;
    item2.supplierName = @"Trunkit Boutique";
    item2.fitDescription = @"This is the text for describing how the clothes fit.";
    item2.materialsDescription = @"This is the text for describing the materials.";
    item2.unitPrice = 200.00;
    item2.itemLongDescription = @"This is the text for describing the item.";
    item2.quantityPerSizes = [dict mutableCopy];
    
    self.merchandiseItems = [@[item1, item2] mutableCopy];
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
    NSLog(@"indexpath = %@", indexPath);
    
    static NSString *CellIdentifier = @"ItemReuseIdentifier";
    ItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
	for (NSString* family in [UIFont familyNames])
	{
		if ([family hasPrefix:@"B"])
		{
			NSLog(@"%@", family);
            
			for (NSString* name in [UIFont fontNamesForFamilyName: family])
			{
				NSLog(@"  %@", name);
			}
		}
	}
  
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
    
    
    NSString *string = [NSString stringWithFormat:@"%d", qty];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    float spacing = 1.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [string length])];
    
    [itemQuantityButton setAttributedTitle:attributedString forState:UIControlStateNormal];

    itemImageView.image = theItem.mainProductPhoto;
    itemTitleLabel.text = theItem.title;
    [itemTitleLabel applyThemeAttribute];
    itemSubtitleLabel.text = [NSString stringWithFormat:@"Designed By %@", theItem.designerName];
    
    cell.merchandiseItem = theItem;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(handleItemPhotoTap:)];
    [itemImageView addGestureRecognizer:tap];
    
    //Enable the image to be clicked
    itemImageView.userInteractionEnabled = YES;

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
