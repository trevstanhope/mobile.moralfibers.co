//
//  FirstViewController.m
//  Moral Fibers
//
//  Created by Joseph Pintozzi on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"
#import "WebBrowserViewController.h"
#import "ASIFormDataRequest.h"
#import "CCJSONParser.h"

#define kUsernameTag    100
#define kPasswordTag    200

@implementation FirstViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Do any additional setup after loading the view from its nib.
	//set our text in our nav bar
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 360, 44)];
	label.backgroundColor = [UIColor clearColor];
	//label.font = [UIFont fontWithName:@"Rabbit On The Moon" size:kNavFontSize];
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:kNavFontSize];
	label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
	label.textAlignment = UITextAlignmentCenter;
	label.textColor =[UIColor whiteColor];
	label.text = @"Moral Fibers";
	//set it in our nav bar
	navItem.titleView = label;
	[label release];
}



-(IBAction)scan:(id)sender{
    //check to make sure we have a valid login
    bool active = [[NSUserDefaults standardUserDefaults] boolForKey:kWorkingLogin];
    if (!active) {
        [self displayUserLogin];
        return;
    }
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.readerView.torchMode = FALSE;
    [reader.scanner setSymbology: 0
                          config: ZBAR_CFG_ENABLE
                              to: 0];
    [reader.scanner setSymbology: ZBAR_QRCODE
                          config: ZBAR_CFG_ENABLE
                              to: 1];
    reader.readerView.zoom = 1.0;
    [self presentModalViewController:reader animated:YES];
}

-(void)displayUserLogin{
    UIAlertView *loginView = [[[UIAlertView alloc] initWithTitle:@"Please Login" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] autorelease];
    
    //Add in our text fields
    UITextField* text = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
	text.borderStyle = UITextBorderStyleRoundedRect;
	text.tag = kUsernameTag;
    [text setAutocorrectionType:UITextAutocorrectionTypeNo];
    [text setPlaceholder:@"Username"];
	[loginView addSubview:text];
    
    UITextField* text2 = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 72.0, 245.0, 25.0)];
	text2.borderStyle = UITextBorderStyleRoundedRect;
	text2.tag = kPasswordTag;
    [text2 setAutocorrectionType:UITextAutocorrectionTypeNo];
	[text2 setSecureTextEntry:YES];
    [text2 setPlaceholder:@"Password"];
	[loginView addSubview:text2];
    
    [loginView show];
    [text becomeFirstResponder];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 0) {
		return;
	}
    //try to login
    NSString *username = [NSString stringWithFormat:@"\"%@\"", ((UITextView*)[alertView viewWithTag:kUsernameTag]).text];
    NSString *password = [NSString stringWithFormat:@"\"%@\"", ((UITextView*)[alertView viewWithTag:kPasswordTag]).text];
    
    //try to login
    ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:kAPIURL]];
	[post setPostValue:kAPIKey forKey:kAPI];
	[post setPostValue:kUserLogin forKey:kMethod];
    [post setPostValue:username forKey:kUsername];
    [post setPostValue:password forKey:kPassword];
	[post setPostValue:kAPIDomain forKey:kDomain];
	[post setDelegate:self];
	[post startSynchronous];
    
    NSError *error = [post error];
	if (!error) {
		NSString *response = [post responseString];
		NSLog(@"Response string: %@", response);
        //make sure we don't have an error
        NSDictionary *responseDict = [CCJSONParser objectFromJSON:response];
        if([[responseDict objectForKey:kErrorKey] boolValue] == TRUE || [[[responseDict objectForKey:kDataKey] objectForKey:kErrorKey] boolValue] == TRUE){
            //crap, error, return
            [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid login" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
            return;
        }
        
        //looks like we have  valid login! store this info
        [[NSUserDefaults standardUserDefaults] setValue:username forKey:kNSDUsername];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:kNSDPassword];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:kWorkingLogin];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[[[UIAlertView alloc] initWithTitle:@"Success" message:@"You can now scan a QR code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
    
}

-(IBAction)openWebpage:(id)sender{
	WebBrowserViewController *browser = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    [browser setInitialURL:[NSURL URLWithString:kBaseURL]];
    [self presentModalViewController:browser animated:YES];
}

- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    id<NSFastEnumeration> results =	[info objectForKey: ZBarReaderControllerResults];
    //UIImage *image = [info objectForKey: UIImagePickerControllerOriginalImage];
	[reader dismissModalViewControllerAnimated:YES];
	
	ZBarSymbolSet *symbols = (ZBarSymbolSet*)results;
	for(ZBarSymbol *symbol in symbols) {
        /*
		UIAlertView *scanned = [[[UIAlertView alloc] initWithTitle:@"Scanned Code" message:symbol.data delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
        [scanned show];*/
		
		NSArray *urlParts = [symbol.data componentsSeparatedByString:@"?"];
		if ([urlParts count] > 1) {
			//check for params
			NSArray *params = [[urlParts objectAtIndex:1] componentsSeparatedByString:@"&"];
			if ([params count] > 1) {
				//now check for serial
				NSArray *parts = [[params objectAtIndex:0] componentsSeparatedByString:@"="];
				if ([parts count] > 1) {
					NSString *serial = [parts objectAtIndex:1];
					NSLog(@"QR Serial Code: %@", serial);
					//we have a serial code!!
					//call the server to save this shit
                    
                    NSString *username = [[[NSUserDefaults standardUserDefaults] objectForKey:kNSDUsername] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    //http://moralfibers.co/iphone/qr.php?qr=1000000885&update=1&active=Active&author=alex.cox
                    NSString *qrCodeActivateData = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@iphone/qr.php?qr=%@&update=1&active=Active&author=%@", kBaseURL, serial, username]] encoding:NSUTF8StringEncoding error:nil];
					NSLog(@"Got back from QRCode activation: %@", qrCodeActivateData);
                    
                    NSString *nodeCheck = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kNodeByTitleURL, serial]] encoding:NSUTF8StringEncoding error:nil];
                    
					NSLog(@"Node Check: %@", nodeCheck);
					
					//see if we've gotten false back
					if ([@"false" isEqualToString:nodeCheck]) {
						[[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong.  Please try loging in again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
						//mark this as an invalid login
						[[NSUserDefaults standardUserDefaults] setBool:NO forKey:kWorkingLogin];
						return;
					}
                    NSDictionary *nodeDictionary = [CCJSONParser objectFromJSON:nodeCheck];
                    NSString *nodeOwner = [nodeDictionary objectForKey:@"name"];
					NSLog(@"Shirt owner found to be: %@", nodeOwner);
                    
                    //make sure the marked owner of this QR code is correct
                    if([nodeOwner isEqualToString:username]){
                        [[[[UIAlertView alloc] initWithTitle:@"QR Code Activated" message:@"This QR code is now tied to your account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                    } else {
                        [[[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong.  Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                    }
				}
			}
		}
		
        break;
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

-(void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
	//[website setFont:[UIFont fontWithName:@"Rabbit On The Moon" size:website.font.pointSize]];
	[website.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kButtonSize]];
	//[scan setFont:[UIFont fontWithName:@"Rabbit On The Moon" size:scan.font.pointSize]];
	[scan.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kButtonSize]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [super dealloc];
}

@end
