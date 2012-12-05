//
//  thermoViewViewController.m
//  screetch
//
//  Created by Niklas Nordin on 2012-10-23.
//  Copyright (c) 2012 Niklas Nordin. All rights reserved.
//

#import "screetchViewController.h"

static float windowWidth = 300.0;
static float windowHeight = 300.0;

@interface screetchViewController ()
@property (strong, nonatomic) NSString *baseURL;
@end

@implementation screetchViewController


-(void)setAllButtonNames
{
    //NSLog(@"setAllButtonNames");
    NSLog(@"buttonNames = %@",_buttonNames);

    NSString *name1 = [_buttonNames objectAtIndex:0];
    NSLog(@"name1 = %@",name1);
    NSString *localName1 = NSLocalizedString(name1, @"comment for what");
    NSLog(@"localName1 = %@",localName1);
    [_button1 setTitle:name1 forState:UIControlStateNormal];
    [_button2 setTitle:[_buttonNames objectAtIndex:1] forState:UIControlStateNormal];
    [_button3 setTitle:[_buttonNames objectAtIndex:2] forState:UIControlStateNormal];
    [_button4 setTitle:[_buttonNames objectAtIndex:3] forState:UIControlStateNormal];
    [_button5 setTitle:[_buttonNames objectAtIndex:4] forState:UIControlStateNormal];
    [_button6 setTitle:[_buttonNames objectAtIndex:5] forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pictureView.delegate = self;
    
    _baseURL = @"http://www.nequam.se/screetch";
    NSString *http = @"categories.php";
    [self loadRandomPictureFromURL:http];
    _pictureView.bgImage = _loadedImage;
    _pictureView.bgImageRef = _loadedImage.CGImage;
    [self setAllButtonNames];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self setAllButtonNames];
    NSLog(@"viewDidAppear");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)choiceButtonPressed:(UIButton *)sender
{
    [_pictureView clearAndAnimatePicture];
    usleep(5000);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You selected R" message:@"correct?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Enter", nil];
    
    alert.delegate = self;
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    //[alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    /*
    UITextField *tf = [alert textFieldAtIndex:0];
    tf.delegate = self;
    [tf setClearButtonMode:UITextFieldViewModeWhileEditing];
    [tf setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    //tf.text = [[NSString alloc] initWithFormat:@"%@", num];
    */
    [alert show];
    
}

-(void)setDisplayWithText:(NSString *)text
{
    _display.text = text;
}

-(void)setScoreWithInt:(int)score
{
    _scoreField.text = [[NSString alloc] initWithFormat:@"%d",score];
}

-(void)loadRandomPictureFromURL:(NSString *)name
{
    // structure of the pictures
    // toplevel
    // -- screetch/
    // ---- categories/
    // ------ selections/
    // -------- version/
    // ---------- picture.png
    // ---------- picture.info
    
    NSString *http = [NSString stringWithFormat:@"%@/%@",_baseURL,name];
    NSURL *url = [NSURL URLWithString:http];

    NSData *data = [NSData dataWithContentsOfURL:url];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *categories = [str componentsSeparatedByString:@":"];
    
    int categoryi = arc4random() % [categories count];
    categoryi = 1;
    NSString *categoryName = [categories objectAtIndex:categoryi];
    //NSLog(@"category = %@",categoryName);
    
    NSString *catHttp = [NSString stringWithFormat:@"%@/%@/files.php",_baseURL,categoryName];
    NSURL *catURL = [NSURL URLWithString:catHttp];
    NSData *catData = [NSData dataWithContentsOfURL:catURL];
    NSString *stringForSelectedCategory = [[NSString alloc] initWithData:catData encoding:NSUTF8StringEncoding];
    NSArray *selections= [stringForSelectedCategory componentsSeparatedByString:@":"];

    NSMutableArray *availableSelections = [[NSMutableArray alloc] initWithArray:selections];
    NSMutableArray *selectedForButtons = [[NSMutableArray alloc] initWithCapacity:6];
    // get 6 selections for the buttons
    for (int i=0; i<6; i++)
    {
        int j = arc4random() & ([availableSelections count] - 1);
        [selectedForButtons setObject:[availableSelections objectAtIndex:j] atIndexedSubscript:i];
        [availableSelections removeObjectAtIndex:j];
    }
    _buttonNames = [[NSArray alloc] initWithArray:selectedForButtons];
    int selectioni = arc4random() % [selections count];
    selectioni = 2;
    NSString *selectedName = [selections objectAtIndex:selectioni];
    // chose one of the random names 
    //NSString *selectedName = [selectedForButtons objectAtIndex:selectioni];
    NSLog(@"selected = %@",selectedName);
    
    NSString *selectedHttp = [NSString stringWithFormat:@"%@/%@/%@/files.php",_baseURL,categoryName,selectedName];

    NSURL *selectedURL = [NSURL URLWithString:selectedHttp];
    NSData *selectedData = [NSData dataWithContentsOfURL:selectedURL];
    NSString *stringSelected = [[NSString alloc] initWithData:selectedData encoding:NSUTF8StringEncoding];
    NSArray *selectedArray = [stringSelected componentsSeparatedByString:@":"];
    //NSLog(@"selectedArray =%@",selectedArray);
    int versioni = arc4random() % [selectedArray count];
    NSString *version = [selectedArray objectAtIndex:versioni];
    //NSLog(@"version = %@",version);
    
    
    // the name of the picture is picture.png
    NSString *imageFilename = [NSString stringWithFormat:@"%@/%@/%@/%@/picture.png",_baseURL,categoryName,selectedName,version];
    NSURL *imageURL = [NSURL URLWithString:imageFilename];
    NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
    UIImage *originalImage = [UIImage imageWithData:imageData];
    CGRect rect = CGRectMake(0.0f, 0.0f, windowWidth, windowHeight);
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([originalImage CGImage], rect);
    // read the picture info to get the essential area-rectangle view
    //_loadedImage = [UIImage imageWithData:imageData];
    _loadedImage = [UIImage imageWithCGImage:croppedImageRef];
    
    // the geometry info for the picture is in the file picture.info
    

}
@end
