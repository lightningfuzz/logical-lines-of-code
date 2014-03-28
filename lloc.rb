# Michael Santer

# LLOC calculates the number of logical lines of code in a C/C++ program. 
# LLOC = 	  NPU		// main program plus all functions
# 			+ NSC 		// semi-colons in the whole program, except comments
# 			+ NEQ		// Assignments within data definitions only (eg. int i = 5;) 
# 			+ Nif		// all if statements
# 			+ Nswitch 	// all switch statements
# 			+ Nwhile 	// all while statements
# 			+ Nfor		// all for statements

# Program will also calculate number of practical lines of code (PLOC).
# PLOC = number of new line characters

DECLS = {'i' => 'int', 'f' => 'float', 'd' => 'double', 'c' => 'char', 
		's' => 'short', 'l' => 'long', 'v' => 'void'}

COND = {'i' => 'if', 's' => 'switch', 'w' => 'while', 'f' => 'for'}

def main
	npu=0; nsc=0; neq=0; ncond=0;

	############## Input Checking #################

	#check args
	if ARGV.length != 1
		puts 'Usage: ruby lloc.rb [filename.cpp]'
		exit
	end

	# open file
	begin
		source = File.open(ARGV[0], 'r')
	rescue
		puts 'ERROR: File not found.'
		exit
	end

	# check that file is c/c++
	ext = File.extname(source)
	if (ext != '.c' && ext != '.cc' && ext != '.cpp')
		puts 'LLOC only works for c and c++ programs'
		exit
	end

	lloc = 0
	ploc = IO.readlines(source).length

	############ Start Scanning file #################

	while c = source.getc

		##### read past white space #####
		c = scan_whitespace(source, c)

		##### scan through comments #######
		if c == '/'
			#if single line comment, scan until newline
			if (c = source.getc) == '/'
				until c == "\n" || c == nil 
					c = source.getc
				end
			#if block comment, scan until */
			elsif c == '*'
				c = source.getc
				cnext = source.getc
				until c == '*' && cnext == '/'
					c = cnext
					cnext = source.getc
				end
				c = cnext
			end

		####### look for declarations and conditions #######
		elsif DECLS.has_key?(c) || COND.has_key?(c)

			# check to make sure this is the beginning of a word
			if source.pos > 1
				source.seek(-2, :CUR)
				c = source.getc

				# if this is not the beginning of a word, continue to next iteration
				if c.match(/[a-zA-Z]/)
					c = source.getc
					next
				end

				c = source.getc
			end


			# read a token until white space or '('
			token = c
			until (c = source.getc).match(/\s/) || c == '('
				token += c
			end

			    ######## if token is a decl keyword ########
			if DECLS.has_value?(token)

				# check if decl is for function
				if is_function?(source, c)
					npu += 1

				else # it's a variable decl
					# scan until semicolon
					until (c = source.getc) == ';'
						if c == '='  
							neq+=1
						end
					end
					nsc += 1
				end
				# increment lloc for semicolon at end of decl
			
				####### if token is a conditional keyword #######
			elsif COND.has_value?(token)
				c = scan_whitespace(source, c)
				if c == '(' 
					ncond += 1 
				else
					source.ungetc(c)
				end

			else #unread token
				source.seek(-1 * (token.size+1), :CUR)
				c = source.getc
			end

		####### count semicolons #######
		elsif c == ';'
			nsc += 1
		end		
	end

	lloc = nsc + npu + ncond + neq
	################ Output ################

	printf("%-15s %-6s %-6s\n", File.basename(ARGV[0]), lloc, ploc)
	# puts 'neq = '+ neq.to_s
	# puts 'ncond = ' + ncond.to_s
	# puts 'npu = ' + npu.to_s
	# puts 'nsc = ' + nsc.to_s
	# puts 'lloc = ' + lloc.to_s
end

############## Methods ###################

# scans past all whitespace
def scan_whitespace(sourcefile, char)
	newlines = 0
	while char && char.match(/\s/)
		char = sourcefile.getc
	end
	return char
end


# checks if the next input after a decl keyword is a function
def is_function?(sourcefile, char)
	pos = sourcefile.pos

	# expect parens
	until (char = sourcefile.getc) == '('
		if char == ';'
			sourcefile.seek(pos-1, :SET)
			return false
		end
	end

	# expect braces
	until (char = sourcefile.getc) == '{'
		if char == ';'
			sourcefile.seek(pos-1, :SET)
			return false
		end
	end

	return true
end

main
