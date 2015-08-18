//
//  ViewController.m
//  CoreDataPractice
//
//  Created by Manish Kumar on 17/08/15.
//  Copyright (c) 2015 Innofied Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.'
    
    
    //---display the map in a region---//
    _mapview.mapType = MKMapTypeStandard;
    _mapview.delegate=self;

    
    //register for location change notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getnewUserLocation:) name:@"kLocationChangeNotification" object:nil];
}


-(void)getnewUserLocation:(NSNotification *)notification{
    
    //getting the new location through notification
    CLLocation *newLocation = [notification.userInfo objectForKey:@"location"];
    
    
    //setting map view coordinates for user
    MKCoordinateSpan span;
    span.latitudeDelta = .001;
    span.longitudeDelta = .001;
    MKCoordinateRegion region;
    region.center = newLocation.coordinate;
    region.span = span;
    [_mapview setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    

    //save the location to core data.
    [self saveLocationToCoreData:newLocation];
}


-(void)saveLocationToCoreData:(CLLocation *)location{
    
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    
    //creating entities for location and date
    NSEntityDescription *entityForDate=[NSEntityDescription entityForName:@"Date" inManagedObjectContext:context];
    
    NSEntityDescription *entityForLocation=[NSEntityDescription entityForName:@"Location" inManagedObjectContext:context];
    
    //initializing coredata classes with entities
    Date *dateToUpdate =[[Date alloc]initWithEntity:entityForDate insertIntoManagedObjectContext:context];
    
    Location *locationToUpdate =[[Location alloc]initWithEntity:entityForLocation insertIntoManagedObjectContext:context];
    
    //assigning new location values in core data object
    locationToUpdate.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
    locationToUpdate.longitude=[NSString stringWithFormat:@"%f",location.coordinate.longitude ];
    
    //creating date to save
    [dateToUpdate setValue:[NSDate date] forKey:@"date"];
    
    //creting locations to save
    [locationToUpdate setValue:locationToUpdate.latitude forKey:@"latitude"];
    [locationToUpdate setValue:locationToUpdate.longitude forKey:@"longitude"];
    
    //creating locations for a particular date
    dateToUpdate.dateForLocation=[NSSet setWithObjects:locationToUpdate, nil];
    
    //saving the object
    NSError *error;
    [context save:&error];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
