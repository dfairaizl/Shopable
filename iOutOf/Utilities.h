//
//  Utilities.h
//  iOutOf
//
//  Created by Dan Fairaizl on 3/12/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utilities : NSObject {

}

+ (NSString *) applicationDocumentsDirectory;
+ (NSString *) databasePath;
+ (NSManagedObjectContext *) managedObjectContext;
+ (id) appDelegate;

@end
