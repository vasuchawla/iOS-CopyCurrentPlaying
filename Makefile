ARCHS = armv7 arm64
include theos/makefiles/common.mk

TWEAK_NAME = CopyCurrentPlaying
CopyCurrentPlaying_FILES = Tweak.xm

CopyCurrentPlaying_FRAMEWORKS = UIKit
CopyCurrentPlaying_PRIVATE_FRAMEWORKS  = MediaRemote


CopyCurrentPlaying_LDFLAGS = -lactivator
CopyCurrentPlaying_CFLAGS = -Wno-error


include $(THEOS_MAKE_PATH)/tweak.mk



SUBPROJECTS += settings

include $(THEOS_MAKE_PATH)/aggregate.mk


after-install::
	install.exec "killall -9 SpringBoard"
