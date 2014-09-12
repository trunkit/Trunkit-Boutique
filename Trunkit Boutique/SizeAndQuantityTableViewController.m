//
//  SizeAndQuantityTableViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/5/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "SizeAndQuantityTableViewController.h"
#import "SizeAndQuantityTableViewCell.h"
#import "UILabel+UILabel_TKExtensions.h"

static NSInteger compareSizes (NSString *size1, NSString *size2, void *context)
{
    if (!size1.length || [size1 isEqualToString:@"new size"])
    {
        return NSOrderedDescending;
    }
    
    if (!size2.length || [size2 isEqualToString:@"new size"])
    {
        return NSOrderedAscending;
    }
    
    return [size1 caseInsensitiveCompare:size2];
}

@interface SizeAndQuantityTableViewController ()

@property (strong, nonatomic) NSArray *cachedSortedSizes;
@property (readwrite, nonatomic) BOOL addingSize;

@end

@implementation SizeAndQuantityTableViewController

#pragma mark - Mock Model

//- (void)loadSizes
//{
//    NSDictionary *sizeRecord1 = [NSDictionary dictionaryWithObjects:@[@"TestSize1", [NSNumber numberWithInt:10]]
//                                                            forKeys:@[@"size", @"quantity"]];
//    NSDictionary *sizeRecord2 = [NSDictionary dictionaryWithObjects:@[@"TestSize2", [NSNumber numberWithInt:20]]
//                                                            forKeys:@[@"size", @"quantity"]];
//    self.sizesAndQuantities = [[NSMutableArray alloc] initWithArray:@[sizeRecord1, sizeRecord2]];
//}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _hasMinusButton = YES;
        _addingSize = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self loadSizes];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setMerchandiseItem:(MerchandiseItem *)merchandiseItem
{
    _merchandiseItem = merchandiseItem;
    if (!merchandiseItem.quantityPerSizes)
    {
        merchandiseItem.quantityPerSizes = [[NSMutableDictionary alloc] init];
    }
    
    if (!_merchandiseItem.quantityPerSizes.allKeys.count)
    {
        [self addSizeButtonTapped:nil];
    }
    [self initCachedSortedSizes];
}

- (void)initCachedSortedSizes
{
    self.cachedSortedSizes = [self.merchandiseItem.quantityPerSizes.allKeys sortedArrayUsingFunction:compareSizes context:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cachedSortedSizes.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s - %@ - Postion=%lu - %lu", __PRETTY_FUNCTION__, indexPath, (unsigned long)[indexPath indexAtPosition:1], (unsigned long)self.sizesAndQuantities.count);
    
    NSString *cellId = (_hasMinusButton) ? @"SizeAndQuantityWithMinusCellReusableIdentifier" : @"SizeAndQuantityCellReusableIdentifier";
    SizeAndQuantityTableViewCell *cell = nil;
    if ([indexPath indexAtPosition:1] == self.cachedSortedSizes.count)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"AddSizeAndQuantityCellReusableIdentifier" forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[SizeAndQuantityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AddSizeAndQuantityCellReusableIdentifier"];
        }
        
        UIButton *addSizeButton = (UIButton *)[cell.contentView viewWithTag:2001];
        UIFont *largeFont = [UIFont fontWithName:@"BebasNeue" size:18.0];
        addSizeButton.titleLabel.font = largeFont;
        [addSizeButton.titleLabel applyThemeAttribute];
        [addSizeButton setNeedsLayout];
        
        [addSizeButton addTarget:self action:@selector(addSizeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
        
        if (cell == nil) {
            cell = [[SizeAndQuantityTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        }
        
        UITextField *sizeTextField = (UITextField *)[cell.contentView viewWithTag:1001];
        UITextField *quantityTextField = (UITextField *)[cell.contentView viewWithTag:1002];
        
        [self applyThemeToTextField:sizeTextField];
        [self applyThemeToTextField:quantityTextField];
        
        NSString *key = [self.cachedSortedSizes objectAtIndex:[indexPath indexAtPosition:1]];
        
        NSString *quantity = @"";
        if ([(NSNumber *)[self.merchandiseItem.quantityPerSizes valueForKey:key] integerValue] != 0)
        {
//            quantity = [[self.merchandiseItem.quantityPerSizes valueForKey:key] stringValue];
            quantity = [self.merchandiseItem.quantityPerSizes valueForKey:key];
        }
        sizeTextField.text = ([key isEqualToString:@"new size"]) ? @"" : key;
        quantityTextField.text = quantity;
        
        cell.merchandiseItem = self.merchandiseItem;
        cell.sizeKey = key;
        
        if (_addingSize && [key isEqualToString:@"new size"])
        {
            [cell becomeFirstResponder];
            _addingSize = NO;
        }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Add Size

- (IBAction)addSizeButtonTapped:(id)sender
{
    [self.view endEditing:YES];
    
    [self.merchandiseItem.quantityPerSizes setObject:[NSNumber numberWithInt:0] forKey:@"new size"];
    [self initCachedSortedSizes];
    _addingSize = YES;
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - Theming

//TODO: This is redundant code
- (void)applyThemeToTextField:(UITextField *)textField
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:18.0];
	
	textField.font = regularFont;
	UIView *styleNumberPaddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
	textField.leftView = styleNumberPaddingView;
	textField.leftViewMode = UITextFieldViewModeAlways;
    
    textField.layer.borderWidth = 2.0f;
}


@end
