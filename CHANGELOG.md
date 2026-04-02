### 0.3.0: The facelift

## On the surface
- Add video and audio disassembler
- Interpolation was fixed (multiplier and files with audio handling)
- Overwrite prompt is now spam-enter proof: default button highlight is now on "keep files")
- Some windows were reworded
- DAIN support was removed
- French language added to installer / uninstaller

## Under the hood
- Big installer / uninstaller refactor
  - Installer has now proper functions that can be skipped and a --ffwd / -f flag to pass all prompts (forces 'everything' install, for devs only!)
  - Change servicemenu versions handling by writing to the Actions line instead of splitting desktop files into folders
  - Proper multilingual support for installer / uninstaller

- Run functions aren't wrapped in the overwrite condition anymore
- Add a disclaimer for translators (coming soon to Github page)
- More comments added
