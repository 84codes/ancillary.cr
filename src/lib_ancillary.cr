@[Link(ldflags: "#{__DIR__}/../libancillary/libancillary.a", static: true)]
lib LibAncillary
  MAX_FDS = 960

  fun ancil_send_fd(socket : LibC::Int, file_descriptor : LibC::Int) : LibC::Int
  fun ancil_send_fds(socket : LibC::Int, fds : LibC::Int*, n_fds : LibC::UInt) : LibC::Int
  fun ancil_recv_fd(socket : LibC::Int, file_descriptor : LibC::Int*) : LibC::Int
  fun ancil_recv_fds(socket : LibC::Int, fds : LibC::Int*, n_fds : LibC::UInt) : LibC::Int
end
