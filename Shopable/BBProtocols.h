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

- (void)showNavigationMenu;
- (void)hideDetailsScreen;
- (void)showDetailsScreen;

- (void)didSelectNavigationOptionWithObject:(BBStore *)selectedStore;

@end

@protocol BBListTableViewCellDelegate <NSObject>

- (void)cellDidFinishEditing:(UITableViewCell *)cell;

@end
