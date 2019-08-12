#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
from lark import Lark, Transformer

PLUG_GRAMMAR = r"""
  ?start: plug_list

  plug_list: (plug | non_plug | _NL)+

  plug: "MP" "'" author "/" project "'" ("," option)? _NL
  non_plug: /[^(MP)\t ].*/ _NL

  author: NAME
  project: NAME
  option: dict

  list: "[" [value ("," value)* ","?] "]"
  dict: "{" [pair ("," pair)* ","? ] "}"
  pair: ESCAPED_STRING ":" value
  lambda_: "{" params "->" expr "}"
  params: [CNAME ("," CNAME)*]
  args: [value ("," value)*]
  expr: /[^}]+/
  call: CNAME "(" args ")"

  value: dict | list | call | lambda_ | ESCAPED_STRING

  NAME: ("_"|"."|"-"|LETTER|DIGIT)+

  _STRING_INNER: /.*?/
  _STRING_ESC_INNER: _STRING_INNER /(?<!\\)(\\\\)*?/
  _STRING_SQ: "'" _STRING_ESC_INNER "'"
  _STRING_DQ: "\"" _STRING_ESC_INNER "\""
  ESCAPED_STRING : _STRING_SQ | _STRING_DQ

  %import common.LETTER
  %import common.DIGIT
  %import common.WORD
  %import common.WS_INLINE
  %import common.NEWLINE -> _NL
  %import common.CNAME
  %ignore WS_INLINE
  // %ignore /^\s*[^(MP)\t ].*\r?\n/m
  %ignore /\n^\s*\\/m
"""


class TreeToVimL(Transformer):
    def plug_list(self, items):
        return '\n'.join([x for x in items if x])

    def plug(self, items):
        if len(items) >= 3:
            [author, project, option] = items
            return "Plug '%s/%s', %s" % (author, project, option)
        [author, project] = items
        return "Plug '%s/%s'" % (author, project)

    def non_plug(self, items):
        return ''

    def author(self, items):
        return items[0]

    def option(self, items):
        return items[0]

    def project(self, items):
        return items[0]

    def dict(self, items):
        return "{ %s }" % ', '.join(items)

    def list(self, items):
        return "[%s]" % ', '.join(items)

    def pair(self, items):
        [key, val] = items
        return "%s: %s" % (key, val)

    def value(self, items):
        return items[0]

    def lambda_(self, items):
        [args, expr] = items
        return "{ %s -> %s }" % (args, expr)

    def params(self, items):
        return ', '.join(items)

    def args(self, items):
        return ', '.join(items)

    def expr(self, items):
        return items[0]

    def call(self, items):
        return '%s(%s)' % (items[0], items[1])


def main(argv=None):
    argv = argv or []
    pathes = argv[1:]
    parser = Lark(PLUG_GRAMMAR, parser='lalr')
    transformer = TreeToVimL()
    if pathes:
        for path in pathes:
            with open(path) as file:
                tree = parser.parse(file.read())
                result = transformer.transform(tree)
                print(result)
                #  print(tree.pretty())
    else:
        tree = parser.parse(os.sys.stdin.read())
        result = transformer.transform(tree)
        print(result)


if __name__ == '__main__':
    main(os.sys.argv)
