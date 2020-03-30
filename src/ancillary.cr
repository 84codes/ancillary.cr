require "socket"
require "./lib_ancillary"

# Allow you to pass file descriptors between process over an UNIX socket
# The socket will be set into blocking mode
class Ancillary
  VERSION = "0.1.1"

  def initialize(@socket : UNIXSocket)
    @socket.blocking = true
  end

  # Send a file descriptor
  def send(fd)
    Ancillary.send(@socket, fd)
  end

  # Receive a file descriptor
  def receive
    Ancillary.receive(@socket)
  end

  # Send a file descriptor
  # Make sure that the socket is in blocking operation
  def self.send(socket : UNIXSocket, fd)
    if LibAncillary.ancil_send_fd(socket.fd, fd) != 0
      raise Error.new "Error while sending file descriptor"
    end
  end

  # Receive a file descriptor
  # Make sure that the socket is in blocking operation
  def self.receive(socket : UNIXSocket)
    fd = LibC::Int.new(0)
    if LibAncillary.ancil_recv_fd(socket.fd, pointerof(fd)) != 0
      raise Error.new "Error while receiving file descriptor"
    end
    fd
  end

  class Error < Exception; end
end
