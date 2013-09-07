//
//  FGViewController.m
//  PlateCollect
//
//  Created by Finn Gaida on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGViewController.h"

@implementation FGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpSettingsDrag];
    
    self.mapView.delegate = self;
    
    FGStuffCalculator *c = [FGStuffCalculator new];
    [c fetchCurrentLocationWithHandler:^(CLLocation *location, NSError *error) {
        [self.mapView setRegion:MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(.5, .5)) animated:YES];
        
        // Fetch the 30 nearest placemarks from the location parameter and create FGStolperstein 's for it
        
        // loop through them and add the annotations
        /*for (FGStolperstein *s in stolpersteine) {
            FGAnnotation *a = [[FGAnnotation alloc] initWithTitle:s.name andCoordinate:s.coord];
        }*/
        
        
    }];
    
}

- (void)setUpSettingsDrag {
    
    // Create the gesture recognizer and put it on a new view, represnting the drag-start area.
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 600)]; v.backgroundColor = [UIColor clearColor];
    [self.view addSubview:v];
    [v addGestureRecognizer:pan];
    
    
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan: {
            
        } break;
        case UIGestureRecognizerStateChanged: {
        
        } break;
        case UIGestureRecognizerStateEnded: {
        
        } break;
        default:break;
    }
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id < MKAnnotation >)annotation {
    
    // Check if the wanted annotation is the users location
    if ([annotation isKindOfClass:[MKUserLocation class]]) {return nil;}
    
    MKAnnotationView *a = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
    //a.image = ...;
    a.canShowCallout = YES;
    a.draggable = NO;
    a.leftCalloutAccessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    return a;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    [self performSegueWithIdentifier:@"showDetailView" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
    FGDetailViewController *detail = [[FGDetailViewController alloc] init];
    detail.name.text = @"Doe John";
    segue.destinationViewController = detail;
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
