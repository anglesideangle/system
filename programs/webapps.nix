{
  lib,
  pkgs,
  chromium-wrapped,
  ...
}:
let
  entries =
    let
      apps = {
        Discord = "https://discord.com/channels/@me";
        Slack = "https://app.slack.com/client/";
        Outlook = "https://outlook.office.com/mail/";
        Gmail = "http://mail.google.com/mail/u/0/";
        "Google Calendar" = "https://calendar.google.com/calendar/u/0/";
        Bluesky = "https://bsky.app/";
        Canvas = "https://canvas.mit.edu/";
        Gradescope = "https://www.gradescope.com/";
        Google = "https://www.google.com/";
        Gemini = "https://gemini.google.com";
      };
    in
    lib.mapAttrsToList (
      name: url:
      pkgs.makeDesktopItem {
        inherit name;
        desktopName = name;
        exec = "${lib.getExe chromium-wrapped} --app=${url} --no-first-run --no-default-browser-check";
        terminal = false;
      }
    ) apps;
in
pkgs.symlinkJoin {
  name = "webapps";
  paths = entries;
}
