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

In order to protect users of this project, we require all contributions to comply with the [Developer Certificate of Origin](https://developercertificate.org/). This ensures that all contributions are properly licensed and attributed. All contributors must agree to this document for their contributions to be accepted.

### Community Guidelines

This project is best served by a collaborative and respectful environment. Treat each other professionally, respect differing viewpoints, and engage constructively. Harassment, discrimination, or harmful behavior is not tolerated. Communicate clearly, listen actively, and support one another. If any issues arise, please inform the project maintainers.
