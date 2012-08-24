#!/usr/bin/env rackup

$:.concat ['./', 'lib']

require 'app'
Ramaze.start(:root => Ramaze.options.roots, :started => true)
run Ramaze
