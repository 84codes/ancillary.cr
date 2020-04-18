require "socket"
require "./lib_ancillary"

# Allow you to pass file descriptors between process over an UNIX socket
# The socket will be set into blocking mode
class Ancillary
  VERSION = "0.1.2"

  def initialize(@socket : UNIXSocket)
    @socket.blocking = true
  end

  # Send a file descriptor
  def send(fd : Int)
    Ancillary.send(@socket, fd)
  end

  # Send an array of file descriptors
  def send(fds : Array(Int32))
    Ancillary.send(@socket, fds)
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

  # Send multiple file descriptor
  # Make sure that the socket is in blocking operation
  def self.send(socket : UNIXSocket, fds : Array(Int32))
    if LibAncillary.ancil_send_fds(socket.fd, fds.to_unsafe, fds.size) != 0
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

  # Receive a file descriptor
  # Make sure that the socket is in blocking operation
  def self.receive_multiple(socket : UNIXSocket, max = LibAncillary::MAX_FDS)
    arr = Array(LibC::Int).new(max)
    if LibAncillary.ancil_recv_fd(socket.fd, arr.to_unsafe, arr.size) != 0
      raise Error.new "Error while receiving file descriptors"
    end
    arr
  end

  class Error < Exception; end
end
