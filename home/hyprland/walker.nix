{ inputs
, system
, ...
}: {
  home.packages = [
    inputs.walker.packages."${system}".default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    # All options from the config.json can be used here.
    config = {
      app_launch_prefix = "uwsm app -- ";
      search.placeholder = "Example";
      ui.fullscreen = true;
      list = {
        height = 200;
      };
      websearch.prefix = "?";
      switcher.prefix = "/";
    };

    # If this is not set the default styling is used.
    style = ''
      /* Catppuccin Mocha Blue Theme for Walker - Color Focused */

      /* Palette: Catppuccin Mocha */
      :root {
        --base: #1e1e2e;      /* Background */
        --mantle: #181825;    /* Slightly Lighter Background (e.g., search bar container) */
        --crust: #11111b;     /* Darkest Background */
        --surface0: #313244;  /* UI Elements, Input Fields */
        --surface1: #45475a;  /* Hovered/Active UI Elements */
        --surface2: #585b70;  /* More prominent UI elements or borders */
        --text: #cdd6f4;      /* Primary Text */
        --subtext0: #a6adc8;  /* Secondary/Dimmer Text */
        --subtext1: #bac2de;  /* Slightly Brighter Secondary Text */
        --overlay0: #6c7086;  /* Subtle Borders, Dividers */
        --overlay1: #7f849c;
        --overlay2: #9399b2;  /* More visible overlays or secondary icons */
        --blue: #89b4fa;      /* Primary Accent, Selection, Markers */
        --sky: #89dceb;       /* Icons, Secondary Accent */
        --sapphire: #74c7ec;  /* Alternative Accent */
        --red: #f38ba8;       /* Destructive Actions, Clear Icon Hover */
        --mauve: #cba6f7;
        --green: #a6e3a1;
        --yellow: #f9e2af;
        --peach: #fab387;

        --font-family: sans-serif; /* Walker will likely use system default or its own font settings */
        --font-size-base: 1em;   /* Let Walker control font sizes primarily */
        --border-radius: 4px;    /* A subtle default radius */
      }

      /* General Window Styling */
      /* Assuming Walker applies a class to the main window or uses #window */
      #window, .walker-window, body { /* General selectors */
        background-color: var(--base);
        color: var(--text);
        border: 1px solid var(--overlay0); /* Subtle border for the window */
        font-family: var(--font-family);
      }

      /* Main content box if distinguishable */
      .box, .main-container {
        background-color: transparent; /* Inherits from window or specific sections get color */
      }

      /* Search Area Styling */
      /* Assuming a container for the search elements */
      .search-bar-wrapper, #search { /* Generic class or if 'search' becomes an ID */
        background-color: var(--mantle); /* Slightly different background for the search bar area */
        border-bottom: 1px solid var(--surface0);
        padding: 8px; /* Basic padding */
      }

      /* Search Input Field */
      /* Targets based on name="input" in TOML or common input styling */
      #input, .search-input, input[type="text"] {
        background-color: var(--surface0);
        color: var(--text);
        border: 1px solid var(--surface1);
        border-radius: var(--border-radius);
        padding: 8px 10px;
        font-size: var(--font-size-base);
        caret-color: var(--blue);
      }

      #input:focus, .search-input:focus, input[type="text"]:focus {
        border-color: var(--blue);
        box-shadow: 0 0 0 2px rgba(137, 180, 250, 0.2); /* Subtle blue glow */
        outline: none;
      }

      /* Search Icons: Prompt and Clear */
      /* Targeting based on name="prompt" and name="clear" from TOML */
      #prompt, .prompt-icon {
        color: var(--blue); /* Prompt icon is blue */
      }

      #clear, .clear-icon {
        color: var(--subtext0); /* Clear icon is subtle */
      }
      #clear:hover, .clear-icon:hover {
        color: var(--red); /* Clear icon turns red on hover */
      }

      /* Common styling for icons if they are buttons or distinct elements */
      .icon-button, #prompt, #clear {
        background-color: transparent;
        padding: 4px;
      }

      /* Spinner */
      /* Targeting based on name="spinner" or a generic class */
      #spinner, .spinner, .loading-spinner {
        color: var(--blue);
      }

      /* Scrollable List Area (Results) */
      .scroll-area, #scroll, #aiScroll { /* Targeting scroll containers */
        background-color: var(--base); /* Ensure scroll area background matches window */
      }

      /* List Items */
      .list-item, .item, #aiItem { /* Generic list item selectors */
        color: var(--text);
        padding: 8px 10px;
        margin: 2px 0;
        border-radius: var(--border-radius);
        border: 1px solid transparent; /* For consistent spacing with selected item */
      }

      .list-item:hover, .item:hover, #aiItem:hover {
        background-color: var(--surface0);
      }

      /* Selected/Active List Item */
      .list-item:selected, .item:selected, #aiItem:selected, /* GTK-like */
      .list-item.selected, .item.selected, #aiItem.selected,
      .list-item:focus, .item:focus, #aiItem:focus,
      .list-item.active, .item.active, #aiItem.active {
        background-color: var(--surface1);
        color: var(--text); /* Ensure text is still readable */
        /* The marker_color from TOML is for the "selection indicator", often a border or background part */
        /* If Walker uses a specific element for the marker, target that. Otherwise, this is a general highlight. */
        border-left: 3px solid var(--blue); /* Use Catppuccin Blue for selection indication */
        padding-left: calc(10px - 3px); /* Adjust padding for the border */
      }

      /* Overriding marker_color if Walker applies it directly to an element's style */
      /* This is a bit of a guess; Walker might use this color for a specific sub-element. */
      [style*="marker_color"], .list-marker {
        /* If it's a background or border color property */
        background-color: var(--blue) !important;
        border-color: var(--blue) !important;
        /* If it's a text color property */
        color: var(--blue) !important;
      }
      /* More specific for the list itself if it has a marker property */
      .list, #list {
        /* This is highly dependent on how Walker uses 'marker_color' */
        /* For example, if it's for a ::before or ::after pseudo-element on selected items: */
        /* .list-item.selected::before { background-color: var(--blue); } */
      }


      /* List Item Icons */
      /* Assuming icons within list items might have a class like .icon or are <img> or <icon> tags */
      .list-item .icon, .item .icon, #aiItem .icon,
      .list-item image, .item image, #aiItem image {
        color: var(--sky); /* Default icon color in list items */
      }

      .list-item:selected .icon, .item:selected .icon, #aiItem:selected .icon,
      .list-item.selected .icon, .item.selected .icon, #aiItem.selected .icon,
      .list-item:selected image, .item:selected image, #aiItem:selected image,
      .list-item.selected image, .item.selected image, #aiItem.selected image {
        color: var(--blue); /* Icon color when item is selected */
      }

      /* Activation Label in List Item */
      .activation-label {
        color: var(--overlay2);
        font-size: 0.9em; /* Slightly smaller */
      }
      .list-item:selected .activation-label, .item:selected .activation-label, #aiItem:selected .activation-label,
      .list-item.selected .activation-label, .item.selected .activation-label, #aiItem.selected .activation-label {
        color: var(--sapphire);
      }

      /* Bar Entry Icon (from your TOML) */
      /* [ui.window.box.bar.entry.icon] */
      .bar-entry-icon, #bar-entry-icon { /* If it gets a class or ID */
          color: var(--sky);
      }


      /* Scrollbars */
      /* Styling scrollbars can be tricky and depends on the toolkit (GTK, Qt, web-based) */
      /* Basic WebKit/Blink scrollbar styling (if applicable) */
      ::-webkit-scrollbar {
        width: 8px;
        height: 8px;
      }
      ::-webkit-scrollbar-track {
        background: var(--mantle);
      }
      ::-webkit-scrollbar-thumb {
        background: var(--surface1);
        border-radius: 4px;
      }
      ::-webkit-scrollbar-thumb:hover {
        background: var(--surface2);
      }
      ::-webkit-scrollbar-thumb:active {
        background: var(--blue);
      }

      /* For GTK-like environments, scrollbar styling is often part of the GTK theme. */
      /* If Walker uses GTK and you want to override, you might need more specific GTK selectors: */
      /*
      scrollbar, scrollbar slider {
        background-color: var(--surface1);
        border-radius: var(--border-radius);
      }
      scrollbar slider:hover {
        background-color: var(--surface2);
      }
      scrollbar slider:active {
        background-color: var(--blue);
      }
      */

      /* General Text Selection Style */
      ::selection {
        background-color: var(--blue);
        color: var(--base); /* Text color on selection */
      }
    '';
  };
}
