//
//  Utilities.m
//  iOutOf
//
//  Created by Dan Fairaizl on 3/12/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "Utilities.h"

#define DATABASE_PATH @"AllOutOf.rdb"

@implementation Utilities

/**
 Returns the path to the application's Documents directory.
 */

+ (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *) databasePath {
	
	return [[self applicationDocumentsDirectory] stringByAppendingPathComponent:DATABASE_PATH];
}

+ (NSManagedObjectContext *) managedObjectContext {
    
    return [[self appDelegate] managedObjectContext];
}

+ (id) appDelegate {
    
    return [[UIApplication sharedApplication] delegate];
}

@end
