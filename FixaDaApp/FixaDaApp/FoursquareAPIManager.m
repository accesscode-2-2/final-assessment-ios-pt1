//
//  FoursquareAPIManager.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/15/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "FoursquareAPIManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Venue.h"


#define kFoursquareAPIClientID     @"GWKJBVWFYBJQ02T3TRBB4VBL24AIO4TCMJCGIQ5ADKVKJXGP"
#define kFoursquareAPIClientSecret @"2WMEZCDQNKNB5XAE5F4BY1VHBK1HITYRU1JEVCOAD2QRLXDJ"

@implementation FoursquareAPIManager

/**
 
 https://api.foursquare.com/v2/venues/search
 ?client_id=CLIENT_ID
 &client_secret=CLIENT_SECRET
 &v=20130815
 &ll=40.7,-74
 &query=sushi
 
**/

+ (void)findSomething:(NSString *)query
           atLocation:(CLLocation *)location
           completion:(void(^)(NSMutableArray *data))completion {
    
    
    
    NSMutableArray *listOfPlaces = [[NSMutableArray alloc]init];
    

    NSString *url = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search?client_id=%@&client_secret=%@&v=20160215&ll=%f,%f&query=%@", kFoursquareAPIClientID, kFoursquareAPIClientSecret, location.coordinate.latitude, location.coordinate.longitude, query];
    
    NSLog(@"%@", url);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject)
    {
        
        NSDictionary *response = [responseObject objectForKey:@"response"];
        NSDictionary *venues = [response objectForKey:@"venues"];
        
        for (NSDictionary *result in venues){
            
            NSString *lngString = [[result objectForKey:@"location"] objectForKey:@"lng"];
            NSString *latString =  [[result objectForKey:@"location"] objectForKey:@"lat"];
            double lat = [latString doubleValue];
            double lng = [lngString doubleValue];
            
            NSString *name = [result objectForKey:@"name"];
            NSString *address = [[result objectForKey:@"location"]objectForKey:@"address"];
            
            Venue *addThisVenue = [[Venue alloc]init];
            addThisVenue.title = name;
            addThisVenue.address = address;
            addThisVenue.latitude = lat;
            addThisVenue.longitude = lng;
            
            NSLog(@"%@", addThisVenue.title);
            [listOfPlaces addObject:addThisVenue];
            
        }
        
        completion(listOfPlaces);
        
    } failure:^(NSURLSessionTask *operation, NSError *error)
    {
        NSLog(@"Error: %@", error);
    }];

}

@end
