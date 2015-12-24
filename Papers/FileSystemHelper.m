//
//  FileSystemHelper.m
//  Papers
//
//  Created by Carlos Calderon on 12/23/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import "FileSystemHelper.h"

@implementation FileSystemHelper

+(NSURL *)pathForDocumentsFile:(NSString *)filename {
    
    // create a URL-based with passed in filename located in the Documents directory
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *directories = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentPath = [directories objectAtIndex:0];
    
    return [documentPath URLByAppendingPathComponent:filename];
    
}

@end


