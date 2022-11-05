defmodule Fixtures do
  def error_with_map_data_1() do
    """
    Task #PID<0.2136.0> started from #PID<0.2135.0> terminating
    ** (stop) exited in: GenServer.call(#PID<0.1406.0>, :fetch, 5000)
        ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
        (elixir) lib/gen_server.ex:737: GenServer.call/3
        (slack_coder) lib/slack_coder/github/event_processor.ex:29: SlackCoder.Github.EventProcessor.process/2
        (elixir) lib/task/supervised.ex:85: Task.Supervised.do_apply/2
        (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
    Function: &SlackCoder.Github.EventProcessor.process/2
        Args: [:push, %{"after" => "66459fcbbc256e2d9d84cd42913fdbc5bac9677f", "base_ref" => nil, "before" => "dab0469b49190a3e90693e64c18cd615bb5791e7"}]
    """
  end

  def error_with_map_data_2() do
    """
    Task #PID<0.1821.0> started from #PID<0.1820.0> terminating
    ** (stop) exited in: GenServer.call(#PID<0.1406.0>, :fetch, 5000)
        ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
        (elixir) lib/gen_server.ex:737: GenServer.call/3
        (slack_coder) lib/slack_coder/github/event_processor.ex:29: SlackCoder.Github.EventProcessor.process/2
        (elixir) lib/task/supervised.ex:85: Task.Supervised.do_apply/2
        (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
    Function: &SlackCoder.Github.EventProcessor.process/2
        Args: [:push, %{"after" => "dab0469b49190a3e90693e64c18cd615bb5791e7", "base_ref" => nil, "before" => "466c92fb6b6e760a3e8309c2bfaa5b6a3884ffcc"}]
    """
  end

  def large_error_stripped() do
    """
    ** State machine  terminating
    ** Last message in was {:ssl_closed,
     ,
      }}
    ** When State == :connected
    **      Data  == {:context,
     {:websocket_req, :wss, , ,
      ,
      , , ,
      ,
       },
      {:transport, :ssl, :ssl, :ssl_closed, :ssl_error,
       [mode: :binary, active: true, verify: :verify_none, packet: ]},
      , :undefined, , :undefined, :undefined,
      :undefined},
     {:transport, :ssl, :ssl, :ssl_closed, :ssl_error,
      [mode: :binary, active: true, verify: :verify_none, packet: ]}, [],
     {:wss, , ,
      },
     {Slack.Bot,
      %{bot_handler: SlackCoder.Slack,
        process_state: ,
        slack: , ...},
         channels: , ...},
         client: :websocket_client,
         groups: ,
         ims: ,
         me: %{created: , id: , manual_presence: ,
           name: ,
           prefs: %{has_invited: false, seen_unread_view_coachmark: false,
             highlight_words: , measure_css_usage: false, prev_next_btn: false,
             ss_emojis: true, new_msg_snd: ,
             seen_onboarding_start: false, threads_everything: false,
             seen_intl_channel_names_coachmark: false,
             search_only_current_team: false, seen_domain_invite_reminder: false,
             email_alerts_sleep_until: , preferred_skin_tone: ,
             loud_channels_set: , mac_ssb_bullet: true, fuller_timestamps: false,
             welcome_message_hidden: false, emoji_autocomplete_big: false,
             user_colors: , flannel_server_pool: , seen_ssb_prompt: false,
             two_factor_auth_enabled: false, seen_single_emoji_msg: false,
             overloaded_message_enabled: true, sidebar_behavior: ,
             gdrive_enabled: true, push_idle_wait: , hide_hex_swatch: false,
             no_invites_widget_in_sidebar: false,
             push_at_channel_suppressed_channels: , ...}}, process: ,
         team: %{approaching_msg_limit: false,
           avatar_base_url: , domain: ,
           email_domain: ,
           icon: ,
           id: , messages_count: , msg_edit_window_mins: -,
           name: , over_storage_limit: false,
           plan: ,
           prefs: %{disable_file_editing: false, allow_message_deletion: true,
             file_retention_type: , invites_limit: false,
             custom_status_default_emoji: ,
             who_can_kick_channels: ,
             uses_customized_custom_status_presets: false,
             invites_only_admins: true, dm_retention_duration: ,
             commands_only_regular: false,
             enterprise_team_creation_request: ,
             enterprise_mdm_date_enabled: , disable_file_uploads: ,
             retention_duration: , channel_handy_rxns: nil,
             disallow_public_file_urls: true, calling_app_name: ,
             slackbot_responses_only_admins: true, disable_file_deleting: false,
             auth_mode: , allow_shared_channel_perms_override: false,
             require_at_for_mention: , ...}},
         token: ,
         users: , ...}}}},
     , true, }
    ** Reason for termination =
    **#{" "}
    """

    # Space at end is on purpose
  end

  def large_error() do
    """
    ** State machine #PID<0.796.0> terminating
    ** Last message in was {:ssl_closed,
     {:sslsocket, {:gen_tcp, #Port<0.14798>, :tls_connection, :undefined},
      #PID<0.797.0>}}
    ** When State == :connected
    **      Data  == {:context,
     {:websocket_req, :wss, 'mpmulti-gmov.slack-msgs.com', 443,
      '/websocket/YvyyOLjxLbx8PgBB7RggziLnyngGeUdmLiftGLN4Ho58PqgxE_2c39mVg33KYISyP11G5LBMj3yZyG1YO0NNf6GUy_FnIep9Bm1pFVrqygwOaYF_fj2lNAG6EXDCtsbOnKKXaDVlw3e39qMC_Z7Qf6eJ06MN6gLELKxCezFBAZk=',
      10000, #Reference<0.0.1.22700>, 1,
      {:sslsocket, {:gen_tcp, #Port<0.14798>, :tls_connection, :undefined},
       #PID<0.797.0>},
      {:transport, :ssl, :ssl, :ssl_closed, :ssl_error,
       [mode: :binary, active: true, verify: :verify_none, packet: 0]},
      "AaGbOjmWPYzCA790UW9bB/A==", :undefined, 1, :undefined, :undefined,
      :undefined},
     {:transport, :ssl, :ssl, :ssl_closed, :ssl_error,
      [mode: :binary, active: true, verify: :verify_none, packet: 0]}, [],
     {:wss, 'mpmulti-gmov.slack-msgs.com', 443,
      '/websocket/YvyyOLjxLbx8PsgBB7RggziLnyngGeUdmLiftGLN4Ho58PqgxE_2c39mVg33KYISyP11G5LBMj3yZyG1YO0NNf6GUy_FnIep9Bm1pFVrqygwOaYF_fj2lNAG6EXDCtsbOnKKXaDVlw3e39qMC_Z7Qf6eJ06MN6gLELKxCezFBAZk='},
     {Slack.Bot,
      %{bot_handler: SlackCoder.Slack,
        process_state: %{},
        slack: %Slack.State{bots: %{"B063293" => %{...}, ...},
         channels: %{"C0GY2K8L" => %{...}, ...},
         client: :websocket_client,
         groups: %{},
         ims: %{},
         me: %{created: 1442969439, id: "U0B835TFW", manual_presence: "active",
           name: "bot",
           prefs: %{has_invited: false, seen_unread_view_coachmark: false,
             highlight_words: "", measure_css_usage: false, prev_next_btn: false,
             ss_emojis: true, new_msg_snd: "knock_brush.mp3",
             seen_onboarding_start: false, threads_everything: false,
             seen_intl_channel_names_coachmark: false,
             search_only_current_team: false, seen_domain_invite_reminder: false,
             email_alerts_sleep_until: 0, preferred_skin_tone: "",
             loud_channels_set: "", mac_ssb_bullet: true, fuller_timestamps: false,
             welcome_message_hidden: false, emoji_autocomplete_big: false,
             user_colors: "", flannel_server_pool: "random", seen_ssb_prompt: false,
             two_factor_auth_enabled: false, seen_single_emoji_msg: false,
             overloaded_message_enabled: true, sidebar_behavior: "",
             gdrive_enabled: true, push_idle_wait: 2, hide_hex_swatch: false,
             no_invites_widget_in_sidebar: false,
             push_at_channel_suppressed_channels: "", ...}}, process: #PID<0.796.0>,
         team: %{approaching_msg_limit: false,
           avatar_base_url: "https://ca.slack-edge.com/", domain: "asdf",
           email_domain: "example.com",
           icon: %{},
           id: "T02UYHB632", messages_count: 0, msg_edit_window_mins: -1,
           name: "Example", over_storage_limit: false,
           plan: "std",
           prefs: %{disable_file_editing: false, allow_message_deletion: true,
             file_retention_type: 0, invites_limit: false,
             custom_status_default_emoji: ":speech_balloon:",
             who_can_kick_channels: "admin",
             uses_customized_custom_status_presets: false,
             invites_only_admins: true, dm_retention_duration: 0,
             commands_only_regular: false,
             enterprise_team_creation_request: %{is_enabled: false},
             enterprise_mdm_date_enabled: 0, disable_file_uploads: "allow_all",
             retention_duration: 0, channel_handy_rxns: nil,
             disallow_public_file_urls: true, calling_app_name: "Slack",
             slackbot_responses_only_admins: true, disable_file_deleting: false,
             auth_mode: "google", allow_shared_channel_perms_override: false,
             require_at_for_mention: 0, ...}},
         token: "jHENksejsu638GAGWHWNj2hs2h3jsj",
         users: %{"U0FU7892KK" => %{...}, ...}}}},
     "", true, 0}
    ** Reason for termination =
    ** {:remote, :closed}
    """
  end

  def with_pid_1() do
    """
    Postgrex.Protocol (#PID<0.343.0>) timed out because it was handshaking for longer than 15000ms
    """
  end

  def with_pid_2() do
    """
    Postgrex.Protocol (#PID<0.344.0>) timed out because it was handshaking for longer than 15000ms
    """
  end
end
