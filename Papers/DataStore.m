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
        
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setValue:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
        [options setValue:NSPersistentStoreUbiquitousContentNameKey forKey:@"iCloudApp"];

        NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.papersnoteRev1"];
        NSURL *storeURL = [directory  URLByAppendingPathComponent:@"notes.sqlite"];
        
        // iCloud notification subscriptions
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(storeWillChange:) name:NSPersistentStoreCoordinatorStoresWillChangeNotification object:psc];
        [notificationCenter addObserver:self selector:@selector(storeDidChange:) name:NSPersistentStoreCoordinatorStoresDidChangeNotification object:psc];
        [notificationCenter addObserver:self selector:@selector(storeDidImportUbiquitousContentChanges:)
                                   name:NSPersistentStoreDidImportUbiquitousContentChangesNotification
                                 object:psc];
        
        NSError *error = nil;
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // Create managed object context
        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
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

- (void)storeDidImportUbiquitousContentChanges:(NSNotification*)notification {
    NSLog(@"%@", notification.userInfo.description);
    NSManagedObjectContext *moc = self.context;
    [moc performBlock:^{
        // Merge the content
        [moc mergeChangesFromContextDidSaveNotification:notification];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        // Refresh the UI here
        NSLog(@"storeDidImportUbiquitousContentChanges called");
    });
}

- (void)storeWillChange:(NSNotification *)notification {
    NSLog(@"%@", notification.userInfo.description);
    NSManagedObjectContext *moc = self.context;
    [moc performBlockAndWait:^{
        NSError *error = nil;
        if ([moc hasChanges]) {
            [moc save:&error];
        }
        [moc reset];
    }];
    
    NSLog(@"Updating UI storeWillChange");

    // This is a good place to let your UI know it needs to get ready
    // to adjust to the change and deal with new data. This might include
    // invalidating UI caches, reloading data, resetting views, etc...
}

- (void)storeDidChange:(NSNotification *)notification {
    NSLog(@"%@", notification.userInfo.description);
    // At this point it's official, the change has happened. Tell your
    // user interface to refresh itself
    dispatch_async(dispatch_get_main_queue(), ^{
         NSLog(@"Updating UI storeDidChange");
        // Refresh the UI here
    });
}

@end
