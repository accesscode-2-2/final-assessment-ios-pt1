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
#import "MapTableViewCell.h"

@interface ViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
MKMapViewDelegate
>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *zoomInButton;
@property (weak, nonatomic) IBOutlet UIButton *zoomOutButton;

@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, assign) BOOL foundPlaces;

@property (nonatomic) NSArray *venues;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    UINib *nib = [UINib nibWithNibName:@"MapTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BeepBoopCellIdentifier"];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setupUI];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.locationManager requestWhenInUseAuthorization];
}

-(void)setupUI{
    [[self.zoomInButton layer] setBorderWidth:2.0f];
    [[self.zoomInButton layer] setBorderColor:[UIColor darkGrayColor].CGColor];
    
    [[self.zoomOutButton layer] setBorderWidth:2.0f];
    [[self.zoomOutButton layer] setBorderColor:[UIColor darkGrayColor].CGColor];
}

# pragma mark - Table view datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.venues.count != 0) {
    return self.venues.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeepBoopCellIdentifier"];
    
    NSDictionary *venue = self.venues[indexPath.row];
    NSString *name = venue[@"name"];
    cell.title.text = name;
    if (venue[@"contact"][@"phone"]) {
        cell.phoneNumber.tintColor = [UIColor blueColor];
    [cell.phoneNumber setTitle:venue[@"contact"][@"phone"] forState:UIControlStateNormal];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSLog(@"cell %@",cell.textLabel.text);

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
                                     NSLog(@"data %@",data);
                                     weakSelf.venues = data;
                                     [weakSelf.tableView reloadData];
                                     [weakSelf showPins];
                                     
                                 }];
}

- (void)showPins
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    for (NSDictionary *venue in self.venues) {
        double lat = [venue[@"location"][@"lat"] doubleValue];
        double lng = [venue[@"location"][@"lng"] doubleValue];
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(lat, lng);
        point.title = venue[@"name"];
        [self.mapView addAnnotation:point];
    }
}

# pragma mark - IBActions

- (IBAction)zoomInButtonPressed:(UIButton *)sender {
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta /= 2.0;
    region.span.longitudeDelta /= 2.0;
    [self.mapView setRegion:region animated:YES];
}
- (IBAction)zoomOutButtonPressed:(UIButton *)sender {
    MKCoordinateRegion region = self.mapView.region;
    region.span.latitudeDelta  = MIN(region.span.latitudeDelta  * 2.0, 180.0);
    region.span.longitudeDelta = MIN(region.span.longitudeDelta * 2.0, 180.0);
    [self.mapView setRegion:region animated:YES];
}

@end
