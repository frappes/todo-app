//
//  ToDoTableViewController.m
//  ToDoList
//
//  Created by Ross Danielson on 1/25/14.
//  Copyright (c) 2014 zynga. All rights reserved.
//

#import "ToDoTableViewController2.h"
#import "ToDoTableCell.h"

@interface ToDoTableViewController2 ()

@property (nonatomic) NSMutableArray* toDoItems;

-(void)onEdit:(id)sender;
-(void)onAdd:(id)sender;

@end

@implementation ToDoTableViewController2

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        [self setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = self.editButtonItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *cellNib = [UINib nibWithNibName:@"ToDoTableCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"ToDoTableCell"];
    
    self.title = @"To Do List";
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(onEdit:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStylePlain target:self action:@selector(onAdd:)];
    
    // this is bad
    //self.toDoItems = [[NSMutableArray alloc] init];
    
    NSData* serialized = [[NSUserDefaults standardUserDefaults] objectForKey:@"todo"];
    NSMutableArray* array = (NSMutableArray*)[NSKeyedUnarchiver unarchiveObjectWithData:serialized];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"todo"];
    if(!array ) {
        self.toDoItems = [[NSMutableArray alloc] init];
    } else {
        self.toDoItems = array;
    }
    
    self.tableView.delegate = self;
    
    //Remove keyboard from UITableViewCell on tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tap.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tap];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)dismissKeyboard:(UIGestureRecognizer*)tapGestureRecognizer
{
    if (!CGRectContainsPoint([self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]].frame, [tapGestureRecognizer locationInView:self.tableView]))
    {
        [self.view endEditing:YES];
    }
}

- (void)onEdit:(id)sender
{
    NSLog(@"Edit tapped");
}

- (void)onAdd:(id)sender
{
    NSLog(@"+ tapped");
    [self.toDoItems addObject:@"TO DO"];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.toDoItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDoTableCell";
    ToDoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ToDoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    cell.field.text = self.toDoItems[indexPath.row];
    
    cell.field.delegate = self;
    cell.field.tag = indexPath.row;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = self.toDoItems[indexPath.row];
    CGSize boundingSize = CGSizeMake(200, MAXFLOAT);
    
    UIFont *font = [UIFont fontWithName:@"Helvetica Neue" size:15];
    
    CGRect textRect = [string boundingRectWithSize:boundingSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    
    //UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    return textRect.size.height + 25;
}


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         [self.toDoItems removeObjectAtIndex:indexPath.row];
         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
         [self saveList];
     }
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }



 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSString* temp = self.toDoItems[fromIndexPath.row];
     self.toDoItems[fromIndexPath.row] = self.toDoItems[toIndexPath.row];
     self.toDoItems[toIndexPath.row] = temp;
     [self saveList];
 }



 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }


- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"END!");
    [self.tableView reloadData];
    
    [self saveList];
}

-(void)saveList
{
    NSLog(@"saving");
    NSData* serialized = [NSKeyedArchiver archivedDataWithRootObject:self.toDoItems];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"todo"];
    [[NSUserDefaults standardUserDefaults] setObject:serialized forKey:@"todo"];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.toDoItems[textView.tag] = textView.text;
    //[self.tableView reloadData];
}


/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 
 */

@end
