zipper-activerecord
===================

This script file that serves a web page for shortening urls. This is an updated version of [zipper-tokyocabinet]. It uses Sinatra, active-record and base-62 numerals for very small and efficient url storage.

### Usage
* Install bundler, (`gem install bundler`).
* Use `bundle` command to install the required gems.
* Install unicorn, shotgun, or whichever ruby webserver you wish, (`gem install unicorn`).
* Edit the included `unicorn.rb` config file to point to your app's directory.
* Run, learn, fork, add helpers, enjoy.

Running the web server and shortening urls will generate a ‘links.tch’ database in the same folder as the script. This script does not include input sanitation or page caching or all that other good stuff you might want for a production site (at least not for now). This is just something simple I made while learning Sinatra and hopefully it will help others.

[zipper-tokyocabinet]: https://github.com/gfax/zipper-tokyocabinet
