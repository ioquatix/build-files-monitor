# Build::Files::Monitor

Efficiently monitor the filesystem for changes.

[![Development Status](https://github.com/ioquatix/build-files-monitor/workflows/Test/badge.svg)](https://github.com/ioquatix/build-files-monitor/actions?workflow=Test)

## Usage

``` ruby
require 'build/files/path'
require 'build/files/directory'
require 'build/files/monitor'

root = Build::Files::Path.current

# Monitor everything within this directory, recursively.
directory = Build::Files::Directory.new(root)

monitor.track_changes(directory) do |state|
	pp state.added
end

monitor.run # Blocking.
```

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by the [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.
