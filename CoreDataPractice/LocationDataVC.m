//
//  LocationDataVC.m
//  CoreDataPractice
//
//  Created by Manish Kumar on 17/08/15.
//  Copyright (c) 2015 Innofied Solutions Pvt. Ltd. All rights reserved.
//

#import "LocationDataVC.h"

@interface LocationDataVC ()

@end

@implementation LocationDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableview.delegate = self;
    _tableview.dataSource = self;
    
    //arry for location data
    arrayForLocationData = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self getLocationDataFromCoreData];
}

-(void)getLocationDataFromCoreData{
    AppDelegate *appDelegate=(AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context=[appDelegate managedObjectContext];
    
    //creating entities for loaction and date
    NSEntityDescription *entityForDate=[NSEntityDescription entityForName:@"Date" inManagedObjectContext:context];
    
    //initializing a fetch request for the entity
    NSFetchRequest *request=[[NSFetchRequest alloc]init];
    [request setEntity:entityForDate];
    
    
    //set the search predicate
    NSPredicate *predicate=nil; //will load all the statements from core data list
    [request setPredicate:predicate];
    
    NSError *error;
    
    NSArray *dateArray=[context executeFetchRequest:request error:&error];
    
    
    for (Date *date in dateArray)
    {
        Location* location = (Location*)[[date.dateForLocation allObjects] objectAtIndex:0];
        
        NSString *stringDate = [self getDateStringFromDate:date.date withFormat:@"dd MMM, yyyy"];
        
        BOOL isDatePresent = NO;
        int index = -1;
        
        if (arrayForLocationData.count > 0) {
            //get all keys from the array
            
            for (int i=0; i<arrayForLocationData.count; i++) {
                
                //iterating through array data
                if ([arrayForLocationData[i] isKindOfClass:[NSDictionary class]]) {
                    
                    //checking for date in terms of keys
                    NSDictionary *locationDictionary = arrayForLocationData[i];
                    
                    NSMutableDictionary *dictionary = [locationDictionary mutableCopy];
                    
                    if (dictionary.allKeys.count > 0) {
                        
                        //compare date string
                        if ([dictionary.allKeys.lastObject isEqualToString:stringDate]) {
                            index = i;
                            isDatePresent = YES;
                            break;
                        }else{
                            continue;
                        }
                    }
                }
            }
            
            //is date is not present then add the new date in array
            if (!isDatePresent) {
                NSArray *dataArray = @[location];
                
                NSDictionary *locationDictionary = [[NSDictionary alloc]initWithObjects:@[dataArray] forKeys:@[stringDate]];
                
                [arrayForLocationData addObject:locationDictionary];

            }else{
                
                //adding the loaction data in the dictionary and then adding the dictionary in array
                NSDictionary *locationDictionary = arrayForLocationData[index];
                
                NSMutableDictionary *dictionary = [locationDictionary mutableCopy];

                //add data to array of locations
                if ([[dictionary.allValues lastObject] isKindOfClass:[NSArray class]]) {
                    //getting location array and adding the location in the array
                    NSArray *locationArray = dictionary.allValues.lastObject;
                    
                    NSMutableArray *newLocationArray = [locationArray mutableCopy];
                    [newLocationArray addObject:location];
                    locationArray = [newLocationArray copy];
                    
                    [dictionary removeObjectForKey:stringDate];
                    [dictionary setObject:locationArray forKey:stringDate];
                    
                    locationDictionary = [dictionary copy];
                    arrayForLocationData[index] = locationDictionary;
                }
            }
        }else{
            //creating an object with single location data
            NSArray *dataArray = @[location];
            
            NSDictionary *locationDictionary = [[NSDictionary alloc]initWithObjects:@[dataArray] forKeys:@[stringDate]];
            
            [arrayForLocationData addObject:locationDictionary];
        }
    }
}

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return arrayForLocationData.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSDictionary *dictionary = arrayForLocationData[section];
    NSArray *allValues = [dictionary allValues].lastObject;
    return allValues.count;
}

#pragma mark - table view delegates
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSDictionary *dictionary = arrayForLocationData[section];
    NSString *stringkey = [dictionary allKeys].lastObject;
    return stringkey;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dictionary = arrayForLocationData[indexPath.section];
    NSArray *allValues = [dictionary allValues].lastObject;

    Location *locationData  = [allValues objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", locationData.latitude, locationData.longitude];
    
    
    
    return cell;

}



-(NSString*)getDateStringFromDate:(NSDate*)date withFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:dateFormat];
    
    return [dateFormatter stringFromDate:date];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
