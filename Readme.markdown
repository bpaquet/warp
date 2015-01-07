# WARP, the Wonderful Application Runtime Packager

Click [here](https://github.com/bpaquet/warp/wiki/Summary) for full documentation.

You are in love with ruby, but deploying in production is a hell :

* Must install GCC and developement dependencies to compile gems
* Must compile ruby when you are using RVM or rbenv
* Running bundle install is very slow

If you want to avoid that, WARP is do for you !

You are in love with [NodeJS], and you have the same problems :

* Must install GCC to compile NodesJS and modules
* Have to wait for NodeJS compilation
* Have to wait for module download and compilation

If you want to avoid that, WARP is do for you !

Another cool feature offered by WARP : you want to use tools such as Chef for your environement management or install softs like Redmine on your server, but

* you do not want to install GCC to compile Ruby and gems
* you do not want a ruby installed in your system neither a gem command as root
* you want to be able to uninstall chef and all related chef features with one command line : rm

WARP allow you to package a self sufficient package for tools such as Chef and Redmine.

# How it works :

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
