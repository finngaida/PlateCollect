//
//  FGDetailViewController.m
//  PlateCollect
//
//  Created by Niklas Riekenbrauck on 07.09.13.
//  Copyright (c) 2013 Finn Gaida. All rights reserved.
//

#import "FGDetailViewController.h"

@interface FGDetailViewController ()

@end

@implementation FGDetailViewController
@synthesize stone = _stone;


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    //[self createNameView];                              FOR WHATEVER REASON CRASHES  A L L  T H E  F U C K I N G  T I M E!!!!
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"SpecialCell"];
    self.tableView.tableFooterView = [UIView new];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor darkGrayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Helvetica" size:20];
    //[title setAttributedText:[self createNameViewString]];
    if (self.stone.firstName && self.stone.lastName) {
        title.text = [NSString stringWithFormat:@"%@, %@", _stone.lastName, _stone.firstName];
    }
    [self.navigationController.navigationBar addSubview:title];
}

-(NSAttributedString *)createNameViewString {
    
    //Design des Textes
    NSMutableAttributedString* nameString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", _stone.lastName, _stone.firstName]];
    int nameEndIndex = [_stone.lastName length] - 1;
    NSRange namePosition = NSMakeRange(0, nameEndIndex);
    
    
    NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];
    
    [nameString beginEditing];
    [nameString addAttribute:NSFontAttributeName
                       value:boldFontName
                       range:namePosition];
    [nameString endEditing];

    return nameString;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 4;
    } else {
        int count = _stone.deportations.count;
        if (_stone.placeOfDeath && _stone.dayOfDeath) {
            count++;
        }
        return count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return NSLocalizedString(@"Allgemein", nil);
    } else {
        return NSLocalizedString(@"Daten", nil);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Dynamische Zelllen sind die für Deportationen etc.
    static NSString *CellIdentifier = @"SpecialCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //Statische Zellen werden automatisch gesetzt
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = NSLocalizedString(@"Geburtsname", nil);
                cell.detailTextLabel.text = _stone.bornName;
                break;
            }
            case 1: {
                cell.textLabel.text = NSLocalizedString(@"Geburstag", nil);
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd.MM.YY"];
                cell.detailTextLabel.text = [formatter stringFromDate:_stone.birthday];
                break;
            }
            case 2: {
                cell.textLabel.text = NSLocalizedString(@"Adresse", nil);
                cell.detailTextLabel.text = _stone.address;
                break;
            }
            case 3: {
                cell.textLabel.text = NSLocalizedString(@"Ortsteil", nil);
                cell.detailTextLabel.text = _stone.quarter;
                break;
            }
                
            default:
                break;
        }
    } else {
        //ImageView für das TimeLineBild
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 44, 44)];
        [cell.contentView addSubview:imageView];
        
        // clear background color, so the image is visible
        cell.textLabel.backgroundColor = [UIColor clearColor];
        
        if (indexPath.row < _stone.deportations.count) {
            //Bild für die Timeline setzen
            UIImage *image = [UIImage imageNamed:@"timline_deporatation.png"];
            [imageView setImage:image];
            
            //Text für Deporatationen
            cell.textLabel.text = [NSString stringWithFormat:@"%i. Deport.", indexPath.row+1];
            
            NSDictionary *dict;
            if (_stone.deportations.count >= indexPath.row) {
                dict = [_stone.deportations objectAtIndex:indexPath.row];
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.YY"];
            NSString *date = [formatter stringFromDate:dict[@"date"]];
            NSString *detailTextLabel;
            
            if (date != NULL) {
                detailTextLabel = [NSString stringWithFormat:@"%@ (%@)",dict[@"place"], date];
            } else {
                detailTextLabel = NSLocalizedString(@"Keine Angabe", nil);
            }
            cell.detailTextLabel.text = detailTextLabel;
            
        } else {
            UIImage *image = [UIImage imageNamed:@"timeline_death.png"];
            [imageView setImage:image];
            
            //Text für Tod setzen
            cell.textLabel.text = NSLocalizedString(@"Tod", nil);
            if (_stone.dayOfDeath && _stone.placeOfDeath) {
                NSString *detailText;
                if (_stone.placeOfDeath) {
                    detailText = _stone.placeOfDeath;
                    if (_stone.dayOfDeath) {
                        
                        if (_stone.dayOfDeath != NULL) {
                            NSString *dayOfDeathFormatted = [NSString stringWithFormat:@" (%@)", _stone.dayOfDeath];
                            detailText = [detailText stringByAppendingString:dayOfDeathFormatted];
                        } else {
                            detailText = NSLocalizedString(@"Keine Angabe", nil);
                        }
                    }
                } else {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd.MM.YY"];
                    detailText = [formatter stringFromDate:_stone.dayOfDeath];
                }
                
            } else {
                cell.detailTextLabel.text = NSLocalizedString(@"Keine Angabe", nil);
            }
        }

    }
    return cell;
}
@end
