//
//  FileSystemHelper.h
//  Papers
//
//  Created by Carlos Calderon on 12/23/15.
//  Copyright © 2015 contructysystems. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileSystemHelper : NSObject

+(NSURL *)pathForDocumentsFile:(NSString *)filename;

@end
