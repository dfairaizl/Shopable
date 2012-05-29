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
    
    if(ubiquityContainer != nil) {
        NSLog(@"iCloud enabled!");
    }
    else {
        NSLog(@"iCloud not enabled for this device");
    }
    
    self.ubiquityContainerURL = ubiquityContainer;
}

- (NSDictionary *)iCloudOptions {
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];

//    if([self iCloudEnabled] == YES) {
//        
//        [options setValue:@"com.basicallybits.shopable.store" forKey:NSPersistentStoreUbiquitousContentNameKey];
//        [options setValue:[NSURL fileURLWithPath:[self iCloudTransactionLogsPath]] forKey:NSPersistentStoreUbiquitousContentURLKey];
//    }
    
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
    NSURL *cloudStorePath = [[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"db" isDirectory:YES] 
                             URLByAppendingPathExtension:@"nosync"];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:[cloudStorePath path]] == NO) {
        
        [[NSFileManager defaultManager] createDirectoryAtURL:cloudStorePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //Update URL to move database
    cloudStorePath = [cloudStorePath URLByAppendingPathComponent:@"Shopable.sqlite" isDirectory:NO];
    
    return cloudStorePath;
}

@end
