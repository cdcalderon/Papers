//
//  NoteListTableViewController.m
//  Papers
//
//  Created by Sofia Calderon on 12/27/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "NoteListTableViewController.h"
#import "DataStore.h"

@interface NoteListTableViewController ()

@end

@implementation NoteListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"An error ocurred: %@", [error localizedDescription]);
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSFetchedResultsController *) fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    
    NSSortDescriptor *primarySort = [NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES];
    
    NSArray *sortArray = [NSArray arrayWithObjects:primarySort , nil];
    
    [fetch setSortDescriptors:sortArray];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    [self setFetchedResultsController:frc];
    [[self fetchedResultsController] setDelegate:self];
    
    return _fetchedResultsController;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSArray *sections = [[self fetchedResultsController] sections];
    return [sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSArray *sections = [[self fetchedResultsController] sections];
    id<NSFetchedResultsSectionInfo> currentSection = [sections objectAtIndex:section];
    return [currentSection numberOfObjects];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *note = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    [[cell textLabel] setText:[note valueForKey:@"title"]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *sections = [[self fetchedResultsController] sections];
    id<NSFetchedResultsSectionInfo> currentSection = [sections objectAtIndex:section];
    return [currentSection name];
    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
