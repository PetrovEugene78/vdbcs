# vdbcs.sh
Script to configure scenes for viewing RTMP streams in OBS. This script is intended for creating video dashboards for: 1, 4 (2x2), 9 (3x3), 16 (4x4) and 25 (5x5) video sources. By default, the
script creates a video dashboard for 25 (5x5) video sources.

As a source of resources for building video dashboards, you must use a text file ***sources.list*** or an CSV file ***sources.list.csv***.

A prerequisite is the presence of a newline character after the last line in the resource source files ***sources.list*** or ***sources.list.csv***.
## Example source files
Information in a source file should be in columns where:
* in the first column - the name of the instance
* in the second column - resource language
* in the third column - link to the video stream

Information in columns in a text file ***sources.list*** must be separated by a space ( ):
```text
    A Eng rtmp://ip/eng/origin
    B Rus rtmp://ip/rus/origin
```

Information in columns in a CSV file ***sources.list.csv*** must be separated by a coma (,):
```text
    A,Eng,rtmp://ip/eng/origin
    B,Rus,rtmp://ip/rus/origin
```
## Instalation
Download the project to the current directory:
``` bash
$ git clone https://github.com/PetrovEugene78/vdbcs
```
If the project needs to be uploaded to a different directory:
``` bash
$ git clone https://github.com/PetrovEugene78/vdbcs new_directory
```
## Usage

