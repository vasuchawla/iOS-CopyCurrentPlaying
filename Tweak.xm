// #import <SpringBoard/SBMediaController.h>
#import <libactivator/libactivator.h>
#import <UIKit/UIKit.h>
#import "MediaRemote.h"


#define setin_domain CFSTR("com.vasuchawla.CopyCurrentPlaying")



NSMutableString *nowPlayingTitle = [[NSMutableString alloc] initWithCapacity:10];
NSMutableString *nowPlayingArtist = [[NSMutableString alloc] initWithCapacity:10];
NSMutableString *nowPlayingAlbum = [[NSMutableString alloc] initWithCapacity:10];
NSString *frmt  =@"";
NSString *alrt  =@"";

@interface CopyMusicListner : NSObject <LAListener, UIAlertViewDelegate> {
// Class Name ^^ should be changed to the name of your Extension
@private
	UIAlertView *av;

}
@end

@implementation CopyMusicListner


- (BOOL)dismiss
{
 	if (av) {
		[av dismissWithClickedButtonIndex:[av cancelButtonIndex] animated:YES];
		[av release];
		av = nil;
		return YES;
	}
	return NO;
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	[av release];
	av = nil;
}
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event
{
	 NSLog(@"CCP: received action:");
	if (![self dismiss])
	{
		// NSLog(@"CCP: started received action with title: %@ %@ %@ ",nowPlayingTitle,nowPlayingAlbum, nowPlayingArtist);
		if(![nowPlayingTitle isEqual:@""])
		{
			// NSLog(@"CCP: We have something in title, lets paste it...");

			UIPasteboard *appPasteBoard = [UIPasteboard generalPasteboard];
			appPasteBoard.persistent = YES;


			NSString *tmp = [[NSString alloc] initWithString:[[[frmt stringByReplacingOccurrencesOfString:@"[l]" withString:nowPlayingAlbum] stringByReplacingOccurrencesOfString:@"[a]" withString:nowPlayingArtist] stringByReplacingOccurrencesOfString:@"[t]" withString:nowPlayingTitle]];

			[appPasteBoard setString: tmp];

			NSLog(@"CCP: Pasted...%@", tmp);

			// NSLog(@"CCP: check if we want to show allert...");
			if([alrt boolValue]){
				av = [[UIAlertView alloc] initWithTitle:@"Copied By CopyCurrentPlaying" message:tmp delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
				[av show];
				NSLog(@"CCP: ALERT !!!");
			}

			// [av release];
		}
		[event setHandled:YES];
	}
}

- (void)activator:(LAActivator *)activator abortEvent:(LAEvent *)event
{
	// Called when event is escalated to a higher event
	// (short-hold sleep button becomes long-hold shutdown menu, etc)
	[self dismiss];
}

- (void)activator:(LAActivator *)activator otherListenerDidHandleEvent:(LAEvent *)event
{
	// Called when some other listener received an event; we should cleanup
	[self dismiss];
}

- (void)activator:(LAActivator *)activator receiveDeactivateEvent:(LAEvent *)event
{
	// Called when the home button is pressed.
	// If (and only if) we are showing UI, we should dismiss it and call setHandled:
	if ([self dismiss])
		[event setHandled:YES];
}

- (void)dealloc
{
	// Since this object lives for the lifetime of SpringBoard, this will never be called
	// It's here for the sake of completeness
	[av release];
	[super dealloc];
}


+(void)trackDidChange{
			// NSLog(@"CCP: LETS TRACK !!!");


	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef information) {
			NSLog(@"CCP: TRACKING !!!");

		NSDictionary *dict=(__bridge NSDictionary *)(information);
			NSLog(@"CCP: traaackerr !!! %@",dict);

		if( dict != NULL ){
			// NSString *nowPlayingTitle_ .l =
			NSString *nowPlayingTitle_tmp = [[NSString alloc] initWithString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoTitle]];
			// NSLog(@"CCP: COMPARING %@ and %@ (second is new)",nowPlayingTitle, nowPlayingTitle_tmp);
			if(![nowPlayingTitle isEqual:nowPlayingTitle_tmp])
			{

				[nowPlayingTitle setString:nowPlayingTitle_tmp];
				[nowPlayingArtist setString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoArtist]];
				[nowPlayingAlbum setString:[dict objectForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoAlbum]];

				NSLog(@"CCP: WE GOT A NEW TITLE, LETS SET THE VALUES AS  %@ and %@ and %@  ",nowPlayingTitle,nowPlayingArtist,nowPlayingAlbum);


				[nowPlayingTitle_tmp release];
				[nowPlayingTitle retain];

			}
		}
			// NSLog(@"CCP: ENDING TRACKING !!!");

	});
			// NSLog(@"CCP: TRACK STOPPED !!!");


 }


+ (void)load
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog(@"CCP: REGISTER LISETNER !!!");
	[[LAActivator sharedInstance] registerListener:[self new] forName:@"CopyCurrentPlaying"];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDidChange) name:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoDidChangeNotification object:nil];
	// NSLog(@"CCP:  LISTENER REGISTERED !!!");
	[pool release];

}
@end


static void loadPrefs()
{
	NSLog(@"CCP: LOADING PREFERENCES !!!");
 	CFPreferencesAppSynchronize(CFSTR("com.vasuchawla.CopyCurrentPlaying"));
	frmt = (NSString*)CFPreferencesCopyAppValue(CFSTR("frmt"), setin_domain) ?: @"[t] by [a], ([l])";
	alrt = (NSString*)CFPreferencesCopyAppValue(CFSTR("alrt"), setin_domain) ?: @"Yes";
	// NSLog(@"CCP: PREFERENCES LOADED %@ %@ ",frmt,alrt);
	[frmt retain];

}



%ctor {
	// NSLog(@"CCP: CONSTRUCTOR !!!");

	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	NSLog(@"CCP: SETTINGS CHANGE LISTNER BEGIN !!!");
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
								NULL,
								(CFNotificationCallback)loadPrefs,
								CFSTR("com.vasuchawla.CopyCurrentPlaying/settingschanged"),
								NULL,
								CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
	// NSLog(@"CCP: SETTINGS CHANGE LISTNER END !!!");

	[pool drain];
}
