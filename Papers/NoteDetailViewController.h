//
//  NoteDetailViewController.h
//  Papers
//
//  Created by Lorena Calderon on 12/28/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NoteDetailViewController : UIViewController
@property (nonatomic, strong) NSManagedObject *managedObject;
@end
