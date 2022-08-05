#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""

$ ./layers.py

update LAYERS.md

"""

import os
import re
import time
import ast
import sys

spacevim_path = sys.argv[1]
output_path = sys.argv[2]
layers_path = os.path.join(spacevim_path, 'layers')
output = open(output_path, 'a')

plugins = []

os.chdir(layers_path)
for topic in os.listdir():
    if not os.path.isdir(topic) or not topic.startswith('+'):
        continue
    pattern = re.compile('\'([\\w\\.-]+/[\\w\\.-]+)\'')
    for layer in os.listdir(topic):
        plugs = []
        with open(os.path.join(topic, layer, 'packages.vim')) as f:
            for line in f.read().splitlines():
                if line.startswith('"'):
                    continue
                mat = pattern.search(line)
                if mat is not None:
                    if mat.group(0).find('/') != -1:
                        plug = mat.group(0).split("'", 2)[1]
                        if plugins.count(plug):
                            continue
                        else:
                            plugins.append(plug)
                            plugs.append(plug)
        plugs.sort()
        plugs = map(
            lambda x: "Plug '{}'".format(x, x),
            plugs)
        #  plugs = '<ul>' + ''.join(plugs) + '</ul>'
        plugs =  '\n'.join(plugs)
        row = ("\" %s -- %s\n%s\n" % (topic, layer, plugs))
        output.write(row)

output.close()

print('All related plugins: {}'.format(len(plugins)))
