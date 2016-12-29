#Introducton
- This is a script for prepare your legency bundle and auto install patch.
- Reference: https://gist.github.com/anthony-chu/1503854a1efb5e743544#file-release-sh
- Edited By: Steven Sun

#Usage
### legency-prepared.sh assumes the following file structure:  
- `path/to/folder/legency-prepared.sh`
- `path/to/folder/portal-ext.properties`
- `path/to/folder/{liferay-release-bundle-zips}`
- `path/to/folder/{license-files}`
- `path/to/folder/{patch-zips}`
- `path/to/folder/mysql.jar `

### Start script
- `./legency-prepared.sh clean`
- Enter the Number of Liferay EE portal as following:
- ![ScreenShot](https://raw.githubusercontent.com/yunlinsun/shell-related/master/legency-prepared/screenshot1.png)
- Enter the Patch name as the following. (Enter "No" if you don't want to install any Patch)
- ![ScreenShot](https://raw.githubusercontent.com/yunlinsun/shell-related/master/legency-prepared/screenshot2.png)
- Waiting for the script to be finished.

### Note
- All the zip files, patches, license files and jars must in this path `path/to/folder/`

