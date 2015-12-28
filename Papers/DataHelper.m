//
//  DataHelper.m
//  Papers
//
//  Created by Carlos Calderon on 12/24/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper

+ (void)createNotesSampleData {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    // Notes
    NSManagedObject *note1;
    note1 = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                              inManagedObjectContext:context];
    
    [note1 setValue:@"My first tet title" forKey:@"title"];
    [note1 setValue:@"Stuff about IOS I need to master ." forKey:@"body"];
    
    
    NSManagedObject *note2;
    note2 = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                              inManagedObjectContext:context];
    
    [note2 setValue:@"my title test" forKey:@"title"];
    [note2 setValue:@"Buy milk" forKey:@"body"];
    
    [dataStore saveChanges];
}

+ (void)logAllNotes {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *req;
    req = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    
    NSError *error;
    NSArray *allNotes = [context executeFetchRequest:req error:&error];
    
    if (!allNotes) {
        NSLog(@"An error occurred. Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"Logging Notes");
    
    for (NSManagedObject *note in allNotes) {
        NSLog(@"Note Name:  %@ (%@)",
              [note valueForKey:@"title"],
              [note valueForKey:@"body"]);
    }
}


@end
