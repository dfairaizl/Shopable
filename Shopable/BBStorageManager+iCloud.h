//
//  BBStorageManager+iCloud.h
//  Shopable
//
//  Created by Dan Fairaizl on 2/18/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import "BBStorageManager.h"

@interface BBStorageManager (iCloud)

- (BOOL)iCloudEnabled;
- (void)migrateToRemoteStore;

- (BOOL)hasRemoteStore;

- (void)enableiCloud;
- (NSDictionary *)iCloudOptions;
- (NSString *)iCloudTransactionLogsPath;
- (NSURL *)iCloudStorePath;

@end
