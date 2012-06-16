//
//  BBProtocols.h
//  Shopable
//
//  Created by Dan Fairaizl on 5/9/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BBStorageManager.h"

@protocol BBNavigationDelegate <NSObject>

@optional

- (void)showNavigationMenu;
- (void)hideDetailsScreen;
- (void)showDetailsScreen;

- (void)didSelectNavigationOptionWithObject:(BBList *)selectedStore;

@end

@protocol BBListTableViewCellDelegate <NSObject>

- (void)cellWillBeginEditing:(UITableViewCell *)cell;
- (void)cellDidFinishEditing:(UITableViewCell *)cell;

@end

@protocol BBItemsListTableViewCellDelegate <NSObject>

- (void)showItemDetailsForCell:(UITableViewCell *)cell;

@optional

- (void)itemQuantityDidChange:(NSInteger)quantity;
- (void)itemUnitsDidChange:(NSInteger)unit;
- (void)itemDidAddNotes:(NSString *)notes;
- (void)itemDidAddPhoto:(UIImage *)photo;

@end
