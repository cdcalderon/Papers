//
//  AddNoteViewController.h
//  Papers
//
//  Created by Lorena Calderon on 12/28/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddNoteViewControllerDelegate <NSObject>

-(void)didAddNote;
-(void)didCancel;

@end

@interface AddNoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *noteBodyTextView;
@property (weak, nonatomic) IBOutlet UIButton *addNoteButton;
@property (weak, nonatomic) id <AddNoteViewControllerDelegate> delegate;

- (IBAction)AddNoteButtonClicked:(UIButton *)sender;


@end
