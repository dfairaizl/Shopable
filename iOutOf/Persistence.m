//
//  Persistence.m
//  iOutOf
//
//  Created by Dan Fairaizl on 6/19/11.
//  Copyright 2011 Basically Bits, LLC. All rights reserved.
//

#import "Persistence.h"

#import "Utilities.h"

@implementation Persistence

+ (void) save {
    
    NSError *coreDataError;
    
    if(![[Utilities managedObjectContext] save:&coreDataError])
        NSLog(@"Unable to save core data!");
}

+ (id) entityOfType:(NSString *)entity {
    
    return [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:[Utilities managedObjectContext]];
}

+ (NSArray *) fetchAllEntitiesOfType:(NSString *)entity sortBy:(NSString *)sort {
    
    return [self fetchEntites:entity withPredicate:nil andSortBy:sort ascending:YES];
}

+ (NSArray *) fetchEntitiesOfType:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    
    return [self fetchEntites:entity withPredicate:predicate andSortBy:nil ascending:YES];
}

+ (NSArray *) fetchEntites:(NSString *)entity withPredicate:(NSPredicate *)predicate andSortBy:(NSString *)sortBy ascending:(BOOL)ascending {
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setReturnsObjectsAsFaults:NO];
    
    NSEntityDescription *description = [NSEntityDescription entityForName:entity inManagedObjectContext:[Utilities managedObjectContext]];
    
    [request setEntity:description];
    
    if(predicate != nil)
        [request setPredicate:predicate];
    
    if(sortBy != nil) {
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortBy ascending:true];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [request setSortDescriptors:sortDescriptors];
        
        [sortDescriptors release];
        [sortDescriptor release];
    }
    
    NSError *error;
    
    NSArray *entities = [[[Utilities managedObjectContext] executeFetchRequest:request error:&error] autorelease];
    
    [request release];
    
    return entities;
}

@end
