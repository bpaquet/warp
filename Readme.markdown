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

There is two roles in WARP :

### Packager

In standard deployment, it's the continuous integration server. This server has GCC and all compilation tools.
After running tests, the continuous integration engine will call WARP to build needed binary packages, and depose them
in a directory exposed by an http server

### Client

Every servers running your app are clients. While deploying, you have to call WARP to install binary packages.
Binary packages are downloaded from continuous integration server.
GCC is not required on theses servers, not recompilation is done while deploying.
