//
//  LocationDataVC.h
//  CoreDataPractice
//
//  Created by Manish Kumar on 17/08/15.
//  Copyright (c) 2015 Innofied Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Date.h"
#import "Location.h"

@interface LocationDataVC : UIViewController<UITableViewDataSource , UITableViewDelegate>{
    NSMutableArray *arrayForLocationData;
}

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end
