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



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // show Navigation bar
    self.navigationController.navigationBarHidden = NO;
    
    //Design auf die View Elemente anwenden
    NSMutableAttributedString* nameString = self.nameLabel.attributedText.mutableCopy;
    NSArray *words = [self.nameLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    int nameEndIndex = [[words objectAtIndex:0] length] - 1;
    NSRange namePosition = NSMakeRange(0, nameEndIndex);
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    NSString *boldFontName = [[UIFont boldSystemFontOfSize:12] fontName];

    [nameString beginEditing];
    [nameString addAttribute:NSFontAttributeName
                       value:boldFontName
                       range:namePosition];
    [nameString endEditing];
    self.nameLabel.attributedText = nameString;
    
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
        return @"Allgemein";
    } else {
        return @"Daten";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Dynamische Zelllen sind die für Deportationen etc.
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //Statische Zellen werden automatisch gesetzt
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                cell.textLabel.text = @"Geburtsname";
                cell.detailTextLabel.text = _stone.bornName;
                break;
            }
            case 1: {
                cell.textLabel.text = @"Geburstag";
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"dd.MM.YY"];
                cell.detailTextLabel.text = [formatter stringFromDate:_stone.birthday];
                break;
            }
            case 2: {
                cell.textLabel.text = @"Adresse";
                cell.detailTextLabel.text = _stone.address;
                break;
            }
            case 3: {
                cell.textLabel.text = @"Ortsteil";
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
        
        if (indexPath.row < _stone.deportations.count) {
            //Bild für die Timeline setzen
            UIImage *image = [UIImage imageNamed:@"timline_deporatation.png"];
            [imageView setImage:image];
            
            //Text für Deporatationen
            cell.textLabel.text = [NSString stringWithFormat:@"%i. Deport.", indexPath.row];
            
            NSDictionary *dict = [_stone.deportations objectAtIndex:indexPath.row];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"dd.MM.YY"];
            NSString *date = [formatter stringFromDate:dict[@"date"]];
            NSString *detailTextLabel = [NSString stringWithFormat:@"%@ (%@)",dict[@"place"], date];
            cell.detailTextLabel.text = detailTextLabel;
        } else {
            UIImage *image = [UIImage imageNamed:@"timline_death.png"];
            [imageView setImage:image];
            
            //Text für Tod setzen
            cell.textLabel.text = @"Tod";
            if (_stone.dayOfDeath && _stone.placeOfDeath) {
                NSString *detailText;
                if (_stone.placeOfDeath) {
                    detailText = _stone.placeOfDeath;
                    if (_stone.dayOfDeath) {
                        NSString *dayOfDeathFormatted = [NSString stringWithFormat:@" (%@)", _stone.dayOfDeath];
                        detailText = [detailText stringByAppendingString:dayOfDeathFormatted];
                    }
                } else {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    [formatter setDateFormat:@"dd.MM.YY"];
                    detailText = [formatter stringFromDate:_stone.dayOfDeath];
                }
                
            } else {
                cell.detailTextLabel.text = @"Keine Angaben";
            }
        }

    }
    return cell;

}
@end
