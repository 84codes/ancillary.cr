@[Link(ldflags: "#{__DIR__}/../libancillary/libancillary.a", static: true)]
lib LibAncillary
  fun ancil_send_fd(socket : LibC::Int, file_descriptor : LibC::Int) : LibC::Int
  fun ancil_recv_fd(socket : LibC::Int, file_descriptor : LibC::Int*) : LibC::Int
end
