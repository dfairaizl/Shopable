//
//  BBStorageManager.m
//  Shopable
//
//  Created by Dan Fairaizl on 1/11/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager.h"

//Categories
#import "BBStorageManager+Initialize.h"
#import "BBStorageManager+iCloud.h"

//singleton
static BBStorageManager *sharedManager = nil;

@implementation BBStorageManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize persistentStore = _persistentStore;

@synthesize ubiquityContainerURL;

- (id)init {
    
    self = [super init];
    
    if(self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(setupDatabase) 
                                                     name:[NSString stringWithString:@"DatabaseReadyNotification"] 
                                                   object:nil];
    }
    
    return self;
}

+ (BBStorageManager *)sharedManager {
    
    if (sharedManager == nil) {
        sharedManager = [[super alloc] init];
    }
    
    return sharedManager;
}

- (BOOL)storeExists {
 
    NSString *storePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Shopable.sqlite"] path];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:storePath];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

// this takes the NSPersistentStoreDidImportUbiquitousContentChangesNotification
// and transforms the userInfo dictionary into something that
// -[NSManagedObjectContext mergeChangesFromContextDidSaveNotification:] can consume
// then it posts a custom notification to let detail views know they might want to refresh.
// The main list view doesn't need that custom notification because the NSFetchedResultsController is
// already listening directly to the NSManagedObjectContext

- (void)mergeiCloudChanges:(NSNotification*)note forContext:(NSManagedObjectContext*)moc {
    
    [moc mergeChangesFromContextDidSaveNotification:note]; 
    
    NSNotification* refreshNotification = [NSNotification notificationWithName:@"RefreshAllViews" object:self  userInfo:[note userInfo]];
    
    [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
    
        // Make life easier by adopting the new NSManagedObjectContext concurrency API
        // the NSMainQueueConcurrencyType is good for interacting with views and controllers since
        // they are all bound to the main thread anyway
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
        
            // even the post initialization needs to be done within the Block
            [moc setPersistentStoreCoordinator: coordinator];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(mergeChangesFrom_iCloud:) 
                                                         name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                       object:coordinator];
        }];
        
        __managedObjectContext = moc;
    }
    
    return __managedObjectContext;
}

// NSNotifications are posted synchronously on the caller's thread
// make sure to vector this back to the thread we want, in this case
// the main thread for our views & controller

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
	NSManagedObjectContext* moc = [self managedObjectContext];
    
    // this only works if you used NSMainQueueConcurrencyType
    // otherwise use a dispatch_async back to the main thread yourself
    [moc performBlock:^{
        [self mergeiCloudChanges:notification forContext:moc];
    }];
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Shopable" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSError *error = nil;
    
    NSURL *storeURL = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"database" isDirectory:YES] 
                       URLByAppendingPathExtension:@"nosync"];
    
    [[NSFileManager defaultManager] createDirectoryAtURL:storeURL withIntermediateDirectories:YES attributes:nil error:&error];
    storeURL = [storeURL URLByAppendingPathComponent:@"Shopable.sqlite"];
    
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSPersistentStoreCoordinator *psc = __persistentStoreCoordinator;
    
    NSDictionary *options = nil;
    
    options = [NSDictionary dictionaryWithObjectsAndKeys:
                   [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
                   [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
    
    [psc lock];
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"unable to create persistent store: %@ %@", error, [error userInfo]);
        abort();
    }
    else {
        
        NSLog(@"Persistant Store added sucessfully");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DatabaseReadyNotification" object:self userInfo:nil];
    }
    
    self.persistentStore = [psc persistentStoreForURL:storeURL];
    
    [psc unlock];
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */

- (NSURL *)applicationDocumentsDirectory {
    
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
