{ config, pkgs, ... }:

{
  programs.steam = {
  	enable = true;
	gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;
  hardware.graphics.enable32Bit = true;

  environment.systemPackages = with pkgs; [
  	lutris
	heroic
	bottles
	protonup-qt
	mangohud
	wineWowPackages.stagingFull
	winetricks
  ];

  programs.nix-ld.enable = true;

}
