//
//  AddNoteViewController.m
//  Papers
//
//  Created by Lorena Calderon on 12/28/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "DataStore.h"
@interface NoteDetailViewController ()

@end

@implementation NoteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.isEditing) {
        self.titleTextField.text = [self.toBeUpdatedManagedObject valueForKey:@"title"];
        self.noteBodyTextView.text = [self.toBeUpdatedManagedObject valueForKey:@"body"];
        [self.addNoteButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)AddNoteButtonClicked:(UIButton *)sender {
    
    [self.noteBodyTextView resignFirstResponder];
    
    if (self.isEditing) {
        [self editNote: self.toBeUpdatedManagedObject];
    } else {
        [self addNewNote];
    }
    
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self.delegate didCancel];
}

- (void)editNote:(NSManagedObject *) managedObject {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    
    [managedObject setValue: self.titleTextField.text forKey:@"title"];
    [managedObject setValue: self.noteBodyTextView.text forKey:@"body"];
    
    [dataStore saveChanges];
    [self.delegate didAddNote];

}

- (void)addNewNote {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    // New Note
    NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                             inManagedObjectContext:context];
    
    
    [newNote setValue: self.titleTextField.text forKey:@"title"];
    [newNote setValue: self.noteBodyTextView.text forKey:@"body"];
    
    [dataStore saveChanges];
    [self.delegate didAddNote];
}


@end
