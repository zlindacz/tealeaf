nouns = File.open('nouns.txt', 'r') do |f|
  f.read
end.split

adjectives = File.open('adjectives.txt', 'r') do |f|
  f.read
end.split

verbs = File.open('verbs.txt', 'r') do |f|
  f.read
end.split

def say(msg)
  puts "=> #{msg}"
end

def exit_with(msg)
  say msg
  exit
end

exit_with('No input file!') if ARGV.empty?
exit_with('Input file does not exist.') unless File.exists?(ARGV[0])

contents = File.open(ARGV[0], 'r') do |f|
  f.read
end

contents.gsub!('NOUN').each do
  nouns.sample
end

contents.gsub!('ADJECTIVE').each do
  adjectives.sample
end

contents.gsub!('VERB').each do
  verbs.sample
end

p contents