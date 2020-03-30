require "./spec_helper"

describe Ancillary do
  it "can send and receive a file descriptor" do
    file_path = File.tempname "spec", ".txt"
    sock_path = File.tempname "spec", ".sock"
    begin
      code = <<-CODE
      #!/usr/bin/env crystal
      require "./src/ancillary"
      File.open("#{file_path}", "w") do |f|
        f.sync = true
        f.print "foo"
        UNIXServer.open("#{sock_path}") do |s|
          client = s.accept
          client.blocking = true
          Ancillary.send(client, f.fd)
        end
      end
      CODE
      File.write("spec-server", code, 0x755)
      server_process = Process.new "./spec-server"
      until File.exists? sock_path
        sleep 0.1
        server_process.terminated?.should be_false
      end
      c = UNIXSocket.new(sock_path)
      ancil = Ancillary.new(c)
      fd = ancil.receive
      io = IO::FileDescriptor.new(fd)
      io.print "bar"
      io.close
      File.read(file_path).should eq "foobar"
    ensure
      File.delete(file_path) if File.exists? file_path
      File.delete(sock_path) if File.exists? sock_path
      File.delete("spec-server") if File.exists? "spec-server"
    end
  end
end
