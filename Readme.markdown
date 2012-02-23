# WARP, the Wonderful Application Runtime Packager

You are in love with ruby, but deploying in production in a hell :

* have to install GCC and dependencies in -dev to compile gem
* have to compile ruby if you are using [RVM] or [rbenv]
* wait for bundle install run

You are in love with [NodeJS], and have the same problem :

* have to install GCC to compile NodesJS and modules
* wait for NodeJS compilation
* wait for module download and compilation

## WARP is for you !

How it's work :

* using Warp, create packages on Continuous Integration Server, containing ruby binary version, gemsets, node binary version, nodes modules ...
* exposing this packages in a HTTP server
* run WARP in your production server : WARP will download binary packages and install them for you at the rigth place !

That's all.

In Ruby world, WARP is designed to work in collaboration with

* [rbenv]
* [bundler]
* [capistrano]

[RVM]: https://rvm.beginrescueend.com/
[rbenv]: https://github.com/sstephenson/rbenv
[NodeJS]: http://nodejs.org/
[bundler]: http://gembundler.com/
[capistrano]: https://github.com/capistrano/capistrano/wiki/Documentation-v2.x

## Architecture

WARP always run in user mode, no root or sudo is needed.

There is two roles in WARP :

### Packager

In standard deployment, it's the continuous integration server. This server has GCC and all compilation tools.
After running tests, the continuous integration engine will call WARP to build needed binary packages, and depose them
in a directory exposed by an http server

### Client

Every servers running your app are clients. While deploying, you have to call WARP to install binary packages.
Binary packages are downloaded from continuous integration server.
GCC is not required on theses servers, not recompilation is done while deploying.


### Warp file

A .warp file is a binary package. It's a self extracting archive, constructed with tar, gzip and some customs scripts.
You can use WARP to bootstrap environments, see below.

## Installing warp

System package required for WARP :

* `curl`
* `git-core`

To install WARP :

    cd $HOME
    git clone git@github.com:bpaquet/warp.git .warp

If you want to use rbenv from in a interactive shell (on a WARP packager for example), type the following command and add the two lines in your shell startup file.
If rbenv is only used through capistrano, it's not needed.

    $HOME/.warp/common/ruby/setup_rbenv.sh
    

# Packaging

## Ruby

### Ruby version

To package a ruby version, use the following command :

    $HOME/.warp/packager/ruby/warp_ruby.sh <target_dir> <ruby_version> [<system required packages>] 

Where

* `<target_dir>` is the target directory where WARP will put the WARP file. This directory should be exposed by a web server.
* `<ruby_version>` is the rbenv ruby version to package. You can list available ruby version in rbenv by typing `rbenv versions`. You can install a new vesion by typing `rbenv install <version>`.
* `<system required packages>` is an optionnal list of system required packages. WARP will not install them for you, but will fail to deploy this package if they are not present on the target system. For example, you can add on command line `libopenssl` to ensure that openssl is installed on the target system.

Please note the packaged ruby version :

* will contain gems installed with this ruby version
* will NOT contain gemsets installed with this ruby version, expect if you specify `PACKAGE_GEMSETS=1` on your command line
* will be specific to your linux version, and architecture.

For me, the warp file is : `ruby_lucid_x86_64_ree-1.8.7-2012.02.warp`
