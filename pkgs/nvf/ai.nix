{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  vim.assistant.codecompanion-nvim = {
    enable = true;

    setupOpts = {
      adapters = mkLuaInline ''
        {
          anthropic = require("codecompanion.adapters").extend("anthropic", {
            schema = { model = { default = "claude-sonnet-4.6" } },
          }),

          gemini = require("codecompanion.adapters").extend("gemini", {
            schema = { model = { default = "gemini-3.1-pro" } },
          }),

          -- Kimi is OpenAI-compatible; set KIMI_API_KEY in your environment.
          -- API key from platform.moonshot.cn — separate from the CLI subscription.
          kimi = require("codecompanion.adapters").extend("openai", {
            name = "kimi",
            url = "https://api.moonshot.cn/v1/chat/completions",
            env = { api_key = "KIMI_API_KEY" },
            schema = { model = { default = "kimi-k2-5" } },
          }),
        }
      '';
      interactions = {
        chat = {
          adapter = "gemini";

          roles = mkLuaInline ''
            {
              llm  = "  Assistant",
              user = "  You",
            }
          '';

          # luaInline type
          slash_commands = mkLuaInline ''
            {
              buffer = {
                opts = { provider = "telescope", keymaps = { modes = { i = "<C-b>" } } },
              },
              file = {
                opts = { provider = "telescope", keymaps = { modes = { i = "<C-f>" } } },
              },
              symbols = {
                opts = { provider = "telescope" },
              },
            }
          '';

          tools = {
            opts = {
              auto_submit_errors = false;
              auto_submit_success = true;
            };
          };

          keymaps = {
            send = {
              modes = {
                n = "<C-CR>";
                i = "<C-CR>";
              };
              description = "Send message (Ctrl+Enter)";
            };
            close = {
              modes = {
                n = "q";
                i = "<leader>iq";
              };
              description = "Close chat";
            };
            stop = {
              modes = {
                n = "<leader>is";
              };
              description = "Stop generation";
            };
            clear = {
              modes = {
                n = "<leader>icl";
              };
              description = "Clear chat";
            };
            codeblock = {
              modes = {
                n = "<leader>icc";
              };
              description = "Insert code block";
            };
            next_chat = {
              modes = {
                n = "]c";
              };
              description = "Next chat";
            };
            previous_chat = {
              modes = {
                n = "[c";
              };
              description = "Previous chat";
            };
          };
        };

        inline = {
          adapter = "anthropic";
          keymaps = {
            accept_change = {
              modes = {n = "ga";};
              description = "Accept inline change";
            };
            reject_change = {
              modes = {n = "gR";};
              description = "Reject inline change";
            };
          };
        };
      };

      display = {
        action_palette = {
          width = 95;
          height = 12;
          prompt = "Actions > ";
          provider = "default"; # this should be snacks
          opts = {
            show_default_actions = true;
            show_default_prompt_library = true;
          };
        };

        chat = {
          show_settings = true;
          show_token_count = true;
          show_header_separator = true;
          show_references = true;
          auto_scroll = true;
          start_in_insert_mode = false;
          intro_message = "CodeCompanion ready. Use /file or /buffer for context, @agent for tools.";

          icons = {
            pinned_buffer = " ";
            watched_buffer = "󰈈 ";
          };
        };

        diff = {
          enabled = true;
          # enum: "inline" | "split" | "mini_diff"
          provider = "split";
          layout = "vertical";
          close_chat_at = 75;
        };

        inline = {
          layout = "vertical";
        };
      };

      opts = {
        log_level = "ERROR";
        send_code = true;
        language = "English";
      };

      prompt_library = {
        "Explain code" = {
          strategy = "chat";
          description = "Explain the selected code in detail";
          opts = {
            index = 5;
            is_default = true;
            is_slash_cmd = false;
            modes = ["v"];
            short_name = "explain";
            auto_submit = true;
            stop_context_insertion = true;
            user_prompt = false;
          };
          prompts = [
            {
              role = "system";
              content = "You are an expert programmer. Explain code clearly and concisely, covering what it does, how it works, and any non-obvious design decisions.";
            }
            {
              role = "user";
              content = mkLuaInline ''
                function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Explain this " .. context.filetype .. " code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end
              '';
            }
          ];
        };

        "Add tests" = {
          strategy = "chat";
          description = "Generate tests for the selected code";
          opts = {
            index = 6;
            is_default = true;
            is_slash_cmd = false;
            modes = ["v"];
            short_name = "tests";
            auto_submit = true;
            stop_context_insertion = true;
            user_prompt = false;
          };
          prompts = [
            {
              role = "system";
              content = "You are an expert in writing tests. Generate comprehensive tests including edge cases. Use the same testing framework already present in the project if identifiable.";
            }
            {
              role = "user";
              content = mkLuaInline ''
                function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Write tests for this " .. context.filetype .. " code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end
              '';
            }
          ];
        };

        "Fix issue" = {
          strategy = "inline";
          description = "Fix the selected code inline";
          opts = {
            index = 7;
            is_default = true;
            is_slash_cmd = false;
            modes = ["v"];
            short_name = "fix";
            auto_submit = true;
            stop_context_insertion = true;
            user_prompt = true;
          };
          prompts = [
            {
              role = "system";
              content = "You are an expert programmer. Fix the code issue described by the user. Return only the corrected code with no explanation or markdown fences.";
            }
            {
              role = "user";
              content = mkLuaInline ''
                function(context)
                  local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)
                  return "Fix this " .. context.filetype .. " code:\n\n```" .. context.filetype .. "\n" .. code .. "\n```"
                end
              '';
            }
          ];
        };
      };
    };
  };

  vim.maps.normal = {
    "<leader>ic" = {
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      desc = "AI: Toggle chat";
      silent = true;
    };
    "<leader>ia" = {
      action = "<cmd>CodeCompanionActions<CR>";
      desc = "AI: Action palette";
      silent = true;
    };
    "<leader>ii" = {
      action = "<cmd>CodeCompanion<CR>";
      desc = "AI: Inline prompt";
      silent = true;
    };
    "<leader>in" = {
      action = "<cmd>CodeCompanionChat<CR>";
      desc = "AI: New chat";
      silent = true;
    };
  };

  vim.maps.visual = {
    "<leader>ic" = {
      action = "<cmd>CodeCompanionChat Toggle<CR>";
      desc = "AI: Send selection to chat";
      silent = true;
    };
    "<leader>ia" = {
      action = "<cmd>CodeCompanionActions<CR>";
      desc = "AI: Action palette";
      silent = true;
    };
    "<leader>ii" = {
      action = "<cmd>CodeCompanion<CR>";
      desc = "AI: Inline prompt on selection";
      silent = true;
    };
  };
}
