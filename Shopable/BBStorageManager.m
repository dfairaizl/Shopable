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
    
    NSNotification* refreshNotification = [NSNotification notificationWithName:@"RefreshUI" object:self  userInfo:[note userInfo]];
    
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
        
            [moc setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
            
            // even the post initialization needs to be done within the Block
            [moc setPersistentStoreCoordinator: coordinator];
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
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    // assign the PSC to our app delegate ivar before adding the persistent store in the background
    // this leverages a behavior in Core Data where you can create NSManagedObjectContext and fetch requests
    // even if the PSC has no stores.  Fetch requests return empty arrays until the persistent store is added
    // so it's possible to bring up the UI and then fill in the results later
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
    
    
    // prep the store path and bundle stuff here since NSBundle isn't totally thread safe
    NSPersistentStoreCoordinator* psc = __persistentStoreCoordinator;
	NSString *storePath = [[[self applicationDocumentsDirectory] path] stringByAppendingPathComponent:@"Shopable.sqlite"];
    
    // do this asynchronously since if this is the first time this particular device is syncing with preexisting
    // iCloud content it may take a long long time to download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSURL *storeUrl = [NSURL fileURLWithPath:storePath];
        // this needs to match the entitlements and provisioning profile
        NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"StoreLogs"];
        cloudURL = [NSURL fileURLWithPath:coreDataCloudContent];
        
        //  The API to turn on Core Data iCloud support here.
        NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@"com.basicallybits.shopable.store", NSPersistentStoreUbiquitousContentNameKey, 
                                 cloudURL, NSPersistentStoreUbiquitousContentURLKey, 
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        NSError *error = nil;
        
        [psc lock];
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:options error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible
             * The schema for the persistent store is incompatible with current managed object model
             Check the error message to determine what the actual problem was.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        [psc unlock];
        
        // tell the UI on the main thread we finally added the store and then
        // post a custom notification to make your views do whatever they need to such as tell their
        // NSFetchedResultsController to -performFetch again now there is a real store
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(mergeChangesFrom_iCloud:) 
                                                         name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                       object:self.persistentStoreCoordinator];
           
            NSLog(@"asynchronously added persistent store!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI" object:self userInfo:nil];
            
        });
    });
    
    return __persistentStoreCoordinator;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
/*- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    __block NSPersistentStoreCoordinator *currentCoordinator = nil;

    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    //check and see if we have an iCloud datastore on this device
    
    if([self hasRemoteStore]) {
        
        //NSLog(@"remote store exists!");
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            currentCoordinator = [self addRemoteStore];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //[self setupDatabase];
                
                [[NSNotificationCenter defaultCenter] addObserver:self 
                                                         selector:@selector(mergeChangesFrom_iCloud:) 
                                                             name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                           object:self.persistentStoreCoordinator];
                
                NSLog(@"asynchronously added cloud persistent store!");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI" object:self userInfo:nil];
            });
            
        });
    }
    else {
        
        NSLog(@"iCloud store does not exist! Creating local store...");
        
        currentCoordinator = [self addLocalStore];
        
//        [self setupDatabase];
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"DatabaseReadyNotification" object:self userInfo:nil];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            if([self iCloudEnabled] == YES) {
                [self migrateToRemoteStore];
            }
        });
    }
    
    return currentCoordinator;
}*/

- (NSPersistentStoreCoordinator *)addRemoteStore {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // this needs to match the entitlements and provisioning profile
    NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
    
    //create the new path for this store to live (e.g. in the Ubiquity Container)
    NSURL *cloudStorePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cloud" isDirectory:YES] 
                             URLByAppendingPathExtension:@"nosync"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[cloudStorePath path]] == NO) {
        
        [[NSFileManager defaultManager] createDirectoryAtURL:cloudStorePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //Update URL to move database
    cloudStorePath = [cloudStorePath URLByAppendingPathComponent:@"Shopable.sqlite" isDirectory:NO];
    
    //create the path to store the transaction logs for iCloud
    NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"TransLogs"];
    NSURL *transLogsURL = [NSURL fileURLWithPath:coreDataCloudContent];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, 
                             @"com.basicallybits.shopable.store", NSPersistentStoreUbiquitousContentNameKey,
                             transLogsURL, NSPersistentStoreUbiquitousContentURLKey,nil];
    
    return [self addStoreAtPath:cloudStorePath withOptions:options];
}

- (NSPersistentStoreCoordinator *)addLocalStore {
    
    NSError *error = nil;
    
    NSURL *storeDirectory = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"database" isDirectory:YES] 
                       URLByAppendingPathExtension:@"nosync"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[storeDirectory path]] == NO) {
        
        [[NSFileManager defaultManager] createDirectoryAtURL:storeDirectory withIntermediateDirectories:YES attributes:nil error:&error];
    }
    
    
    NSURL *storeURL = [storeDirectory URLByAppendingPathComponent:@"Shopable.sqlite"];
    
    NSDictionary *options = nil;
    
    options = [NSDictionary dictionaryWithObjectsAndKeys:
               [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, 
               [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    return [self addStoreAtPath:storeURL withOptions:options];
}

- (NSPersistentStoreCoordinator *)addStoreAtPath:(NSURL *)storePath withOptions:(NSDictionary *)storeOptions {

    NSError *error = nil;
    
    if(__persistentStoreCoordinator == nil) {
        __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    }
    
    NSPersistentStoreCoordinator *psc = __persistentStoreCoordinator;
    
    [psc lock];
    
    if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storePath options:storeOptions error:&error]) {
        
        NSLog(@"unable to create persistent store: %@ %@", error, [error userInfo]);
        abort();
    }
    
    self.persistentStore = [psc persistentStoreForURL:storePath];
    
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
