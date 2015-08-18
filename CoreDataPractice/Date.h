//
//  Date.h
//  
//
//  Created by Manish Kumar on 17/08/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Date : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSSet *dateForLocation;
@end

@interface Date (CoreDataGeneratedAccessors)

- (void)addDateForLocationObject:(Location *)value;
- (void)removeDateForLocationObject:(Location *)value;
- (void)addDateForLocation:(NSSet *)values;
- (void)removeDateForLocation:(NSSet *)values;

@end
