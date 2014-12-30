
PROJECT=NeetAssertionKit.xcodeproj
SCHEME=NeetAssertionKit


clean:
	xcodebuild clean \
		-project $(PROJECT)

test-debug:
	xcodebuild test \
		-scheme $(SCHEME) \
		-configuration Debug

test-release:
	xcodebuild test \
		-scheme $(SCHEME) \
		-configuration Release

