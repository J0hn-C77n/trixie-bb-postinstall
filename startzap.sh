#!/bin/bash
xpra start :100 --start-child="proxychains4 zaproxy -Xmx40G -config pscan.threads=16" --daemon=yes
