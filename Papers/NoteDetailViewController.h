//
//  AddNoteViewController.h
//  Papers
//
//  Created by Lorena Calderon on 12/28/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol NoteDetailViewControllerDelegate <NSObject>

-(void)didAddNote;
-(void)didCancel;

@end

@interface NoteDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;
@property (nonatomic, strong) NSManagedObject *toBeUpdatedManagedObject;
@property (nonatomic, assign) BOOL isEditing ;
@property (weak, nonatomic) id <NoteDetailViewControllerDelegate> delegate;

- (IBAction)AddNoteButtonClicked:(UIButton *)sender;
- (IBAction)cancelButtonClicked:(UIButton *)sender;


@end
