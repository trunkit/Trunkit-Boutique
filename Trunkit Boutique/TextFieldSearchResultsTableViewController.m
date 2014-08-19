//
//  TextFieldSearchResultsTableViewController.m
//  Trunkit Boutique
//
//  Created by Frank Le Grand on 7/7/14.
//  Copyright (c) 2014 Trunkit. All rights reserved.
//

#import "TextFieldSearchResultsTableViewController.h"

@interface TextFieldSearchResultsTableViewController ()

@end

@implementation TextFieldSearchResultsTableViewController

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
    [self setupMockModel];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setupMockModel
{
    NSString *referenceType = nil;
    switch (self.referenceValueType) {
        case TKReferenceValueBrandType:
            referenceType = @"Brand";
            break;
        case TKReferenceValueCategoryType:
            referenceType = @"Category";
            break;
        case TKReferenceValueSubCategoryType:
            referenceType = @"SubCategory";
            break;
            
        default:
            break;
    }
    NSMutableArray *mockArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 100; i++) {
        NSString *aMatch = [NSString stringWithFormat:@"%@ test #%lu", referenceType, (long)i];
        [mockArray addObject:aMatch];
    }
    self.matches = mockArray;
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
    return self.matches.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"\nself = %@\n, delegate = %@", self, self.tableView.delegate);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldSearchResultCellReusableIdentifier"
                                                            forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TextFieldSearchResultCellReusableIdentifier"];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1001];
    [self applyThemeToLabel:label];
    
    NSString *resultName = [self.matches objectAtIndex:[indexPath indexAtPosition:1]];
    label.text = resultName;
    
//    UITextField *sizeTextField = (UITextField *)[cell.contentView viewWithTag:1001];
//    UITextField *quantityTextField = (UITextField *)[cell.contentView viewWithTag:1002];
    
    return cell;
}

- (void)setMatchesForString:(NSString *)string
{
    if (!string.length)
        return;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", string];
    NSArray *matchesForString = [NSArray arrayWithArray:[self.matches filteredArrayUsingPredicate:predicate]];
    
    if (!matchesForString.count)
        return;
    
    NSString *firstMatch = [matchesForString objectAtIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.matches indexOfObject:firstMatch] inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
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

- (void)applyThemeToLabel:(UILabel *)label
{
    UIFont *regularFont = [UIFont fontWithName:@"HelveticaLTStd-LightCond" size:18.0];
	label.font = regularFont;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSString *selectedText = [self.matches objectAtIndex:[indexPath indexAtPosition:1]];
    NSLog(@"SELECTED %@", selectedText);
    self.textField.text = selectedText;
}
@end
