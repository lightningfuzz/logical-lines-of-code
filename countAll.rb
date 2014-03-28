# This script runs LLOC/PLOC counter on all c/c++ files in a given directory
# USAGE: ruby coutAll.rb [dir_name]

if ARGV.size != 1
	puts 'USAGE:   \'ruby coutAll.rb [dir]\''
	exit
end

printf("%-15s %-6s %-6s\n", 'Filename', 'LLOC', 'PLOC')

Dir.glob(ARGV[0] + "/*.c*") do |filename|
	output = `ruby lloc.rb #{filename}`
	printf(output)
end