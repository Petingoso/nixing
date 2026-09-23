{ pkgs, ... }:
let
  tmux-backup-bin = pkgs.rustPlatform.buildRustPackage {
    pname = "tmux-backup";
    version = "0.5.10";

    src = pkgs.fetchFromGitHub {
      owner = "graelo";
      repo = "tmux-backup";
      rev = "v0.5.10";
      hash = "sha256-yfHZMMOKxOfHUJvQLGpL02gaym6cL2wAgQmlwN1dpD8=";
    };

    cargoHash = "sha256-Io0/Z60gho1nFMUn4PzVHAuEjV8Mzl6qzwq8eC3OpH4=";
  };

  tmux-backup-plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-backup";
    name = "tmux-backup";
    rtpFilePath = "tmux-backup.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "graelo";
      repo = "tmux-backup";
      rev = "v0.5.10";
      hash = "sha256-yfHZMMOKxOfHUJvQLGpL02gaym6cL2wAgQmlwN1dpD8=";
    };
  };
in
{
  environment.systemPackages = [
    pkgs.wl-clipboard
    pkgs.moreutils
    tmux-backup-bin
  ];

  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      tmux-fzf
      jump
      tmux-backup-plugin
    ];
    extraConfig = ''
      set -g default-terminal "tmux-256color"

      #vim uses C-b
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix


      # permit changing terminal title
      set -g set-titles on
      set -g set-titles-string "#T"

      set -g allow-rename off
      set -g automatic-rename off

      # Enable auto-rename for new windows
      setw -g automatic-rename on

      set -g mouse on

      # makes windows snicer
      set -g renumber-windows on
      set -g base-index 1
      setw -g pane-base-index 1

      # Rather than constraining window size to the maximum size of any client
      # connected to the *session*, constrain window size to the maximum size of any
      # client connected to *that window*. Much more reasonable.
      setw -g aggressive-resize on


      # binds

      setw -g mode-keys vi

      bind R source-file /etc/tmux.conf\; display "Config reloaded!"

      bind-key C command-prompt -p "Name of new window: " "new-window -n '%%'"

      unbind [
      unbind ]

      bind r copy-mode
      bind P paste-buffer

      #probs not needed but for good measure
      bind -T copy-mode-vi v send -X begin-selection       # character-wise
      bind -T copy-mode-vi V send -X select-line          # line-wise
      bind -T copy-mode-vi C-v send -X rectangle-toggle   # rectangle



      unbind '"'
      unbind %

      bind v split-window -h
      bind B split-window

      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind H select-pane -L
      bind J select-pane -D
      bind K select-pane -U
      bind L select-pane -R

      set -g @jump-key 'S'

      #bar
      set -g status-position bottom
      set -g status-justify left
      set -g status-style 'fg=red'

      set -g status-left "#[fg=black,bg=yellow,bold] #S #[default]"
      set -g status-left-length 20


      set -g status-right-style 'fg=black bg=yellow'
      set -g status-right '%Y-%m-%d %H:%M '
      set -g status-right-length 50

      setw -g window-status-current-style 'fg=black bg=red'
      setw -g window-status-current-format ' #I #W #F '

      setw -g window-status-style 'fg=red bg=black'
      setw -g window-status-format ' #I #[fg=white]#W #[fg=yellow]#F '

      setw -g window-status-bell-style 'fg=yellow bg=red bold'

      # messages
      set -g message-style 'fg=yellow bg=red bold'
    '';
  };
}
