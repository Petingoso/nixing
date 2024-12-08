{
    config,
    lib,
    pkgs,
    ...
}: let
    cfg = config.mystuff.programs.vesktop;
    inherit (config.mystuff.other.system) username;

    inherit (lib.modules) mkIf;
    inherit (lib.options) mkEnableOption;
    inherit (lib.strings) concatStrings;
in {
    options.mystuff.programs.vesktop = {
        enable = mkEnableOption "vesktop";
    };

    config = mkIf cfg.enable {
        users.users.${username}.packages = [
            (pkgs.vesktop.overrideAttrs (old: {
                patches = (old.patches or []) ++ [ ./readonlyFix.patch ];
                # thanks aleph :3
                # https://github.com/AlephNought0/Faery/blob/main/modules/home/programs/graphical/vesktop/patchedvesktop.patch
                # thanks poz 
                postFixup = concatStrings [
                    old.postFixup
                    ''
                        wrapProgram $out/bin/vesktop \
                            --add-flags "--ozone-platform=wayland \
                                --enable-zero-copy \
                                --use-gl=angle \
                                --use-vulkan \
                                --enable-oop-rasterization \
                                --enable-raw-draw \
                                --enable-gpu-rasterization \
                                --enable-gpu-compositing \
                                --enable-native-gpu-memory-buffers \
                                --enable-accelerated-2d-canvas \
                                --enable-accelerated-video-decode \
                                --enable-accelerated-mjpeg-decode \
                                --disable-gpu-vsync \
                                --enable-features=Vulkan,VulkanFromANGLE,DefaultANGLEVulkan,VaapiIgnoreDriverChecks,VaapiVideoDecoder,PlatformHEVCDecoderSupport"
                    ''
                ];
            }))
        ];

        home-manager.users.${username} = {
            xdg.configFile."vesktop/settings.json".text = builtins.toJSON {
                discordBranch = "ptb";
                firstLaunch = false;
                arRPC = "on";
                splashColor = "rgb(220, 221, 222)";
                splashBackground="oklab(0.321044 -0.000249296 -0.00927344)";
                minimizeToTray = true;
            };

            xdg.configFile."vesktop/quickCss.css".source = ./quickCss.css;
            xdg.configFile."vesktop/settings/settings.json".text = builtins.toJSON {
                notifyAboutUpdates = false;
                autoUpdate = false;
                autoUpdateNotification = false;
                useQuickCss = true;
                themeLinks = [];
                enabledThemes = ["Catppuccin.theme.css"]; # TODO:
                enableReactDevtools = false;
                frameless = false;
                transparent = true;
                winCtrlQ = false;
                macosTranslucency = false;
                disableMinSize = false;
                winNativeTitleBar = false;
                plugins = {
                    BadgeAPI.enabled = true;
                    CommandsAPI.enabled = true;
                    ContextMenuAPI.enabled = true;
                    MemberListDecoratorsAPI.enabled = true;
                    MessageAccessoriesAPI.enabled = true;
                    MessageDecorationsAPI.enabled = true;
                    MessageEventsAPI.enabled = true;
                    MessagePopoverAPI.enabled = true;
                    NoticesAPI.enabled = true;
                    ServerListAPI.enabled = true;
                    SettingsStoreAPI.enabled = true;
                    NoTrack.enabled = true;
                    Settings = {
                        enabled = true;
                        settingsLocation = "aboveActivity";
                    };
                    AlwaysAnimate.enabled = false;
                    AlwaysTrust.enabled = false;
                    AnonymiseFileNames.enabled = false;
                    "WebRichPresence (arRPC)".enabled = false;
                    BANger.enabled = false;
                    BetterFolders = {
                        enabled = false;
                        sidebar = true;
                        sidebarAnim = true;
                        closeAllFolders = false;
                        closeAllHomeButton = false;
                        closeOthers = false;
                        forceOpen = false;
                        keepIcons = false;
                        showFolderIcon = 1;
                    };
                    BetterGifAltText.enabled = false;
                    BetterNotesBox.enabled = false;
                    BetterRoleDot.enabled = false;
                    BetterUploadButton.enabled = true;
                    BiggerStreamPreview.enabled = false;
                    BlurNSFW.enabled = false;
                    CallTimer = {
                        enabled = true;
                        format = "human";
                    };
                    ClearURLs.enabled = true;
                    ColorSighted.enabled = false;
                    ConsoleShortcuts.enabled = false;
                    CopyUserURLs.enabled = true;
                    CrashHandler.enabled = true;
                    CustomRPC.enabled = false;
                    Dearrow.enabled = false;
                    DisableDMCallIdle.enabled = false;
                    EmoteCloner.enabled = false;
                    Experiments = {
                        enabled = false;
                        enableIsStaff = false;
                    };
                    F8Break.enabled = false;
                    FakeNitro = {
                        enabled = true;
                        enableEmojiBypass = true;
                        emojiSize = 48;
                        transformEmojis = true;
                        enableStickerBypass = true;
                        stickerSize = 160;
                        transformStickers = true;
                        transformCompoundSentence = false;
                        enableStreamQualityBypass = true;
                    };
                    FakeProfileThemes = {
                        enabled = false;
                        nitroFirst = true;
                    };
                    FavoriteEmojiFirst.enabled = true;
                    FavoriteGifSearch = {
                        enabled = false;
                        searchOption = "hostandpath";
                    };
                    FixImagesQuality.enabled = true;
                    FixSpotifyEmbed = {
                        enabled = true;
                        volume = 10;
                    };
                    ForceOwnerCrown.enabled = false;
                    FriendInvites.enabled = false;
                    GameActivityToggle.enabled = true;
                    GifPaste.enabled = true;
                    HideAttachments.enabled = false;
                    iLoveSpam.enabled = false;
                    IgnoreActivities = {
                        enabled = true;
                        ignoredActivities = [];
                    };
                    ImageZoom = {
                        enabled = true;
                        saveZoomValues = true;
                        invertScroll = true;
                        nearestNeighbour = false;
                        square = false;
                        zoom = 2;
                        size = 100;
                        zoomSpeed = 0.5;
                    };
                    InvisibleChat = {
                        enabled = false;
                        savedPasswords = "password";
                    };
                    KeepCurrentChannel.enabled = false;
                    LastFMRichPresence.enabled = false;
                    LoadingQuotes.enabled = false;
                    MemberCount.enabled = true;
                    MessageClickActions = {
                        enabled = true;
                        enableDeleteOnClick = true;
                        enableDoubleClickToEdit = true;
                        enableDoubeClickToReply = true;
                        requireModifier = true;
                    };
                    MessageLinkEmbeds = {
                        enabled = false;
                        automodEmbeds = "never";
                        listMode = "blacklist";
                        idList = "";
                    };
                    MessageLogger = {
                        enabled = true;
                        deleteStyle = "text";
                        ignoreBots = false;
                        ignoreSelf = false;
                        ignoreUsers = "";
                        ignoreChannels = "";
                        ignoreGuilds = "";
                    };
                    MessageTags.enabled = false;
                    MoreCommands.enabled = false;
                    MoreKaomoji.enabled = true;
                    MoreUserTags.enabled = true;
                    Moyai.enabled = false;
                    MuteNewGuild = {
                        enabled = true;
                        guild = false;
                        everyone = true;
                        role = true;
                    };
                    MutualGroupDMs.enabled = true;
                    NoBlockedMessages = {
                        enabled = false;
                        ignoreBlockedMessages = false;
                    };
                    NoDevtoolsWarning.enabled = false;
                    NoF1.enabled = false;
                    NoPendingCount.enabled = false;
                    NoProfileThemes.enabled = true;
                    NoReplyMention = {
                        enabled = false;
                        # userList = "372809091208445953";
                        # shouldPingListed = false;
                        # inverseShiftReply = true;
                    };
                    NoScreensharePreview.enabled = false;
                    NoTypingAnimation = false;
                    NoUnblockToJump.enabled = false;
                    NSFWGateBypass.enabled = true;
                    oneko.enabled = false;
                    OpenInApp.enabled = false;
                    "Party mode 🎉".enabled = false;
                    PermissionFreeWill = {
                        enabled = false;
                        # lockout = true;
                        # onboarding = true;
                    };
                    PermissionsViewer = {
                        enabled = true;
                        permissionsSortOrder = 0;
                        defaultPermissionsDropdownState = false;
                    };
                    petpet.enabled = false;
                    PictureInPicture = {
                        enabled = false;
                        # loop = false;
                    };
                    PinDMs.enabled = true;
                    PlainFolderIcon.enabled = false;
                    PlatformIndicators = {
                        enabled = true;
                        list = true;
                        badges = true;
                        messages = true;
                        colorMobileIndicator = true;
                    };
                    PreviewMessage.enabled = true;
                    PronounDB.enabled = false;
                    QuickMention.enabled = false;
                    QuickReply.enabled = false;
                    ReactErrorDecoder.enabled = false;
                    ReadAllNotificationsButton.enabled = false;
                    RelationshipNotifier = {
                        enabled = true;
                        notices = true;
                        offlineRemovals = true;
                        friends = true;
                        friendRequestCancels = true;
                        servers = true;
                        groups = true;
                    };
                    RevealAllSpoilers.enabled = false;
                    ReverseImageSearch.enabled = false;
                    ReviewDB.enabled = false;
                    RoleColorEverywhere = {
                        enabled = false;
                        # chatMentions = true;
                        # memberList = true;
                        # voiceUsers = true;
                    };
                    SearchReply.enabled = true;
                    SendTimestamps.enabled = false;
                    ServerListIndicators = {
                        enabled = true;
                        mode = 3;
                    };
                    ServerProfile.enabled = true;
                    ShikiCodeblocks = {
                        enabled = true;
                        # theme = "https://raw.githubusercontent.com/shikijs/shiki/0b28ad8ccfbf2615f2d9d38ea8255416b8ac3043/packages/shiki/themes/dark-plus.json";
                        # tryHljs = "SECONDARY";
                        # uesDevIcon = "GREYSCALE";
                        bgOpacity = 100;
                    };
                    ShowAllMessageButtons.enabled = false;
                    ShowConnections = {
                        enabled = false;
                        # iconSize = 32;
                        # iconSpacing = 1;
                    };
                    ShowHiddenChannels = {
                        enabled = false;
                        # hideUnreads = true;
                        # showMode = 0;
                        # defaultAllowedUsersAndRolesDropdownState = true;
                    };
                    ShowMeYourName.enabled = false;
                    ShowTimeouts.enabled = true;
                    SilentMessageToggle = {
                        enabled = false;
                        # persistState = false;
                        # autoDisable = true;
                    };
                    SilentTyping = {
                        enabled = false;
                        # showIcon = false;
                        # isEnabled = true;
                    };
                    SortFriendRequests.enabled = false;
                    SpotifyControls.enabled = false;
                    SpotifyCrack.enabled = false;
                    SpotifyShareCommands.enabled = false;
                    StartupTimings.enabled = false;
                    SupportHelper.enabled = true;
                    TextReplace.enabled = false;
                    TimeBarAllActivities.enabled = false;
                    Translate.enabled = false;
                    TypingIndicator = {
                        enabled = true;
                        includeMutedChannels = false;
                        includeBlockedUsers = true;
                    };
                    TypingTweaks = {
                        enabled = false;
                        # showAvatars = true;
                        # showRoleColors = true;
                        # alternativeFormatting = true;
                    };
                    Unindent.enabled = false;
                    UnsuppressEmbeds.enabled = false;
                    UrbanDictionary.enabled = false;
                    UserVoiceShow = {
                        enabled = false;
                        # showInUserProfileModal = true;
                        # showVoiceChannelSectionHeader = true;
                    };
                    USRBG.enabled = false;
                    UwUifier.enabled = false;
                    ValidUser.enabled = false;
                    VoiceChatDoubleClick.enabled = false;
                    VcNarrator.enabled = false;
                    VencordToolbox.enabled = false;
                    ViewIcons = {
                        enabled = true;
                        format = "png";
                        imgSize = "2048";
                    };
                    ViewRaw = {
                        enabled = true;
                        clickMethod = "Left";
                    };
                    VoiceMessages = {
                        enabled = true;
                        noiseSuppression = true;
                        echoCancellation = true;
                    };
                    WebContextMenus = {
                        enabled = true;
                        addBack = true;
                    };
                    WebKeybinds.enabled = true;
                    GreetStickerPicker.enabled = false;
                    WhoReacted.enabled = true;
                    Wikisearch.enabled = false;
                    NormalizeMessageLinks.enabled = false;
                    "AI Noise Suppression" = {
                        enabled = true;
                        isEnabled = true;
                    };
                    SecretRingToneEnabler.enabled = false;
                };
                notifications = {
                    timeout = 5000;
                    position = "bottom-right";
                    useNative = "not-focused";
                    logLimit = 50;
                };
                cloud = {
                    authenticated = false;
                    url = "https://api.vencord.dev/";
                    settingsSync = false;
                    settingsSyncVersion = 1682768329526;
                };
            };
        };
    };
}
