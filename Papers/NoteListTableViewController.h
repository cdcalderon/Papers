//
//  NoteListTableViewController.h
//  Papers
//
//  Created by Sofia Calderon on 12/27/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AddNoteViewController.h"

@interface NoteListTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, AddNoteViewControllerDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

- (IBAction)addNoteButtonClicked:(UIBarButtonItem *)sender;

@end
