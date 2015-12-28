//
//  NoteListTableViewController.m
//  Papers
//
//  Created by Sofia Calderon on 12/27/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "NoteListTableViewController.h"
#import "NoteDetailViewController.h"
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

- (IBAction)addNoteButtonClicked:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"goToNoteDetailViewController" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.destinationViewController isKindOfClass: [NoteDetailViewController class]]) {
        
        NoteDetailViewController *addNoteViewController = segue.destinationViewController;
        addNoteViewController.delegate = self;
        
        if (![sender isKindOfClass:[UIBarButtonItem class]]) {
            NSManagedObject *note = [[self fetchedResultsController] objectAtIndexPath:self.tableView.indexPathForSelectedRow];
            addNoteViewController.toBeUpdatedManagedObject = note;
            addNoteViewController.isEditing = YES;
        }
    }
//    else if ([segue.destinationViewController isKindOfClass: [NoteDetailViewController class]]) {
//        NSManagedObject *note = [[self fetchedResultsController] objectAtIndexPath:self.tableView.indexPathForSelectedRow];
//        NoteDetailViewController *noteDetailViewController = segue.destinationViewController;
//        noteDetailViewController.toBeUpdatedManagedObject = note;
//    }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"goToNoteDetailViewController" sender:self];
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [[self tableView] beginUpdates];
        DataStore *dataStore = [DataStore sharedDataStore];
        NSManagedObjectContext *context = [dataStore context];
        
        [context deleteObject:[_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row]];
        
        NSError *error;
        
        [dataStore saveChanges];
        
        [[self tableView] endUpdates];
        
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


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

#pragma mark - AddNoteViewControllerDelegate
-(void)didAddNote {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)didCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - NSFetchedResultsControllerDelegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    [[self tableView] beginUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller
 didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
          atIndex:(NSUInteger)sectionIndex
    forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void)controller:(NSFetchedResultsController *)controller
  didChangeObject:(id)anObject
      atIndexPath:(NSIndexPath *)indexPath
    forChangeType:(NSFetchedResultsChangeType)type
     newIndexPath:(NSIndexPath *)newIndexPath {
 
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
            NSManagedObject *note = [[self fetchedResultsController] objectAtIndexPath:indexPath];
            [[cell textLabel] setText:[note valueForKey:@"title"]];
            break;
        }
            
        case NSFetchedResultsChangeMove:
            [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
            [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                    withRowAnimation:UITableViewRowAnimationFade];
            break;
    }

}

-(NSString *)controller:(NSFetchedResultsController *)controller sectionIndexTitleForSectionName:(NSString *)sectionName {
    
    return sectionName;
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    [[self tableView] endUpdates];
    
}

@end
