//
//  AddNoteViewController.m
//  Papers
//
//  Created by Lorena Calderon on 12/28/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "AddNoteViewController.h"
#import "DataStore.h"
@interface AddNoteViewController ()

@end

@implementation AddNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    // New Note
    NSManagedObject *note1;
    note1 = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                          inManagedObjectContext:context];
    
    [note1 setValue: self.titleTextField.text forKey:@"title"];
    [note1 setValue: self.noteBodyTextView.text forKey:@"body"];
    
    [dataStore saveChanges];
    [self.delegate didAddNote];
    
}
@end
