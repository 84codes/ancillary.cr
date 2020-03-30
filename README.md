# Ancillary

Allows you to pass file descriptors between processes over an UNIX socket.
It's a wrapper around a [libancillary](http://www.normalesup.org/~george/comp/libancillary/).

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     ancillary:
       github: 84codes/ancillary
   ```

2. Run `shards install`

## Usage

On one side:

```crystal
require "ancillary"

file = File.open("/tmp/file", "w")

UNIXServer.open("/tmp/fd-passing") do |s|
  while client = s.accept?
    ancil = Ancillary.new(client)
    ancil.send(file.fd)
  end
end
```

On the other side: 

```crystal
require "ancillary"

s = UNIXSocket.new("/tmp/fd-passing")
ancil = Ancillary.new(s)
fd = ancil.receive
io = IO::FileDescriptor.new(fd)
io.print "foo"
io.close
```

## Contributing

1. Fork it (<https://github.com/84codes/ancillary/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Carl Hörberg](https://github.com/carlhoerberg) - creator and maintainer
