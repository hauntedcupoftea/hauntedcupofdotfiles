{ inputs, system, ... }:
{

  home.packages = [
    inputs.walker.packages."${system}".default
  ];
  programs.walker = {
    enable = true;
    runAsService = true;

    # This is Walker's main configuration
    config = {
      app_launch_prefix = "uwsm app --";
      ui.fullscreen = true;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
      general.runner_mode = "drun";
    };

    # This is where you define your custom theme using the submodule structure
    theme = {
      layout = {
        ui.anchors = {
          bottom = true;
          left = true;
          right = true;
          top = true;
        };

        ui.window = {
          h_align = "fill";
          v_align = "fill";
          box = {
            h_align = "center";
            width = 450;
            bar = {
              orientation = "horizontal";
              position = "end";
              entry = {
                h_align = "fill";
                h_expand = true;
                icon = {
                  h_align = "center";
                  h_expand = true;
                  pixel_size = 24;
                  theme = "";
                };
              };
            };
            margins = {
              top = 200;
            };
            ai_scroll = {
              name = "aiScroll";
              h_align = "fill";
              v_align = "fill";
              max_height = 300;
              min_width = 400;
              height = 300;
              width = 400;
              margins = {
                top = 8;
              };
              list = {
                name = "aiList";
                orientation = "vertical";
                width = 400;
                spacing = 10;
                item = {
                  name = "aiItem";
                  h_align = "fill";
                  v_align = "fill";
                  x_align = 0.0; # Nix requires a decimal for floats
                  y_align = 0.0; # Nix requires a decimal for floats
                  wrap = true;
                };
              };
            };
            scroll.list = {
              marker_color = "#1BFFE1";
              max_height = 300;
              max_width = 400;
              min_width = 400;
              width = 400;
              item.activation_label = {
                h_align = "fill";
                v_align = "fill";
                width = 20;
                x_align = 0.5;
                y_align = 0.5;
              };
              item.icon = {
                pixel_size = 26;
                theme = "";
              };
              margins = {
                # This was [ui.window.box.scroll.list.margins]
                top = 8;
              };
            };
            search = {
              prompt = {
                name = "prompt";
                icon = "edit-find";
                theme = "";
                pixel_size = 18;
                h_align = "center";
                v_align = "center";
              };
              clear = {
                name = "clear";
                icon = "edit-clear";
                theme = "";
                pixel_size = 18;
                h_align = "center";
                v_align = "center";
              };
              input = {
                h_align = "fill";
                h_expand = true;
                icons = true;
              };
              spinner = {
                hide = true;
              };
            };
          };
        };
      };

      style = ''
        /* Catppuccin Mocha Blue Theme for Walker - Adapted to Default Structure */

        /* Palette: Catppuccin Mocha */
        :root {
          --base: #1e1e2e;      /* Main background for #box */
          --mantle: #181825;    /* Slightly lighter, for #search bar or elevated elements */
          --crust: #11111b;     /* Darkest */
          --surface0: #313244;  /* UI Elements, hover states */
          --surface1: #45475a;  /* Active/selected states */
          --surface2: #585b70;
          --text: #cdd6f4;      /* Primary Text */
          --subtext0: #a6adc8;  /* Secondary/Dimmer Text */
          --subtext1: #bac2de;
          --overlay0: #6c7086;  /* Borders */
          --overlay1: #7f849c;
          --overlay2: #9399b2;
          --blue: #89b4fa;      /* Primary Accent, Selection */
          --sky: #89dceb;       /* Icons */
          --sapphire: #74c7ec;
          --red: #f38ba8;
          --mauve: #cba6f7;
          --green: #a6e3a1;
          --yellow: #f9e2af;
          --peach: #fab387;

          --border-radius: 2px; /* From default.css */
          --item-padding: 8px;  /* From default.css child padding */
        }

        /* Reset from default.css */
        #window,
        #box,
        #aiScroll,
        #aiList,
        #search,
        #password,
        #input,
        #prompt,
        #clear,
        #typeahead,
        #list,
        child, /* This is typically how GTK CSS refers to list items or direct children */
        scrollbar,
        slider,
        #item, /* Often a container within a 'child' */
        #text,
        #label,
        #bar,
        #sub,
        #activationlabel {
          all: unset;
        }

        /* Error message styling (from default.css, Catppuccin-ified) */
        #cfgerr {
          background: rgba(243, 139, 168, 0.4); /* Catppuccin Red with alpha */
          color: var(--text); /* Ensure text is readable */
          margin-top: 20px;
          padding: 8px;
          font-size: 1.2em;
        }

        /* Main window - only sets text color, background should be transparent or handled by WM */
        #window {
          color: var(--text);
          font-family: sans-serif; /* Basic font stack */
        }

        /* Main content box - this is the primary visible background */
        #box {
          border-radius: var(--border-radius);
          background: var(--base); /* Catppuccin Base */
          padding: 32px; /* From default.css */
          border: 1px solid var(--overlay0); /* Catppuccin Overlay0 for border */
          /* Optional: Softer shadow with Catppuccin colors if desired, or remove if too much */
          box-shadow:
            0 10px 20px rgba(17, 17, 27, 0.25), /* Crust with alpha */
            0 6px 6px rgba(17, 17, 27, 0.2);   /* Crust with alpha */
        }

        /* Search bar area */
        #search {
          /* Optional: Shadow from default.css, can be removed or softened */
          /* box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.22); */
          background: var(--mantle); /* Catppuccin Mantle (slightly lighter than #box) */
          padding: 8px; /* From default.css */
          border-radius: var(--border-radius); /* Added for consistency */
          margin-bottom: 8px; /* Added spacing */
        }

        /* Prompt icon (e.g., search icon) */
        #prompt {
          margin-left: 4px;
          margin-right: 12px;
          color: var(--blue); /* Catppuccin Blue for prompt icon */
          opacity: 0.7; /* Slightly less opaque than default */
        }

        /* Clear icon */
        #clear {
          color: var(--subtext0); /* Catppuccin Subtext0 */
          opacity: 0.8; /* From default.css */
        }
        #clear:hover {
          color: var(--red); /* Catppuccin Red on hover */
        }

        /* Input field related */
        #password,
        #input,
        #typeahead {
          border-radius: var(--border-radius); /* From default.css */
          color: var(--text); /* Catppuccin Text */
          caret-color: var(--blue); /* Catppuccin Blue caret */
        }

        #input {
          background: none; /* From default.css - inherits background from #search */
          padding: 4px 2px; /* Small padding for the input itself */
        }

        #password {
          /* Specific password styling if needed */
        }

        #spinner {
          padding: 8px; /* From default.css */
          color: var(--blue); /* Catppuccin Blue spinner */
        }

        /* Typeahead text (autocompletion suggestion) */
        #typeahead {
          color: var(--subtext1); /* Catppuccin Subtext1 (brighter than placeholder) */
          opacity: 0.8; /* From default.css */
        }

        /* Placeholder text within the input */
        #input placeholder { /* Standard CSS selector for placeholder */
          color: var(--subtext0); /* Catppuccin Subtext0 */
          opacity: 0.6; /* Slightly more visible than default */
        }

        /* List container */
        #list {
          /* No specific styling in default.css, so we leave it mostly to 'child' */
        }

        /* List items (referred to as 'child' in default.css) */
        child {
          padding: var(--item-padding); /* From default.css */
          border-radius: var(--border-radius); /* From default.css */
          color: var(--text);
          border: 1px solid transparent; /* For consistent spacing with selected */
          margin: 2px 0; /* Added for spacing between items */
        }

        child:hover {
          background: var(--surface0); /* Catppuccin Surface0 for hover */
        }

        child:selected {
          background: var(--blue); /* Catppuccin Blue for selection background */
          color: var(--crust); /* Dark text on blue background for contrast */
        }

        /* Container within a list item, if used */
        #item {
          /* No specific styling in default.css */
        }

        /* Icon within a list item */
        #icon {
          margin-right: 8px; /* From default.css */
          color: var(--sky); /* Catppuccin Sky for icons */
        }
        child:selected #icon {
          color: var(--crust); /* Icon color on selected item */
        }


        /* Main text label within a list item */
        #label {
          font-weight: 500; /* From default.css */
          color: var(--text); /* Ensure it inherits window text color if not overridden */
        }
        child:selected #label {
          color: var(--crust); /* Text color on selected item */
        }

        /* Sub-text within a list item */
        #sub {
          opacity: 0.7; /* Slightly more visible than default */
          font-size: 0.9em; /* Slightly larger than default */
          color: var(--subtext0); /* Catppuccin Subtext0 */
        }
        child:selected #sub {
          color: var(--mantle); /* Sub-text color on selected item (lighter than crust) */
          opacity: 0.8;
        }

        /* Activation label (e.g., for keybind hints) */
        #activationlabel {
          color: var(--subtext1);
          font-size: 0.85em;
        }
        child:selected #activationlabel {
          color: var(--base);
        }


        /* Bar (if used, e.g. for tabs or extra info) */
        #bar {
          /* No specific styling in default.css */
        }

        .barentry {
          /* No specific styling in default.css */
        }

        /* Styling for when an item is in "activation" mode (e.g., showing keybinds) */
        .activation #activationlabel {
          /* Specific styling if needed when in activation mode */
        }

        .activation #text,
        .activation #icon,
        .activation #search { /* Note: .activation #search seems unusual, might be a typo in default or specific context */
          opacity: 0.6; /* Slightly more opaque than default */
        }

        /* AI Item specific styling */
        .aiItem {
          padding: 10px; /* From default.css */
          border-radius: var(--border-radius); /* From default.css */
          color: var(--text); /* Catppuccin Text */
          background: var(--base); /* Catppuccin Base */
          margin: 4px 0; /* Added spacing */
        }

        .aiItem.user {
          padding-left: 0; /* From default.css */
          padding-right: 0; /* From default.css */
          /* No background change, uses base .aiItem background */
        }

        .aiItem.assistant {
          background: var(--mantle); /* Catppuccin Mantle for assistant messages (like #search) */
        }

        /* Scrollbar styling (basic WebKit/Blink, GTK might need theme-level changes) */
        scrollbar {
          background-color: transparent;
        }
        scrollbar slider {
          background-color: var(--surface0);
          border-radius: var(--border-radius);
          min-width: 8px;
          min-height: 8px;
        }
        scrollbar slider:hover {
          background-color: var(--surface1);
        }
        scrollbar slider:active {
          background-color: var(--blue);
        }

        /* General text selection style if not handled by GTK */
        ::selection {
          background-color: var(--blue);
          color: var(--crust);
        }
      '';
    };
  };
}
