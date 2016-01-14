//
//  NoteListTableViewController.m
//  Papers
//
//  Created by Carlos Calderon on 12/27/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "NoteListTableViewController.h"
#import "NoteDetailViewController.h"
#import "DataStore.h"

@interface NoteListTableViewController ()

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) UISearchController *searchController;

@end

@implementation NoteListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
    [self.searchController.searchBar sizeToFit];
    
}

- (void)didChangePreferredContentSize:(NSNotification *)notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    self.searchFetchRequest = nil;
}

- (NSFetchRequest *)searchFetchRequest {
    if (_searchFetchRequest != nil) {
        return _searchFetchRequest;
    }
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
   
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
}

#pragma mark - Fetched Results Controller ===

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    }
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Note" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                          managedObjectContext:context
                                                                            sectionNameKeyPath:nil
                                                                                     cacheName:nil];
    frc.delegate = self;
    self.fetchedResultsController = frc;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return _fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView reloadData];
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.searchController.active)
    {
        return [[self.fetchedResultsController sections] count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (!self.searchController.active)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo numberOfObjects];
    }
    else
    {
        return [self.filteredList count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSManagedObject *note = nil;
    if (!self.searchController.active)
    {
        note = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        [[cell textLabel] setText:[note valueForKey:@"title"]];
        [[cell detailTextLabel] setText: [NSString stringWithFormat:@"%@",[note valueForKey:@"dateModified"]]];
    }
    else
    {
        NSManagedObject *note = [[self filteredList] objectAtIndex:indexPath.row];
        [[cell textLabel] setText:[note valueForKey:@"title"]];
        [[cell detailTextLabel] setText: [NSString stringWithFormat:@"%@",[note valueForKey:@"dateModified"]]];
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView)
    {
        id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
        return [sectionInfo name];
    }
    return nil;
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
        
        [dataStore saveChanges];
        
        [[self tableView] endUpdates];
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == self.tableView)
    {
        NSMutableArray *index = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
        NSArray *initials = [self.fetchedResultsController sectionIndexTitles];
        [index addObjectsFromArray:initials];
        return index;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == self.tableView)
    {
        if (index > 0)
        {
            return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index-1];
        }
        else
        {
            //force the table to scroll to the top.
            CGRect searchBarFrame = self.searchController.searchBar.frame;
            [self.tableView scrollRectToVisible:searchBarFrame animated:NO];
            return NSNotFound;
        }
    }
    return 0;
}

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
            [[cell detailTextLabel] setText: [NSString stringWithFormat:@"%@",[note valueForKey:@"dateModified"]]];
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

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    [self searchForText:searchString];
    [self.tableView reloadData];
}

- (void)searchForText:(NSString *)searchText {
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    if (context) {
        NSString *predicateFormat = @"%K BEGINSWITH[cd] %@";
        NSString *searchAttribute = @"title";
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat, searchAttribute, searchText];
        [self.searchFetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        self.filteredList = [context executeFetchRequest:self.searchFetchRequest error:&error];
        if (error)
        {
            NSLog(@"searchFetchRequest failed: %@",[error localizedDescription]);
        }
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    [self updateSearchResultsForSearchController:self.searchController];
}


- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    
    [self showDetailViewController:viewControllerToCommit sender:self];
}


@end
