{ configs, pkgs, ... }:

{
  home.username = "anomxsst17";
  home.homeDirectory = "/home/anomxsst17";
  home.stateVersion = "23.11"; # No cambiar esto
  home.packages = with pkgs; [
  	bitwarden-desktop
	brave
	spotify
	fish
	fastfetch
	foliate
	duf
	vscode
	librewolf
	nyxt
	fzf
	grc
	discord
	kdePackages.dolphin
	ferdium
	antigravity
  ];

  # Home-manager
  programs.home-manager.enable = true;

  # Git
  programs.git = {
  	enable = true;
	userName = "N4tonh";
	userEmail = "n4tonh@proton.me";
  };

  # --- FISH & STARSHIP ---

  programs.fish = {
  	enable = true;
	interactiveShellInit = ''
	  set fish_greeting
	'';
	plugins = [
	  { name = "z"; src = pkgs.fishPlugins.z.src; }
	  { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
	  { name = "done"; src = pkgs.fishPlugins.done.src; }
	];

	# Aliases útiles
	shellAliases = {
		rebuild = "sudo nixos-rebuild switch --flake /etc/nixos/#twarlien";
		ll = "ls -lha";
		v = "nvim";
	};
  };

  programs.starship = {
  	enable = true;
	enableFishIntegration = true;
  };

  programs.fzf.enable = true;

}
