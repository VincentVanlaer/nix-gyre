{
  lib,
}:
{
  patchLinkProgs = (makeFiles: linkProgs:
    /* bash */ ''
      for f in ${makeFiles}; do
        if [[ -f $f ]]; then
          ${(lib.strings.concatStringsSep
              "\n"
              (lib.attrsets.mapAttrsToList
                (name: value: "sed -i \"s|${name}|${value}|\" $f")
                linkProgs
              )
          )}
        fi
      done
    ''
  );
}
