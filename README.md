# vdbcs.sh

   Script to configure scenes for viewing RTMP streams in OBS. This script is intended for creating video dashboards for: 1, 4 (2x2), 9 (3x3), 16 (4x4) and 25 (5x5) video sources. By default, the
script creates a video dashboard for 25 (5x5) video sources.

   As a source of resources for building video dashboards, you must use a text file **sources.list** or an CSV file **sources.list.csv**.

A prerequisite is the presence of a newline character after the last line in the resource source files **sources.list** or **sources.list.csv**.