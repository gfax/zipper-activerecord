zipper-activerecord
===================

This script file that serves a web page for shortening urls. This is an updated version of [zipper-tokyocabinet]. It uses Sinatra, active-record and base-62 numerals for very small and efficient url storage. Live demo: http://z.gfax.ch

### Usage
* Install bundler, (`gem install bundler`).
* Use `bundle` command to install the required gems.
* Run create-db.sh to generate an empty sqlite database.
* Install unicorn, shotgun, or whichever ruby webserver you wish, (`gem install unicorn`).
* Edit the included `unicorn.rb` config file to point to your app's directory.
* Run, learn, fork, add helpers, enjoy.

[zipper-tokyocabinet]: https://github.com/gfax/zipper-tokyocabinet
