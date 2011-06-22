//
//  Persistence.h
//  iOutOf
//
//  Created by Dan Fairaizl on 6/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Persistence : NSObject {
    
}

+ (NSArray *) fetchEntites:(NSString *)entity withPredicate:(NSPredicate *)predicate andSortBy:(NSString *)sortBy ascending:(BOOL)ascending;


+ (NSArray *) fetchAllEntitiesOfType:(NSString *)entity sortBy:(NSString *)sort;

@end
