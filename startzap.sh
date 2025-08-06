#!/bin/bash
#xpra start :100 --start-child="proxychains4 zaproxy -Xmx{how much memory}" --daemon=yes
# Working command should look like zaproxy -Xmx12G
xpra start :100 --start-child="zaproxy" --daemon=yes
