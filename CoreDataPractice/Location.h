//
//  Location.h
//  
//
//  Created by Manish Kumar on 17/08/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Date;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) Date *locationForDate;

@end
