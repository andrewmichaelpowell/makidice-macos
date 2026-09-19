#!/bin/bash

# Maki Dice (macOS)
# github.com/andrewmichaelpowell

set -euo pipefail

NOTARY_PROFILE="${NOTARY_PROFILE:-makidice-notary}"
TEAM_ID="925F4PY4UL"
APP_NAME="Maki Dice"

cd "$(dirname "$0")/.."
ROOT="$PWD"
BUILD="$ROOT/build"
ARCHIVE="$BUILD/$APP_NAME.xcarchive"
EXPORT="$BUILD/export"
STAGING="$BUILD/dmg"

VERSION=$(xcodebuild -project "$APP_NAME.xcodeproj" -scheme "$APP_NAME" -showBuildSettings 2>/dev/null \
	| awk -F' = ' '/ MARKETING_VERSION /{print $2; exit}')
DMG="$BUILD/makidice-macos.dmg"

IDENTITY=$(security find-identity -v -p codesigning | awk -F'"' '/Developer ID Application/{print $2; exit}')
if [ -z "$IDENTITY" ]; then
	exit 1
fi

rm -rf "$BUILD"
mkdir -p "$BUILD"

xcodebuild archive \
	-project "$APP_NAME.xcodeproj" \
	-scheme "$APP_NAME" \
	-configuration Release \
	-destination 'generic/platform=macOS' \
	-archivePath "$ARCHIVE" \
	-quiet

cat > "$BUILD/exportOptions.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>developer-id</string>
	<key>teamID</key>
	<string>$TEAM_ID</string>
	<key>signingStyle</key>
	<string>automatic</string>
</dict>
</plist>
PLIST
xcodebuild -exportArchive \
	-archivePath "$ARCHIVE" \
	-exportPath "$EXPORT" \
	-exportOptionsPlist "$BUILD/exportOptions.plist" \
	-quiet

mkdir -p "$STAGING"
cp -R "$EXPORT/$APP_NAME.app" "$STAGING/"
ln -s /Applications "$STAGING/Applications"
hdiutil create -volname "$APP_NAME" -srcfolder "$STAGING" -fs HFS+ -format UDZO -ov "$DMG" >/dev/null
codesign --force --sign "$IDENTITY" --timestamp "$DMG"

xcrun notarytool submit "$DMG" --keychain-profile "$NOTARY_PROFILE" --wait

xcrun stapler staple "$DMG"
xcrun stapler validate "$DMG"

spctl --assess --type open --context context:primary-signature --verbose=2 "$DMG"
