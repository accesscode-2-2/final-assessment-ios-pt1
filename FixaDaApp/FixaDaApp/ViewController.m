//
//  ViewController.m
//  FixaDaApp
//
//  Created by Michael Kavouras on 2/14/16.
//  Copyright © 2016 Michael Kavouras. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FoursquareAPIManager.h"
#import "APIManager.h"

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
MKMapViewDelegate
>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL foundPlaces;

@property (nonatomic) NSArray *venues;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.mapView.delegate = self;
    
    self.venues = @[ @"I", @"had", @"a", @"difficult", @"time", @"passing", @"the", @"api", @"results", @"back", @"to", @"this", @"view", @"controller"];

//    NSString *searchTerm = @"music";
//    [self.makeNewFourSquareAPIRequestWithSearchTerm:searchTerm callbackBlock:^{ //make an API request
//        [self.tableView reloadData]; // reload table data
//    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.locationManager requestWhenInUseAuthorization];
}


# pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeepBoopCellIdentifier"];

// original info:
//    NSDictionary *venue = self.venues[indexPath.row];
//    NSString *name = venue[@"name"]; // this comes from the api call...
//    cell.textLabel.text = name;
    
    NSString *venueToPass = self.venues[indexPath.row];
    cell.textLabel.text = venueToPass;
    
    return cell;
}

# pragma mark - Map view delegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.foundPlaces) {
        self.foundPlaces = YES;
        
        [self zoomToLocation:userLocation.location];
        [self fetchVenuesAtLocation:userLocation.location];
    }
}

- (void)zoomToLocation:(CLLocation *)location
{
    MKCoordinateSpan span = MKCoordinateSpanMake(0.05f,0.05f);
    CLLocationCoordinate2D coordinate = location.coordinate;
    MKCoordinateRegion region = {coordinate, span};
    MKCoordinateRegion regionThatFits = [self.mapView regionThatFits:region];
    [self.mapView setRegion:regionThatFits animated:YES];
}

- (void)fetchVenuesAtLocation:(CLLocation *)location
{
        __weak typeof(self) weakSelf = self;
        [FoursquareAPIManager findSomething:@"music"
                                 atLocation:location
                                 completion:^(NSArray *data){
                                     
                                     weakSelf.venues = data;
                                     [weakSelf.tableView reloadData];
                                     [weakSelf showPins];
                                     
                                 }];
}

- (void)showPins
{
//    [self.mapView removeAnnotations:self.mapView.annotations];
    
//    for (NSDictionary *venue in self.venues) {
//        double lat = [venue[@"location"][@"lat"] doubleValue];
//        double lng = [venue[@"location"][@"lng"] doubleValue];
        
        double lat = [@"37.323605" doubleValue];
        double lng = [@"-122.023448" doubleValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(lat, lng);
        [self.mapView addAnnotation:point];
//    }
}


@end
