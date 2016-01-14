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



- (IBAction)addNoteButtonClicked:(UIBarButtonItem *)sender;

@end
