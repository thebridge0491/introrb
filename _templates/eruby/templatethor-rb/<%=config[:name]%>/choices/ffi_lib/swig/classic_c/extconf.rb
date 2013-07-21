require 'mkmf'

# prefix = ENV['prefix'] ? ENV['prefix'] : '/usr/local'
prefix = ENV.fetch('prefix', '/usr/local')

## find non-system libs:
## (1) cmd-ln opts: --with-target-dir=$prefix
## (2) extconf.rb dir_config: dir_config(target[, idefault, ldefault])
dir_config('classic_c', "#{prefix}/include", "#{prefix}/lib")

have_library('intro_c-practice', 'fact_i')

create_makefile('classic_c')
