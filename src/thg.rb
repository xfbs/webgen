# add directory of main file thg.rb to lib search path
$:.push File.dirname($0)

require 'ups'

require 'configuration'
require 'parser'
require 'tree'
require 'thgexception'

class Main < UPS::StandardPlugin

	def initialize
		super('main', 'thaumaturge')
	end

	def after_register
		UPS::PluginRegistry.instance['main'].set_plugin('thaumaturge')
	end

	def run(*arg)
		begin
			# initialise the configuration
			cfg = Configuration.instance
			#print "Config: #{cfg.inspect}\n"

			# load the plugins
			cfg.loadPlugins
			#UPS::PluginRegistry.instance['listRegistry'].list
			#print UPS::PluginRegistry.instance['fileWriter'].inspect
			
			# load all the files in src dir and build tree
			parser = Parser.new
			tree = parser.build_tree
			#print "Tree: #{tree.inspect}\n"

			# execute tree transformer plugins
			UPS::PluginRegistry.instance['treeTransformer'].execute(tree)

			# generate output files
			UPS::PluginRegistry.instance['fileWriter'].execute(tree)

		rescue ThaumaturgeException => e
			print "An error occured: #{e.message}\n"
			print "Possible solution: #{e.solution}\n\n"
			print "Stack trace: #{e.backtrace.join("\n")}\n"
		end
	end

end

UPS::PluginRegistry.instance.register_plugin(Main.new)
UPS::PluginRegistry.instance['main'].run(ARGV)
