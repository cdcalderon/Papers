//
//  ShareViewController.m
//  ShareNote
//
//  Created by carlos calderon on 1/6/16.
//  Copyright © 2016 contructysystems. All rights reserved.
//

#import "ShareViewController.h"
@import MobileCoreServices;

static NSString *const AppGroupId = @"group.papersnote";

@interface ShareViewController ()

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    inputItem = self.extensionContext.inputItems.firstObject;
    NSItemProvider *urlItemProvider = [[inputItem.userInfo valueForKey:NSExtensionItemAttachmentsKey] objectAtIndex:0];
    
    if ([urlItemProvider hasItemConformingToTypeIdentifier:(__bridge NSString *)kUTTypeURL])
    {
        [urlItemProvider loadItemForTypeIdentifier:(__bridge NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error)
        {
            if (error)
            {
                NSLog(@"Error occured");
            }
            else
            {
                // Save to Core Data
                DataStore *dataStore = [DataStore sharedDataStore];
                NSManagedObjectContext *context = [dataStore context];
                
                // New Note
                NSManagedObject *newNote = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                                                         inManagedObjectContext:context];
                
                
                [newNote setValue: url.absoluteString forKey:@"title"];
                [newNote setValue: self.contentText forKey:@"body"];
                
                [dataStore saveChanges];
                
                UIAlertController * alert= [UIAlertController
                                            alertControllerWithTitle:@"Success"
                                            message:@"Posted Successfully."
                                            preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                {
                    [UIView animateWithDuration:0.20 animations:^
                    {
                        self.view.transform = CGAffineTransformMakeTranslation(0, self.view.frame.size.height);
                    }
                                     completion:^(BOOL finished)
                    {
                        [self.extensionContext completeRequestReturningItems:nil completionHandler:nil];
                    }];
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }
    
    //[self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
