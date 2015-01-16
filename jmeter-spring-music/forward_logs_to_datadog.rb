#!/usr/bin/env ruby
require 'dogapi'
input = ARGV[0]

datadog = Dogapi::Client.new("REDACTED","REDACTED")
input_io = File.new(input)
line_buffer = []
input_io.each do |line|
  next if line =~ /samples/
  line_buffer << line
  if line_buffer.length >= 100
    datadog.batch_metrics do
      line_buffer.each do line
        timestamp, duration, url, status, _ = line.split(",")
        url.sub!(/albums\/.*/, "albums/specific")
        datadog.emit_point("app_benchmarking.duration4", duration, tags: ["url:#{url}","status:#{status}"])
      end
    end
    line_buffer = []
  end
end
