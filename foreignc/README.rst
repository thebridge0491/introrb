Introrb::Util
===========================================
.. .rst to .html: rst2html5 foo.rst > foo.html
..                pandoc -s -f rst -t html5 -o foo.html foo.rst

FFI sub-package for Ruby Intro examples project.

Installation
------------
source code tarball download:
    
        # [aria2c --check-certificate=false | wget --no-check-certificate | curl -kOL]
        
        FETCHCMD='aria2c --check-certificate=false'
        
        $FETCHCMD https://bitbucket.org/thebridge0491/introrb/[get | archive]/master.zip

version control repository clone:
        
        git clone https://bitbucket.org/thebridge0491/introrb.git

build example with make:
cd <path> ; make [test | spec] gem

make install

build example with rake:
cd <path> ; rake [test | spec] gem

rake install

Usage
-----
        ruby -Ilib bin/console
        
        > Classic = Introrb::Foreignc::Classic
        
        > n = 5
        
        > res = Classic.fact_i(n)
        
or
        require 'introrb/foreignc'
        
        ...
        
        n = 5
        
        res = Classic.fact_i(n)

Author/Copyright
----------------
Copyright (c) 2013 by thebridge0491 <thebridge0491-codelab@yahoo.com>

License
-------
Licensed under the Apache-2.0 License. See LICENSE for details.
