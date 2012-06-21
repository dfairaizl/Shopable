//
//  BBShoppingListAddViewController.h
//  Shopable
//
//  Created by Daniel Fairaizl on 6/18/12.
//  Copyright (c) 2012 Basically Bits, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BBProtocols.h"

typedef enum {
    
    BBShoppingListAddPullDownStateNormal = 0,
    BBShoppingListAddPullDownStateRelease,
    BBShoppingListAddPullDownStateCancel,
    
} BBShoppingListAddPullDownState;

@interface BBShoppingListAddViewController : UITableViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *addItemPullDownLabel;
@property (weak, nonatomic) id <BBShoppingAddItemDelegate> delegate;

- (void)shoppingListScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)shoppingListScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
