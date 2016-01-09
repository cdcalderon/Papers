//
//  ShareViewController.h
//  ShareNote
//
//  Created by carlos calderon on 1/6/16.
//  Copyright © 2016 contructysystems. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "DataStore.h"

@interface ShareViewController : SLComposeServiceViewController
{
    NSExtensionItem *inputItem;
}
@end
