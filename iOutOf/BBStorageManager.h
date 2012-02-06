//
//  BBStorageManager.h
//  iOutOf
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBStorageConstants.h"

@interface BBStorageManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (BBStorageManager *)sharedManager;

- (void)saveContext;
- (BOOL)storeExists;
- (NSURL *)applicationDocumentsDirectory;

#pragma mark - Store Methods
- (NSArray *)stores;

@end
