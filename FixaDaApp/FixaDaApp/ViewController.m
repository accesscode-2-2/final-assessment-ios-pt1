//
//  ViewController.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/14/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "FoursquareAPIManager.h"
#import "Venue.h"

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
CLLocationManagerDelegate,
MKMapViewDelegate
>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL foundPlaces;

@property (nonatomic) NSArray *venues;

@property (nonatomic) NSString *latitude;
@property (nonatomic) NSString *longitude;

@property (nonatomic) NSMutableArray *soTired;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Table view delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Map view delegates
    self.mapView.delegate = self;
    
    // Initiate location manager
    self.locationManager = [[CLLocationManager alloc] init];
    
    // Location delegates
    self.locationManager.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // Request user to use location services
    [self.locationManager requestWhenInUseAuthorization];
    
    // Start updating user's current location
    // Will activate the location manager
    [self.locationManager startUpdatingLocation];
    

}

# pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.soTired.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeepBoopCellIdentifier"];
    
    
    Venue *ughh = [self.soTired objectAtIndex:indexPath.row];
    
    cell.textLabel.text = ughh.title;
    

    return cell;
}

# pragma mark - Get Current Location

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    CLLocation *location = locations.lastObject;
    NSLog(@"%f %f", location.coordinate.latitude, location.coordinate.longitude);
    
    [FoursquareAPIManager findSomething:@"music" atLocation:location completion:^(NSMutableArray *data) {
        
        self.soTired = data;
        
        NSLog(@"%@", self.soTired);
        
        [self showPins];

        [self.tableView reloadData];
        
        
    }];
    
    [self.locationManager stopUpdatingLocation];
    
}


# pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.foundPlaces) {
        self.foundPlaces = YES;
        
        [self zoomToLocation:userLocation.location];

    }
}

- (void)zoomToLocation:(CLLocation *)location {
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f,0.05f);
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateRegion region = {coordinate, span};
    MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
    [self.mapView setRegion:regionThatFits animated:YES];
    
}


- (void)showPins {
    
    for (Venue *venue in self.soTired){

        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(venue.latitude, venue.longitude);
        [self.mapView addAnnotation:point];
    }
    
}

@end
