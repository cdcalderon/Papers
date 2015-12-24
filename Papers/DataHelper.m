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
    
    // Categories
    NSManagedObject *category1;
    category1 = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                              inManagedObjectContext:context];
    
    [category1 setValue:@"My first tet title" forKey:@"title"];
    [category1 setValue:@"Stuff about IOS I need to master ." forKey:@"body"];
    
    
    NSManagedObject *category2;
    category2 = [NSEntityDescription insertNewObjectForEntityForName:@"Note"
                                              inManagedObjectContext:context];
    
    [category2 setValue:@"my title test" forKey:@"title"];
    [category2 setValue:@"Buy milk" forKey:@"body"];
    
    [dataStore saveChanges];
}

+ (void)logAllNotes {
    
    DataStore *dataStore = [DataStore sharedDataStore];
    NSManagedObjectContext *context = [dataStore context];
    
    NSFetchRequest *req;
    req = [NSFetchRequest fetchRequestWithEntityName:@"Note"];
    
    NSError *error;
    NSArray *allCategories = [context executeFetchRequest:req error:&error];
    
    if (!allCategories) {
        NSLog(@"An error occurred. Error: %@", [error localizedDescription]);
    }
    
    NSLog(@"Logging Notes");
    
    for (NSManagedObject *cat in allCategories) {
        NSLog(@"Note Name:  %@ (%@)",
              [cat valueForKey:@"title"],
              [cat valueForKey:@"body"]);
    }
}


@end
