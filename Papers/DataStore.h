//
//  DataStore.h
//  Papers
//
//  Created by Carlos Calderon on 12/23/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DataStore : NSObject {
    NSManagedObjectModel *model;
}

@property (nonatomic, strong) NSManagedObjectContext *context;

+ (id)sharedDataStore;
- (BOOL)saveChanges;

@end
