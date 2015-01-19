
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <Preferences/Preferences.h>
#import <UIKit/UIKit.h>

#define MY_COLOR  [UIColor colorWithRed:22/255.0f green:22/255.0f blue:22/255.0f alpha:1.0f]

@interface PSListController (CopyCurrentPlaying)
	-(UIView*)view;
	-(UINavigationController*)navigationController;
	-(void)viewWillAppear:(BOOL)animated;
	-(void)viewWillDisappear:(BOOL)animated;

	- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
	- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
	-(UINavigationController*)navigationController;

	-(void)loadView;
@end

@interface UIImage (CopyCurrentPlaying)
	+ (UIImage *)imageNamed:(NSString *)named inBundle:(NSBundle *)bundle;
@end

@interface CopyCurrentPlayingListController: PSListController {
}
@end


@implementation CopyCurrentPlayingListController
	-(void)loadView
	{
		[super loadView];

		// NSLog(@"CCP (PREF): LOAD VIEW CALLED,  ADDING HEART");
		UIImage* image = [UIImage imageNamed:@"heart.png" inBundle:[NSBundle bundleForClass:self.class]];
		CGRect frameimg = CGRectMake(0, 0, image.size.width, image.size.height);
		UIButton *someButton = [[UIButton alloc] initWithFrame:frameimg];
		[someButton setBackgroundImage:image forState:UIControlStateNormal];
		[someButton addTarget:self action:@selector(heartBeat)
			 forControlEvents:UIControlEventTouchUpInside];
		[someButton setShowsTouchWhenHighlighted:YES];
		UIBarButtonItem *heartButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];

		UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
		negativeSpacer.width = -16;
		[self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, heartButton, nil] animated:NO];
		[self setupHeader];
		[UISwitch appearanceWhenContainedIn:self.class, nil].onTintColor = MY_COLOR;
		[UISwitch appearanceWhenContainedIn:self.class, nil].tintColor = MY_COLOR;
	}


	-(void) heartBeat
	{
		// NSLog(@"CCP (PREF): I CAN FEEL YOUR HEARTBEAT !!!");
		SLComposeViewController *twitter = [[SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter] retain];
		[twitter setInitialText:@"#CopyCurrentPlaying by @VasuChawla is awesome!"];
		if (twitter != nil){
			NSLog(@"CCP (PREF): TWEETY LOVES ME !!!");
			[[self navigationController] presentViewController:twitter animated:YES completion:nil];

		}
		// NSLog(@"CCP (PREF): I LOVE YOU TOO TWEETY  !!!");
		[twitter release];
	}

	- (void)viewWillAppear:(BOOL)animated {
		// NSLog(@"CCP (PREF): LETS ADD SOME KETCHUP !!!");
		self.view.tintColor = MY_COLOR;
		self.navigationController.navigationBar.tintColor = MY_COLOR;
		self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: MY_COLOR};
		self.navigationController.navigationBar.tintColor = MY_COLOR;
	}

	- (void)viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
		self.view.tintColor = nil;
	}
	-(void) setupHeader
	{
		// NSLog(@"CCP (PREF): BRANDING, SIR !!!");
		UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];

		UIImage *headerImage = [UIImage imageNamed:@"CCP.png" inBundle:[NSBundle bundleForClass:self.class]];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:headerImage];
		imageView.frame = CGRectMake(imageView.frame.origin.x, 10, imageView.frame.size.width, 75);

		[headerView addSubview:imageView];
		[self.table setTableHeaderView:headerView];
	}


	- (id)specifiers {
		if(_specifiers == nil) {
			_specifiers = [[self loadSpecifiersFromPlistName:@"CopyCurrentPlaying" target:self] retain];
		}
		return _specifiers;

	}

	-(void)twitter {
		// NSLog(@"CCP (PREF): SEE MY TWEETS !!!");
		if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=VasuChawla"]]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=VasuChawla"]];
		} else {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/VasuChawla"]];
		}
	}

	-(void)my_site {
		// NSLog(@"CCP (PREF): SEE MY WORK !!!");
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.vasuchawla.com"]];
	}

	-(void)donate {
		// NSLog(@"CCP (PREF): HELP ME EAT !!!");
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=HJAWL8WG8RVSA"]];
	}
	-(void) sendEmail{
		// NSLog(@"CCP (PREF): DISTRACT ME FROM MY WORK !!!");
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:vchawla26@gmail.com?subject=CopyCurrentPlaying"]];
	}
	-(void)save{
		// NSLog(@"CCP (PREF): NOW THATS GONNA DO SOMETHING NEW !!!");
		[self.view endEditing:YES];
	}
@end
