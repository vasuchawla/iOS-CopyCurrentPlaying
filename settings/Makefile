ARCHS = armv7 arm64
include theos/makefiles/common.mk

BUNDLE_NAME = CopyCurrentPlaying
CopyCurrentPlaying_FILES = CopyCurrentPlaying.mm
CopyCurrentPlaying_INSTALL_PATH = /Library/PreferenceBundles
CopyCurrentPlaying_FRAMEWORKS = UIKit
CopyCurrentPlaying_PRIVATE_FRAMEWORKS = Preferences Social

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/CopyCurrentPlaying.plist$(ECHO_END)

include $(THEOS_MAKE_PATH)/aggregate.mk
