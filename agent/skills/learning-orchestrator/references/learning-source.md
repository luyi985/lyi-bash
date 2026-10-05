# Learning Source

## Accepted inputs

- `LocalSource`: a specified file or folder under the target workspace's `preRaw/` tree.
- `ExternalSource`: an external link or externally addressable resource available through the current runtime.

Resolve sources using the capabilities available in the current environment; do not bind this specification to one connector or transport.

## Validation gate

Before analyzing or generating KPs, verify:

1. the resource exists or resolves;
2. it is readable;
3. its expected scope is accessible, not only its title or summary;
4. no obviously required part is missing;
5. the obtained content is sufficient for the requested decomposition.

For folders, repositories, courses, and multi-page collections, inspect enough structure to distinguish complete access from a landing page, README, excerpt, or partial listing.

## Failure behavior

If validation fails, do not change the KP plan. Identify each unavailable or incomplete input, distinguish access failure from missing material or uncertain scope, and state the smallest action needed to continue.

Validation confirms accessibility and apparent coverage; it does not claim the source is factually correct.
