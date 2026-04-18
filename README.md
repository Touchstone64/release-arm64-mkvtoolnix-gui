# release-arm64-mkvtoolnix-gui
These are the artefacts I needed to build a signed MKVToolNix GUI for Apple Silicon on a fresh install of macOS.

The script and patches in this repo are the only elements that can be attributed to [me](mailto:touchstone64@gweb.me.uk). The MKVToolNix GUI and associated tools are created and owned by Moritz Bunkus and are thoroughly [documented here](https://mkvtoolnix.download/index.html).

These artefacts have been used to build signed releases of the MKVToolNix GUI as described below:

| repo | macOS | MVKToolNix GUI | Disk image |
|:----:|:-----:|:--------------:|:----------:|
| 0.1 | 26.4.1 | 98.0 | [download](https://www.gweb.me.uk/dmg/arm64-mkvtoolnix-gui/MKVToolNix-98.0.dmg) |



The rest of this README.md file is essentially a record of the steps taken to build an MVKToolNix GUI disk image ready for installation on macOS.

## Export a code-signing certificate
On a Mac used to sign macOS applications, open Keychain Access and in the login keychain, click My Certificates and export your Developer ID Application certificate using 'File | Export Items' and select the file format 'Personal Information Exchange (.p12)'. 

Provide a password and save the exported certificates. You'll use this export to re-use your working code-signing certificate in another macOS installation.

(You may of course prefer to create a Developer ID Certificate signing request on the fresh macOS installation. This export process is the just the method I chose to use.)

## Create a fresh macOS Install
Create a new APFS volume on your chosen internal or external drive and use  the 'Install macOS Tahoe' app to install macOS. The app can be downloaded from the App Store. A virtual machine (VM) can't be used because they don't support App Store installs, which we'll need to get Xcode. 

## Configure macOS
Run through the installation of macOS, these are my preferences:

- Set up as a new user to avoid environment pollution
- For Apple Account: sign in later in Settings
- Enable Location Services, Touch ID etc, as desired
- Click 'Get Started' to ... get started
- Configure trackpad, keyboard as desired
- Rename Mac as desired

Enable iCloud and any other macOS features as desired. Since this is an instance intended for a clean, from-source signed build I prefer to keep it light.

## Setup prerequisites on macOS
The text 'your terminal' refers to your chosen terminal emulator, be it the macOS Terminal app, [iTerm2](https://iterm2.com) or whatever your personal preference. If it's not macOS Terminal then you'll need to install it now.
- Use the App Store to install Xcode (this is where you'll sign in with your Apple account)
- Run Xcode and accept the license agreements
- In your terminal, run `xcode-select —install` to install the command-line developer tools
- In your terminal, use `xcode-select -p` to check the location of the developer directory, it should be '/Applications/Xcode.app/Contents/Developer'
- If you exported a working code-signing certificate above, open Keychain Access and use 'File | Import Items' to import the .p12 certificates file. (You may need to move one or more imported intermediate certificates to the System keychain.)
- If you chose to create a new Developer ID Certificate, install it using Keychain Access.
- In Keychain Access, select My Certificates in the login keychain and inspect your 'Developer ID Application' certificate to ensure it's trusted.
- In your terminal, run `security find-identity -p codesigning` to review the code-signing identities now recognised by the OS to ensure your certificate is installed as expected

## Build the release
Using release 98.0 as an example, in your terminal:
- Choose or create a working directory for this project and change to it
- Clone this repo using `git clone https://github.com/Touchstone64/release-arm64-mkvtoolnix-gui.git`
- Use `cd ./release-arm64-mkvtoolnix-gui` to change to the repo directory
- Run `./prep_to_build_mkvtoolnix_release.sh 98.0` to prepare to build and sign release 98.0
- Use `cd ./release-98.0/packaging/macos` to change to the release's macos packaging directory
- Run `./build.sh` to build all of the component parts of the MKVToolNix GUI. This will take some time.
- Run `./build.sh dmg` to assemble and sign the disk image for the release

The build script uses ~/opt and ~/tmp to build and assemble all the component parts needed to create the MKVToolNix GUI from source.

The signed disk image will be located at ~/tmp/compile/MKVToolNix-98.0.dmg.