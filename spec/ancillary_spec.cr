require "./spec_helper"

describe Ancillary do
  it "can send and receive a file descriptor" do
    File.delete "/tmp/ancilspec" if File.exists? "/tmp/ancilspec"
    fork do
      File.open("/tmp/ancilspecfile", "w") do |f|
        f.sync = true
        f.print "foo"
        UNIXServer.open("/tmp/ancilspec") do |s|
          client = s.accept
          ancil = Ancillary.new(client)
          ancil.send(f.fd)
        end
      end
    end
    sleep 0.1
    c = UNIXSocket.new("/tmp/ancilspec")
    ancil = Ancillary.new(c)
    fd = ancil.receive
    io = IO::FileDescriptor.new(fd)
    io.print "bar"
    io.close
    File.read("/tmp/ancilspecfile").should eq "foobar"
  end
end
