//
//  BBStorageManager+iCloud.m
//  Shopable
//
//  Created by Dan Fairaizl on 2/18/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager+Initialize.h"

#import "BBStorageManager+iCloud.h"

@implementation BBStorageManager (iCloud)

- (BOOL)iCloudEnabled {
    
    return (self.ubiquityContainerURL != nil);
}

- (void)enableiCloud {

    NSURL *ubiquityContainer = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
    
    NSLog(@"iCloud enabled!");
    
    self.ubiquityContainerURL = ubiquityContainer;
    
    /*if([[[NSUbiquitousKeyValueStore defaultStore] stringForKey:@"BBPersistentStorePath"] length] == NO) {
    
        [[NSUbiquitousKeyValueStore defaultStore] setString:[[self iCloudStorePath] path] forKey:@"BBPersistentStorePath"];
    }
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];*/
}

- (NSDictionary *)iCloudOptions {
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];

    if([self iCloudEnabled] == YES) {
        
        [options setValue:@"com.basicallybits.shopable.store" forKey:NSPersistentStoreUbiquitousContentNameKey];
        [options setValue:[NSURL fileURLWithPath:[self iCloudTransactionLogsPath]] forKey:NSPersistentStoreUbiquitousContentURLKey];
    }
    
    return options;
}

- (NSString *)iCloudTransactionLogsPath {
    
    //create the path to store the transaction logs for iCloud
    NSString* coreDataCloudContent = [[self.ubiquityContainerURL path] stringByAppendingPathComponent:@"TransLogs"];
    
    if(coreDataCloudContent == nil) {
        
        coreDataCloudContent = [NSString string];
    }
   
    return coreDataCloudContent;
}

- (NSURL *)iCloudStorePath {
    
    //create the new path for this store to live (e.g. in the Ubiquity Container)
    NSURL *cloudStorePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cloud" isDirectory:YES] 
                             URLByAppendingPathExtension:@"nosync"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[cloudStorePath path]] == NO) {
        
        [[NSFileManager defaultManager] createDirectoryAtURL:cloudStorePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //Update URL to move database
    cloudStorePath = [cloudStorePath URLByAppendingPathComponent:@"Shopable.sqlite" isDirectory:NO];
    
    return cloudStorePath;
}

- (void)migrateToRemoteStore {
    
    // do this asynchronously since if this is the first time this particular device is syncing with preexisting
    // iCloud content it may take a long long time to download
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // this needs to match the entitlements and provisioning profile
        NSURL *cloudURL = [fileManager URLForUbiquityContainerIdentifier:nil];
        
        //create the new path for this store to live (e.g. in the Ubiquity Container)
        NSURL *cloudStorePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cloud" isDirectory:YES] 
                                 URLByAppendingPathExtension:@"nosync"];
        [fileManager createDirectoryAtURL:cloudStorePath withIntermediateDirectories:YES attributes:nil error:&error];
        
        //Update URL to move database
        cloudStorePath = [cloudStorePath URLByAppendingPathComponent:@"Shopable.sqlite" isDirectory:NO];

        //create the path to store the transaction logs for iCloud
        NSString* coreDataCloudContent = [[cloudURL path] stringByAppendingPathComponent:@"TransLogs"];
        NSURL *transLogsURL = [NSURL fileURLWithPath:coreDataCloudContent];
        
        //Get options from existing NSPersistentStoreCoordinator
        NSPersistentStore *localStore= (NSPersistentStore *)[[self.persistentStoreCoordinator persistentStores] lastObject];
        NSMutableDictionary  *options = [[localStore options] mutableCopy];
        
        //  The API to turn on Core Data iCloud support here.

        
        [self.persistentStoreCoordinator lock];

        if(![self.persistentStoreCoordinator migratePersistentStore:localStore 
                                                             toURL:cloudStorePath 
                                                           options:options 
                                                          withType:NSSQLiteStoreType error:&error]) {
            
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible
             * The schema for the persistent store is incompatible with current managed object model
             Check the error message to determine what the actual problem was.
             */
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        }
         
        [self.persistentStoreCoordinator unlock];
         
        // tell the UI on the main thread we finally added the store and then
        // post a custom notification to make your views do whatever they need to such as tell their
        // NSFetchedResultsController to -performFetch again now there is a real store
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setupDatabase];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(mergeChangesFrom_iCloud:) 
                                                         name:NSPersistentStoreDidImportUbiquitousContentChangesNotification 
                                                       object:self.persistentStoreCoordinator];
            
            NSLog(@"asynchronously migrated to cloud store!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RefreshUI" object:self userInfo:nil];
            
        });
    });
}

- (BOOL)hasRemoteStore {
    
    //create the new path for this store to live (e.g. in the Ubiquity Container)
    NSURL *cloudStorePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"cloud" isDirectory:YES] 
                             URLByAppendingPathExtension:@"nosync"];
    
    //Update URL to move database
    cloudStorePath = [cloudStorePath URLByAppendingPathComponent:@"Shopable.sqlite" isDirectory:NO];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:[cloudStorePath path]];
}

@end
