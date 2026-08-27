#!/usr/bin/env bash

# Terminal.app (Apple's built-in terminal) does not read iTerm's settings, so the
# Nerd Font that makes powerline/prompt icons render has to be set on its own
# profile. macOS stores the profile font as an archived NSFont blob inside
# com.apple.Terminal, which plain `defaults` can't write, so we use the ObjC
# bridge (osascript -l JavaScript) to build and apply it.

terminal_plist="$HOME/Library/Preferences/com.apple.Terminal.plist"
terminal_font_name="MesloLGS-NF-Regular" # PostScript name of the installed Nerd Font
terminal_font_file="$HOME/Library/Fonts/MesloLGS NF Regular.ttf" # for on-demand registration
terminal_font_size=13

# Applies terminal_font_name to Terminal's default + startup profiles.
# Prints "OK ..." on success or "ERROR: ..." on failure.
_terminal_apply_font() {
  TF_FONT_NAME="$terminal_font_name" TF_FONT_SIZE="$terminal_font_size" TF_FONT_PATH="$terminal_font_file" \
    osascript -l JavaScript <<'JXA'
ObjC.import('AppKit');
ObjC.import('Foundation');
ObjC.import('CoreText');
function run() {
  var app = 'com.apple.Terminal';
  var env = $.NSProcessInfo.processInfo.environment;
  var fontName = env.objectForKey('TF_FONT_NAME').js;
  var fontSize = parseInt(env.objectForKey('TF_FONT_SIZE').js, 10);
  var fontPath = env.objectForKey('TF_FONT_PATH');

  var ud = $.NSUserDefaults.alloc.init;
  var domain = ud.persistentDomainForName(app);
  if (domain.isNil()) { return 'ERROR: no Terminal preferences found'; }

  var m  = $.NSMutableDictionary.dictionaryWithDictionary(domain);
  var wsRaw = m.objectForKey('Window Settings');
  if (wsRaw.isNil()) { return 'ERROR: no Window Settings found'; }
  var ws = $.NSMutableDictionary.dictionaryWithDictionary(wsRaw);

  var font = $.NSFont.fontWithNameSize(fontName, fontSize);
  // A font installed moments ago (e.g. by the Fonts step of "Install all") may
  // not be registered with CoreText yet, so NSFont can't find it. Register the
  // file for this process and retry before giving up.
  if (font.isNil() && fontPath && !fontPath.isNil()) {
    var url = $.NSURL.fileURLWithPath(fontPath.js);
    $.CTFontManagerRegisterFontsForURL(url, $.kCTFontManagerScopeProcess, $());
    font = $.NSFont.fontWithNameSize(fontName, fontSize);
  }
  if (font.isNil()) { return 'ERROR: font not installed: ' + fontName; }
  var err = $();
  var fdata = $.NSKeyedArchiver.archivedDataWithRootObjectRequiringSecureCodingError(font, false, err);

  // Prefer the profiles Terminal actually uses; fall back to every profile.
  var names = [];
  ['Default Window Settings', 'Startup Window Settings'].forEach(function (k) {
    var v = m.objectForKey(k);
    if (v && !v.isNil()) { names.push(v.js); }
  });
  if (names.length === 0) { names = ObjC.deepUnwrap(ws.allKeys); }

  var changed = [];
  names.forEach(function (name) {
    var p = ws.objectForKey(name);
    if (p && !p.isNil()) {
      var prof = $.NSMutableDictionary.dictionaryWithDictionary(p);
      prof.setObjectForKey(fdata, 'Font');
      // If a separate non-ASCII font is configured it would hide the glyphs,
      // so point it at the same Nerd Font.
      if (!prof.objectForKey('NonASCIIFont').isNil()) {
        prof.setObjectForKey(fdata, 'NonASCIIFont');
      }
      // Make the window fully opaque: a transparent/blurred background lets the
      // desktop bleed through as a white/black overlay. Rebuild the background
      // color with alpha 1.0 (keeping its RGB) and disable blur.
      var bc = prof.objectForKey('BackgroundColor');
      if (!bc.isNil()) {
        var e2 = $();
        var col = $.NSKeyedUnarchiver.unarchivedObjectOfClassFromDataError($.NSColor.class, bc, e2);
        if (!col.isNil()) {
          var c = col.colorUsingColorSpace($.NSColorSpace.genericRGBColorSpace);
          var opaque = $.NSColor.colorWithCalibratedRedGreenBlueAlpha(
            c.redComponent, c.greenComponent, c.blueComponent, 1.0);
          var e3 = $();
          var odata = $.NSKeyedArchiver.archivedDataWithRootObjectRequiringSecureCodingError(opaque, false, e3);
          prof.setObjectForKey(odata, 'BackgroundColor');
        }
      }
      prof.setObjectForKey($.NSNumber.numberWithDouble(0), 'BackgroundBlur');
      if (!prof.objectForKey('BackgroundBlurInactive').isNil()) {
        prof.setObjectForKey($.NSNumber.numberWithDouble(0), 'BackgroundBlurInactive');
      }
      ws.setObjectForKey(prof, name);
      changed.push(name);
    }
  });
  if (changed.length === 0) { return 'ERROR: no matching profile to update'; }

  m.setObjectForKey(ws, 'Window Settings');
  ud.setPersistentDomainForName(m, app);
  ud.synchronize;
  return 'OK ' + changed.join(', ');
}
JXA
}

# Reads the font name of Terminal's default profile (empty if unavailable).
_terminal_current_font() {
  TF_FONT_PATH="$terminal_font_file" osascript -l JavaScript <<'JXA' 2>/dev/null
ObjC.import('AppKit');
ObjC.import('Foundation');
ObjC.import('CoreText');
function run() {
  // Register the font for this process first: unarchiving an NSFont whose font
  // is not registered yet makes CoreText substitute a system font (e.g.
  // .AppleSystemUIFont), which would make a freshly-set font look "not set".
  var env = $.NSProcessInfo.processInfo.environment;
  var fontPath = env.objectForKey('TF_FONT_PATH');
  if (fontPath && !fontPath.isNil()) {
    var furl = $.NSURL.fileURLWithPath(fontPath.js);
    $.CTFontManagerRegisterFontsForURL(furl, $.kCTFontManagerScopeProcess, $());
  }

  var ud = $.NSUserDefaults.alloc.init;
  var m = ud.persistentDomainForName('com.apple.Terminal');
  if (m.isNil()) { return ''; }
  var ws = m.objectForKey('Window Settings');
  var def = m.objectForKey('Default Window Settings');
  if (ws.isNil() || def.isNil()) { return ''; }
  var prof = ws.objectForKey(def.js);
  if (prof.isNil()) { return ''; }
  var fdata = prof.objectForKey('Font');
  if (fdata.isNil()) { return ''; }
  var err = $();
  var font = $.NSKeyedUnarchiver.unarchivedObjectOfClassFromDataError($.NSFont.class, fdata, err);
  if (font.isNil()) { return ''; }
  return font.fontName.js;
}
JXA
}

install_terminal_font() {
  new_line
  msg_title "Terminal font settings"

  msg_searching "Checking if the Nerd Font is installed"
  if ! file_exists "$HOME/Library/Fonts/MesloLGS NF Regular.ttf"; then
    msg_not_found "Not found"
    msg_warning "MesloLGS NF font is not installed. Please run the 'Fonts' item first."
    return
  fi
  msg_found "Found"

  # Snapshot the pristine Terminal preferences so uninstall can restore them.
  backup_path "$terminal_plist" terminal_plist

  msg_searching "Configuring Terminal font"
  local result
  result="$(_terminal_apply_font)"
  if [[ "$result" == OK* ]]; then
    msg_found "Configured (${result#OK })"
  else
    msg_warning "$result"
    return
  fi

  msg_installed "Terminal font & opacity set (restart Terminal to see the changes)"
}

install_terminal_font_manually() {
  install_terminal_font
}

check_install_terminal_font() {
  local font
  font="$(_terminal_current_font)"
  if [[ "$font" == *MesloLGS* ]]; then
    msg_found "Installed"
  else
    msg_not_found "Not installed"
  fi
}
