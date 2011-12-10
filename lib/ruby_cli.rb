require 'optparse'

# The goal of this library is to factor out code needed to create Ruby 
# command line applications which follow the Unix Philosophy design method 
# (http://www.faqs.org/docs/artu/ch01s06.html).
#
# See README.rdoc for more information. 
module RubyCLI

	# Initialization of this application requires the command line arguments.
	def initialize(default_argv, command_name, usage = "[OPTIONS]... [ARGUMENTS]...")
		@default_argv = default_argv
		@default_options = {:help => false, :verbose => false}
		define_command_options
		define_command_arguments
		@opt_parser = nil
		@command_name = command_name
		@usage = usage
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

	# Redefine this method if you want to add command specific options	
	def define_option_parser
		#configure an OptionParser
		OptionParser.new do |opts|		
			opts.banner = "Usage: #{@command_name} #{@usage}"
			opts.separator ""
			opts.separator "Specific options:"
			opts.on('-h', '--help', 'displays help information') do
				@default_options[:help] = true
				exit output_help(0)
			end
			opts.on('-V','--verbose','Run verbosely') do 
				@default_options[:verbose] = true
			end
			# If you redefine, you can copy this method and add command specific options here!
		end
	end

	# Parse the options
	def parse_options?
		@opt_parser = define_option_parser	
		@opt_parser.parse!(@default_argv) rescue return false
		return true
	end

	# Check if the required number of arguments remains in the 
	# argv array after it has been processed by the option parser
	def arguments_valid?() 
		return true if @arguments.size == 0
		return @default_argv.size == @arguments.size 
	end

	def output_options_and_arguments
    puts "OPTIONS:"
    @default_options.each {|name, value| puts "#{name} = #{value}"}
    @options.each {|name, value| puts "#{name} = #{value}"}
		puts "No options" if @options.length == 0 and @default_options == 0
		
		puts "ARGUMENTS:"
    @arguments.each {|name,value| puts "#{name} = #{value}"}
		puts "No arguments" if @arguments.length == 0
  end

	# Performs post-parse processing on options
	# For instance, some options may be mutually exclusive
	# Redefine if you need to process options.
	def process_options() return true end	
	
	# Redefine if you need to process arguments.
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
