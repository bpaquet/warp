# WARP, the Wonderful Application Runtime Packager

Click [here](https://github.com/bpaquet/warp/wiki/Summary) for full documentation.

You are in love with ruby, but deploying in production in a hell :

* have to install GCC and dependencies in -dev to compile gem
* have to compile ruby if you are using [RVM] or [rbenv]
* running `bundle install` is too slow

You are in love with [NodeJS], and you have same problems :

* have to install GCC to compile NodesJS and modules
* wait for NodeJS compilation
* wait for module download and compilation

Another feature offered by WARP : you want to use a tools like Chef or Redmine on a server, but

* you does not want to install GCC to compile Ruby and gems
* you does not want a system ruby, and system gems as root
* you want uninstall chef and all related chef with one command line : rm

WARP allow you to package an self sufficient package for Chef or Redmine.

# How it's work :

* use Warp on your Continuous Integration Server to create binary packages, containing ruby binary version, gemsets, node binary version, nodes modules ...
* expose these packages in a HTTP server
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