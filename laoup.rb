$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'json'
require 'encounters/lib/aggregate'

aggregate = Aggregate.new
Aggregate.download
aggregate.compile_all
aggregate.save_to_disk
