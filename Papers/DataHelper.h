//
//  DataHelper.h
//  Papers
//
//  Created by Carlos Calderon on 12/24/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DataStore.h"

@interface DataHelper : NSObject

+ (void)createNotesSampleData;
+ (void)logAllNotes;

@end
