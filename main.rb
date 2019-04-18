#!/usr/bin/env ruby

require 'bundler'
Bundler.require
require 'optparse'

require './utils/bot'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: wellness-bot [options]"

  opts.on("-u", "--user USERNAME", "Username to login SFC-SFS") do |v|
    USERNAME = v
  end

  opts.on("-p", "--pass PASSWORD", "Password to login SFC-SFS") do |v|
    PASSWORD = v
  end

  opts.on("-i", "--uid UID", "Keio Student ID") do |v|
    UID = v
  end

  opts.on("-s", "--sem SEMESTER", "Semester, eg: 20190") do |v|
    SEMESTER = v
  end

  opts.on("-l", "--lec LECTURE", "Lecture ID, eg: 57850") do |v|
    LECTURE = v
  end

  opts.on("-d", "--date DATE", "Date, eg: 20190426") do |v|
    DATE = v
  end
end.parse!

conn = Faraday.new(:url => 'https://wellness.sfc.keio.ac.jp') do |builder|
  builder.request  :url_encoded
  builder.response :logger
  builder.adapter  :net_http
end

loop do
  auth = BOT::login(conn, USERNAME, PASSWORD, SEMESTER)
  res = BOT::register(conn, auth, UID, LECTURE, SEMESTER, '20190426')
  if res
    puts "Register Succeeded"
    exit 0
  else
    puts "Register Failed, Wait 30 secs and Retry"
    sleep 30
  end
end
