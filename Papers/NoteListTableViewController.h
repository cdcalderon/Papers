//
//  NoteListTableViewController.h
//  Papers
//
//  Created by Carlos Calderon on 12/27/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NoteDetailViewController.h"

@interface NoteListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, NoteDetailViewControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating, UIViewControllerPreviewingDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSArray *filteredList;
@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSPredicate *searchPredicate;

- (IBAction)addNoteButtonClicked:(UIBarButtonItem *)sender;

@end
