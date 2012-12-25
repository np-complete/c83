#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

files = Dir.glob("./*.md").sort
values = {
  title: "失敗しないGit運用マニュアル",
  author: "NP-complete",
  date: "2012/12/31\\\\\\\\コミックマーケット83"
}
values_str = values.map { |k, v|
  "-V #{k}:#{v}"
}.join(" ")

`pandoc #{values_str} --template=template.latex -s -o c83.tex -f markdown #{files.join(' ')}`
