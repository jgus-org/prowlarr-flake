# prowlarr

A Nix flake publishing [Prowlarr](https://github.com/Prowlarr/Prowlarr) with a patch that gives each
indexer the arrs' `failDownloads` file-type policy and syncs it to the indexers Prowlarr manages.

## Artifact

`packages.<system>.prowlarr`, also published as `packages.<system>.default` — nixpkgs' Prowlarr with
the patch applied, so it tracks whatever Prowlarr the `nixpkgs` input resolves.

## Consuming

```nix
package = prowlarr.packages.${system}.prowlarr;
```

## What you get

- Every indexer's edit form gains **Fail Downloads**, a multi-select of `Executables` and
  `Potentially Dangerous`, beside the indexer's own limits. The label and the choices are the arr's
  for the same setting, and the value is the array the arr's indexer setting stores, so anything the
  arr does with a hand-set value it does with a synced one: the release fails, is blocklisted, and is
  searched again.
- It is per indexer. Every other field Prowlarr syncs comes from the application's settings or the
  indexer's app profile; this one is the indexer's own, so two indexers on the same Sonarr can differ.
  Both the Newznab and the Torznab implementation carry it.
- Left unset, behaviour is byte-for-byte upstream: Prowlarr stops sending the field, and a value set
  by hand in the arr survives each sync the way it does today. Indexers that already exist after an
  upgrade are unset, so nothing changes until you set one.
- Set, the value is written whenever Prowlarr writes that indexer — on add, on update, and on the
  re-add that replaces an indexer Prowlarr can no longer read back or that lost all its sync
  categories. An index created by hand in the arr, or an indexer Prowlarr does not manage, is
  untouched. Clearing it hands the setting back to the arr but does not restore a value the arr held
  before Prowlarr first wrote it, and a re-add rebuilds the indexer from the arr's schema default.
- An application whose indexer schema has no such field simply gets no field, so the same Prowlarr
  can keep syncing Lidarr, Readarr, Mylar, and the others unchanged.
- The setting is Prowlarr-side. Whether a rejected release's files are also deleted from disk stays
  the arr's own download-client and blocklist configuration.

See [LICENSE.md](LICENSE.md) for licensing and copyright, and [NOTICE.md](NOTICE.md) for the terms of upstream and distributed artifacts.
