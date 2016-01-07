//
//  DataStore.m
//  Papers
//
//  Created by Carlos Calderon on 12/23/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "DataStore.h"
#import "FileSystemHelper.h"

@implementation DataStore

+(id)sharedDataStore {
    static DataStore *sharedDataStore = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDataStore = [[self alloc] init];
    });
    
    return sharedDataStore;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // create a URL-based path to the passed in filename located in the Documents directory
        NSURL *dataStoreURL = [FileSystemHelper pathForDocumentsFile:@"notes.sqlite"];
        
        //Note:: Uncomment this line to start with aclean copy of the DB when the App starts
      //  [[NSFileManager defaultManager] removeItemAtURL:dataStoreURL error:nil];
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
        
        //extension changes
        NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.papersnote"];
        NSURL *storeURL = [directory  URLByAppendingPathComponent:@"notes.sqlite"];
        
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Create managed object context
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:psc];
    }
    return self;
}

- (BOOL)saveChanges {
    
    NSError *error = nil;
    BOOL saveSuccessful = [_context save:&error];
    if (!saveSuccessful) {
        NSLog(@"An error occurred while saving data. Error: %@", [error localizedDescription]);
    }
    return saveSuccessful;
}


@end
