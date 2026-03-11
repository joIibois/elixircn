defmodule ElixircnWeb.ShowcaseApiDocs do
  @moduledoc "API documentation data for showcase component pages."

  def docs do
    %{
      "accordion" => [
        %{
          title: "accordion/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique HTML element ID."},
            %{prop: "type", type: "string", required: false, default: "\"multiple\"", desc: "Expand behavior: \"multiple\" allows many open items, \"single\" allows only one."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        },
        %{
          title: "accordion_item/1",
          rows: [
            %{prop: "value", type: "string", required: true, default: "—", desc: "Unique key identifying this item within the accordion."},
            %{prop: "accordion_id", type: "string", required: true, default: "—", desc: "ID of the parent accordion element."},
            %{prop: "open", type: "boolean", required: false, default: "false", desc: "Whether this item is expanded by default."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: true, default: "—", desc: "Clickable header content of the item."},
            %{prop: ":content", type: "slot", required: true, default: "—", desc: "Content revealed when the item is expanded."}
          ]
        }
      ],
      "alert" => [
        %{
          title: "alert/1",
          rows: [
            %{prop: "variant", type: "string", required: false, default: "\"default\"", desc: "Visual style: default or destructive."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Alert content (title, description)."}
          ]
        },
        %{
          title: "alert_title/1 · alert_description/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Text content."}
          ]
        }
      ],
      "alert-dialog" => [
        %{
          title: "alert_dialog/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: false, default: "—", desc: "Optional trigger element. Omit to control with show_alert_dialog/1."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Dialog content (use alert_dialog_content)."}
          ]
        },
        %{
          title: "alert_dialog_title/1 · alert_dialog_description/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Custom element ID."},
            %{prop: "dialog_id", type: "string", required: false, default: "nil", desc: "Parent dialog ID; auto-generates id as dialog_id-title / dialog_id-description."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Title or description text."}
          ]
        },
        %{
          title: "alert_dialog_cancel/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Parent alert_dialog ID; wires up close behavior."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Cancel button content."}
          ]
        },
        %{
          title: "alert_dialog_action/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Confirm/action button content."}
          ]
        }
      ],
      "aspect-ratio" => [
        %{
          title: "aspect_ratio/1",
          rows: [
            %{prop: "ratio", type: "float", required: false, default: "1.0", desc: "Width-to-height ratio (e.g., 16/9 ≈ 1.778)."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Content to display within the ratio container."}
          ]
        }
      ],
      "avatar" => [
        %{
          title: "avatar/1",
          rows: [
            %{prop: "src", type: "string", required: false, default: "nil", desc: "Image URL."},
            %{prop: "alt", type: "string", required: false, default: "nil", desc: "Alt text for the image."},
            %{prop: "fallback", type: "string", required: false, default: "nil", desc: "Text shown when no image is available (e.g., initials)."},
            %{prop: "size", type: "string", required: false, default: "\"default\"", desc: "Size variant: sm, default, or lg."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "badge" => [
        %{
          title: "badge/1",
          rows: [
            %{prop: "variant", type: "string", required: false, default: "\"default\"", desc: "Visual style: default, secondary, destructive, or outline."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Badge label text."}
          ]
        }
      ],
      "breadcrumb" => [
        %{
          title: "breadcrumb/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "breadcrumb_item elements."}
          ]
        },
        %{
          title: "breadcrumb_link/1",
          rows: [
            %{prop: "href", type: "string", required: false, default: "nil", desc: "URL for the breadcrumb link."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Link label text."}
          ]
        },
        %{
          title: "breadcrumb_ellipsis/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID for the dropdown popover."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Optional breadcrumb_ellipsis_item entries."}
          ]
        },
        %{
          title: "breadcrumb_ellipsis_item/1",
          rows: [
            %{prop: "href", type: "string", required: false, default: "\"#\"", desc: "URL for the hidden item."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Item label text."}
          ]
        }
      ],
      "button" => [
        %{
          title: "button/1",
          rows: [
            %{prop: "variant", type: "string", required: false, default: "\"default\"", desc: "Visual style: default, destructive, outline, secondary, ghost, or link."},
            %{prop: "size", type: "string", required: false, default: "\"default\"", desc: "Size: default, sm, lg, or icon."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the button."},
            %{prop: "type", type: "string", required: false, default: "\"button\"", desc: "HTML button type attribute."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Button label content."}
          ]
        },
        %{
          title: "link_button/1",
          rows: [
            %{prop: "href", type: "string", required: true, default: "—", desc: "URL to link to."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path."},
            %{prop: "patch", type: "string", required: false, default: "nil", desc: "LiveView patch path."},
            %{prop: "variant", type: "string", required: false, default: "\"default\"", desc: "Visual style variant."},
            %{prop: "size", type: "string", required: false, default: "\"default\"", desc: "Size variant."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Link content."}
          ]
        }
      ],
      "button-group" => [
        %{
          title: "button_group/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Button elements to group together."}
          ]
        }
      ],
      "calendar" => [
        %{
          title: "calendar/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "month", type: "integer", required: true, default: "—", desc: "Currently displayed month (1–12)."},
            %{prop: "year", type: "integer", required: true, default: "—", desc: "Currently displayed year."},
            %{prop: "on_select", type: "string", required: true, default: "—", desc: "Event fired when a date is selected, with %{\"date\" => iso_string}."},
            %{prop: "on_prev", type: "string", required: true, default: "—", desc: "Event fired to navigate to the previous month."},
            %{prop: "on_next", type: "string", required: true, default: "—", desc: "Event fired to navigate to the next month."},
            %{prop: "selected", type: "Date.t()", required: false, default: "nil", desc: "Currently selected date."},
            %{prop: "today", type: "Date.t()", required: false, default: "nil", desc: "Today's date for highlighting. Defaults to Date.utc_today()."},
            %{prop: "week_start", type: "atom", required: false, default: ":sunday", desc: "First day of the week: :sunday or :monday."},
            %{prop: "day_names", type: "list", required: false, default: "nil", desc: "List of 7 day name strings. Defaults to [\"Su\", \"Mo\", …, \"Sa\"]."},
            %{prop: "month_names", type: "list", required: false, default: "nil", desc: "List of 12 month name strings. Defaults to [\"January\", …, \"December\"]."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "card" => [
        %{
          title: "card/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Card content."}
          ]
        },
        %{
          title: "card_title/1",
          rows: [
            %{prop: "as", type: "string", required: false, default: "\"h3\"", desc: "HTML heading element to render: h1–h6."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Title text."}
          ]
        },
        %{
          title: "card_header/1 · card_description/1 · card_content/1 · card_footer/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Section content."}
          ]
        }
      ],
      "carousel" => [
        %{
          title: "carousel/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID used to wire navigation controls."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "carousel_content and optional navigation buttons."}
          ]
        },
        %{
          title: "carousel_previous/1 · carousel_next/1",
          rows: [
            %{prop: "carousel_id", type: "string", required: true, default: "—", desc: "ID of the parent carousel element."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        },
        %{
          title: "carousel_content/1 · carousel_item/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Slide content."}
          ]
        }
      ],
      "checkbox" => [
        %{
          title: "checkbox/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct. Auto-extracts id, name, value, and errors."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Input name attribute."},
            %{prop: "checked", type: "boolean", required: false, default: "false", desc: "Whether the checkbox is checked."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the checkbox."},
            %{prop: "required", type: "boolean", required: false, default: "false", desc: "Marks the checkbox as required."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Optional label content rendered next to the checkbox."}
          ]
        },
        %{
          title: "checkbox_group/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "checkbox elements."}
          ]
        }
      ],
      "collapsible" => [
        %{
          title: "collapsible/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "open", type: "boolean", required: false, default: "false", desc: "Whether the collapsible is open by default."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Trigger and content components."}
          ]
        },
        %{
          title: "collapsible_trigger/1",
          rows: [
            %{prop: "collapsible_id", type: "string", required: true, default: "—", desc: "ID of the parent collapsible element."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Trigger content."}
          ]
        },
        %{
          title: "collapsible_content/1",
          rows: [
            %{prop: "collapsible_id", type: "string", required: true, default: "—", desc: "ID of the parent collapsible element."},
            %{prop: "open", type: "boolean", required: false, default: "false", desc: "Controls visibility (keep in sync with parent)."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Collapsible body content."}
          ]
        }
      ],
      "combobox" => [
        %{
          title: "combobox/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "on_select", type: "string", required: true, default: "—", desc: "Event fired when an option is selected, with %{\"value\" => value}."},
            %{prop: "value", type: "string", required: false, default: "nil", desc: "Currently selected value."},
            %{prop: "placeholder", type: "string", required: false, default: "\"Select...\"", desc: "Placeholder text shown when no value is selected."},
            %{prop: "search_placeholder", type: "string", required: false, default: "\"Search...\"", desc: "Placeholder text for the search input."},
            %{prop: "options", type: "list", required: false, default: "[]", desc: "List of option maps with :label and :value keys."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Hidden input name for form submission."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "command" => [
        %{
          title: "command/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Command subcomponents."}
          ]
        },
        %{
          title: "command_group/1",
          rows: [
            %{prop: "heading", type: "string", required: false, default: "nil", desc: "Optional group label."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "command_item elements."}
          ]
        },
        %{
          title: "command_item/1",
          rows: [
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the item."},
            %{prop: "shortcut", type: "string", required: false, default: "nil", desc: "Keyboard shortcut hint displayed on the right."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Item content."}
          ]
        },
        %{
          title: "command_input/1 · command_list/1 · command_empty/1 · command_separator/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "context-menu" => [
        %{
          title: "context_menu/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: true, default: "—", desc: "Right-click target area."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Menu items, labels, and separators."}
          ]
        },
        %{
          title: "context_menu_item/1",
          rows: [
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the item."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Item content."}
          ]
        },
        %{
          title: "context_menu_label/1 · context_menu_separator/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "data-table" => [
        %{
          title: "data_table/1",
          rows: [
            %{prop: "rows", type: "list", required: true, default: "—", desc: "List of row data maps or structs."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "row_id", type: "function", required: false, default: "nil", desc: "Function extracting a unique ID from each row."},
            %{prop: "row_click", type: "function", required: false, default: "nil", desc: "JS command factory called with each row for click behavior."},
            %{prop: "empty_message", type: "string", required: false, default: "\"No results.\"", desc: "Message shown when rows is empty."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":col", type: "slot", required: true, default: "—", desc: "Column definition. Slot attrs: label* (string), class (any)."},
            %{prop: ":action", type: "slot", required: false, default: "—", desc: "Actions column. Slot attrs: label (string)."}
          ]
        }
      ],
      "date-picker" => [
        %{
          title: "date_picker/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "on_select", type: "string", required: true, default: "—", desc: "Event fired when a date is selected."},
            %{prop: "on_prev", type: "string", required: true, default: "—", desc: "Event fired to navigate to the previous month."},
            %{prop: "on_next", type: "string", required: true, default: "—", desc: "Event fired to navigate to the next month."},
            %{prop: "selected", type: "Date.t()", required: false, default: "nil", desc: "Currently selected date."},
            %{prop: "placeholder", type: "string", required: false, default: "\"Pick a date\"", desc: "Placeholder shown when no date is selected."},
            %{prop: "month", type: "integer", required: false, default: "nil", desc: "Month override for the displayed calendar (1–12)."},
            %{prop: "year", type: "integer", required: false, default: "nil", desc: "Year override for the displayed calendar."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "dialog" => [
        %{
          title: "dialog/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: false, default: "—", desc: "Optional trigger element. Omit to control with show_dialog/1."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Dialog content (use dialog_content)."}
          ]
        },
        %{
          title: "dialog_title/1 · dialog_description/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Custom element ID."},
            %{prop: "dialog_id", type: "string", required: false, default: "nil", desc: "Parent dialog ID; auto-generates id as dialog_id-title / dialog_id-description."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Title or description text."}
          ]
        },
        %{
          title: "dialog_content/1 · dialog_header/1 · dialog_footer/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Section content."}
          ]
        }
      ],
      "direction" => [
        %{
          title: "direction/1",
          rows: [
            %{prop: "dir", type: "string", required: false, default: "\"ltr\"", desc: "Text direction: ltr or rtl."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Content to render with the specified direction."}
          ]
        }
      ],
      "drawer" => [
        %{
          title: "drawer/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "side", type: "string", required: false, default: "\"bottom\"", desc: "Slide-in side: bottom, top, left, or right."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: false, default: "—", desc: "Optional trigger element. Omit to control with show_drawer/3."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Drawer panel content."}
          ]
        },
        %{
          title: "drawer_header/1 · drawer_content/1 · drawer_footer/1 · drawer_title/1 · drawer_description/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Section content."}
          ]
        }
      ],
      "dropdown-menu" => [
        %{
          title: "dropdown_menu/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: true, default: "—", desc: "Element that opens the dropdown on click."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Menu items, labels, and separators."}
          ]
        },
        %{
          title: "dropdown_menu_item/1",
          rows: [
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the item."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Item content."}
          ]
        },
        %{
          title: "dropdown_menu_label/1 · dropdown_menu_separator/1 · dropdown_menu_group/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "empty" => [
        %{
          title: "empty/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":icon", type: "slot", required: false, default: "—", desc: "Optional icon rendered above the title."},
            %{prop: ":title", type: "slot", required: true, default: "—", desc: "Primary empty state message."},
            %{prop: ":description", type: "slot", required: false, default: "—", desc: "Supporting description text."},
            %{prop: ":action", type: "slot", required: false, default: "—", desc: "Call-to-action element (e.g., a button)."}
          ]
        }
      ],
      "field" => [
        %{
          title: "field/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID override."},
            %{prop: "label", type: "string", required: false, default: "nil", desc: "Field label text."},
            %{prop: "description", type: "string", required: false, default: "nil", desc: "Helper text shown below the input."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "The form control (e.g., input, select)."}
          ]
        }
      ],
      "hover-card" => [
        %{
          title: "hover_card/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID. Auto-generated if omitted."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: true, default: "—", desc: "Element the user hovers to reveal the card."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Card content."}
          ]
        }
      ],
      "input" => [
        %{
          title: "input/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct. Auto-extracts id, name, value, and errors."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Input name attribute."},
            %{prop: "type", type: "string", required: false, default: "\"text\"", desc: "HTML input type (text, email, password, number, etc.)."},
            %{prop: "value", type: "any", required: false, default: "nil", desc: "Current input value."},
            %{prop: "placeholder", type: "string", required: false, default: "nil", desc: "Placeholder text."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the input."},
            %{prop: "required", type: "boolean", required: false, default: "false", desc: "Marks the input as required."},
            %{prop: "readonly", type: "boolean", required: false, default: "false", desc: "Makes the input read-only."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages displayed below the input."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "input-group" => [
        %{
          title: "input_group/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":addon_start", type: "slot", required: false, default: "—", desc: "Content prepended to the input (icon, text, or button)."},
            %{prop: ":addon_end", type: "slot", required: false, default: "—", desc: "Content appended to the input."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "The input element."}
          ]
        }
      ],
      "input-otp" => [
        %{
          title: "input_otp/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Hidden input name for form submission."},
            %{prop: "length", type: "integer", required: false, default: "6", desc: "Number of OTP input slots."},
            %{prop: "value", type: "string", required: false, default: "\"\"", desc: "Current OTP value."},
            %{prop: "mode", type: "string", required: false, default: "\"numeric\"", desc: "Input mode: numeric (0–9) or alphanumeric."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables all OTP slots."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "item" => [
        %{
          title: "item/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":media", type: "slot", required: false, default: "—", desc: "Optional media element (avatar, image, icon)."},
            %{prop: ":content", type: "slot", required: true, default: "—", desc: "Primary content (title, description)."},
            %{prop: ":action", type: "slot", required: false, default: "—", desc: "Optional trailing action element."}
          ]
        }
      ],
      "kbd" => [
        %{
          title: "kbd/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Key label text."}
          ]
        }
      ],
      "label" => [
        %{
          title: "label/1",
          rows: [
            %{prop: "for", type: "string", required: false, default: "nil", desc: "ID of the associated form element."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Label text."}
          ]
        }
      ],
      "menubar" => [
        %{
          title: "menubar/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID for the menubar."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "menubar_menu elements."}
          ]
        },
        %{
          title: "menubar_menu/1",
          rows: [
            %{prop: "menubar_id", type: "string", required: true, default: "—", desc: "ID of the parent menubar."},
            %{prop: "value", type: "string", required: true, default: "—", desc: "Unique key for this menu within the menubar."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: true, default: "—", desc: "Menu label shown in the menubar."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Menu items, labels, separators."}
          ]
        },
        %{
          title: "menubar_item/1",
          rows: [
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the item."},
            %{prop: "shortcut", type: "string", required: false, default: "nil", desc: "Keyboard shortcut hint."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Item content."}
          ]
        },
        %{
          title: "menubar_label/1 · menubar_separator/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "native-select" => [
        %{
          title: "native_select/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Select name attribute."},
            %{prop: "value", type: "any", required: false, default: "nil", desc: "Currently selected value."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the select."},
            %{prop: "required", type: "boolean", required: false, default: "false", desc: "Marks the select as required."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":option", type: "slot", required: false, default: "—", desc: "Option definition. Slot attrs: value* (any)."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Raw <option> elements as an alternative to :option."}
          ]
        }
      ],
      "navigation-menu" => [
        %{
          title: "navigation_menu/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "navigation_menu_list content."}
          ]
        },
        %{
          title: "navigation_menu_item/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique ID shared with trigger and content."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Trigger and optional content panel."}
          ]
        },
        %{
          title: "navigation_menu_trigger/1",
          rows: [
            %{prop: "item_id", type: "string", required: true, default: "—", desc: "ID of the parent navigation_menu_item."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Trigger label."}
          ]
        },
        %{
          title: "navigation_menu_content/1",
          rows: [
            %{prop: "item_id", type: "string", required: true, default: "—", desc: "ID of the parent navigation_menu_item."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Dropdown panel content."}
          ]
        },
        %{
          title: "navigation_menu_link/1",
          rows: [
            %{prop: "title", type: "string", required: true, default: "—", desc: "Link heading text."},
            %{prop: "href", type: "string", required: false, default: "nil", desc: "URL."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Optional description text."}
          ]
        }
      ],
      "pagination" => [
        %{
          title: "pagination/1 · pagination_content/1 · pagination_ellipsis/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        },
        %{
          title: "pagination_link/1",
          rows: [
            %{prop: "href", type: "string", required: false, default: "nil", desc: "URL."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path."},
            %{prop: "active", type: "boolean", required: false, default: "false", desc: "Highlights the link as the current page."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the link."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Page number or label."}
          ]
        },
        %{
          title: "pagination_previous/1 · pagination_next/1",
          rows: [
            %{prop: "href", type: "string", required: false, default: "nil", desc: "URL."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the button."},
            %{prop: "label", type: "string", required: false, default: "\"Previous\" / \"Next\"", desc: "Accessible label text."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "popover" => [
        %{
          title: "popover/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "side", type: "string", required: false, default: "\"bottom\"", desc: "Preferred placement: top, bottom, left, or right."},
            %{prop: "align", type: "string", required: false, default: "\"start\"", desc: "Alignment along the cross axis: start, center, or end."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: true, default: "—", desc: "Element that opens the popover on click."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Popover panel content."}
          ]
        }
      ],
      "progress" => [
        %{
          title: "progress/1",
          rows: [
            %{prop: "value", type: "number", required: false, default: "0", desc: "Current progress value."},
            %{prop: "max", type: "number", required: false, default: "100", desc: "Maximum value."},
            %{prop: "aria_label", type: "string", required: false, default: "nil", desc: "Accessible label for screen readers."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "radio-group" => [
        %{
          title: "radio_group/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Group name shared by all radio_group_item children."},
            %{prop: "value", type: "any", required: false, default: "nil", desc: "Currently selected value."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "radio_group_item elements."}
          ]
        },
        %{
          title: "radio_group_item/1",
          rows: [
            %{prop: "value", type: "any", required: true, default: "—", desc: "Value submitted when this item is selected."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Input name (inherits from radio_group when nested)."},
            %{prop: "checked", type: "boolean", required: false, default: "false", desc: "Whether this item is selected."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables this item."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Optional label content."}
          ]
        }
      ],
      "resizable" => [
        %{
          title: "resizable_panel_group/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "direction", type: "string", required: false, default: "\"horizontal\"", desc: "Resize axis: horizontal or vertical."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "resizable_panel and resizable_handle elements."}
          ]
        },
        %{
          title: "resizable_panel/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "default_size", type: "float", required: false, default: "50.0", desc: "Initial size as a percentage of the group."},
            %{prop: "min_size", type: "float", required: false, default: "10.0", desc: "Minimum panel size as a percentage."},
            %{prop: "max_size", type: "float", required: false, default: "90.0", desc: "Maximum panel size as a percentage."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Panel content."}
          ]
        },
        %{
          title: "resizable_handle/1",
          rows: [
            %{prop: "direction", type: "string", required: false, default: "\"horizontal\"", desc: "Must match the parent group direction."},
            %{prop: "with_handle", type: "boolean", required: false, default: "true", desc: "Show the grip icon on the handle."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "scroll-area" => [
        %{
          title: "scroll_area/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "CSS classes defining size and shape (e.g., h-72 w-48)."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Scrollable content."}
          ]
        }
      ],
      "select" => [
        %{
          title: "select/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Hidden input name."},
            %{prop: "value", type: "any", required: false, default: "nil", desc: "Currently selected value."},
            %{prop: "placeholder", type: "string", required: false, default: "\"Select an option...\"", desc: "Placeholder text shown when no value is selected."},
            %{prop: "on_change", type: "string", required: false, default: "nil", desc: "Event fired when selection changes, with %{\"value\" => value}."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the select."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":select_item", type: "slot", required: true, default: "—", desc: "Option definition. Slot attrs: value* (any), label* (string)."}
          ]
        }
      ],
      "separator" => [
        %{
          title: "separator/1",
          rows: [
            %{prop: "orientation", type: "string", required: false, default: "\"horizontal\"", desc: "Layout direction: horizontal or vertical."},
            %{prop: "decorative", type: "boolean", required: false, default: "true", desc: "When true, hides the separator from assistive technology."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "sheet" => [
        %{
          title: "sheet/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "side", type: "string", required: false, default: "\"right\"", desc: "Slide-in side: left, right, top, or bottom."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":trigger", type: "slot", required: false, default: "—", desc: "Optional trigger element. Omit to control with show_sheet/2."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Sheet panel content."}
          ]
        },
        %{
          title: "sheet_title/1 · sheet_description/1",
          rows: [
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Custom element ID."},
            %{prop: "sheet_id", type: "string", required: false, default: "nil", desc: "Parent sheet ID; auto-generates id as sheet_id-title / sheet_id-description."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Title or description text."}
          ]
        },
        %{
          title: "sheet_content/1 · sheet_header/1 · sheet_footer/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Section content."}
          ]
        }
      ],
      "sidebar" => [
        %{
          title: "sidebar/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Sidebar sections."}
          ]
        },
        %{
          title: "sidebar_menu_button/1",
          rows: [
            %{prop: "active", type: "boolean", required: false, default: "false", desc: "Highlights the button as the current route."},
            %{prop: "href", type: "string", required: false, default: "nil", desc: "URL; renders an <a> element when provided."},
            %{prop: "navigate", type: "string", required: false, default: "nil", desc: "LiveView navigate path; renders a link element when provided."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Button/link content."}
          ]
        },
        %{
          title: "sidebar_trigger/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "ID of the sidebar element to toggle."},
            %{prop: "side", type: "string", required: false, default: "\"left\"", desc: "Must match the sidebar's side for correct animation: left or right."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Button content (usually a menu icon)."}
          ]
        },
        %{
          title: "sidebar_header/1 · sidebar_content/1 · sidebar_footer/1 · sidebar_group/1 · sidebar_group_content/1 · sidebar_group_label/1 · sidebar_menu/1 · sidebar_menu_item/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Section content."}
          ]
        }
      ],
      "skeleton" => [
        %{
          title: "skeleton/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "CSS classes defining the size and shape (e.g., h-4 w-32 rounded-md)."}
          ]
        }
      ],
      "slider" => [
        %{
          title: "slider/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct. Auto-extracts id, name, and value."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Hidden input name."},
            %{prop: "value", type: "float", required: false, default: "50.0", desc: "Current slider value."},
            %{prop: "min", type: "float", required: false, default: "0.0", desc: "Minimum value."},
            %{prop: "max", type: "float", required: false, default: "100.0", desc: "Maximum value."},
            %{prop: "step", type: "float", required: false, default: "1.0", desc: "Step increment."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the slider."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "spinner" => [
        %{
          title: "spinner/1",
          rows: [
            %{prop: "size", type: "string", required: false, default: "\"default\"", desc: "Size variant: sm, default, or lg."},
            %{prop: "label", type: "string", required: false, default: "nil", desc: "Visible text label rendered alongside the spinner."},
            %{prop: "aria_label", type: "string", required: false, default: "nil", desc: "Accessible label for screen readers. Defaults to label if omitted."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "switch" => [
        %{
          title: "switch/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Hidden input name."},
            %{prop: "checked", type: "boolean", required: false, default: "false", desc: "Whether the switch is on."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the switch."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Optional label content."}
          ]
        }
      ],
      "table" => [
        %{
          title: "table/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "table_header, table_body, table_footer."}
          ]
        },
        %{
          title: "table_cell/1",
          rows: [
            %{prop: "colspan", type: "integer", required: false, default: "nil", desc: "Number of columns to span."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Cell content."}
          ]
        },
        %{
          title: "table_header/1 · table_body/1 · table_footer/1 · table_row/1 · table_head/1 · table_caption/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Section content."}
          ]
        }
      ],
      "tabs" => [
        %{
          title: "tabs/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "default_value", type: "string", required: false, default: "nil", desc: "Value of the tab active by default."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":tab", type: "slot", required: false, default: "—", desc: "Shorthand tab definition. Slot attrs: value* (string), label* (string), active (bool), disabled (bool)."},
            %{prop: ":inner_block", type: "slot", required: false, default: "—", desc: "Explicit tabs_list / tabs_content composition."}
          ]
        },
        %{
          title: "tabs_trigger/1",
          rows: [
            %{prop: "tabs_id", type: "string", required: true, default: "—", desc: "ID of the parent tabs element."},
            %{prop: "value", type: "string", required: true, default: "—", desc: "Tab identifier matching a tabs_content value."},
            %{prop: "active", type: "boolean", required: false, default: "false", desc: "Highlights this tab as active."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the tab."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Tab label."}
          ]
        },
        %{
          title: "tabs_content/1",
          rows: [
            %{prop: "tabs_id", type: "string", required: true, default: "—", desc: "ID of the parent tabs element."},
            %{prop: "value", type: "string", required: true, default: "—", desc: "Matches the associated tabs_trigger value."},
            %{prop: "active", type: "boolean", required: false, default: "false", desc: "Shows this content panel."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Panel content."}
          ]
        }
      ],
      "textarea" => [
        %{
          title: "textarea/1",
          rows: [
            %{prop: "field", type: "FormField", required: false, default: "nil", desc: "Phoenix form field struct."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID."},
            %{prop: "name", type: "string", required: false, default: "nil", desc: "Textarea name attribute."},
            %{prop: "value", type: "any", required: false, default: "nil", desc: "Current text value."},
            %{prop: "placeholder", type: "string", required: false, default: "nil", desc: "Placeholder text."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the textarea."},
            %{prop: "required", type: "boolean", required: false, default: "false", desc: "Marks the textarea as required."},
            %{prop: "rows", type: "integer", required: false, default: "3", desc: "Number of visible text rows."},
            %{prop: "errors", type: "list", required: false, default: "[]", desc: "Validation error messages."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        }
      ],
      "toast" => [
        %{
          title: "toast_viewport/1",
          rows: [
            %{prop: "toasts", type: "list", required: false, default: "[]", desc: "List of toast maps with :id, :title, and optional :description keys."},
            %{prop: "position", type: "string", required: false, default: "\"bottom-right\"", desc: "Viewport position: top-left, top-center, top-right, bottom-left, bottom-center, or bottom-right."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."}
          ]
        },
        %{
          title: "toast_item/1",
          rows: [
            %{prop: "toast", type: "map", required: true, default: "—", desc: "Toast map with :id, :title, and optional :description."},
            %{prop: "auto_dismiss", type: "integer", required: false, default: "5000", desc: "Auto-dismiss delay in milliseconds. Set to 0 to disable."},
            %{prop: "on_dismiss", type: "string", required: false, default: "\"dismiss_toast\"", desc: "Event name fired when dismissed, with %{\"id\" => id}."}
          ]
        }
      ],
      "toggle" => [
        %{
          title: "toggle/1",
          rows: [
            %{prop: "id", type: "string", required: true, default: "—", desc: "Unique element ID."},
            %{prop: "variant", type: "string", required: false, default: "\"default\"", desc: "Visual style: default or outline."},
            %{prop: "size", type: "string", required: false, default: "\"default\"", desc: "Size: default, sm, or lg."},
            %{prop: "pressed", type: "boolean", required: false, default: "false", desc: "Initial pressed state."},
            %{prop: "disabled", type: "boolean", required: false, default: "false", desc: "Disables the toggle."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Toggle content."}
          ]
        }
      ],
      "toggle-group" => [
        %{
          title: "toggle_group/1",
          rows: [
            %{prop: "type", type: "string", required: false, default: "\"single\"", desc: "Selection behavior: single (at most one active) or multiple."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "toggle elements to group."}
          ]
        }
      ],
      "tooltip" => [
        %{
          title: "tooltip/1",
          rows: [
            %{prop: "content", type: "string", required: true, default: "—", desc: "Text displayed in the tooltip."},
            %{prop: "side", type: "string", required: false, default: "\"top\"", desc: "Preferred position: top, bottom, left, or right."},
            %{prop: "id", type: "string", required: false, default: "nil", desc: "Element ID. Auto-generated if omitted."},
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Element that triggers the tooltip on hover/focus."}
          ]
        }
      ],
      "typography" => [
        %{
          title: "h1/1 · h2/1 · h3/1 · h4/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Heading content."}
          ]
        },
        %{
          title: "prose_p/1 · lead/1 · large_text/1 · small_text/1 · muted_text/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Text content."}
          ]
        },
        %{
          title: "blockquote/1 · inline_code/1",
          rows: [
            %{prop: "class", type: "any", required: false, default: "nil", desc: "Additional CSS classes."},
            %{prop: ":inner_block", type: "slot", required: true, default: "—", desc: "Content."}
          ]
        }
      ]
    }
  end
end
