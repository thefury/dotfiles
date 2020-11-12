#!/usr/bin/env ruby

def usage
  puts "obsidian-blank-links VAULT"
end

usage unless ARGV.size == 1
vault = ARGV[0]

files = []
links = []

Dir["#{vault}/*.md"].each do |f|
  files << File.basename(f, ".md").strip


  File.open(f).each_line do |l|
    l.scan(/\[\[([a-zA-Z0-9 ].*)\]\]/).each { |l| links << l.first }
  end
end

puts "broken links"
puts files.sort.uniq.map{ |s| s.strip } - links.sort.uniq.map{ |s| s.strip }
