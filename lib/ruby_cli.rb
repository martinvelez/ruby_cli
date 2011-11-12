require 'optparse'

# The goal of this library is to factor out code needed to create Ruby 
# command line applications which follow the Unix Philosophy design method 
# (http://www.faqs.org/docs/artu/ch01s06.html).
#
# What does a command line application library need to do?
#	1. Provide a UI
#	a. Process options (use Ruby's Option Parser)
# b. Process arguments
# 2. Pass options and arguments as parameters to other functions defined in
#	libraries or other executables.
#
# What does a command line application library need not do?
# 1. A command line application does not need to validate options or arguments.
# Libraries or other executables should do this.
#
# This module serves as a mixin for Ruby Command Line Applications (CLI).
# Ruby commands can be written much easier by including this class and following
# the convention that I have outlined here.
#
# This is the core algorithm of any Ruby CLI application.
# def run
#   if parse_options? && arguments_valid?
#		process_options
#     process_arguments
#     output_options_and_arguments if @default_options[:verbose]
#     command
#   else
#     output_help(1)
#   end
#  end
module RubyCLI

	# Initialization of this application requires the command line arguments.
	def initialize(default_argv)
		@default_argv = default_argv
		@default_options = {:help => false, :verbose => false}
		define_command_options
		define_command_arguments
		@opt_parser = nil
	end

	# This method can be overwritten if you want to set defaults for your command
	# specific options.
	def define_command_options() @options = {} end
	
	# This method can be overwritten if you want to set defaults for your command
	# specific arguments.
	def define_command_arguments() @arguments = {} end
	
	# Run the application
  def run
    if parse_options? && arguments_valid?
			process_options
      process_arguments
      output_options_and_arguments if @default_options[:verbose]
      command
    else
      output_help(1)
    end
  end
		
		
	# Parse the options
	# Redefine this method if you want to add command specific options
	def parse_options?
		#configure an OptionParser
		@opt_parser = OptionParser.new do |opts|		
			opts.banner = "Usage: #{__FILE__} [OPTIONS]... [ARGUMENTS]..."
			opts.separator ""
			opts.separator "Specific options:"
			opts.on('-h', '--help', 'displays help information') do
				@default_options[:help] = true
				exit output_help(0)
			end
			opts.on('-V','--verbose','Run verbosely') do 
				@default_options[:verbose] = true
			end
			# TODO: If you redefine, you can add command specific options here!
		end
		@opt_parser.parse!(@default_argv) rescue return false
		true
	end

	# Check if the required number of arguments remains in the 
	# argv array after it has been processed by the option parser
	def arguments_valid?() 
		return true if @arguments.size == 0
		@default_argv.size == @arguments.size 
	end

	def output_options_and_arguments
    puts "OPTIONS:"
    @default_options.each {|name, value| puts "#{name} = #{value}"}
    @options.each {|name, value| puts "#{name} = #{value}"}
		puts "No options" if @options.length == 0
		
		puts "ARGUMENTS:"
    @arguments.each {|name,value| puts "#{name} = #{value}"}
		puts "No arguments" if @arguments.length == 0
  end

	# Performs post-parse processing on options
	# For instance, some options may be mutually exclusive
	# Redefine if you need to process options.
	def process_options() return true end	
	
	# Redefine if you need to process options.
	def process_arguments() return true end
	
	# Application logic
	def command
		raise "This method should be overwritten." 
		return 0
	end
	
	def output_help(exit_code) 
		puts @opt_parser
		puts exit_code if @default_options[:verbose]
		return exit_code 
	end
	
end # Application
