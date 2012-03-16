//
//  BBStorageManager.h
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BBStorageConstants.h"

@interface BBStorageManager : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSPersistentStore *persistentStore;

@property (strong, nonatomic) NSURL *ubiquityContainerURL;

+ (BBStorageManager *)sharedManager;

- (void)saveContext;
- (BOOL)storeExists;
- (NSDictionary *)storeOptions;
- (void)resetStorageManager;
- (NSURL *)applicationDocumentsDirectory;

@end
